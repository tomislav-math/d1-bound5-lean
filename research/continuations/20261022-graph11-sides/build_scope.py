"""Run one reviewed graph11 side scope serially through the guarded worker.

Usage: python3.12 -B build_scope.py sides-pilot|left-rest|right-rest
This records guarded builds only. Audit acceptance remains a separate step.
"""
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
import ast
import fcntl
import hashlib
import importlib.util
import json
import os
import signal
import subprocess
import sys
import tempfile
import time

R = Path('/Users/tp/Lean/D1Bound5')
O = Path(__file__).resolve().parent
EXPECTED_OUT = R / 'research/continuations/20261022-graph11-sides'
PYTHON = '/Users/tp/.local/bin/python3.12'
WORKER_SHA = '454e4c162343902792c09c15fe1487498be07cddc9cf41d1e7d2a48b678b6d7f'
PREPARE_SHA = '70291589163ff26ea091753bc6ef3f53fe94686ed5b2899e77fb7d693bcb072c'
SIGNALS = (signal.SIGTERM, signal.SIGINT, signal.SIGHUP)
SCOPES = {'sides-pilot': [
    'SmallPairLightAdaptiveLeft11_000Part00',
    'SmallPairLightAdaptiveRight11_000Part00',
]}
ALL_TARGETS = []
for side in ('left', 'right'):
    prefix = 'SmallPairLightAdaptive' + side.title() + '11_'
    side_targets = ([prefix + '000Part' + f'{i:02d}' for i in range(6)]
        + [prefix + '000'] + [prefix + '001Part' + f'{i:02d}' for i in range(4)]
        + [prefix + '001', 'SmallPairLight' + side.title() + '11'])
    ALL_TARGETS.extend(side_targets)
    SCOPES[side + '-rest'] = side_targets[1:]


def utc():
    return datetime.now(timezone.utc).isoformat()


def sha(path):
    path = Path(path)
    assert path.is_file() and not path.is_symlink(), str(path)
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def durable_json(path, value, exclusive=False):
    """Fsync a complete replacement, with exclusive initial batch creation."""
    path = Path(path)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8',
                prefix='.' + path.name + '.', suffix='.tmp', dir=path.parent,
                delete=False) as stream:
            temporary = Path(stream.name)
            json.dump(value, stream, indent=2, sort_keys=True)
            stream.write('\n')
            stream.flush()
            os.fsync(stream.fileno())
        if exclusive:
            os.link(temporary, path)
            temporary.unlink()
        else:
            assert path.is_file() and not path.is_symlink()
            os.replace(temporary, path)
        temporary = None
        directory = os.open(path.parent, os.O_RDONLY)
        try:
            os.fsync(directory)
        finally:
            os.close(directory)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def load_checks():
    path = O / 'prepare_checks.py'
    assert sha(path) == PREPARE_SHA
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location('graph11_build_scope_checks', path)
    checks = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = checks
    spec.loader.exec_module(checks)
    assert checks.O == O and checks.R == R and checks.SCOPES == SCOPES
    return checks


@contextmanager
def project_locks(checks):
    # Release these before the worker starts: the worker acquires both itself.
    with (checks.W / 'continuation-driver.lock').open('r+') as owner, \
            (checks.W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        yield


def worker_pins():
    path = O / 'bounded_build.py'
    assert sha(path) == WORKER_SHA, 'Guarded worker changed'
    nodes = [node.value for node in ast.parse(path.read_text()).body
             if isinstance(node, ast.Assign)
             and any(isinstance(target, ast.Name) and target.id == 'PINS'
                     for target in node.targets)]
    assert len(nodes) == 1
    pins = ast.literal_eval(nodes[0])
    assert isinstance(pins, dict) and set(pins) == set(ALL_TARGETS)
    return pins


def metadata(checks):
    plan = load(O / 'PLAN.json')
    receipt = load(O / 'INSTALL_RECEIPT.json')
    assert plan['status'] == 'BOTH_SIDES_PREPARED_NOT_COMPILED'
    assert receipt['status'] == 'BOTH_SIDE_PARTITIONS_INSTALLED_NOT_COMPILED'
    assert plan['targets'] == receipt['targets'] == ALL_TARGETS
    assert plan['scope_targets'] == receipt['scope_targets'] == SCOPES
    assert plan['source_manifest'] == receipt['source_manifest'] == worker_pins()
    assert plan['model'] == [0, 1]
    assert plan['original_parent_counts'] == receipt['original_parent_counts'] == [138, 221]
    assert plan['heads_per_side'] == receipt['heads_per_side'] == 359
    assert receipt['coverage_parts'] == receipt['queue_entries_added'] == 20
    assert receipt['wrappers_unchanged'] and receipt['previous_accepted_sources_retained']
    assert receipt['compiler_run'] is False and receipt['baseline_changed'] is False
    for item in (plan, receipt):
        assert item['root_integration'] is False and item['whole_graph11_complete'] is False
        assert item['main_theorem_complete'] is False
    paths = [O / name for name in ('PLAN.json', 'INSTALL_RECEIPT.json',
        'CONFIGURATION.json', 'FOUNDATION_REUSE_EVIDENCE.json',
        'EXTERNAL_DEPENDENCY_GUARDS.json', 'QUEUE_AFTER.json',
        'bounded_build.py', 'prepare_checks.py')]
    for scope, targets in SCOPES.items():
        path = O / (scope + '-TARGETS.json')
        assert load(path) == targets
        paths.append(path)
    for name, digest in plan['source_manifest'].items():
        source = checks.repo_file('D1Bound5/' + name + '.lean')
        candidate = checks.repo_file(O / 'candidates' / (name + '.lean'))
        assert sha(source) == sha(candidate) == digest, name
        paths.extend([source, candidate])
    return plan, receipt, {str(path): sha(path) for path in paths}


def check_foundation(checks, driver, plan):
    foundation = load(O / 'FOUNDATION_REUSE_EVIDENCE.json')
    summary = load(checks.repo_file(foundation['summary_path']))
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert foundation['summary_path'] == plan['foundation_summary']
    assert foundation['proof_fingerprint'] == summary['proof_fingerprint'] \
        == plan['foundation_proof_fingerprint']
    assert all(sha(checks.repo_file(path)) == digest
               for path, digest in foundation['protected_files'].items())
    assert all(sha(checks.repo_file('D1Bound5/' + name + '.lean')) == digest
               for name, digest in foundation['source_manifest'].items())
    assert foundation['configuration'] == driver.static
    assert driver.manifest_matches(foundation['artifacts'])
    assert driver.manifest_matches(foundation['configuration'])


def checkpoint(checks, scope, plan, install, protected, pilot_reference,
               unattempted=(), completed=()):
    """Validate only; never launch a compiler, update the queue, or run Git."""
    assert sha(O / 'bounded_build.py') == WORKER_SHA
    assert sha(O / 'prepare_checks.py') == PREPARE_SHA
    assert all(sha(path) == digest for path, digest in protected.items()), 'Protected bytes changed'
    module, driver = checks.load_driver()
    checks.idle(driver)
    assert sha(driver.queue_path) == install['queue_sha256_after']
    assert load(driver.queue_path) == load(O / 'QUEUE_AFTER.json')
    assert sha(R / 'D1Bound5.lean') == plan['canonical_root_sha256']
    assert driver.static == load(O / 'CONFIGURATION.json') and driver.manifest_matches(driver.static)
    check_foundation(checks, driver, plan)
    latest = driver.latest()
    for name, item in load(O / 'EXTERNAL_DEPENDENCY_GUARDS.json').items():
        key = module.fingerprint(driver.closure(name))
        expected = driver.expected_manifest(name, key, latest)
        assert key == item['fingerprint'] and expected == item['artifacts'] == driver.artifacts(name), name
    pilot = None if scope == 'sides-pilot' else checks.verify_pilots(driver, module, latest)
    if pilot_reference is not None:
        assert pilot == pilot_reference, 'Pilot proof state, sources, artifacts, or bound receipts changed'
    for name in unattempted:
        key = module.fingerprint(driver.closure(name))
        assert latest.get((name, key)) is None, 'Existing exact attempt: ' + name
        assert not (O / (name + '-BUILD_RECEIPT.json')).exists(), 'Existing build receipt: ' + name
    for child in completed:
        name = child['name']
        receipt_path = O / (name + '-BUILD_RECEIPT.json')
        assert sha(receipt_path) == child['build_receipt_sha256']
        row = load(receipt_path)
        closure = driver.closure(name)
        key = module.fingerprint(closure)
        assert row['name'] == name and row['exit'] == 0 and row['accepted_build'] is True
        assert not row['timed_out'] and not row['interrupted']
        assert row['closure_unchanged'] and row['shared_artifacts_unchanged']
        assert row['source_sha256'] == plan['source_manifest'][name]
        assert load(O / (name + '-SOURCE_CLOSURE.json')) == closure
        assert key == row['fingerprint']
        assert driver.expected_manifest(name, key, latest) == row['artifacts'] == driver.artifacts(name)
    return pilot


def main():
    if not __debug__:
        raise RuntimeError('Do not disable verification assertions')
    assert O == EXPECTED_OUT
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
    scope = sys.argv[1]
    targets = SCOPES[scope]
    checks = load_checks()
    worker = O / 'bounded_build.py'
    batch_path = O / (scope + '-BUILD_BATCH.json')
    current = None
    current_row = None
    stop_signals = []
    record = None

    def forward(sig, _frame):
        stop_signals.append({'signal': sig, 'utc': utc()})
        if current is not None and current.poll() is None:
            try:
                current.send_signal(sig)
            except ProcessLookupError:
                pass

    def save(exclusive=False):
        record['signals'] = list(stop_signals)
        durable_json(batch_path, record, exclusive)

    def drain():
        # The worker owns the inner 240-second limit and its compiler teardown.
        # Never kill it before its finally/reap path has drained its children.
        while True:
            try:
                return current.wait(timeout=1)
            except subprocess.TimeoutExpired:
                if record['signals'] != stop_signals:
                    save()

    # This extra lock serializes all three scope controllers, without holding
    # either project lock while a child worker needs those locks itself.
    with (O / 'build-scope.lock').open('a+') as batch_lock:
        fcntl.flock(batch_lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not batch_path.exists(), 'Existing batch record: review separately; never resume or repeat'
        for sig in SIGNALS:
            signal.signal(sig, forward)
        with project_locks(checks):
            plan, install, protected = metadata(checks)
            pilot = checkpoint(checks, scope, plan, install, protected, None, unattempted=targets)
        record = {'status': 'RUNNING', 'scope': scope, 'pid': os.getpid(),
                  'started_utc': utc(), 'targets': targets, 'children': [], 'signals': [],
                  'worker_sha256': WORKER_SHA, 'prepare_helpers_sha256': PREPARE_SHA,
                  'controller_sha256': sha(Path(__file__)), 'inner_target_timeout_seconds': 240,
                  'plan_sha256': sha(O / 'PLAN.json'), 'protected_files': protected,
                  'pilot_reuse_evidence': pilot, 'queue_changed': False,
                  'audit_acceptance_claim': False, 'whole_graph11_complete': False,
                  'main_theorem_complete': False}
        save(exclusive=True)
        try:
            for index, name in enumerate(targets):
                assert not stop_signals, 'Stop requested'
                with project_locks(checks):
                    checkpoint(checks, scope, plan, install, protected, pilot,
                               unattempted=targets[index:], completed=record['children'])
                assert not stop_signals, 'Stop requested before launch'
                current_row = {'name': name, 'started_utc': utc(), 'pid': None, 'exit': None,
                               'command': [PYTHON, '-B', str(worker), name]}
                record['children'].append(current_row)
                save()
                started = time.monotonic()
                current = subprocess.Popen(current_row['command'], cwd=R)
                current_row['pid'] = current.pid
                save()
                if stop_signals and current.poll() is None:
                    try:
                        current.send_signal(stop_signals[-1]['signal'])
                    except ProcessLookupError:
                        pass
                current_row['exit'] = drain()
                current_row['finished_utc'] = utc()
                current_row['controller_elapsed_seconds'] = round(time.monotonic() - started, 3)
                save()
                assert not stop_signals, 'Stop requested; child drained'
                assert current_row['exit'] == 0, 'Guarded worker failed: ' + name
                receipt_path = O / (name + '-BUILD_RECEIPT.json')
                current_row['build_receipt_sha256'] = sha(receipt_path)
                current_row['build_seconds'] = load(receipt_path)['seconds']
                with project_locks(checks):
                    checkpoint(checks, scope, plan, install, protected, pilot,
                               completed=record['children'])
                save()
                current = None
                current_row = None
            record['status'] = 'GUARDED_BUILDS_PASS_AUDIT_PENDING'
        except BaseException as error:
            record['status'] = 'STOPPED_OR_FAILED'
            record['error'] = {'type': type(error).__name__, 'message': str(error)}
            raise
        finally:
            try:
                if current is not None:
                    if current.poll() is None:
                        try:
                            current.terminate()
                        except ProcessLookupError:
                            pass
                        # Drain even if writing a durable STOPPING record fails.
                        try:
                            record['status'] = 'DRAINING_AFTER_STOP_OR_FAILURE'
                            save()
                        finally:
                            current.wait()
                    current_row['exit'] = current.returncode
                    current_row.setdefault('finished_utc', utc())
            finally:
                if record['status'] == 'DRAINING_AFTER_STOP_OR_FAILURE':
                    record['status'] = 'STOPPED_OR_FAILED'
                record['finished_utc'] = utc()
                save()
        print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
