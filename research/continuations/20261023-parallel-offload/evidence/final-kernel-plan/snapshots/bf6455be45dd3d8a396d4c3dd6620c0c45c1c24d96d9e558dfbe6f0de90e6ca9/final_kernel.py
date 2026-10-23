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


def clean_build_evidence(project, build_root, env, order, sources, inventory, manifest):
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
    if (Path(identity['source_root']).resolve() != project or
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
        source = str(project / (name.replace('.', '/') + '.lean'))
        if (row['status'] != 'COMPILE_PASS' or row['exit_code'] != 0 or row['module'] != name
                or row['build_id'] != origin['build_id'] or row['identity_hash'] != digest
                or row['source_sha256'] != sources[source]):
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
    return pins, {'build_id': origin['build_id'], 'identity_hash': digest,
                  'status': summary['status'], 'module_count': len(order),
                  'scope': 'Exact source/artifact/dependency receipts from initially empty project output; external runtime caches retained'}


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
    build_pins, build_evidence = clean_build_evidence(project, build_root, env, order, source_files, artifacts, args.manifest)
    clean_runner = root / 'fresh_project_build.py'
    clean_origin = json.loads((build_root.parent / 'ORIGIN.json').read_text())
    if sha(clean_runner) != clean_origin['identity']['runner_sha256']:
        raise ValueError('Completed clean build used a different DAG runner than the reviewed current file')
    build_pins[str(clean_runner)] = sha(clean_runner)
    shared_libraries = distribution_libraries(root)
    extra = [checker, Path(__file__).resolve(), args.lean_env.resolve(),
             root / 'RUNTIME_SETUP.json', Path(args.manifest).resolve(),
             root / 'mathlib/lake-manifest.json']
    extra.extend(project / n for n in ['lean-toolchain', 'lake-manifest.json', 'lakefile.lean', 'lakefile.toml']
                 if (project / n).is_file())
    pins = {**source_files, **artifacts, **{str(p): sha(p) for p in extra},
            **{str(p): h for p, h in expected.items()}, **shared_libraries, **build_pins}
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
    return {'schema': 3, 'status': 'FROZEN_INPUTS_NOT_PROOF', 'utc': utc(),
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
    if frozen.get('schema') != 3:
        raise ValueError('A schema-3 freeze with explicit clean source/artifact paths is required')
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
        if any(x is None for x in (args.manifest, args.project_root, args.project_build_root, args.lean_env)):
            ap.error('freeze requires --manifest, --project-root, --project-build-root, and --lean-env for the clean build')
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
