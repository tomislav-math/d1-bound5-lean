#!/usr/bin/env python3
"""Guard the unmodified Lean 4.33.1 leanchecker; never implements proof checking.

plan: no Lean subprocess; freeze: hash inputs, no Lean subprocess;
run: dry run unless --execute is present. A fresh PASS is distinct from an
import-context project-closure PASS. See PLAN.md for scope and limitations.
"""
import argparse
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import signal
import subprocess
import sys
import time

MIB = 1024 ** 2
NAME = re.compile(r"D1Bound5(?:\.[A-Za-z_][A-Za-z_0-9']*)+")


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for b in iter(lambda: f.read(MIB), b''):
            h.update(b)
    return h.hexdigest()


def utc():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def write(path, data):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(data, indent=2, sort_keys=True) + '\n')
    tmp.replace(path)


def module_name(s):
    if not s:
        raise ValueError('An exact nonempty project module is required')
    n = s if s == 'D1Bound5' or s.startswith('D1Bound5.') else 'D1Bound5.' + s
    if n != 'D1Bound5' and not NAME.fullmatch(n):
        raise ValueError('Invalid or non-project exact module: ' + repr(s))
    return n


def closure_manifest(path, project, target):
    """Accept the integration source inventory, not as proof acceptance."""
    d = json.loads(Path(path).read_text())
    hashes = d.get('source_closure')
    if hashes is None:
        hashes = {n: r['sha256'] for n, r in d['modules'].items()}
    hashes = {module_name(n): h for n, h in hashes.items()}
    deps = {module_name(n): [module_name(x) for x in xs]
            for n, xs in d['dependencies'].items()}
    active, done, order = set(), set(), []

    def visit(n):
        if n in done:
            return
        if n in active:
            raise ValueError('Project dependency cycle: ' + n)
        if n not in hashes or n not in deps:
            raise ValueError('Incomplete source inventory: ' + n)
        active.add(n)
        for x in deps[n]:
            visit(x)
        active.remove(n)
        done.add(n)
        order.append(n)

    visit(target)
    sources = {}
    for n in order:
        p = project / (n.replace('.', '/') + '.lean')
        if sha(p) != hashes[n]:
            raise ValueError('Source changed since inventory: ' + str(p))
        sources[str(p)] = hashes[n]
    return order, sources


def search_roots(env):
    components = env['LEAN_PATH'].split(os.pathsep)
    if any(not p or not Path(p).is_absolute() for p in components):
        raise ValueError('Every LEAN_PATH component must be explicit, nonempty, and absolute')
    return list(dict.fromkeys(str(Path(p).resolve()) for p in components))


def approved_environment(env):
    # Do not inherit loader overrides or other Lean configuration from the
    # supervisor environment. These exact values become part of the freeze.
    result = {key: env[key] for key in ('PATH', 'LEAN_PATH', 'LD_PRELOAD')}
    result['LEAN_PATH'] = os.pathsep.join(search_roots(env))
    result.update(LEAN_NUM_THREADS='0', LANG='C.UTF-8', LC_ALL='C.UTF-8')
    return result


def distribution_libraries(root):
    # Pin the full bundled shared-library set, including transitive runtime
    # dependencies, rather than only libleanshared.so. Host libc/loader remain
    # part of the operating-system trust boundary.
    lib = root / 'lean-4.33.1-linux/lib'
    return {str(p.absolute()): sha(p) for p in lib.rglob('*')
            if p.is_file() and (p.name.endswith('.so') or '.so.' in p.name)}


def process_memory(proc_dir):
    try:
        fields = {}
        for line in (proc_dir / 'status').read_text().splitlines():
            key, _, value = line.partition(':')
            if key in ('VmRSS', 'VmSize', 'VmPeak', 'VmHWM', 'RssAnon', 'RssFile'):
                fields[key] = int(value.split()[0]) * 1024
        return fields
    except FileNotFoundError:
        return {}  # The child may have exited between poll and sampling.


def resolve_module(roots, name):
    # Match Lean.SearchPath.findWithExt: first root owning the package wins.
    package = name.split('.')[0]
    for r in map(Path, roots):
        if (r / package).is_dir() or (r / (package + '.olean')).exists():
            p = r / (name.replace('.', '/') + '.olean')
            if not p.is_file():
                raise ValueError('Missing selected artifact: ' + str(p))
            return p
    raise ValueError('No search root owns package for ' + name)


def validate_clean_paths(root, project, build_root, roots, env, order):
    """The final checker must not silently consume the candidate artifact tree."""
    candidate_source = (root / 'project').resolve()
    candidate_build = (candidate_source / '.lake/build/lib/lean').resolve()
    if project == candidate_source or build_root == candidate_build:
        raise ValueError('Final freeze requires the clean checkout and clean artifact root')
    if env.get('LD_PRELOAD') != str(root / 'proc_self_exe_compat.so'):
        raise ValueError('Only the reviewed executable-path compatibility shim is permitted')
    if build_root not in [Path(p) for p in roots]:
        raise ValueError('Explicit clean artifact root is absent from the pinned LEAN_PATH')
    builtin = (root / 'lean-4.33.1-linux/lib/lean').resolve()
    if str(builtin) not in roots:
        raise ValueError('Implicit official builtin search root must be explicit and frozen')
    for r in map(Path, roots):
        owns_project = (r / 'D1Bound5').is_dir() or (r / 'D1Bound5.olean').exists()
        if r == candidate_build or (owns_project and r != build_root):
            raise ValueError('A second/candidate D1Bound5 artifact root is forbidden: ' + str(r))
    for n in order:
        selected = resolve_module(roots, n).resolve()
        expected = build_root / (n.replace('.', '/') + '.olean')
        if selected != expected or not selected.is_relative_to(build_root):
            raise ValueError('Project module does not resolve exclusively to clean output: ' + n)


def artifact_inventory(roots):
    # All search-path olean and IR parts, not a guessed source-level closure.
    # Environment.readIRPartsOfMod derives .ir.sig/.ir beside the selected
    # .olean, and the private importer loads them even with loadExts=false.
    # Pin their existence too: newly added IR parts change the import inputs.
    result = {}
    for r in map(Path, roots):
        if not r.is_dir():
            raise ValueError('Missing search path: ' + str(r))
        for p in r.rglob('*'):
            if p.is_file() and (p.name.endswith('.olean') or
                               p.name.endswith('.olean.server') or
                               p.name.endswith('.olean.private') or
                               p.name.endswith('.ir.sig') or
                               p.name.endswith('.ir')):
                result[str(p.resolve())] = sha(p)
    return result


def clean_lock_evidence(root, project, build_root, env, order, sources, manifest, source_lock_path, runtime_lock_path, compile_project=None):
    origin = json.loads((build_root.parent / 'ORIGIN.json').read_text())
    identity = origin['identity']
    source_lock = json.loads(source_lock_path.read_text())
    runtime_lock = json.loads(runtime_lock_path.read_text())
    if (sha(source_lock_path) != identity['source_lock_sha256'] or
            sha(runtime_lock_path) != identity['runtime_lock_sha256']):
        raise ValueError('Clean build source/runtime lock hashes differ from original identity')
    if (source_lock['namespace'] != 'D1Bound5' or source_lock['module_count'] != len(order)
            or set(source_lock['sources']) != set(order)
            or source_lock['roots'] != [order[-1]]):
        raise ValueError('Clean source lock has a different module scope')
    data = json.loads(Path(manifest).read_text())
    dependencies = {module_name(n): [module_name(x) for x in ds]
                    for n, ds in data['dependencies'].items()}
    pins = {str(source_lock_path): sha(source_lock_path), str(runtime_lock_path): sha(runtime_lock_path)}
    for name in order:
        row = source_lock['sources'][name]
        relative = name.replace('.', '/') + '.lean'
        path = project / relative
        project_imports = [n for n in row['imports'] if n == 'D1Bound5' or n.startswith('D1Bound5.')]
        if (row['relative_path'] != relative or row['sha256'] != sources[str(path)]
                or row['bytes'] != path.stat().st_size or set(project_imports) != set(dependencies[name])):
            raise ValueError('Clean source lock differs from final source inventory: ' + name)
    for relative, expected in source_lock['auxiliary'].items():
        if relative not in ('lean-toolchain', 'lakefile.toml', 'lakefile.lean', 'lake-manifest.json'):
            raise ValueError('Unexpected clean project configuration path')
        path = project / relative
        if sha(path) != expected:
            raise ValueError('Clean project configuration changed: ' + str(path))
        pins[str(path)] = expected
    toolchain = root / 'lean-4.33.1-linux'
    compiler = str(toolchain / 'bin/lean')
    arguments = ['-j1', '-DautoImplicit=false', '-R', str(project if compile_project is None else compile_project)]
    if (runtime_lock['lean'] != compiler or runtime_lock['toolchain'] != str(toolchain)
            or identity['lean_arguments'] != arguments):
        raise ValueError('Clean build compiler/toolchain/options differ from reviewed Lean configuration')
    if runtime_lock['environment'] != {'LD_PRELOAD': str(root / 'proc_self_exe_compat.so')}:
        raise ValueError('Clean runtime lock has unreviewed loader overrides')
    expected_roots = [str(build_root)] + runtime_lock['external_paths']
    if search_roots(env) != expected_roots:
        raise ValueError('Clean build runtime external paths differ from final checker paths')
    recorded_env = identity['environment']
    exact_env = {'PATH': str(toolchain / 'bin') + ':/usr/bin:/bin:/usr/sbin:/sbin',
                 'LEAN_PATH': os.pathsep.join(expected_roots), 'LEAN_SYSROOT': str(toolchain),
                 'LEAN_NUM_THREADS': '1', 'OMP_NUM_THREADS': '1',
                 'LANG': 'C.UTF-8', 'LC_ALL': 'C.UTF-8', **runtime_lock['environment']}
    if (any(recorded_env.get(k) != v for k, v in exact_env.items())
            or set(recorded_env) - set(exact_env) - {'HOME', 'USER', 'LOGNAME', 'SYSTEMROOT'}):
        raise ValueError('Clean compiler environment differs from the reviewed runner recipe')
    if compiler not in runtime_lock['files']:
        raise ValueError('Clean runtime lock omits the compiler')
    for path, expected in runtime_lock['files'].items():
        if sha(path) != expected:
            raise ValueError('Clean runtime/cache input changed: ' + path)
        pins[path] = expected
    return pins, compiler, arguments


def clean_build_evidence(project, build_root, env, order, sources, inventory, manifest, compiler, lean_arguments, compile_project=None):
    """Validate and pin the portable DAG runner's completed clean receipts.

    This is provenance validation, never proof checking. Only the upstream
    installed checker below performs kernel replay.
    """
    build = build_root.parent
    origin_path, summary_path = build / 'ORIGIN.json', build / 'SUMMARY.json'
    origin = json.loads(origin_path.read_text())
    summary = json.loads(summary_path.read_text())
    identity = origin['identity']
    digest = hashlib.sha256(json.dumps(identity, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    if origin['identity_hash'] != digest or origin['initial_artifact_inventory'] != []:
        raise ValueError('Clean build identity/empty-origin evidence is invalid')
    if ((Path(identity['source_root']).resolve() != project if compile_project is None else
         identity['source_root'] != str(compile_project)) or
            Path(identity['build_dir']).resolve() != build or build_root.name != 'artifacts'):
        raise ValueError('Clean build origin paths differ from selected source/artifacts')
    if approved_environment(identity['environment']) != approved_environment(env):
        raise ValueError('Clean build environment differs from selected checker environment')
    if (summary['status'] not in ('FRESH_PROJECT_SOURCE_BUILD_PASS', 'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED')
            or summary['identity_hash'] != digest or summary['build_id'] != origin['build_id']
            or not summary['fresh_project_origin'] or summary['failed'] or summary['active'] or summary['waiting']
            or summary['expected_modules'] != len(order) or summary['completed_modules'] != len(order)):
        raise ValueError('The selected clean source build is not complete for the exact final closure')
    completed = summary['compiled_this_invocation'] + summary['validated_passes_from_prior_invocations']
    if len(completed) != len(order) or set(completed) != set(order):
        raise ValueError('Clean build completion module list differs from final closure')
    data = json.loads(Path(manifest).read_text())
    dependencies = {module_name(n): [module_name(x) for x in ds]
                    for n, ds in data['dependencies'].items()}
    pins = {str(origin_path): sha(origin_path), str(summary_path): sha(summary_path)}
    accepted = {}
    for name in order:
        pointer = build / 'accepted' / (name.replace('.', '/') + '.json')
        index = json.loads(pointer.read_text())
        receipt = (build / index['receipt_path']).resolve()
        if not receipt.is_relative_to((build / 'attempts').resolve()):
            raise ValueError('Clean receipt pointer escapes build attempts: ' + name)
        receipt_hash = sha(receipt)
        if receipt_hash != index['receipt_sha256']:
            raise ValueError('Clean receipt hash differs: ' + name)
        row = json.loads(receipt.read_text())
        source = str((project if compile_project is None else compile_project) / (name.replace('.', '/') + '.lean'))
        current_source = str(project / (name.replace('.', '/') + '.lean'))
        output = str(receipt.parent / 'stage' / (name.replace('.', '/') + '.olean'))
        if row['command'] != [compiler, *lean_arguments, '-o', output, source]:
            raise ValueError('Clean receipt compiler command differs from the reviewed recipe: ' + name)
        if (row['status'] != 'COMPILE_PASS' or row['exit_code'] != 0 or row['module'] != name
                or row['build_id'] != origin['build_id'] or row['identity_hash'] != digest
                or row['source_sha256'] != sources[current_source]):
            raise ValueError('Clean module receipt is not accepted for this source/build: ' + name)
        expected_deps = {n: accepted[n] for n in dependencies[name]}
        if row['dependencies'] != expected_deps:
            raise ValueError('Clean receipt dependency chain differs: ' + name)
        base = name.replace('.', '/')
        allowed = {base + s for s in ('.olean', '.olean.server', '.olean.private', '.ir.sig', '.ir')}
        bundle = row['artifact_bundle']
        if base + '.olean' not in bundle or not set(bundle) <= allowed:
            raise ValueError('Unexpected clean artifact bundle paths: ' + name)
        if any((build_root / relative).resolve() != build_root / relative for relative in bundle):
            raise ValueError('Clean artifact part is a symlink escape: ' + name)
        actual = {relative: inventory[str((build_root / relative).resolve())]
                  for relative in allowed if (build_root / relative).is_file()}
        if actual != bundle:
            raise ValueError('Clean accepted artifact bundle differs: ' + name)
        log = receipt.parent / 'compiler.log'
        if sha(log) != row['log_sha256']:
            raise ValueError('Clean compiler log changed: ' + name)
        pins.update({str(pointer): sha(pointer), str(receipt): receipt_hash, str(log): row['log_sha256']})
        accepted[name] = {'receipt_sha256': receipt_hash, 'artifact_bundle': bundle}
    bridge_fields = {} if compile_project is None else {
        'accepted_receipt_chain_sha256': bridge_digest(accepted),
        'artifact_bundles_sha256': bridge_digest({p: h for row in accepted.values() for p, h in row['artifact_bundle'].items()})}
    return pins, {**bridge_fields, 'build_id': origin['build_id'], 'identity_hash': digest,
                  'status': summary['status'], 'module_count': len(order),
                  'scope': 'Exact source/artifact/dependency receipts from initially empty project output; external runtime caches retained'}


# Optional explicit source relocation. These checks bind historical evidence;
# they do not execute Lean, repeat an axiom audit, or manufacture proof acceptance.
BRIDGE_COMMIT = 'b4c81242dd9c9cee6966a1e08bce0f94c66f1491'
BRIDGE_TREE = 'ee490da49ba30447d92745140f48c1ae3c34f263'
BRIDGE_SOURCE_LOCK = 'b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c'
BRIDGE_COUNT = 4406
BRIDGE_HARNESSES = {
    'scripts/verification/FinalIntegrationAudit.lean': '005f05312ef81f9a961e1c8adefb00b98e514cca3794adcc438118e4edf5d1ac',
    'scripts/verification/FinalTargetAudit.lean': 'b21a0deae156faabd97ad38e87920a5f9f16700cad843c3e38e040c90aaa61d7'}
BRIDGE_BROAD_SHA = '0e4779bb1f294d3588dd409e9afe616855346da52172596efabd9adca594537f'
BRIDGE_POLICY_SHA = '46b5b3cdc7a4228a53a05b7e62cb0e549ad212b67282fbd2c0fa4cce97ac8b9b'
BRIDGE_POLICY_MANIFEST_SHA = 'fa84386224dedc9b6a9a4fa76679b7bdaf1250cf1927e0ae59c170bc4eee9550'


def bridge_require(condition, message):
    if not condition:
        raise ValueError('Relocation bridge: ' + message)


def bridge_digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def bridge_path(value, live=True):
    p = Path(value)
    bridge_require(isinstance(value, str) and p.is_absolute() and str(p) == value and
                   '..' not in p.parts and '.' not in p.parts, 'noncanonical absolute path')
    if live:
        bridge_require(p.resolve(strict=True) == p, 'symlink/alias path: ' + value)
        for parent in (p, *p.parents):
            bridge_require(not parent.is_symlink(), 'symlink path component: ' + value)
    return p


def bridge_git_storage(project):
    # A retained clone must not consult another workspace, object store, or
    # configuration include. Reject indirect/partial forms rather than repair
    # them. This only inspects metadata and never invokes Git writes/network.
    gitdir = bridge_path(str(project/'.git'))
    bridge_require(gitdir.is_dir(), 'Standalone Git directory is required')
    for p in gitdir.rglob('*'):
        bridge_require(not p.is_symlink() and (p.is_dir() or p.is_file()), 'Nonregular/symlink Git metadata')
        bridge_require(not p.name.endswith('.promisor'), 'Promisor Git object store is forbidden')
    for name in ('commondir', 'gitdir', 'shallow', 'config.worktree'):
        bridge_require(not (gitdir/name).exists(), 'Indirect/shallow Git metadata is forbidden: ' + name)
    for name in ('objects/info/alternates', 'objects/info/http-alternates'):
        p = gitdir/name
        bridge_require(not p.exists() or not p.read_bytes().strip(), 'External Git object alternates are forbidden')
    config = (gitdir/'config').read_text()
    bridge_require(re.search(r'^\s*\[\s*include', config, re.I | re.M) is None and
                   re.search(r'^\s*(?:partialclone|promisor)\s*(?:=|[;#]|$)', config, re.I | re.M) is None,
                   'External include/partial/promisor Git configuration is forbidden')


def bridge_git(project, expected):
    bridge_git_storage(project)
    # Read only. Never rely on status alone: assume-unchanged/index flags cannot
    # hide modified blobs, and ignored/untracked payloads are inventoried below.
    git_env = {'PATH': '/usr/bin:/bin', 'GIT_CONFIG_NOSYSTEM': '1',
               'GIT_CONFIG_GLOBAL': '/dev/null', 'GIT_OPTIONAL_LOCKS': '0'}
    def git(*words):
        return subprocess.check_output(['git', '--no-optional-locks', '-c', 'core.fsmonitor=false',
                                        '-C', str(project), *words], env=git_env)
    bridge_require(git('rev-parse', '--show-toplevel').decode().strip() == str(project), 'Git top-level mismatch')
    for flag in ('--absolute-git-dir', '--git-common-dir'):
        selected = Path(git('rev-parse', flag).decode().strip())
        if not selected.is_absolute(): selected = project/selected
        bridge_require(selected.resolve(strict=True) == project/'.git', 'External Git metadata directory')
    bridge_require(git('rev-parse', 'HEAD').decode().strip() == BRIDGE_COMMIT, 'Git candidate mismatch')
    bridge_require(git('rev-parse', 'HEAD^{tree}').decode().strip() == BRIDGE_TREE, 'Git tree mismatch')
    bridge_require(git('status', '--porcelain=v1', '--untracked-files=all') == b'', 'Git worktree/index is not clean')
    bridge_require(git('rev-parse', '--show-object-format').decode().strip() == 'sha1', 'Unexpected Git object format')
    entries = {}
    for raw in git('ls-tree', '-r', '-z', 'HEAD').split(b'\0'):
        if not raw:
            continue
        head, name = raw.split(b'\t', 1)
        mode, kind, oid = head.decode().split()
        relative = name.decode()
        bridge_require(mode in ('100644', '100755') and kind == 'blob', 'Nonregular tracked path')
        bridge_require(relative not in entries, 'Duplicate Git path')
        entries[relative] = oid
    bridge_require(set(entries) == set(expected), 'Git tracked scope differs from exact source/config/harness set')
    actual = {}
    dirs = {}
    for parent, dirnames, filenames in os.walk(project, followlinks=False):
        parent = Path(parent)
        if parent == project:
            bridge_require('.git' in dirnames and (project/'.git').is_dir() and not (project/'.git').is_symlink(), 'A regular local Git directory is required')
            dirnames.remove('.git')
        for name in dirnames:
            bridge_require(not (parent/name).is_symlink(), 'Symlink directory in replay source')
        st = parent.stat()
        dirs[str(parent.relative_to(project))] = [st.st_dev, st.st_ino, st.st_mtime_ns, st.st_ctime_ns]
        for name in filenames:
            path = bridge_path(str(parent/name))
            bridge_require(path.is_file(), 'Nonregular replay source file')
            relative = str(path.relative_to(project))
            body = path.read_bytes()
            actual[relative] = hashlib.sha256(body).hexdigest()
            if relative in entries:
                blob = hashlib.sha1(b'blob ' + str(len(body)).encode() + b'\0' + body).hexdigest()
                bridge_require(blob == entries[relative], 'Actual bytes differ from committed blob: ' + relative)
    bridge_require(actual == expected, 'Extra/missing/changed replay source/config/harness file')
    bridge_require(git('rev-parse', 'HEAD').decode().strip() == BRIDGE_COMMIT and
                   git('rev-parse', 'HEAD^{tree}').decode().strip() == BRIDGE_TREE and
                   git('status', '--porcelain=v1', '--untracked-files=all') == b'', 'Git identity changed during scan')
    bridge_git_storage(project)
    return {'commit': BRIDGE_COMMIT, 'tree': BRIDGE_TREE, 'object_format': 'sha1',
            'clean_worktree': True, 'selected_committed_blobs': entries}, dirs


def bridge_load(path, expected_sha, project, build_root, root, source_lock_path, runtime_lock_path, manifest_path):
    bridge_require(re.fullmatch('[0-9a-f]{64}', expected_sha or '') is not None, 'Missing explicit reviewed manifest SHA256')
    path = bridge_path(str(path))
    bridge_require(sha(path) == expected_sha, 'Manifest SHA256 differs')
    data = json.loads(path.read_text())
    required = {'schema', 'kind', 'original_compile_root', 'replay_source_root', 'artifact_root',
                'distribution_root', 'candidate_commit', 'candidate_tree', 'source_lock_sha256',
                'runtime_lock_sha256', 'source_inventory_sha256', 'build_origin_sha256',
                'build_summary_sha256', 'build_id', 'build_identity_hash', 'records', 'retained_files'}
    bridge_require(set(data) == required and data['schema'] == 1 and
                   data['kind'] == 'D1BOUND5_REPLAY_SOURCE_RELOCATION', 'Manifest schema/keys differ')
    original = bridge_path(data['original_compile_root'], live=False)
    replay = bridge_path(data['replay_source_root'])
    bridge_require(replay == project and replay != original and not replay.is_relative_to(original) and
                   not original.is_relative_to(replay), 'Compile/replay roots must be explicit disjoint identities')
    bridge_require(str(build_root) == data['artifact_root'] and str(root) == data['distribution_root'], 'Artifact/runtime relocation is forbidden')
    bridge_require(data['candidate_commit'] == BRIDGE_COMMIT and data['candidate_tree'] == BRIDGE_TREE and
                   data['source_lock_sha256'] == BRIDGE_SOURCE_LOCK, 'Unreviewed source candidate/lock')
    for p, key in [(source_lock_path, 'source_lock_sha256'), (runtime_lock_path, 'runtime_lock_sha256'),
                   (manifest_path, 'source_inventory_sha256'), (build_root.parent/'ORIGIN.json', 'build_origin_sha256'),
                   (build_root.parent/'SUMMARY.json', 'build_summary_sha256')]:
        bridge_path(str(p))
        bridge_require(sha(p) == data[key], 'Pinned bridge input changed: ' + key)
    origin = json.loads((build_root.parent/'ORIGIN.json').read_text())
    bridge_require(origin['identity']['source_root'] == str(original) and origin['build_id'] == data['build_id'] and
                   origin['identity_hash'] == data['build_identity_hash'], 'Original compile identity mismatch')
    sl = json.loads(source_lock_path.read_text())
    bridge_require(sl['module_count'] == BRIDGE_COUNT and len(sl['sources']) == BRIDGE_COUNT and
                   set(sl['auxiliary']) == {'lean-toolchain', 'lakefile.lean', 'lake-manifest.json'}, 'Exact production/config scope mismatch')
    expected = {v['relative_path']: v['sha256'] for v in sl['sources'].values()}
    bridge_require(len(expected) == BRIDGE_COUNT, 'Duplicate source-lock relative path')
    expected.update(sl['auxiliary']); expected.update(BRIDGE_HARNESSES)
    git_identity, directories = bridge_git(project, expected)
    records = {'exact_summary', 'exact_input_freeze', 'integration_log', 'target_log',
               'broad_summary', 'broad_evidence_freeze', 'broad_log', 'source_policy_report', 'source_policy_manifest'}
    bridge_require(set(data['records']) == records, 'Exact audit record roles are required')
    retained = data['retained_files']
    bridge_require(isinstance(retained, dict), 'Explicit retained-file mapping required')
    destinations = set()
    for old, row in retained.items():
        bridge_path(old, live=False)
        bridge_require(set(row) == {'path', 'sha256'}, 'Invalid retained mapping row')
        new = bridge_path(row['path'])
        bridge_require(not new.is_relative_to(original), 'Retained evidence still depends on old source root')
        bridge_require(row['path'] not in destinations, 'Retained-file destination collision')
        destinations.add(row['path'])
        bridge_require(new.is_file() and sha(new) == row['sha256'], 'Retained evidence changed')
    bridge_require(sha(path) == expected_sha, 'Manifest changed during validation')
    return {'path': str(path), 'sha256': expected_sha, 'manifest': data, 'original': str(original),
            'replay': str(project), 'git_identity': git_identity, 'directories': directories,
            'expected_sources': expected, 'source_lock_path': str(source_lock_path),
            'runtime_lock_path': str(runtime_lock_path), 'source_inventory_path': str(manifest_path)}


def bridge_artifact_inventory(artifact_root):
    artifact_root = bridge_path(str(artifact_root))
    result = {}
    for parent, dirs, files in os.walk(artifact_root, followlinks=False):
        for name in dirs:
            bridge_require(not (Path(parent)/name).is_symlink(), 'Symlink directory in isolated artifacts')
        for name in files:
            part = bridge_path(str(Path(parent)/name))
            bridge_require(part.is_file(), 'Nonregular isolated artifact part')
            result[str(part)] = sha(part)
    return result


def bridge_bind(context, pins, build_pins, build_evidence, artifacts, compiler, origin):
    data = context['manifest']; original = Path(context['original']); replay = Path(context['replay'])
    retained = data['retained_files']; used = set(); extra = {}; mapped = {}
    def bind(old, expected=None):
        old_path = bridge_path(old, live=False)
        if old_path.is_relative_to(original):
            relative = str(old_path.relative_to(original))
            bridge_require(relative in context['expected_sources'], 'Unselected old source path in evidence')
            new = replay/relative
        elif old in retained:
            used.add(old); new = bridge_path(retained[old]['path'])
            bridge_require(expected is None or retained[old]['sha256'] == expected, 'Retained evidence expected hash mismatch')
        else:
            new = bridge_path(old)
            bridge_require(old in pins, 'Historical non-source input requires explicit retained mapping: ' + old)
        actual = sha(new)
        bridge_require(expected is None or actual == expected, 'Historical evidence bytes changed: ' + old)
        bridge_require(str(new) not in pins or pins[str(new)] == actual, 'Historical/current frozen input mismatch')
        extra[str(new)] = actual; mapped[old] = str(new)
        return new
    def record(role):
        old = data['records'][role]
        bridge_require(old in retained, 'Record must have explicit immutable mapping: ' + role)
        return bind(old, retained[old]['sha256'])
    paths = {role: record(role) for role in data['records']}
    exact = json.loads(paths['exact_summary'].read_text()); audited = json.loads(paths['exact_input_freeze'].read_text())
    bridge_require(exact['status'] == 'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS' and
                   exact['post_audit_all_input_hashes_equal'] is True and exact['accepted_fresh_project_modules'] == BRIDGE_COUNT and
                   exact['input_freeze_sha256'] == sha(paths['exact_input_freeze']) and
                   exact['source_lock_sha256'] == data['source_lock_sha256'] and exact['runtime_lock_sha256'] == data['runtime_lock_sha256'], 'Exact audit summary is not accepted for these inputs')
    bridge_require(audited['schema'] == 1 and audited['source_root'] == str(original) and
                   audited['artifact_root'] == data['artifact_root'] and audited['build_dir'] == str(Path(data['artifact_root']).parent) and
                   audited['build_id'] == data['build_id'] and audited['identity_hash'] == data['build_identity_hash'] and
                   audited['source_lock_sha256'] == data['source_lock_sha256'] and audited['runtime_lock_sha256'] == data['runtime_lock_sha256'] and
                   audited['accepted_modules'] == BRIDGE_COUNT and audited['lean'] == compiler and
                   audited['environment'] == origin['identity']['environment'] and audited['git_identity'] == context['git_identity'], 'Exact audit identity differs from completed build/replay clone')
    rt = json.loads(Path(context['runtime_lock_path']).read_text())
    bridge_require(audited['runtime_inventory_sha256'] == bridge_digest(rt['files']) and
                   audited['runtime_file_count'] == len(rt['files']), 'Exact audited runtime inventory differs')
    for key in ('accepted_receipt_chain_sha256', 'artifact_bundles_sha256'):
        bridge_require(audited[key] == build_evidence[key], 'Exact audited build artifact/receipt identity differs')
    for old, expected in audited['files'].items(): bind(old, expected)
    # Completeness in both directions: no current source, pin, or accepted part
    # may silently fall outside the exact audited snapshot.
    required = {**build_pins, **{p: h for p, h in artifacts.items() if Path(p).is_relative_to(Path(data['artifact_root']))}}
    required.update({str(replay/p): h for p, h in context['expected_sources'].items()})
    audited_current = {new: audited['files'][old] for old, new in mapped.items() if old in audited['files']}
    artifact_root = bridge_path(data['artifact_root'])
    actual_parts = bridge_artifact_inventory(artifact_root)
    audited_parts = {p: h for p, h in audited_current.items() if Path(p).is_relative_to(artifact_root)}
    bridge_require(actual_parts == audited_parts, 'Extra/missing/changed isolated artifact membership')
    for p, expected in required.items():
        bridge_require(audited_current.get(p) == expected, 'Current build/source input absent from exact audit: ' + p)
    expected_audits = [('FinalIntegrationAudit', 'integration_log', 114, 'ORIGINAL_TYPE_AXIOMS_PASS', 'scripts/verification/FinalIntegrationAudit.lean'),
                       ('FinalTargetAudit', 'target_log', 4, 'FINAL_TARGET_AXIOMS_PASS', 'scripts/verification/FinalTargetAudit.lean')]
    bridge_require(len(exact['audits']) == 2, 'Wrong exact audit count')
    for row, (name, log, count, marker, harness) in zip(exact['audits'], expected_audits):
        bridge_require(row['name'] == name and row['exit_code'] == 0 and row['expected_pass_markers'] == row['observed_pass_markers'] == count and
                       row['audit_sha256'] == BRIDGE_HARNESSES[harness] and row['log_sha256'] == sha(paths[log]) and
                       paths[log].read_text().count(marker) == count and
                       row['command'] == [compiler, '-j1', '-DautoImplicit=false', '-R', str(original), str(original/harness)], 'Exact audit command/log/marker mismatch')
    broad = json.loads(paths['broad_summary'].read_text()); bf = json.loads(paths['broad_evidence_freeze'].read_text())
    bridge_require(broad['status'] == 'CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS' and broad['exit_code'] == 0 and
                   broad['all_clean_source_artifact_runtime_git_and_evidence_guards_equal'] is True and
                   broad['exact_audit_input_freeze_sha256'] == bf['exact_audit_input_freeze_sha256'] == sha(paths['exact_input_freeze']) and
                   broad['broad_source_sha256'] == BRIDGE_BROAD_SHA and broad['log_sha256'] == sha(paths['broad_log']), 'Broad audit summary/input binding mismatch')
    for old, expected in bf['files'].items(): bind(old, expected)
    command = broad['command']
    bridge_require(len(command) == 6 and command[:4] == [compiler, '-j1', '-DautoImplicit=false', '-R'] and
                   command[4] == bf['command_root'] == str(Path(command[5]).parent) and
                   bf['files'].get(command[5]) == BRIDGE_BROAD_SHA, 'Broad historical command/source mismatch')
    for role in ('exact_summary', 'exact_input_freeze', 'integration_log', 'target_log'):
        old = data['records'][role]
        bridge_require(bf['files'].get(old) == sha(paths[role]), 'Broad evidence omits exact audit record')
    text = paths['broad_log'].read_text(); lines = [s.strip() for s in text.splitlines()]
    public = [int(m.group(1)) for s in lines if (m := re.fullmatch(r'AXIOM_AUDIT_PASS: (\d+) project declarations', s))]
    private = [int(m.group(1)) for s in lines if (m := re.fullmatch(r'BROAD_PROJECT_AXIOM_AUDIT_PASS (\d+) declarations', s))]
    targets = [m.group(1) for s in lines if (m := re.match(r'^FINAL_TARGET_AXIOMS_PASS (D1Bound5\.[^: ]+):', s))]
    individual = sum(s.startswith('AUDIT D1Bound5.') or s.startswith('AUDIT D1Bound5:') for s in lines)
    bridge_require(len(public) == len(private) == 1 and public[0] > 0 and private[0] >= public[0] and individual == public[0] and
                   len(targets) == 4 and set(targets) == {'D1Bound5.MainStatement', 'D1Bound5.IsD1', 'D1Bound5.IsD1Tuple', 'D1Bound5.main_statement'}, 'Broad audit markers differ')
    bridge_require(broad['markers'] == {'exported_project_declarations': public[0], 'including_private_declarations': private[0],
                   'independent_target_markers': 4, 'individual_exported_audit_lines': individual}, 'Broad recorded markers differ')
    bridge_require(sha(paths['source_policy_report']) == BRIDGE_POLICY_SHA and
                   sha(paths['source_policy_manifest']) == BRIDGE_POLICY_MANIFEST_SHA, 'Reviewed source-policy evidence differs')
    policy = json.loads(paths['source_policy_report'].read_text()); sm = json.loads(paths['source_policy_manifest'].read_text())
    bridge_require(policy['status'] == 'SOURCE_POLICY_PASS_SOURCE_ONLY' and policy['production_module_count'] == policy['reachable_module_count'] == BRIDGE_COUNT and
                   all(policy[k] == [] for k in ('errors', 'unreviewed_findings', 'unreviewed_options', 'source_changes_during_scan')), 'Source-only policy is not accepted')
    sl = json.loads(Path(context['source_lock_path']).read_text())
    bridge_require(sm == {n: {k: row[k] for k in ('bytes', 'relative_path', 'sha256')} for n, row in sl['sources'].items()}, 'Source-policy map differs from exact source lock')
    bridge_require(used == set(retained), 'Unused/ambiguous retained mapping entries')
    bridge_require(sha(context['path']) == context['sha256'], 'Bridge mapping changed during binding')
    extra[context['path']] = context['sha256']
    return extra


def cgroup():
    p = Path('/sys/fs/cgroup')
    maximum = (p / 'memory.max').read_text().strip()
    if maximum == 'max':
        raise ValueError('Finite Linux cgroup memory limit is required')
    stat = dict((k, int(v)) for k, v in
                (line.split() for line in (p / 'memory.stat').read_text().splitlines()))
    events = dict((k, int(v)) for k, v in
                  (line.split() for line in (p / 'memory.events').read_text().splitlines()))
    # Do not count clean file cache as unreclaimable. Counting all kernel
    # memory is conservative (part of it is reclaimable).
    resident_floor = sum(stat.get(k, 0) for k in
                         ('anon', 'kernel', 'shmem', 'file_dirty', 'file_writeback'))
    return {'limit': int(maximum), 'current': int((p / 'memory.current').read_text()),
            'resident_floor': resident_floor, 'events': events, 'stat': stat}


def build_freeze(args, root, env, roots, checker):
    project = args.project_root.resolve()
    build_root = args.project_build_root.resolve()
    relocation = None
    if getattr(args, 'source_relocation_manifest', None) is not None:
        bridge_require(args.target == 'D1Bound5', 'Relocation supports the full canonical root only')
        bridge_require(str(args.project_root) == str(project), 'Replay root alias is forbidden')
        relocation = bridge_load(args.source_relocation_manifest, args.source_relocation_sha256,
                                 project, build_root, root, args.source_lock.resolve(),
                                 args.runtime_lock.resolve(), args.manifest.resolve())
    compile_project = None if relocation is None else Path(relocation['original'])
    order, source_files = closure_manifest(args.manifest, project, args.target)
    validate_clean_paths(root, project, build_root, roots, env, order)
    runtime = json.loads((root / 'RUNTIME_SETUP.json').read_text())
    expected = {
        root / 'lean-4.33.1-linux/bin/lean': runtime['lean_binary_sha256'],
        root / 'lean-4.33.1-linux/lib/lean/libleanshared.so': runtime['kernel_library_sha256'],
        root / 'proc_self_exe_compat.so': runtime['compat_object_sha256'],
    }
    for p, h in expected.items():
        if sha(p) != h:
            raise ValueError('Runtime differs from reviewed setup: ' + str(p))
    artifacts = artifact_inventory(roots)
    lock_pins, compiler, lean_arguments = clean_lock_evidence(
        root, project, build_root, env, order, source_files, args.manifest,
        args.source_lock.resolve(), args.runtime_lock.resolve(), compile_project=compile_project)
    build_pins, build_evidence = clean_build_evidence(
        project, build_root, env, order, source_files, artifacts, args.manifest, compiler, lean_arguments,
        compile_project=compile_project)
    clean_runner = root / 'fresh_project_build.py'
    clean_origin = json.loads((build_root.parent / 'ORIGIN.json').read_text())
    if sha(clean_runner) != clean_origin['identity']['runner_sha256']:
        raise ValueError('Completed clean build used a different DAG runner than the reviewed current file')
    build_pins[str(clean_runner)] = sha(clean_runner)
    shared_libraries = distribution_libraries(root)
    for path, expected_hash in {**artifacts, **shared_libraries}.items():
        if not Path(path).is_relative_to(build_root) and lock_pins.get(path) != expected_hash:
            raise ValueError('Current external artifact/runtime library is absent or changed in the clean runtime lock: ' + path)
    extra = [checker, Path(__file__).resolve(), args.lean_env.resolve(),
             root / 'RUNTIME_SETUP.json', Path(args.manifest).resolve(),
             root / 'mathlib/lake-manifest.json']
    extra.extend(project / n for n in ['lean-toolchain', 'lake-manifest.json', 'lakefile.lean', 'lakefile.toml']
                 if (project / n).is_file())
    pins = {**source_files, **artifacts, **{str(p): sha(p) for p in extra},
            **{str(p): h for p, h in expected.items()}, **shared_libraries, **lock_pins, **build_pins}
    bridge_record = {}
    if relocation is not None:
        # Builder may have been copied byte-for-byte since its historical audit.
        audit_build_pins = {p: h for p, h in build_pins.items() if p != str(clean_runner)}
        pins.update(bridge_bind(relocation, pins, audit_build_pins, build_evidence, artifacts, compiler, clean_origin))
        bridge_require(all(Path(p).is_relative_to(Path('/tmp')) for p in pins),
                       'Relocated freeze must have no live input outside retained /tmp roots')
        after = bridge_load(args.source_relocation_manifest, args.source_relocation_sha256,
                            project, build_root, root, args.source_lock.resolve(),
                            args.runtime_lock.resolve(), args.manifest.resolve())
        bridge_require(after == relocation, 'Replay source/Git/mapping changed during freeze')
        bridge_record = {'source_relocation': relocation}
    parent_names = set()
    for p in artifacts:
        if not p.endswith('.olean'):
            continue
        for r in map(Path, roots):
            if Path(p).is_relative_to(r):
                components = Path(p).relative_to(r).with_suffix('').parts
                parent_names.update('.'.join(components[:i]) for i in range(1, len(components)))
    for n in order:
        # Structural dotted-name prefixes only; Data4 does not select Data40.
        if n != 'D1Bound5' and n in parent_names:
            raise ValueError('Exact serial module has dotted descendants: ' + n)
    return {**bridge_record, 'schema': 3 if relocation is None else 4, 'status': 'FROZEN_INPUTS_NOT_PROOF', 'utc': utc(),
            'target': args.target, 'project_order': order,
            'source_inventory_sha256': sha(args.manifest),
            'source_inventory_scope': 'Caller-provided source import graph; not an acceptance ledger',
            'roots': roots, 'artifacts': artifacts, 'pins': pins,
            'shared_libraries': shared_libraries, 'distribution_root': str(root),
            'project_root': str(project), 'project_build_root': str(build_root),
            'lean_env_path': str(args.lean_env.resolve()),
            'clean_output_policy': 'Every project module resolves only to the explicitly selected clean artifact root; candidate/cache roots excluded',
            'clean_build_evidence': build_evidence,
            'env': approved_environment(env), 'checker': str(checker), 'cwd': str(project),
            'notes': 'Fresh scope is the actual compiled root imports, independent of this source graph.'}


def validate(frozen):
    if frozen.get('schema') not in (3, 4):
        raise ValueError('A schema-3 or explicit relocation schema-4 freeze is required')
    if frozen.get('schema') == 4:
        prior = frozen['source_relocation']
        current = bridge_load(Path(prior['path']), prior['sha256'], Path(frozen['project_root']),
                              Path(frozen['project_build_root']), Path(frozen['distribution_root']),
                              Path(prior['source_lock_path']), Path(prior['runtime_lock_path']),
                              Path(prior['source_inventory_path']))
        bridge_require(current == prior, 'Replay source/Git/mapping no longer matches freeze')
        build_root = Path(frozen['project_build_root'])
        bridge_require(bridge_artifact_inventory(build_root) ==
                       {p: h for p, h in frozen['artifacts'].items() if Path(p).is_relative_to(build_root)},
                       'Isolated artifact membership/bytes changed since relocation freeze')
        bridge_require(frozen['pins'].get(prior['path']) == prior['sha256'] and
                       all(Path(p).is_relative_to(Path('/tmp')) for p in frozen['pins']),
                       'Relocation manifest missing from pins or old live input retained')
    validate_clean_paths(Path(frozen['distribution_root']), Path(frozen['project_root']),
                         Path(frozen['project_build_root']), frozen['roots'],
                         frozen['env'], frozen['project_order'])
    for p, h in frozen['pins'].items():
        if p in frozen['artifacts']:
            continue
        if not Path(p).is_file() or sha(p) != h:
            raise ValueError('Frozen input changed: ' + p)
    if artifact_inventory(frozen['roots']) != frozen['artifacts']:
        raise ValueError('Artifact search universe changed (added/removed/modified file)')
    if distribution_libraries(Path(frozen['distribution_root'])) != frozen['shared_libraries']:
        raise ValueError('Bundled shared-library universe changed')


def execute(args, frozen, output):
    validate(frozen)
    env = approved_environment(frozen['env'])
    # No executable options other than the three flags recognized upstream.
    targets = [frozen['target']] if args.mode == 'fresh' else frozen['project_order']
    if args.mode != 'fresh' and 'D1Bound5' in targets:
        raise ValueError('The canonical umbrella requires --fresh; serial prefix expansion is forbidden')
    address_limit = args.address_space_mib * MIB
    physical_budget = args.physical_memory_mib * MIB
    reserve = args.reserve_mib * MIB
    before = cgroup()
    if physical_budget + before['resident_floor'] + reserve > before['limit']:
        raise RuntimeError('Insufficient quiescent memory budget; no checker launched')
    result = {'status': 'RUNNING', 'mode': args.mode, 'utc_start': utc(),
              'freeze_sha256': sha(args.freeze), 'LEAN_NUM_THREADS': '0',
              'address_space_limit': address_limit, 'physical_rss_budget': physical_budget,
              'reserve': reserve,
              'memory_enforcement': 'RLIMIT_AS bounds virtual space; RSS/cgroup reserve are sampled watchdogs, not a hard per-process RAM limit. The hard physical limit is the enclosing cgroup.',
              'cgroup_before': before, 'runs': [],
              'scope': ('Actual imported constant map replayed into an empty environment'
                        if args.mode == 'fresh' else
                        'Listed project modules individually replayed; imports trusted within each call')}
    write(output / 'RESULT.json', result)

    for index, target in enumerate(targets):
        module_name(target)
        cmd = [frozen['checker'], '--verbose']
        if args.mode == 'fresh':
            cmd.append('--fresh')
        cmd.append(target)
        log = output / (str(index).zfill(5) + '-' + target + '.log')
        started = time.monotonic()
        row = {'target': target, 'command': cmd, 'log': str(log), 'utc_start': utc()}
        stopped = None
        report_r, report_w = os.pipe()

        def child_limits():
            resource.setrlimit(resource.RLIMIT_AS, (address_limit, address_limit))
            resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
            # /proc is mounted outside the child PID namespace here. Its
            # self symlink supplies the correct host-visible proc directory.
            os.write(report_w, os.readlink('/proc/self').encode('ascii') + b'\n')
            os.close(report_w)

        with log.open('wb') as f:
            try:
                proc = subprocess.Popen(cmd, cwd=frozen['cwd'], env=env,
                                        stdout=f, stderr=subprocess.STDOUT,
                                        start_new_session=True, preexec_fn=child_limits,
                                        pass_fds=(report_w,))
            except BaseException:
                os.close(report_r)
                os.close(report_w)
                raise
            os.close(report_w)
            with os.fdopen(report_r, 'rb') as report:
                proc_name = report.read(128).decode('ascii').strip()
            # Validate this inside the cleanup-protected region below.
            memory_samples = []
            peak_rss = peak_virtual = 0
            try:
                if not proc_name.isdigit():
                    raise RuntimeError('Child did not report its actual /proc identity')
                proc_dir = Path('/proc') / proc_name
                row['proc_directory'] = str(proc_dir)
                while proc.poll() is None:
                    sample = cgroup()
                    child = process_memory(proc_dir)
                    peak_rss = max(peak_rss, child.get('VmRSS', 0), child.get('VmHWM', 0))
                    peak_virtual = max(peak_virtual, child.get('VmSize', 0), child.get('VmPeak', 0))
                    memory_samples.append({'seconds': round(time.monotonic() - started, 3),
                                           'child': child, 'cgroup_current': sample['current'],
                                           'cgroup_resident_floor': sample['resident_floor']})
                    if sample['resident_floor'] > sample['limit'] - reserve:
                        stopped = 'CGROUP_MEMORY_RESERVE'
                    elif child.get('VmRSS', 0) > physical_budget:
                        stopped = 'CHILD_RSS_BUDGET'
                    elif time.monotonic() - started > args.timeout_seconds:
                        stopped = 'TIME_LIMIT'
                    if stopped:
                        os.killpg(proc.pid, signal.SIGTERM)
                        try:
                            proc.wait(timeout=5)
                        except subprocess.TimeoutExpired:
                            os.killpg(proc.pid, signal.SIGKILL)
                            proc.wait()
                        break
                    time.sleep(0.5)
            except BaseException:
                if proc.poll() is None:
                    os.killpg(proc.pid, signal.SIGTERM)
                    try:
                        proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        os.killpg(proc.pid, signal.SIGKILL)
                        proc.wait()
                raise
        row.update(exit_code=proc.returncode, seconds=time.monotonic() - started,
                   termination_reason=stopped, log_sha256=sha(log),
                   sampled_peak_rss=peak_rss, sampled_peak_virtual=peak_virtual)
        memory_log = log.with_suffix('.memory.json')
        write(memory_log, memory_samples)
        row.update(memory_log=str(memory_log), memory_log_sha256=sha(memory_log))
        expected_banner = 'replaying ' + target + (' with --fresh' if args.mode == 'fresh' else '')
        row['expected_banner_seen'] = expected_banner in log.read_text(errors='replace').splitlines()
        result['runs'].append(row)
        write(output / 'RESULT.json', result)
        print(json.dumps(row), flush=True)
        if proc.returncode != 0 or stopped or not row['expected_banner_seen']:
            result['status'] = 'INCOMPLETE_CHECKER_FAILURE_OR_RESOURCE_LIMIT'
            break
    else:
        result['status'] = ('FRESH_INTEGRATED_KERNEL_REPLAY_PASS' if args.mode == 'fresh'
                            else 'PROJECT_IMPORT_CONTEXT_REPLAY_PASS_NOT_FRESH')
    try:
        validate(frozen)
    except Exception as e:
        result['status'] = 'INVALIDATED_INPUT_CHANGED'
        result['input_error'] = str(e)
    result.update(utc_end=utc(), cgroup_after=cgroup(),
                  child_max_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
                  axiom_gate='Separate exact-type and allowed-transitive-axiom audit required',
                  skipped_by_upstream='unsafe and partial declarations')
    result['oom_event_deltas'] = {
        key: result['cgroup_after']['events'].get(key, 0) - before['events'].get(key, 0)
        for key in ('oom', 'oom_kill', 'oom_group_kill')}
    if any(result['oom_event_deltas'].values()):
        result['status'] = 'INVALIDATED_CGROUP_OOM_EVENT'
    write(output / 'RESULT.json', result)
    return 0 if result['status'].endswith('PASS') or result['status'].endswith('NOT_FRESH') else 1


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('action', choices=['plan', 'freeze', 'run'])
    ap.add_argument('--offload-root', type=Path, default=Path(__file__).resolve().parent.parent)
    ap.add_argument('--project-root', type=Path, help='Clean source checkout; required for freeze')
    ap.add_argument('--project-build-root', type=Path, help='Clean Lean library directory; required for freeze')
    ap.add_argument('--lean-env', type=Path, help='Pinned clean-build environment JSON; required for freeze')
    ap.add_argument('--source-lock', type=Path, help='Original reviewed clean source lock; required for freeze')
    ap.add_argument('--runtime-lock', type=Path, help='Original reviewed clean runtime lock; required for freeze')
    ap.add_argument('--source-relocation-manifest', type=Path, help='Optional explicit retained source/evidence bridge; freeze only')
    ap.add_argument('--source-relocation-sha256', help='Externally reviewed bridge manifest SHA256; required with manifest')
    ap.add_argument('--target', type=module_name, default='D1Bound5')
    ap.add_argument('--manifest', type=Path)
    ap.add_argument('--freeze', type=Path, default=Path(__file__).resolve().parent / 'FREEZE.json')
    ap.add_argument('--output', type=Path, default=Path(__file__).resolve().parent / 'run')
    ap.add_argument('--mode', choices=['fresh', 'project-serial'], default='fresh')
    ap.add_argument('--address-space-mib', type=int, default=32768)
    ap.add_argument('--physical-memory-mib', type=int, default=6144)
    ap.add_argument('--reserve-mib', type=int, default=1024)
    ap.add_argument('--timeout-seconds', type=int, default=86400)
    ap.add_argument('--execute', action='store_true')
    args = ap.parse_args()
    relocation_flags = (args.source_relocation_manifest is not None, args.source_relocation_sha256 is not None)
    if any(relocation_flags) and (args.action != 'freeze' or not all(relocation_flags)):
        ap.error('Relocation manifest and SHA256 must occur together, and only on freeze')
    root = args.offload_root.resolve()
    env = json.loads(args.lean_env.read_text()) if args.lean_env is not None else None
    roots = search_roots(env) if env is not None else []
    checker = root / 'lean-4.33.1-linux/bin/leanchecker'
    if args.action == 'plan':
        print(json.dumps({'status': 'PLAN_ONLY_NO_CHECKER_LAUNCHED', 'target': args.target,
                          'command': [str(checker), '--verbose', '--fresh', args.target],
                          'LEAN_NUM_THREADS': '0', 'search_roots': roots,
                          'project_root': str(args.project_root) if args.project_root else 'REQUIRED_CLEAN_CHECKOUT',
                          'project_build_root': str(args.project_build_root) if args.project_build_root else 'REQUIRED_CLEAN_ARTIFACT_ROOT',
                          'lean_env_path': str(args.lean_env) if args.lean_env else 'REQUIRED_PINNED_CLEAN_ENVIRONMENT',
                          'hard_address_space_mib': args.address_space_mib,
                          'sampled_physical_rss_budget_mib': args.physical_memory_mib,
                          'reserve_mib': args.reserve_mib}, indent=2))
        return 0
    if args.action == 'freeze':
        if any(x is None for x in (args.manifest, args.project_root, args.project_build_root,
                                   args.lean_env, args.source_lock, args.runtime_lock)):
            ap.error('freeze requires --manifest, --project-root, --project-build-root, --lean-env, --source-lock, and --runtime-lock for the clean build')
        write(args.freeze, build_freeze(args, root, env, roots, checker))
        print('Frozen inputs only; no checker launched: ' + str(args.freeze))
        return 0
    frozen = json.loads(args.freeze.read_text())
    if args.target != frozen['target']:
        ap.error('target differs from frozen target')
    if not args.execute:
        print(json.dumps({'status': 'DRY_RUN_NO_CHECKER_LAUNCHED', 'mode': args.mode,
                          'target': frozen['target'], 'frozen_project_modules': len(frozen['project_order'])}))
        return 0
    if (args.physical_memory_mib < 1024 or args.address_space_mib < args.physical_memory_mib
            or args.reserve_mib < 1024 or args.timeout_seconds < 1):
        ap.error('Unsafe resource budget')
    args.output.mkdir(parents=True, exist_ok=True)
    with (Path(__file__).parent / 'CHECKER_LOCK').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        return execute(args, frozen, args.output)


if __name__ == '__main__':
    try:
        sys.exit(main())
    except Exception as exc:
        print('REFUSED_OR_INCOMPLETE: ' + str(exc), file=sys.stderr)
        sys.exit(2)
