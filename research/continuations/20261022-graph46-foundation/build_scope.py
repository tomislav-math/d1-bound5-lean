"""Run a graph46 foundation pilot or remainder through the guarded worker.

Usage: python3.12 -B build_scope.py pilot|rest
The pilot builds the first exact data fragment. The remainder reuses that actual
accepted receipt and builds the other six targets serially. Neither phase claims
the exact-type/axiom audit or kernel replays, which follow all seven builds.
"""
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
import fcntl
import importlib.util
import json
import os
import signal
import subprocess
import sys
import tempfile
import time

from foundation_inputs import (
    REPOSITORY as R, DRIVER_SHA, RUNNER_SHA, TARGETS, source_hash, verify_prepared,
)
from installer import no_compiler


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
U = R / 'research/continuations/20261020T100000CEST-work-resume'
O = R / 'research/continuations/20261022-graph46-foundation'
PYTHON = '/Users/tp/.local/bin/python3.12'
SCOPES = {'pilot': TARGETS[:1], 'rest': TARGETS[1:]}
SIGNALS = (signal.SIGTERM, signal.SIGINT, signal.SIGHUP)


def load(path):
    return json.loads(Path(path).read_text())


def utc():
    return datetime.now(timezone.utc).isoformat()


def git(*arguments):
    return subprocess.check_output(['git', *arguments], cwd=R, text=True, timeout=30).strip()


def durable_json(path, value, exclusive=False):
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', dir=path.parent,
                prefix='.' + path.name + '.', suffix='.tmp', delete=False) as stream:
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


@contextmanager
def project_locks():
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        yield


def load_driver():
    path = W / 'continuation_driver_capacity.py'
    assert source_hash(path) == DRIVER_SHA
    assert source_hash(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph46_foundation_batch_driver', path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module, module.Driver(R, W)


def metadata(scope):
    binding, plan, payload = verify_prepared(O)
    installation = load(O / 'INSTALL_RECEIPT.json')
    assert installation['status'] == 'EXACT_GRAPH46_LITERAL_PARTITION_INSTALLED_NOT_BUILT'
    assert installation['plan_sha256'] == source_hash(O / 'PLAN.json')
    assert installation['prepared_payload_sha256'] == source_hash(O / 'PREPARED_PAYLOAD_SHA256.json')
    assert installation['input_binding_sha256'] == plan['input_binding_sha256'] == source_hash(O / 'GRAPH46_BINDING.json')
    assert installation['source_manifest'] == plan['source_manifest'] and plan['targets'] == TARGETS
    assert installation['root_integration'] is False and installation['main_theorem_complete'] is False
    protected = {str(O / relative): expected for relative, expected in payload.items()}
    for name in ('INSTALL_RECEIPT.json', 'PREPARED_PAYLOAD_SHA256.json'):
        protected[str(O / name)] = source_hash(O / name)
    for name, expected in plan['source_manifest'].items():
        path = R / 'D1Bound5' / (name + '.lean')
        assert source_hash(path) == expected
        protected[str(path)] = expected
    for item in load(O / 'PROVENANCE_BINDING.json')['source_maps']:
        path = R / item['path']
        assert source_hash(path) == item['sha256']
        protected[str(path)] = item['sha256']
    index = Path(git('rev-parse', '--git-path', 'index'))
    index = index if index.is_absolute() else R / index
    protected[str(index)] = source_hash(index)
    reused = []
    if scope == 'rest':
        path = O / 'foundation-pilot-BUILD_BATCH.json'
        pilot = load(path)
        assert pilot['status'] == 'GUARDED_BUILDS_PASS_AUDIT_PENDING'
        assert pilot['scope'] == 'pilot' and pilot['targets'] == SCOPES['pilot'] and not pilot['signals']
        assert pilot['input_binding_sha256'] == plan['input_binding_sha256']
        assert pilot['plan_sha256'] == source_hash(O / 'PLAN.json')
        assert pilot['worker_sha256'] == source_hash(O / 'bounded_build.py')
        assert pilot['audit_acceptance_claim'] is False and pilot['root_integration'] is False
        assert pilot['main_theorem_complete'] is False and pilot['whole_graph46_complete'] is False
        assert [item['name'] for item in pilot['children']] == SCOPES['pilot']
        assert all(item['exit'] == 0 for item in pilot['children'])
        assert all(source_hash(Path(filename)) == expected for filename, expected in pilot['protected_files'].items())
        reused = pilot['children']
        protected[str(path)] = source_hash(path)
    return binding, plan, installation, protected, reused


def checkpoint(scope, binding, plan, installation, protected, reused, unattempted=(), completed=()):
    no_compiler()
    assert git('rev-parse', 'HEAD') == binding['base_commit'] and git('branch', '--show-current') == 'main'
    assert not git('diff', '--cached', '--name-only')
    assert all(source_hash(Path(path)) == expected for path, expected in protected.items())
    module, driver = load_driver()
    active = load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    assert source_hash(driver.queue_path) == installation['queue_after_sha256']
    queue = load(driver.queue_path)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert set(TARGETS) <= set(queue['names'])
    assert driver.static == binding['configuration'] and driver.manifest_matches(binding['configuration'], cached=False)
    assert source_hash(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
    configuration = O / 'CONFIGURATION.json'
    if configuration.exists() or configuration.is_symlink():
        assert configuration.is_file() and not configuration.is_symlink() and load(configuration) == binding['configuration']
    else:
        assert scope == 'pilot' and not completed and not reused and not list(O.glob('*-BUILD_RECEIPT.json'))
    latest = driver.latest()
    for name in unattempted:
        closure = driver.closure(name)
        assert latest.get((name, module.fingerprint(closure))) is None, 'Existing exact attempt: ' + name
        for suffix in ('.lean', '-SOURCE_CLOSURE.json', '-BUILD_RECEIPT.json', '-build.log', '-ORIGINAL_SOURCES.json'):
            path = O / (name + suffix)
            assert not path.exists() and not path.is_symlink(), 'Existing target output: ' + str(path)
    for child in reused + list(completed):
        name = child['name']
        receipt = O / (name + '-BUILD_RECEIPT.json')
        assert source_hash(receipt) == child['build_receipt_sha256']
        row, closure = load(receipt), driver.closure(name)
        key = module.fingerprint(closure)
        assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
        assert row['timed_out'] is False and row['interrupted'] is False and row['timeout_seconds'] == 240
        assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
        assert row['source_sha256'] == plan['source_manifest'][name] and key == row['fingerprint']
        assert load(O / (name + '-SOURCE_CLOSURE.json')) == closure
        assert load(O / (name + '-ORIGINAL_SOURCES.json')) == closure
        assert source_hash(O / (name + '.lean')) == plan['source_manifest'][name]
        assert driver.expected_manifest(name, key, latest) == row['artifacts'] == driver.artifacts(name)


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
    scope, targets = sys.argv[1], SCOPES[sys.argv[1]]
    path = O / ('foundation-' + scope + '-BUILD_BATCH.json')
    current = current_row = record = None
    signals = []

    def halt(number, _frame):
        signals.append({'signal': number, 'utc': utc()})
        if current is not None and current.poll() is None:
            try:
                current.send_signal(number)
            except ProcessLookupError:
                pass

    def save(exclusive=False):
        record['signals'] = list(signals)
        durable_json(path, record, exclusive)

    def drain():
        while True:
            try:
                return current.wait(timeout=1)
            except subprocess.TimeoutExpired:
                if record['signals'] != signals:
                    save()

    lock_path = O / 'build-scope.lock'
    assert not lock_path.is_symlink()
    with lock_path.open('a+') as batch_lock:
        fcntl.flock(batch_lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not path.exists() and not path.is_symlink(), 'Existing batch; never resume or repeat'
        for number in SIGNALS:
            signal.signal(number, halt)
        with project_locks():
            binding, plan, installation, protected, reused = metadata(scope)
            checkpoint(scope, binding, plan, installation, protected, reused, unattempted=targets)
        record = {'status': 'RUNNING', 'scope': scope, 'pid': os.getpid(), 'started_utc': utc(),
                  'targets': targets, 'children': [], 'signals': [], 'worker_sha256': source_hash(O / 'bounded_build.py'),
                  'template_sha256': binding['script_pins']['bounded_build_template.py'], 'driver_sha256': DRIVER_SHA,
                  'controller_sha256': source_hash(Path(__file__)), 'inner_target_timeout_seconds': 240,
                  'plan_sha256': source_hash(O / 'PLAN.json'), 'input_binding_sha256': plan['input_binding_sha256'],
                  'protected_files': protected, 'reused_pilot_children': reused, 'queue_changed': False,
                  'audit_acceptance_claim': False, 'whole_graph46_complete': False,
                  'root_integration': False, 'main_theorem_complete': False}
        save(exclusive=True)
        try:
            for index, name in enumerate(targets):
                assert not signals, 'Stop requested'
                with project_locks():
                    checkpoint(scope, binding, plan, installation, protected, reused,
                               unattempted=targets[index:], completed=record['children'])
                assert not signals, 'Stop requested before launch'
                current_row = {'name': name, 'pid': None, 'exit': None, 'started_utc': utc(),
                               'command': [PYTHON, '-B', str(O / 'bounded_build.py'), name]}
                record['children'].append(current_row)
                save()
                started = time.monotonic()
                current = subprocess.Popen(current_row['command'], cwd=R)
                current_row['pid'] = current.pid
                save()
                if signals and current.poll() is None:
                    try:
                        current.send_signal(signals[-1]['signal'])
                    except ProcessLookupError:
                        pass
                current_row['exit'] = drain()
                current_row['finished_utc'] = utc()
                current_row['controller_elapsed_seconds'] = round(time.monotonic() - started, 3)
                save()
                assert not signals, 'Stop requested; child drained'
                assert current_row['exit'] == 0, 'Guarded worker failed: ' + name
                receipt = O / (name + '-BUILD_RECEIPT.json')
                current_row['build_receipt_sha256'] = source_hash(receipt)
                current_row['build_seconds'] = load(receipt)['seconds']
                with project_locks():
                    checkpoint(scope, binding, plan, installation, protected, reused, completed=record['children'])
                save()
                current = current_row = None
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
