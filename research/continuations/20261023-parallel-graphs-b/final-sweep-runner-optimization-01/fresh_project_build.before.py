#!/usr/bin/env python3
"""Bounded source-only Lean project build; external caches are explicitly pinned.

No existing project olean is imported. Resume accepts only recursively validated
COMPILE_PASS receipts originating in this initially empty build directory.
This compilation gate complements theorem/axiom audits and a separate
installed-kernel replay. Python 3.8+, Linux/macOS, standard library only.
"""
import argparse
import concurrent.futures
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import threading
import time
import uuid

SCHEMA = 1
MIB = 1024 * 1024
MODULE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*\Z")
ENV_ALLOWED = {'LD_PRELOAD', 'LD_LIBRARY_PATH', 'DYLD_INSERT_LIBRARIES', 'DYLD_LIBRARY_PATH'}


def check(ok, message):
    if not ok:
        raise RuntimeError(message)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def save(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + '.' + uuid.uuid4().hex + '.tmp')
    tmp.write_text(json.dumps(value, sort_keys=True, indent=2) + '\n')
    os.replace(str(tmp), str(path))


def read(path):
    return json.loads(Path(path).read_text())


def under(path, root):
    try:
        Path(path).resolve().relative_to(Path(root).resolve())
        return True
    except ValueError:
        return False


def module_path(name, suffix='.lean'):
    check(bool(MODULE.fullmatch(name)), 'Unsupported module identifier: ' + name)
    return Path(*name.split('.')).with_suffix(suffix)


def resolve_module(paths, name):
    """Mirror Lean.SearchPath.findWithExt: first package owner, not first file."""
    package = name.split('.')[0]
    for root in map(Path, paths):
        if (root/package).is_dir() or (root/(package+'.olean')).exists():
            return root/module_path(name, '.olean')
    return None


def artifact_files(base):
    base = Path(base)
    return sorted({p for pattern in [base.name+'*', base.with_suffix('.ir').name+'*']
                   for p in base.parent.glob(pattern) if p.is_file()})


def strip_comments(text):
    """Preserve line structure; nested Lean block comments and strings are handled."""
    out = []; i = 0; depth = 0; string = False
    while i < len(text):
        c = text[i]; pair = text[i:i+2]
        if depth:
            if pair == '/-': depth += 1; out.extend('  '); i += 2; continue
            if pair == '-/': depth -= 1; out.extend('  '); i += 2; continue
            out.append('\n' if c == '\n' else ' '); i += 1; continue
        if string:
            out.append(c)
            if c == '\\' and i+1 < len(text): out.append(text[i+1]); i += 2; continue
            if c == '"': string = False
            i += 1; continue
        if pair == '--':
            j = text.find('\n', i)
            if j < 0: out.extend(' ' * (len(text)-i)); break
            out.extend(' ' * (j-i)); i = j; continue
        if pair == '/-': depth = 1; out.extend('  '); i += 2; continue
        if c == '"': string = True
        out.append(c); i += 1
    check(depth == 0, 'Unterminated block comment')
    return ''.join(out)


def imports(path):
    result = []; header = True
    for line in strip_comments(Path(path).read_text()).splitlines():
        line = line.strip()
        if not line or line in ['prelude', 'module']: continue
        m = re.fullmatch(r'(?:(?:public|private|meta)\s+)*import\s+(.+)', line)
        if m:
            check(header, 'Import outside supported header in ' + str(path))
            for name in m.group(1).split():
                check(bool(MODULE.fullmatch(name)), 'Unsupported import syntax in ' + str(path))
                if name not in result: result.append(name)
        else:
            header = False
    return result


def project_name(name, namespace):
    return name == namespace or name.startswith(namespace + '.')


def source_lock(source_root, roots, namespace):
    source_root = Path(source_root).resolve(); sources = {}; visiting = set(); order = []
    def walk(name):
        check(name not in visiting, 'Import cycle: ' + name)
        if name in sources: return
        path = source_root / module_path(name)
        check(under(path, source_root) and path.is_file(), 'Missing/escaping source: ' + str(path))
        visiting.add(name); ds = imports(path)
        for dep in ds:
            if project_name(dep, namespace): walk(dep)
        visiting.remove(name)
        sources[name] = {'relative_path': str(module_path(name)), 'sha256': sha(path),
                         'bytes': path.stat().st_size, 'imports': ds}
        order.append(name)
    for root in roots: walk(root)
    auxiliary = {}
    for name in ['lean-toolchain', 'lakefile.toml', 'lakefile.lean', 'lake-manifest.json']:
        path = source_root / name
        if path.is_file(): auxiliary[name] = sha(path)
    return {'schema': SCHEMA, 'namespace': namespace, 'roots': roots, 'sources': sources,
            'auxiliary': auxiliary, 'topological_order': order, 'module_count': len(sources),
            'scope': 'Only the exact reachable project import closure; unused files are not compiled.'}


def inventory(roots):
    files = {}; directories = {}
    for root in roots:
        root = Path(root).resolve(); check(root.is_dir(), 'Missing runtime/cache root: ' + str(root))
        for base, dirs, names in os.walk(str(root), followlinks=False):
            base = Path(base); directories[str(base)] = fingerprint(base)
            for name in dirs:
                check(not (base/name).is_symlink(), 'Symlinked runtime directory needs an explicit resolved root: ' + str(base/name))
            for name in names:
                path = base/name
                if path.is_file(): files[str(path)] = sha(path)
    return files, directories


def fingerprint(path):
    path = Path(path); st = path.stat()
    return (str(path.resolve()), st.st_dev, st.st_ino, st.st_size, st.st_mtime_ns, st.st_ctime_ns)


class Pins:
    """SHA256 cache invalidated by inode, size, mtime, ctime or symlink target changes."""
    def __init__(self):
        self.cache = {}; self.lock = threading.RLock()
    def verify(self, path, expected):
        path = str(Path(path)); before = fingerprint(path)
        with self.lock:
            cached = self.cache.get(path)
            if cached and cached == (before, expected): return
            actual = sha(path); after = fingerprint(path)
            check(before == after, 'File changed while hashing: ' + path)
            check(actual == expected, 'SHA256 mismatch: ' + path)
            self.cache[path] = (after, expected)


def clean_environment(runtime, artifacts):
    toolchain = Path(runtime['toolchain'])
    env = {name: os.environ[name] for name in ['HOME', 'USER', 'LOGNAME', 'SYSTEMROOT'] if name in os.environ}
    env.update(PATH=str(toolchain/'bin') + os.pathsep + '/usr/bin:/bin:/usr/sbin:/sbin',
               LANG='C.UTF-8', LC_ALL='C.UTF-8', LEAN_SYSROOT=str(toolchain),
               LEAN_NUM_THREADS='1', OMP_NUM_THREADS='1')
    extra = runtime.get('environment', {})
    check(set(extra) <= ENV_ALLOWED, 'Unapproved environment override')
    env.update(extra)
    paths = ([str(artifacts)] if artifacts is not None else []) + runtime['external_paths']
    env['LEAN_PATH'] = os.pathsep.join(paths)
    return env


def make_runtime_lock(args):
    tc = Path(args.toolchain).resolve()
    external = list(dict.fromkeys(str(Path(p).resolve()) for p in args.external_path))
    core = str(tc/'lib/lean')
    if core not in external: external.append(core)
    env = read(args.environment) if args.environment else {}
    check(set(env) <= ENV_ALLOWED, 'Only explicit dynamic-loader environment overrides are supported')
    roots = list(dict.fromkeys([str(tc/'bin'), str(tc/'lib')] + external))
    extras = list(args.extra_file)
    for key in ['LD_PRELOAD', 'DYLD_INSERT_LIBRARIES']:
        if key in env:
            extras += [p for p in re.split(r'[:\s]+', env[key]) if p]
    for path in extras:
        p = str(Path(path).resolve()); check(Path(p).is_file(), 'Missing runtime extra: ' + p)
    for key in ['LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH']:
        for directory in env.get(key, '').split(os.pathsep):
            if directory and str(Path(directory).resolve()) not in roots:
                roots.append(str(Path(directory).resolve()))
    roots = [p for p in roots if not any(p != q and under(p, q) for q in roots)]
    files, _ = inventory(roots)
    for path in extras:
        p = str(Path(path).resolve()); files[p] = sha(p)
    result = {'schema': SCHEMA, 'toolchain': str(tc), 'lean': str(tc/'bin/lean'),
              'external_paths': external, 'inventory_roots': roots, 'files': files,
              'extra_files': [str(Path(p).resolve()) for p in extras], 'environment': env,
              'scope': 'Pinned toolchain distribution, external cache files, and declared loader files; operating-system ABI is external.'}
    p = subprocess.run([result['lean'], '--version'], env=clean_environment(result, None),
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=20)
    check(p.returncode == 0, 'Cannot execute pinned Lean: ' + p.stdout)
    check(args.expected_version in p.stdout, 'Unexpected Lean version: ' + p.stdout)
    result['version_output'] = p.stdout.strip(); return result


def memory_snapshot():
    """Use the actual cgroup limit and non-reclaimable demand, never sum process RSS."""
    base = Path('/sys/fs/cgroup')
    try:
        limit_text = (base/'memory.max').read_text().strip()
        stat = dict((k, int(v)) for k, v in (line.split() for line in (base/'memory.stat').read_text().splitlines()))
        limit = int(limit_text) if limit_text != 'max' else None
        demand = stat.get('anon', 0) + stat.get('kernel', 0) + stat.get('file_dirty', 0) + stat.get('file_writeback', 0)
        if limit: return {'limit': limit, 'nonreclaimable': demand, 'source': 'cgroup-v2 anon+kernel+dirty+writeback'}
    except (OSError, ValueError): pass
    try: limit = os.sysconf('SC_PHYS_PAGES') * os.sysconf('SC_PAGE_SIZE')
    except (ValueError, OSError): limit = 8 * 1024 * MIB
    return {'limit': limit, 'nonreclaimable': None, 'source': 'physical-memory static reservations; no portable live pressure metric'}


class Build:
    def __init__(self, args):
        self.a = args; self.src = Path(args.source_root).resolve(); self.out = Path(args.build_dir).resolve()
        check(not under(self.out, self.src), 'Build directory must be outside the source checkout')
        check(sha(args.source_lock) == args.source_lock_sha256, 'Reviewed source lock hash mismatch')
        check(sha(args.runtime_lock) == args.runtime_lock_sha256, 'Reviewed runtime lock hash mismatch')
        self.sl = read(args.source_lock); self.rt = read(args.runtime_lock)
        check(self.sl['schema'] == self.rt['schema'] == SCHEMA, 'Lock schema mismatch')
        check(self.sl['module_count'] == args.expected_modules, 'Unexpected selected module count')
        check(source_lock(self.src, self.sl['roots'], self.sl['namespace']) == self.sl, 'Source closure differs from reviewed lock')
        check(not any(self.src.rglob('*.olean*')) and not any(self.src.rglob('*.ir'))
              and not any(self.src.rglob('*.ir.sig')), 'Source checkout contains compiled artifacts; export a clean checkout')
        self.names = self.sl['topological_order']; self.modules = self.sl['sources']
        self.deps = {n: [d for d in self.modules[n]['imports'] if d in self.modules] for n in self.names}
        self.ancestor_cache = {}
        self.external_dependencies = {}
        for n in self.names:
            self.ancestor_cache[n] = set(self.deps[n])
            for d in self.deps[n]: self.ancestor_cache[n].update(self.ancestor_cache[d])
            self.external_dependencies[n] = {'Init'} | {d for d in self.modules[n]['imports'] if d not in self.modules}
            for d in self.deps[n]: self.external_dependencies[n].update(self.external_dependencies[d])
        self.pins = Pins(); self.runtime_mutex = threading.RLock(); self.accepted = {}; self.failed = []
        self.interrupted = threading.Event()
        self.art = self.out/'artifacts'; self.hints = read(args.hints) if args.hints else {}
        self.env = clean_environment(self.rt, self.art)
        self.identity = {'schema': SCHEMA, 'source_lock_sha256': args.source_lock_sha256,
                         'runtime_lock_sha256': args.runtime_lock_sha256, 'runner_sha256': sha(__file__),
                         'source_root': str(self.src), 'build_dir': str(self.out),
                         'environment': self.env, 'lean_arguments': ['-j1', '-DautoImplicit=false', '-R', str(self.src)]}
        self.identity_hash = digest(self.identity)
        self.runtime_critical = {p: h for p, h in self.rt['files'].items()
                                 if p == self.rt['lean'] or '.so' in Path(p).name or '.dylib' in Path(p).name
                                 or p in self.rt.get('extra_files', [])}
        self.external_bundles = {}
        for p, h in self.rt['files'].items():
            if '.olean' in p:
                base = p.split('.olean', 1)[0]+'.olean'
                self.external_bundles.setdefault(base, {})[p] = h
            elif '.ir' in Path(p).name:
                base = str(Path(p).with_name(Path(p).name.split('.ir', 1)[0]+'.olean'))
                self.external_bundles.setdefault(base, {})[p] = h
        if args.resume:
            check((self.out/'ORIGIN.json').is_file(), 'Resume requires an existing fresh-build origin')
        else:
            check(not self.out.exists() or not any(self.out.iterdir()), 'Fresh build directory must be empty')
        self.out.mkdir(parents=True, exist_ok=True)
        self.lock_file = (self.out/'build.lock').open('a+')
        try: fcntl.flock(self.lock_file.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError: raise RuntimeError('Another runner owns this build directory')
        if args.resume:
            self.origin = read(self.out/'ORIGIN.json')
            check(self.origin['identity_hash'] == self.identity_hash and self.origin['initial_artifact_inventory'] == [],
                  'Resume identity/fresh origin mismatch')
        else:
            self.origin = {'build_id': uuid.uuid4().hex, 'identity_hash': self.identity_hash,
                           'identity': self.identity, 'initial_artifact_inventory': [],
                           'created_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}
            save(self.out/'ORIGIN.json', self.origin)
        self.invocation = uuid.uuid4().hex; self.runtime_dirs = {}
        self.art.mkdir(parents=True, exist_ok=True)
        self.guard_runtime(full=True)
        self.guard_source(self.names)
        self.validate_artifact_inventory()
        self.resume_passes()
        self.reused = sorted(self.accepted); self.compiled = []
        mem = memory_snapshot(); self.memory_limit = min(mem['limit'], args.memory_limit_mib*MIB) if args.memory_limit_mib else mem['limit']
        reserve = args.memory_reserve_mib*MIB
        baseline = mem['nonreclaimable'] or 0
        self.budget = args.memory_budget_mib*MIB if args.memory_budget_mib else max(256*MIB, self.memory_limit-reserve-baseline)
        check(self.budget > 0, 'Invalid memory reservation budget')
        self.resolved_external = {}
        for n in self.names:
            for dep in self.external_dependencies[n]:
                if dep in self.resolved_external: continue
                chosen = resolve_module(self.rt['external_paths'], dep)
                check(chosen is not None and chosen.is_file() and str(chosen) in self.rt['files'], 'Unpinned or package-shadowed external import: ' + dep)
                self.resolved_external[dep] = str(chosen)
        self.last_runtime_checkpoint = time.monotonic()
        save(self.out/'invocations'/self.invocation/'START.json', {'identity_hash': self.identity_hash,
             'resume': args.resume, 'reused': self.reused, 'memory_snapshot': mem, 'reservation_budget': self.budget,
             'jobs': args.jobs, 'hints_sha256': sha(args.hints) if args.hints else None})

    def guard_runtime(self, full=False, module=None, checkpoint=False):
        with self.runtime_mutex:
            self.pins.verify(__file__, self.identity['runner_sha256'])
            self.pins.verify(self.a.source_lock, self.a.source_lock_sha256)
            self.pins.verify(self.a.runtime_lock, self.a.runtime_lock_sha256)
            for p in self.rt['external_paths']:
                root = Path(p); ns = self.sl['namespace']
                check(not (root/module_path(ns, '.olean')).exists() and not (root/Path(*ns.split('.'))).exists(),
                      'External search path contains project artifacts: ' + p)
            changed = full or not self.runtime_dirs
            if checkpoint and not changed:
                changed = any(not Path(p).is_dir() or fingerprint(p) != fp for p, fp in self.runtime_dirs.items())
            if changed:
                actual, dirs = inventory(self.rt['inventory_roots'])
                for p in self.rt.get('extra_files', []): actual[p] = sha(p)
                check(actual == self.rt['files'], 'Runtime/cache inventory changed')
                self.runtime_dirs = dirs
            selected = dict(self.rt['files'] if (full or checkpoint) else self.runtime_critical)
            if module is not None:
                for dep in self.external_dependencies[module]:
                    chosen = self.resolved_external[dep]
                    current = resolve_module(self.rt['external_paths'], dep)
                    check(current is not None and str(current) == chosen and current.is_file(), 'External resolution changed: ' + dep)
                    bundles = self.external_bundles[chosen]
                    actual = {str(p) for p in artifact_files(chosen)}
                    check(actual == set(bundles), 'External sidecar inventory changed: ' + dep)
                    selected.update(bundles)
            for p, expected in selected.items(): self.pins.verify(p, expected)

    def guard_source(self, names):
        for n in names:
            row = self.modules[n]; self.pins.verify(self.src/row['relative_path'], row['sha256'])
        for p, expected in self.sl['auxiliary'].items(): self.pins.verify(self.src/p, expected)

    def bundle(self, n, root=None):
        base = (root or self.art)/module_path(n, '.olean')
        check(base.is_file(), 'Missing olean: ' + str(base))
        return {str(p.relative_to(root or self.art)): sha(p) for p in artifact_files(base)}

    def guard_bundle(self, n, expected):
        base = self.art/module_path(n, '.olean')
        actual = {str(p.relative_to(self.art)) for p in artifact_files(base)}
        check(actual == set(expected), 'Artifact sidecar inventory changed: ' + n)
        for p, h in expected.items(): self.pins.verify(self.art/p, h)

    def validate_artifact_inventory(self):
        paths = set(self.art.rglob('*.olean*')) | set(self.art.rglob('*.ir')) | set(self.art.rglob('*.ir.sig'))
        for p in paths:
            relative = str(p.relative_to(self.art)); base = re.split(r'\.(?:olean|ir)', relative, 1)[0].replace(os.sep, '.')
            check(base in self.modules and p.is_file(), 'Unselected project artifact: ' + str(p))

    def dependency_snapshot(self, n):
        return {d: {'receipt_sha256': self.accepted[d]['receipt_sha256'],
                    'artifact_bundle': self.accepted[d]['row']['artifact_bundle']} for d in self.deps[n]}

    def ancestors(self, n):
        return self.ancestor_cache[n]

    def guard_dependencies(self, n):
        ancestors = self.ancestors(n); self.guard_source(list(ancestors)+[n])
        for dep in ancestors:
            check(dep in self.accepted, 'Unaccepted dependency: ' + dep)
            accepted = self.accepted[dep]
            self.pins.verify(accepted['path'], accepted['receipt_sha256'])
            self.guard_bundle(dep, accepted['row']['artifact_bundle'])

    def resume_passes(self):
        rejected = []
        for n in self.names:
            pointer = self.out/'accepted'/module_path(n, '.json')
            if not pointer.is_file(): continue
            try:
                index = read(pointer); path = self.out/index['receipt_path']
                check(under(path, self.out/'attempts'), 'Escaping receipt pointer')
                check(sha(path) == index['receipt_sha256'], 'Receipt hash mismatch')
                row = read(path)
                check(row['status'] == 'COMPILE_PASS' and row['exit_code'] == 0, 'Receipt is not PASS')
                check(row['build_id'] == self.origin['build_id'] and row['identity_hash'] == self.identity_hash, 'Foreign receipt')
                check(row['module'] == n and row['source_sha256'] == self.modules[n]['sha256'], 'Source receipt mismatch')
                check(all(d in self.accepted for d in self.deps[n]), 'Unvalidated ancestor')
                check(row['dependencies'] == self.dependency_snapshot(n), 'Dependency receipt chain mismatch')
                check(isinstance(row.get('log_sha256'), str), 'Missing compiler log hash')
                self.pins.verify(path.parent/'compiler.log', row['log_sha256'])
                self.guard_bundle(n, row['artifact_bundle'])
                self.accepted[n] = {'path': path, 'receipt_sha256': index['receipt_sha256'], 'row': row}
            except (RuntimeError, OSError, KeyError, ValueError) as error:
                rejected.append({'module': n, 'reason': str(error)})
        save(self.out/'invocations'/self.invocation/'RESUME_VALIDATION.json', {'accepted': list(self.accepted), 'rejected': rejected})

    def profile(self, n):
        hint = self.hints.get(n, {})
        heavy = n.rsplit('.', 1)[-1] in ['FiniteA5Matrix', 'FinitePMatrix'] or hint.get('heavy', False)
        pure = self.external_dependencies[n] <= {'Init'}
        kind = 'heavy' if heavy else ('pure' if pure else 'mathlib')
        reserve = int(hint.get('memory_mib', {'heavy': 4900, 'pure': 256, 'mathlib': 1100}[kind]))*MIB
        return {'kind': kind, 'reservation': reserve, 'timeout': float(hint.get('timeout', self.a.timeout))}

    def build_one(self, n, profile):
        attempt_id = uuid.uuid4().hex; attempt = self.out/'attempts'/n/attempt_id
        stage = attempt/'stage'; stage.mkdir(parents=True)
        output = stage/module_path(n, '.olean'); output.parent.mkdir(parents=True, exist_ok=True)
        command = [self.rt['lean'], '-j1', '-DautoImplicit=false', '-R', str(self.src), '-o', str(output), str(self.src/module_path(n))]
        row = {'schema': SCHEMA, 'module': n, 'build_id': self.origin['build_id'], 'invocation': self.invocation,
               'identity_hash': self.identity_hash, 'source_sha256': self.modules[n]['sha256'],
               'dependencies': self.dependency_snapshot(n), 'status': 'RUNNING', 'exit_code': None,
               'command': command, 'profile': profile, 'started_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}
        save(attempt/'receipt.json', row); start = time.monotonic(); process = None
        try:
            self.guard_dependencies(n); self.guard_runtime(module=n)
            if self.interrupted.is_set():
                row['status'] = 'INTERRUPTED_NO_PASS'
                raise InterruptedError('Owned build interrupted before compiler launch')
            with (attempt/'compiler.log').open('w') as log:
                process = subprocess.Popen(command, cwd=str(self.src), env=self.env, stdout=log,
                                           stderr=subprocess.STDOUT, start_new_session=True)
                deadline = time.monotonic()+profile['timeout']
                while process.poll() is None:
                    if self.interrupted.is_set() or time.monotonic() >= deadline:
                        row['status'] = 'INTERRUPTED_NO_PASS' if self.interrupted.is_set() else 'TIMEOUT'
                        try: os.killpg(process.pid, signal.SIGTERM)
                        except ProcessLookupError: pass
                        try: process.wait(timeout=5)
                        except subprocess.TimeoutExpired:
                            try: os.killpg(process.pid, signal.SIGKILL)
                            except ProcessLookupError: pass
                            process.wait()
                        break
                    try: process.wait(timeout=min(1, max(.01, deadline-time.monotonic())))
                    except subprocess.TimeoutExpired: pass
                row['exit_code'] = process.returncode
            self.guard_dependencies(n); self.guard_runtime(module=n)
            if row['status'] in ['TIMEOUT', 'INTERRUPTED_NO_PASS']: pass
            elif row['exit_code'] != 0: row['status'] = 'COMPILER_FAILED'
            else:
                bundle = self.bundle(n, stage)
                check(bool(bundle), 'Compiler produced no artifact bundle')
                oldbase = self.art/module_path(n, '.olean')
                for old in artifact_files(oldbase):
                    if old.is_file():
                        target = attempt/'superseded'/old.name; target.parent.mkdir(exist_ok=True); os.replace(str(old), str(target))
                for relative in bundle:
                    target = self.art/relative; target.parent.mkdir(parents=True, exist_ok=True)
                    os.replace(str(stage/relative), str(target))
                self.guard_bundle(n, bundle)
                row['artifact_bundle'] = bundle; row['status'] = 'COMPILE_PASS'
        except Exception as error:
            if row['status'] != 'INTERRUPTED_NO_PASS': row['status'] = 'GUARD_OR_RUNNER_FAILED'
            row['error'] = repr(error)
            if process is not None and process.poll() is None:
                os.killpg(process.pid, signal.SIGKILL); process.wait()
        row['seconds'] = time.monotonic()-start
        row['log_sha256'] = sha(attempt/'compiler.log') if (attempt/'compiler.log').exists() else None
        save(attempt/'receipt.json', row)
        result = {'path': attempt/'receipt.json', 'receipt_sha256': sha(attempt/'receipt.json'), 'row': row}
        if row['status'] == 'COMPILE_PASS':
            save(self.out/'accepted'/module_path(n, '.json'), {'receipt_path': str(result['path'].relative_to(self.out)),
                                                            'receipt_sha256': result['receipt_sha256']})
        print(n, row['status'], round(row['seconds'], 2), flush=True)
        return result

    def control(self):
        value = read(self.a.control) if self.a.control and Path(self.a.control).exists() else {}
        jobs = int(value.get('jobs', self.a.jobs)); check(1 <= jobs <= self.a.jobs, 'Control jobs outside configured cap')
        deferred = set(value.get('defer', [])); check(deferred <= set(self.names), 'Unknown deferred module')
        return jobs, bool(value.get('stop', False)), deferred

    def admit(self, profile, active_profiles):
        if profile['kind'] == 'heavy' and any(p['kind'] != 'pure' for p in active_profiles): return False
        if profile['kind'] == 'mathlib' and any(p['kind'] == 'heavy' for p in active_profiles): return False
        if profile['kind'] == 'mathlib' and sum(p['kind'] == 'mathlib' for p in active_profiles) >= self.a.max_mathlib_jobs: return False
        reserved = sum(p['reservation'] for p in active_profiles) + profile['reservation']
        if reserved > self.budget: return False
        mem = memory_snapshot()
        if mem['nonreclaimable'] is not None:
            if mem['nonreclaimable'] + profile['reservation'] > self.memory_limit-self.a.memory_reserve_mib*MIB: return False
        return True

    def summary(self, status, waiting, active):
        value = {'status': status, 'build_id': self.origin['build_id'], 'invocation': self.invocation,
                 'identity_hash': self.identity_hash, 'expected_modules': len(self.names),
                 'roots': self.sl['roots'], 'compiled_this_invocation': self.compiled,
                 'validated_passes_from_prior_invocations': self.reused, 'failed': self.failed,
                 'waiting': sorted(waiting), 'active': sorted(v[0] for v in active.values()),
                 'completed_modules': len(self.accepted), 'fresh_project_origin': True,
                 'external_cache_used': True, 'installed_kernel_replay_claim': False,
                 'runtime_guard_policy': 'Full cache hashes/inventory at start/end; compiler/loader and selected external bundles before/after each module; periodic full metadata/hash checkpoints. No concurrent writers to pinned runtime/cache roots permitted.'}
        save(self.out/'invocations'/self.invocation/'SUMMARY.json', value)
        save(self.out/'SUMMARY.json', value)

    def run(self):
        previous = {}
        def stop_handler(signum, frame): self.interrupted.set()
        for sig in [signal.SIGINT, signal.SIGTERM]:
            previous[sig] = signal.signal(sig, stop_handler)
        try: return self.run_scheduler()
        except Exception as error:
            self.failed.append({'module': None, 'status': 'FINAL_OR_SCHEDULER_GUARD_FAILED', 'error': repr(error)})
            self.summary('GUARD_FAILED', set(self.names)-set(self.accepted), {})
            return 2
        finally:
            for sig, handler in previous.items(): signal.signal(sig, handler)

    def run_scheduler(self):
        waiting = set(self.names)-set(self.accepted); active = {}; stopped = False; blocked_since = None
        profiles = {n: self.profile(n) for n in waiting}
        pool = concurrent.futures.ThreadPoolExecutor(max_workers=self.a.jobs)
        try:
            while waiting or active:
                jobs, stop, deferred = self.control(); stopped = stopped or stop or self.interrupted.is_set()
                if time.monotonic()-self.last_runtime_checkpoint >= self.a.runtime_checkpoint:
                    self.guard_runtime(checkpoint=True); self.last_runtime_checkpoint = time.monotonic()
                eligible = [n for n in waiting if n not in deferred and set(self.deps[n]) <= set(self.accepted)]
                if not stopped and not self.failed:
                    for n in sorted(eligible, key=lambda n: (profiles[n]['kind'] != 'heavy', n)):
                        if len(active) >= jobs: break
                        if not self.admit(profiles[n], [v[1] for v in active.values()]): continue
                        waiting.remove(n); active[pool.submit(self.build_one, n, profiles[n])] = (n, profiles[n])
                if not active:
                    if stopped or self.failed or (waiting and not eligible): break
                    if waiting:
                        if blocked_since is None: blocked_since = time.monotonic()
                        if time.monotonic()-blocked_since >= self.a.resource_wait:
                            self.failed.append({'module': None, 'status': 'RESOURCE_ADMISSION_BLOCKED'})
                            break
                        self.summary('WAITING_FOR_MEMORY', waiting, active); time.sleep(2); continue
                    break
                blocked_since = None
                ready, _ = concurrent.futures.wait(active, timeout=2, return_when=concurrent.futures.FIRST_COMPLETED)
                for future in ready:
                    n, _ = active.pop(future)
                    try: result = future.result()
                    except Exception as error:
                        self.failed.append({'module': n, 'status': 'WORKER_FAILED', 'error': repr(error)}); continue
                    if result['row']['status'] == 'COMPILE_PASS': self.accepted[n] = result; self.compiled.append(n)
                    else: self.failed.append({'module': n, 'status': result['row']['status'], 'receipt': str(result['path'])})
                self.summary('RUNNING', waiting, active)
        except BaseException as error:
            self.interrupted.set()
            self.failed.append({'module': None, 'status': 'SCHEDULER_FAILED', 'error': repr(error)})
            for future, (n, _) in list(active.items()):
                try:
                    result = future.result(timeout=20)
                    if result['row']['status'] == 'COMPILE_PASS': self.accepted[n] = result; self.compiled.append(n)
                    else: self.failed.append({'module': n, 'status': result['row']['status'], 'receipt': str(result['path'])})
                except BaseException as child_error:
                    self.failed.append({'module': n, 'status': 'WORKER_EXCEPTION', 'error': repr(child_error)})
            active.clear()
        finally:
            pool.shutdown(wait=True)
        if self.failed: self.summary('BUILD_FAILED', waiting, active); return 1
        if waiting: self.summary('STOPPED_OR_DEFERRED_INCOMPLETE', waiting, active); return 3
        self.guard_runtime(full=True); self.guard_source(self.names); self.validate_artifact_inventory()
        for n in self.names:
            self.pins.verify(self.accepted[n]['path'], self.accepted[n]['receipt_sha256'])
            self.pins.verify(self.accepted[n]['path'].parent/'compiler.log', self.accepted[n]['row']['log_sha256'])
            self.guard_dependencies(n); self.guard_bundle(n, self.accepted[n]['row']['artifact_bundle'])
        status = 'FRESH_PROJECT_SOURCE_BUILD_PASS' if not self.a.resume else 'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED'
        self.summary(status, waiting, active); return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    source = commands.add_parser('prepare-source-lock')
    source.add_argument('--source-root', required=True); source.add_argument('--namespace', default='D1Bound5')
    source.add_argument('--roots', nargs='+', default=['D1Bound5']); source.add_argument('--out', required=True)
    runtime = commands.add_parser('prepare-runtime-lock')
    runtime.add_argument('--toolchain', required=True); runtime.add_argument('--external-path', action='append', default=[])
    runtime.add_argument('--extra-file', action='append', default=[]); runtime.add_argument('--environment')
    runtime.add_argument('--expected-version', default='4.33.1'); runtime.add_argument('--out', required=True)
    run = commands.add_parser('run')
    for name in ['source-root', 'build-dir', 'source-lock', 'source-lock-sha256', 'runtime-lock', 'runtime-lock-sha256']:
        run.add_argument('--'+name, required=True)
    run.add_argument('--expected-modules', type=int, required=True)
    run.add_argument('--jobs', type=int, choices=range(1, 8), default=4)
    run.add_argument('--max-mathlib-jobs', type=int, default=2)
    run.add_argument('--timeout', type=float, default=240)
    run.add_argument('--resource-wait', type=float, default=300)
    run.add_argument('--runtime-checkpoint', type=float, default=60)
    run.add_argument('--memory-limit-mib', type=int, default=0)
    run.add_argument('--memory-budget-mib', type=int, default=0)
    run.add_argument('--memory-reserve-mib', type=int, default=768)
    run.add_argument('--hints'); run.add_argument('--control'); run.add_argument('--resume', action='store_true')
    args = parser.parse_args()
    try:
        if args.command == 'prepare-source-lock': result = source_lock(args.source_root, args.roots, args.namespace)
        elif args.command == 'prepare-runtime-lock': result = make_runtime_lock(args)
        else: return Build(args).run()
        save(args.out, result); print(json.dumps({'path': args.out, 'sha256': sha(args.out), 'schema': SCHEMA})); return 0
    except KeyboardInterrupt:
        print('FRESH_BUILD_INTERRUPTED during initialization (no compiler children)', file=sys.stderr)
        return 130
    except Exception as error:
        print('FRESH_BUILD_ERROR:', repr(error), file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
