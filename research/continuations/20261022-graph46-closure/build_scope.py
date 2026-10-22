"""Serial graph46 closure builds through the installed guarded worker.

Usage: python3.12 -B build_scope.py closure-pilot|closure-rest|assembly
Completed prerequisite scopes are verified before the next build batch starts.
This controller does not prepare audits or make audit-acceptance claims.
"""
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
import ast
import fcntl
import importlib.util
import json
import os
import signal
import subprocess
import sys
import tempfile
import time

from closure_inputs import RAW_GROUPS
from closure_runtime import (
    R, W, U, O, DRIVER_SHA, RUNNER_SHA, sha, load, git, repo_file,
    no_live_project_compiler, verify_install_binding, verify_scope, verify_proposal,
    verify_original_attempts, scope_counts,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
I = O / 'installation'
PYTHON = '/Users/tp/.local/bin/python3.12'
CHUNKS = ['SmallPairGraphClosure46Chunk' + f'{number:02d}' for number in range(12)]
COVERAGE = 'SmallPairGraphClosure46Coverage'
CORE = ['SmallPairGraphInputs46', 'SmallPairGraphWitnessData46'] + CHUNKS + [COVERAGE, 'SmallPairGraphClosure46']
SCOPES = {
    'closure-pilot': CORE[:2] + [CHUNKS[0], COVERAGE],
    'closure-rest': CHUNKS[1:] + ['SmallPairGraphClosure46'],
    'assembly': ['SmallPairGraphArithmetic46'] + list(RAW_GROUPS) + [
        'SmallPairRawSelectedData46', 'SmallPairLightAssembly46', 'SmallPairGraphTriangle46', 'SmallPairGraphData46'],
}
ORDER = CORE + SCOPES['assembly']
PREVIOUS = {'closure-pilot': [], 'closure-rest': ['closure-pilot'], 'assembly': ['closure-pilot', 'closure-rest']}
SIGNALS = (signal.SIGTERM, signal.SIGINT, signal.SIGHUP)


def utc():
    return datetime.now(timezone.utc).isoformat()


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
    assert sha(path) == DRIVER_SHA
    assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph46_closure_batch_driver', path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module, module.Driver(R, W)


def metadata():
    binding = verify_install_binding()
    verified_proposal, inspection, proposal_guards = verify_proposal(binding)
    assert (O / 'INSTALL_BINDING.json').read_bytes() == (I / 'INSTALL_BINDING_USED.json').read_bytes()
    assert load(I / 'SCRIPT_PINS.json') == binding['script_pins']
    proposal = O / 'proposal'
    assert sha(proposal / 'PLAN.json') == binding['proposal_plan_sha256']
    assert sha(proposal / 'PAYLOAD_SHA256.json') == binding['proposal_payload_sha256']
    paths = [proposal / 'PLAN.json', proposal / 'PAYLOAD_SHA256.json']
    for relative, expected in load(proposal / 'PAYLOAD_SHA256.json').items():
        assert not Path(relative).is_absolute() and '..' not in Path(relative).parts
        path = repo_file(proposal / relative)
        assert path.resolve().is_relative_to(proposal.resolve()) and sha(path) == expected
        paths.append(path)
    proposed = load(proposal / 'PLAN.json')
    assert proposed == verified_proposal
    assert proposed['status'] == 'REVIEWED_GRAPH46_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED'
    expected = dict(proposed)
    expected.update(status='REVIEWED_GRAPH46_RESTORATION_NOT_BUILT', base_commit=binding['base_commit'],
                    canonical_root_sha256=binding['canonical_root_sha256'], configuration=binding['configuration'],
                    install_binding_sha256=sha(O / 'INSTALL_BINDING.json'),
                    proposal_plan_sha256=binding['proposal_plan_sha256'],
                    proposal_payload_sha256=binding['proposal_payload_sha256'],
                    source_provenance=load(proposal / 'INPUT_PROVENANCE.json')['source_sha256'])
    plan, installed, application = load(O / 'PLAN.json'), load(I / 'GUARDS_BEFORE.json'), load(I / 'APPLICATION_RECEIPT.json')
    assert plan == expected and plan['build_order'] == ORDER and plan['scopes'] == SCOPES
    assert scope_counts(plan) == scope_counts(verified_proposal)
    assert application['status'] == 'GRAPH46_RESTORED_UNCOMPILED' and application['compiler_started'] is False
    assert application['install_binding_sha256'] == plan['install_binding_sha256']
    assert application['new_modules'] == [name for name in ORDER if name != 'SmallPairGraphData46']
    assert application['complete_rows'] == plan['closure_rows'] == inspection['closure_rows']
    assert application['filtered_vertices'] == plan['filtered_vertices'] == inspection['filtered_vertices']
    assert application['original_declarations_preserved'] == plan['original_public_declarations'] == inspection['declaration_counts']['total']
    assert application['partition_counts'] == [part['count'] for part in inspection['proposed_prefix_parts']]
    assert application['raw_data_modules'] == list(RAW_GROUPS)
    for item in (plan, application):
        assert item['root_integration'] is False and item['main_theorem_complete'] is False
        assert item['all_original_literal_definitions_byte_identical'] is True
        assert item['both_mutation_signs_and_global_indices_preserved'] is True
    assert plan['configuration'] == installed['configuration'] == binding['configuration']
    assert plan['canonical_root_sha256'] == installed['canonical_root_sha256'] == binding['canonical_root_sha256']
    assert load(O / 'DECLARATION_ORIGINS.json') == plan['origins']
    assert load(O / 'SOURCE_INSPECTION.json') == load(proposal / 'SOURCE_INSPECTION.json')
    template, worker = O / 'bounded_build_template.py', O / 'bounded_build.py'
    text = template.read_text()
    assert text.count('__REVIEWED_SOURCE_PINS__') == 1
    ordered = {name: plan['source_manifest'][name] for name in ORDER}
    expected_worker = text.replace('__REVIEWED_SOURCE_PINS__', repr(ordered)).encode()
    assert worker.read_bytes() == expected_worker
    pin_nodes = [node.value for node in ast.parse(expected_worker.decode()).body
                 if isinstance(node, ast.Assign) and any(isinstance(target, ast.Name) and target.id == 'PINS'
                                                        for target in node.targets)]
    assert len(pin_nodes) == 1 and ast.literal_eval(pin_nodes[0]) == plan['source_manifest']
    worker_receipt = load(I / 'WORKER_SHA256.json')
    assert worker_receipt == {'sha256': sha(worker), 'template_sha256': binding['script_pins']['bounded_build_template.py']}
    paths += [O / name for name in ('PLAN.json', 'DECLARATION_ORIGINS.json', 'SOURCE_INSPECTION.json',
              'INSTALL_BINDING.json', 'PROVENANCE_BINDING.json', 'bounded_build.py', *binding['script_pins'])]
    paths += [I / name for name in ('APPLICATION_RECEIPT.json', 'GUARDS_BEFORE.json', 'INSTALL_BINDING_USED.json',
              'SCRIPT_PINS.json', 'QUEUE_AFTER.json', 'WORKER_SHA256.json', 'PREREQUISITES_VERIFIED.json',
              'ACCEPTED_INPUT_EVIDENCE.json', 'ORIGINAL_ATTEMPTS_BEFORE.json')]
    for scope, targets in SCOPES.items():
        path = O / (scope + '-TARGETS.json')
        assert load(path) == targets
        paths.append(path)
    for name, expected in plan['source_manifest'].items():
        pair = [repo_file('D1Bound5/' + name + '.lean'), repo_file(O / 'candidates' / (name + '.lean'))]
        assert all(sha(path) == expected for path in pair)
        paths.extend(pair)
    for name, expected in {**plan['original_source_manifest'], **plan['reviewed_helper_source_manifest']}.items():
        path = repo_file(O / 'originals' / (name + '.lean'))
        assert sha(path) == expected
        paths.append(path)
    protected = {str(path): sha(path) for path in paths}
    for path, expected in proposal_guards.items():
        assert path not in protected or protected[path] == expected
        protected[path] = expected
    prerequisite_record = load(I / 'PREREQUISITES_VERIFIED.json')
    assert prerequisite_record['scopes'] == application['prerequisite_scope_fingerprints'] == {
        scope: value['proof_fingerprint'] for scope, value in binding['prerequisite_scopes'].items()}
    for path, expected in prerequisite_record['protected_files'].items():
        assert path not in protected or protected[path] == expected
        assert sha(repo_file(path)) == expected
        protected[path] = expected
    return binding, plan, installed, protected, worker_receipt


def checkpoint(scope, binding, plan, installed, protected, reused=None, unattempted=(), completed=()):
    no_live_project_compiler()
    assert git('rev-parse', 'HEAD') == binding['base_commit'] and git('branch', '--show-current') == 'main'
    assert not git('diff', '--cached', '--name-only')
    index = Path(git('rev-parse', '--git-path', 'index'))
    index = index if index.is_absolute() else R / index
    assert sha(index) == installed['index_sha256']
    assert all(sha(repo_file(path)) == expected for path, expected in protected.items())
    assert sha(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
    module, driver = load_driver()
    assert driver.static == binding['configuration'] and driver.manifest_matches(binding['configuration'], cached=False)
    active = load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    expected_queue = json.dumps(load(I / 'QUEUE_AFTER.json'), indent=2, sort_keys=True).encode()
    assert driver.queue_path.read_bytes() == expected_queue
    queue = json.loads(expected_queue)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert all(sha(R / 'D1Bound5' / (name + '.lean')) == expected for name, expected in installed['accepted_sources'].items())
    assert driver.manifest_matches(installed['accepted_artifacts'], cached=False)
    configuration = O / 'CONFIGURATION.json'
    if configuration.exists() or configuration.is_symlink():
        assert configuration.is_file() and not configuration.is_symlink() and load(configuration) == binding['configuration']
    else:
        assert scope == 'closure-pilot' and not completed and not list(O.glob('*-BUILD_RECEIPT.json'))
    actual = {}
    counts = scope_counts(plan)
    for previous in PREVIOUS[scope]:
        _, definitions, theorems = counts[previous]
        actual[previous] = verify_scope(O, previous, SCOPES[previous], definitions, theorems,
                                       'GRAPH46_CLOSURE_AXIOMS_PASS ', driver, module, binding['configuration'])
    if reused is not None:
        assert actual == reused, 'Previously verified scope evidence changed'
    latest = driver.latest()
    history = verify_original_attempts(driver, module)
    assert history['target_names'] == plan['build_order']
    for name in unattempted:
        closure = driver.closure(name)
        assert latest.get((name, module.fingerprint(closure))) is None, 'Existing exact attempt: ' + name
        for suffix in ('.lean', '-SOURCE_CLOSURE.json', '-BUILD_RECEIPT.json', '-build.log', '-ORIGINAL_SOURCES.json'):
            path = O / (name + suffix)
            assert not path.exists() and not path.is_symlink(), 'Existing target output: ' + str(path)
    for child in completed:
        name = child['name']
        receipt = O / (name + '-BUILD_RECEIPT.json')
        assert sha(receipt) == child['build_receipt_sha256']
        row, closure = load(receipt), driver.closure(name)
        key = module.fingerprint(closure)
        assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
        assert row['timed_out'] is False and row['interrupted'] is False and row['timeout_seconds'] == 240
        assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
        assert row['source_sha256'] == plan['source_manifest'][name]
        assert load(O / (name + '-SOURCE_CLOSURE.json')) == closure and key == row['fingerprint']
        assert latest.get((name, key)) == row
        assert load(O / (name + '-ORIGINAL_SOURCES.json')) == closure
        assert sha(O / (name + '.lean')) == plan['source_manifest'][name]
        assert driver.expected_manifest(name, key, latest) == row['artifacts'] == driver.artifacts(name)
    return actual


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
    scope, targets = sys.argv[1], SCOPES[sys.argv[1]]
    path = O / (scope + '-BUILD_BATCH.json')
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
        assert not path.exists() and not path.is_symlink(), 'Existing batch record; never resume or repeat'
        for number in SIGNALS:
            signal.signal(number, halt)
        with project_locks():
            binding, plan, installed, protected, worker = metadata()
            reused = checkpoint(scope, binding, plan, installed, protected, unattempted=targets)
        record = {'status': 'RUNNING', 'scope': scope, 'pid': os.getpid(), 'started_utc': utc(),
                  'targets': targets, 'children': [], 'signals': [], 'worker_sha256': worker['sha256'],
                  'template_sha256': worker['template_sha256'], 'driver_sha256': DRIVER_SHA,
                  'controller_sha256': sha(Path(__file__)), 'inner_target_timeout_seconds': 240,
                  'plan_sha256': sha(O / 'PLAN.json'), 'protected_files': protected,
                  'reused_scope_evidence': reused, 'queue_changed': False, 'root_integration': False,
                  'audit_acceptance_claim': False, 'whole_graph46_complete': False, 'main_theorem_complete': False}
        save(exclusive=True)
        try:
            for index, name in enumerate(targets):
                assert not signals, 'Stop requested'
                with project_locks():
                    checkpoint(scope, binding, plan, installed, protected, reused,
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
                current_row['build_receipt_sha256'] = sha(receipt)
                current_row['build_seconds'] = load(receipt)['seconds']
                with project_locks():
                    checkpoint(scope, binding, plan, installed, protected, reused, completed=record['children'])
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
