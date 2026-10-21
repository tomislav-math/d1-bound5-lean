"""Proposal: bind prepared source audits to guarded accepted build evidence.

Default/check/bind modes NEVER launch Lean, Lake, Git, or the project driver.
Only explicit --run executes the reviewed two-lock audit/replay workflow.
This is an isolated adaptation of initial-audit-v2/locked_checks.py, not a
monkeypatch or a second compiler queue. The original runner is not modified.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse
import hashlib
import json
import re
import sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261020T100000CEST-work-resume'
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
DRIVER = WORK / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
BASE_RUNNER = RUN / 'initial-audit-v2/locked_checks.py'
BASE_SHA = 'cbe0905ab28e953c5b14309f60decea9cc454c4d30ecf26c6ad91a1648d4dff6'
BOUND_NAME = 'PREPARATION_BINDINGS.json'
METADATA = ['TARGETS.json', 'REPLAY_TARGETS.json', 'SOURCE_MAP.json',
            'SCOPED_ORIGINAL_DECLARATIONS.json', 'DECLARATION_NAMES.json',
            'BUILD_RECEIPT_MAP.json', 'AnalyticAudit.lean']


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def now():
    return datetime.now(timezone.utc).isoformat()


def load(path):
    return json.loads(Path(path).read_text())


def write_new(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2) + '\n')


def repo_file(value):
    path = Path(value)
    if not path.is_absolute(): path = ROOT / path
    require(path.is_file() and not path.is_symlink(), 'Missing/symlink input: ' + str(path))
    require(path.resolve().is_relative_to(ROOT.resolve()), 'Input outside project: ' + str(path))
    return path.resolve()


def child(value):
    require(re.fullmatch(r'[A-Za-z0-9][A-Za-z0-9_-]*', value), 'Use one direct child audit name')
    out = RUN / value
    require(out.is_dir() and not out.is_symlink(), 'Prepared audit folder missing/symlink')
    return out


def merge_exact(destination, entries, label):
    for key, value in entries.items():
        require(re.fullmatch(r'[0-9a-f]{64}', value), 'Malformed SHA-256: ' + label)
        require(key not in destination or destination[key] == value, 'Conflicting frozen bytes: ' + key)
        destination[key] = value


def collect_binding(out):
    """Read-only until caller explicitly saves a new binding file."""
    targets = load(out / 'TARGETS.json')
    replays = load(out / 'REPLAY_TARGETS.json')
    require(targets and len(targets) == len(set(targets)), 'Empty/duplicate targets')
    require(all(re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*', n) for n in targets), 'Unsafe target name')
    # The initial proposal intentionally keeps one replay per exact target.
    require(replays == targets, 'This proposal requires one replay per target, in target order')
    source_map = load(out / 'SOURCE_MAP.json')
    original_records = load(out / 'SCOPED_ORIGINAL_DECLARATIONS.json')
    receipt_map = load(out / 'BUILD_RECEIPT_MAP.json')
    require(set(source_map) == set(targets) == set(receipt_map), 'Target/map mismatch')
    require(len(original_records) == len(targets), 'Original record count mismatch')
    original_map = {item['module']: item for item in original_records}
    require(set(original_map) == set(targets), 'Original module set mismatch')
    require(sha(DRIVER) == DRIVER_SHA and sha(BASE_RUNNER) == BASE_SHA, 'Reviewed runner/driver drift')
    files = {str(repo_file(out / name)): sha(out / name) for name in METADATA}
    files.update({str(repo_file(__file__)): sha(__file__), str(DRIVER): DRIVER_SHA, str(BASE_RUNNER): BASE_SHA})
    sources = {}
    target_artifacts = {}
    closure_sizes = {}
    for n in targets:
        item = source_map[n]
        current = repo_file(item['source'])
        snapshot = repo_file(item['snapshot'])
        require(current == (ROOT / 'D1Bound5' / (n + '.lean')).resolve(), 'Wrong canonical source')
        require(snapshot == (out / (n + '.lean')).resolve(), 'Snapshot outside exact audit folder')
        expected = item['sha256']
        require(sha(current) == sha(snapshot) == expected, 'Prepared/current source drift: ' + n)
        files[str(snapshot)] = expected
        original = original_map[n]
        original_path = repo_file(original['original_path'])
        require(original_path != current and original_path != snapshot, 'Original is not independently preserved')
        require(sha(original_path) == original['original_sha256'], 'Original snapshot drift: ' + n)
        require(original['current_sha256'] == expected, 'Original record/current map mismatch: ' + n)
        files[str(original_path)] = original['original_sha256']
        reference = receipt_map[n]
        require(set(reference) == {'receipt', 'closure'}, 'Receipt reference must name receipt and closure')
        receipt_path = repo_file(reference['receipt'])
        closure_path = repo_file(reference['closure'])
        files[str(receipt_path)] = sha(receipt_path)
        files[str(closure_path)] = sha(closure_path)
        receipt = load(receipt_path)
        require(receipt['name'] == n and receipt['source_sha256'] == expected, 'Wrong accepted source receipt')
        require(receipt['exit'] == 0 and receipt['accepted_build'] is True and
                receipt['closure_unchanged'] is True and receipt['shared_artifacts_unchanged'] is True and
                receipt['timed_out'] is False and receipt.get('interrupted', False) is False,
                'No exact guarded PASS receipt: ' + n)
        closure = load(closure_path)
        require(closure.get(n) == expected, 'Closure does not bind target: ' + n)
        require(all(re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*', k) for k in closure), 'Unsafe closure module')
        merge_exact(sources, closure, n + ' closure')
        merge_exact(target_artifacts, receipt['artifacts'], n + ' artifacts')
        closure_sizes[n] = len(closure)
    for n, value in sources.items():
        require(sha(ROOT / 'D1Bound5' / (n + '.lean')) == value, 'Accepted closure source drift: ' + n)
    for path, value in target_artifacts.items():
        require(sha(repo_file(path)) == value, 'Accepted target artifact drift: ' + path)
    return {'schema': 1, 'status': 'BOUND_PREPARATION_NOT_AUDIT', 'time': now(),
            'audit_folder': str(out.resolve()), 'targets': targets, 'replays': replays,
            'files': files, 'project_sources': sources, 'target_artifacts': target_artifacts,
            'closure_sizes': closure_sizes, 'compiler_run': False,
            'main_theorem_claim': False, 'original_runner_sha256': BASE_SHA}


def mismatches(binding, hash_file=sha, include_artifacts=True):
    """Pure comparison interface also used by mock-hash unit tests."""
    bad = []
    expected_files = dict(binding['files'])
    expected_files.update({str(ROOT / 'D1Bound5' / (n + '.lean')): h
                           for n, h in binding['project_sources'].items()})
    if include_artifacts:
        expected_files.update({str(ROOT / path): h for path, h in binding['target_artifacts'].items()})
    for path, expected in expected_files.items():
        try:
            if hash_file(path) != expected: bad.append(path)
        except (OSError, ValueError):
            bad.append(path)
    return bad


def binding_for_run(out):
    path = out / BOUND_NAME
    binding = load(path)
    require(binding['schema'] == 1 and binding['audit_folder'] == str(out.resolve()), 'Invalid binding identity')
    require(binding['targets'] == load(out / 'TARGETS.json') and binding['replays'] == load(out / 'REPLAY_TARGETS.json'),
            'Binding target/replay mismatch')
    binding['files'][str(path)] = sha(path)  # Freeze the binding file itself in memory.
    require(not mismatches(binding), 'Prepared binding drift: ' + repr(mismatches(binding)))
    return binding


def run_locked(out):
    # These imports and all subprocess operations are isolated behind --run.
    import fcntl
    import importlib.util
    import os
    import signal
    import subprocess
    import time
    binding = binding_for_run(out)
    targets, replays = binding['targets'], binding['replays']
    reserved = ['BOUND_AUDIT_START.json', 'BOUND_AUDIT_FINAL.json', 'TARGETED_REPLAY_GUARDS.json',
                'TARGETED_REPLAY_RECEIPTS.json', 'active-targeted-replay.json', 'analytic-type-axioms.log']
    reserved += [n + '-targeted-replay.log' for n in replays]
    require(not any((out / n).exists() for n in reserved), 'Prior attempt exists: prepare a new audit directory')
    spec = importlib.util.spec_from_file_location('d1_bound_scoped_checks_driver', DRIVER)
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    records = []
    with (WORK / 'continuation-driver.lock').open('a+') as owner, (WORK / 'continuation-intake.lock').open('a+') as intake:
        fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
        fcntl.flock(intake, fcntl.LOCK_EX | fcntl.LOCK_NB)
        require(not mismatches(binding), 'Preparation drift before locked driver snapshot')
        driver = mod.Driver(ROOT, WORK)
        active = load(driver.active_path)
        require(not active.get('active') and not active.get('protected_closure'), 'Another live proof owner')
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        require(not unknown and queue.get('max_parallel') == 1 and queue.get('pause_after_current') is True,
                'Unexpected queue state')
        require(all(n in accepted for n in targets), 'All exact targets must currently have accepted guarded builds')
        frozen = {}
        for n in targets: merge_exact(frozen, closures[n], n)
        require(frozen == binding['project_sources'], 'Prepared/accepted closure mismatch inside locks')
        expected = {}
        latest = driver.latest()
        for dep in frozen:
            merge_exact(expected, driver.expected_manifest(dep, mod.fingerprint(closures[dep]), latest), dep)
        require(all(expected.get(p) == h for p, h in binding['target_artifacts'].items()),
                'Prepared/current accepted target artifact identities differ')
        require(driver.manifest_matches(expected) and driver.manifest_matches(driver.static), 'Initial artifact/static drift')

        def full_stable():
            return not mismatches(binding) and driver.manifest_matches(expected) and driver.manifest_matches(driver.static)

        require(full_stable(), 'Initial locked binding mismatch')
        write_new(out / 'BOUND_AUDIT_START.json', {'time': now(), 'binding_sha256': sha(out / BOUND_NAME),
                  'source_map_sha256': sha(out / 'SOURCE_MAP.json'), 'targets': targets, 'main_theorem_claim': False})
        write_new(out / 'TARGETED_REPLAY_GUARDS.json', {'project_sources': frozen, 'compiled_artifacts': expected,
                  'immutable_inputs': driver.static, 'preparation_files': binding['files'], 'time': now()})
        commands = [('analytic-type-axioms', ['/Users/tp/.elan/bin/lake', 'env', 'lean', str(out / 'AnalyticAudit.lean')])]
        commands += [(n + '-targeted-replay', ['/Users/tp/.elan/bin/lake', 'env', 'leanchecker', '--verbose', 'D1Bound5.' + n]) for n in replays]

        def stop_child(process):
            if process.poll() is not None: return
            os.killpg(process.pid, signal.SIGTERM)
            try: process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL); process.wait()

        for label, args in commands:
            require(full_stable(), 'Source/preparation/artifact drift before ' + label)
            log = out / (label + '.log')
            started = time.monotonic()
            timed_out = False
            drift = []
            polls = 0
            with log.open('x') as stream:
                process = subprocess.Popen(args, cwd=ROOT, env={**os.environ, 'LEAN_NUM_THREADS': '1'},
                                           stdout=stream, stderr=subprocess.STDOUT, start_new_session=True)
                entry = {'label': label, 'pid': process.pid, 'command': args, 'time': now()}
                (out / 'active-targeted-replay.json').write_text(json.dumps({'active': True, **entry}, indent=2) + '\n')
                print(json.dumps(entry), flush=True)
                try:
                    while process.poll() is None:
                        # Poll preparation metadata, original/snapshot bytes, and
                        # full source closure. Compiled artifacts retain the
                        # original runner's complete before/after checks.
                        drift = mismatches(binding, include_artifacts=False)
                        polls += 1
                        if drift: stop_child(process); break
                        if time.monotonic() - started >= 240:
                            timed_out = True; stop_child(process); break
                        try: process.wait(timeout=1)
                        except subprocess.TimeoutExpired: pass
                finally:
                    # An exception cannot leave an unowned compiler subprocess.
                    stop_child(process)
            stable = full_stable()
            result = {**entry, 'exit': process.returncode, 'seconds': time.monotonic() - started,
                      'timed_out': timed_out, 'guards_unchanged': stable, 'binding_poll_count': polls,
                      'binding_drift_paths': drift, 'log': log.name}
            records.append(result)
            (out / 'TARGETED_REPLAY_RECEIPTS.json').write_text(json.dumps(records, indent=2) + '\n')
            (out / 'active-targeted-replay.json').write_text(json.dumps({'active': False, 'last': result}, indent=2) + '\n')
            print(json.dumps(result), flush=True)
            if result['exit'] or timed_out or drift or not stable:
                write_new(out / 'BOUND_AUDIT_FINAL.json', {'status': 'FAIL_NOT_VERIFIED', 'time': now(), 'records': records,
                          'main_theorem_claim': False})
                return 1
        require(full_stable(), 'Final source/preparation/artifact drift')
        write_new(out / 'BOUND_AUDIT_FINAL.json', {'status': 'BOUND_SCOPED_AUDIT_PASS', 'time': now(),
                  'records': records, 'binding_sha256': sha(out / BOUND_NAME),
                  'source_map_sha256': sha(out / 'SOURCE_MAP.json'), 'main_theorem_claim': False})
        print('BOUND_SCOPED_AUDIT_PASS_NOT_MAIN_THEOREM', flush=True)
    return 0


def self_test():
    good = 'a' * 64
    bad = 'b' * 64
    binding = {'files': {'/fixture/SOURCE_MAP.json': good, '/fixture/original.lean': good},
               'project_sources': {'Example': good}, 'target_artifacts': {'.lake/example.olean': good}}
    require(mismatches(binding, lambda p: good) == [], 'Stable fixture rejected')
    for target in ['/fixture/SOURCE_MAP.json', '/fixture/original.lean',
                   str(ROOT / 'D1Bound5/Example.lean'), str(ROOT / '.lake/example.olean')]:
        require(mismatches(binding, lambda p: bad if p == target else good) == [target], 'Missed binding drift')
    require(len(mismatches(binding, lambda p: (_ for _ in ()).throw(FileNotFoundError()))) == 4, 'Missing file handling')
    try: merge_exact({'x': good}, {'x': bad}, 'test')
    except ValueError: pass
    else: raise ValueError('Conflicting closure accepted')
    return {'status': 'PYTHON_GUARD_TESTS_PASS_NOT_LEAN', 'cases': 7}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument('--bind', action='store_true', help='Write one new binding record; no compiler/driver import')
    modes.add_argument('--check', action='store_true', help='Read-only verification of existing binding; no compiler/driver import')
    modes.add_argument('--run', action='store_true', help='Explicitly execute guarded Lean/leanchecker under both locks')
    modes.add_argument('--self-test', action='store_true', help='Pure mocked-hash tests; no file writes or subprocesses')
    parser.add_argument('audit_child', nargs='?')
    args = parser.parse_args()
    if args.self_test:
        print(json.dumps(self_test(), indent=2)); return 0
    require(args.audit_child is not None, 'Prepared audit child name required')
    out = child(args.audit_child)
    if args.bind:
        require(not (out / BOUND_NAME).exists(), 'Existing binding cannot be overwritten')
        binding = collect_binding(out)
        require(not mismatches(binding), 'Drift during binding preparation')
        write_new(out / BOUND_NAME, binding)
        print('PREPARATION_BOUND_NOT_AUDITED', out); return 0
    if args.run: return run_locked(out)
    binding = binding_for_run(out)
    print('PREPARATION_BINDING_CHECK_PASS_NOT_AUDIT', len(binding['targets']), 'targets')
    return 0


if __name__ == '__main__':
    sys.exit(main())
