"""Serial graph11 closure builds through the installed 240-second guarded worker.

Usage: python3.12 -B build_scope.py closure-pilot|closure-rest|assembly
No audit script is imported. Successful batches still require their own audit.
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
import re
import signal
import subprocess
import sys
import tempfile
import time

R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
I = O / 'installation'
PYTHON = '/Users/tp/.local/bin/python3.12'
TEMPLATE_SHA = '3cd90f876193aef1d6c4014ba9794bb95995ae005f23af4772a020aa0a024cf8'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
SIGNALS = (signal.SIGTERM, signal.SIGINT, signal.SIGHUP)
RAW = 'SmallPairRawSelectedData11'
RAW_PARTS = [RAW + suffix for suffix in ('LeftCached', 'LeftRows', 'RightCached', 'RightRows')]
CHUNKS = ['SmallPairGraphClosure11Chunk' + f'{i:02d}' for i in range(12)]
COVERAGE = 'SmallPairGraphClosure11Coverage'
CORE = ['SmallPairGraphInputs11', 'SmallPairGraphWitnessData11'] + CHUNKS + [COVERAGE, 'SmallPairGraphClosure11']
SCOPES = {
    'closure-pilot': CORE[:2] + [CHUNKS[0], COVERAGE],
    'closure-rest': CHUNKS[1:] + ['SmallPairGraphClosure11'],
    'assembly': ['SmallPairGraphArithmetic11'] + RAW_PARTS + [RAW,
                 'SmallPairLightAssembly11', 'SmallPairGraphTriangle11', 'SmallPairGraphData11'],
}
ALL_TARGETS = CORE + SCOPES['assembly']
PREREQUISITES = {'closure-pilot': [], 'closure-rest': ['closure-pilot'],
                 'assembly': ['closure-pilot', 'closure-rest']}
COUNTS = {'closure-pilot': (9, 2), 'closure-rest': (0, 13), 'assembly': (4, 13)}
ASSURANCE = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'


def utc():
    return datetime.now(timezone.utc).isoformat()


def sha(path):
    path = Path(path)
    assert path.is_file() and not path.is_symlink(), str(path)
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def fingerprint(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def repo_file(value):
    path = Path(value)
    path = path if path.is_absolute() else R / path
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve())
    return path


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
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location('graph11_closure_batch_driver', path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module, module.Driver(R, W)


def verify_worker(plan):
    template = O / 'bounded_build_template.py'
    worker = O / 'bounded_build.py'
    assert sha(template) == TEMPLATE_SHA
    text = template.read_text()
    assert len(re.findall(r'^PINS = .*$', text, re.M)) == 1
    # PLAN is written with sorted JSON keys; the installer synthesizes repr(pins)
    # in build_order. Preserve that order for an exact byte comparison.
    ordered = {name: plan['source_manifest'][name] for name in plan['build_order']}
    expected = re.sub(r'^PINS = .*$', 'PINS = ' + repr(ordered), text, flags=re.M).encode()
    assert worker.read_bytes() == expected, 'Worker differs from the pinned template synthesis'
    nodes = [node.value for node in ast.parse(expected.decode()).body
             if isinstance(node, ast.Assign) and any(
                 isinstance(target, ast.Name) and target.id == 'PINS' for target in node.targets)]
    assert len(nodes) == 1 and ast.literal_eval(nodes[0]) == plan['source_manifest']
    return sha(worker)


def metadata():
    plan = load(O / 'PLAN.json')
    application = load(I / 'APPLICATION_RECEIPT.json')
    guards = load(I / 'GUARDS_BEFORE.json')
    assert plan['status'] == 'REVIEWED_GRAPH11_RESTORATION_NOT_BUILT'
    assert plan['build_order'] == ALL_TARGETS and set(plan['source_manifest']) == set(ALL_TARGETS)
    assert plan['original_public_declarations'] == application['original_declarations_preserved'] == 28
    assert plan['closure_rows'] == application['complete_rows'] == 719
    assert plan['filtered_vertices'] == application['filtered_vertices'] == 718
    assert plan['canonical_root_sha256'] == guards['canonical_root_sha256']
    assert application['status'] == 'GRAPH11_RESTORED_UNCOMPILED' and application['compiler_started'] is False
    assert application['new_modules'] == [name for name in ALL_TARGETS if name != 'SmallPairGraphData11']
    assert application['partition_counts'] == [64] * 11 + [15]
    assert application['raw_data_modules'] == RAW_PARTS
    assert application['all_original_literal_definitions_byte_identical'] is True
    assert application['both_mutation_signs_and_global_indices_preserved'] is True
    for item in (plan, application):
        assert item['root_integration'] is False and item['main_theorem_complete'] is False
    assert plan['prefix_parts'] == [{'module': name, 'offset': i * 64,
                                    'count': min(64, 719 - i * 64)} for i, name in enumerate(CHUNKS)]
    assert load(O / 'DECLARATION_ORIGINS.json') == plan['origins']
    assert (O / 'INSTALL_BINDING.json').read_bytes() == (I / 'INSTALL_BINDING_USED.json').read_bytes()
    script_pins = load(I / 'SCRIPT_PINS.json')
    assert script_pins == load(O / 'INSTALL_BINDING.json')['script_pins']
    assert set(script_pins) == {'prepare_checks.py', 'finish_checks.py', 'bounded_build_template.py'}
    assert script_pins['bounded_build_template.py'] == TEMPLATE_SHA
    assert all(sha(O / name) == digest for name, digest in script_pins.items())
    paths = [O / name for name in ('PLAN.json', 'DECLARATION_ORIGINS.json', 'INSTALL_BINDING.json',
             'bounded_build.py', *script_pins)]
    paths += [I / name for name in ('APPLICATION_RECEIPT.json', 'GUARDS_BEFORE.json',
              'ACCEPTED_INPUT_EVIDENCE.json', 'QUEUE_AFTER.json', 'INSTALL_BINDING_USED.json', 'SCRIPT_PINS.json')]
    for scope, targets in SCOPES.items():
        path = O / (scope + '-TARGETS.json')
        assert load(path) == targets
        paths.append(path)
    for name, digest in plan['source_manifest'].items():
        pair = [repo_file('D1Bound5/' + name + '.lean'), repo_file(O / 'candidates' / (name + '.lean'))]
        assert all(sha(path) == digest for path in pair), name
        paths.extend(pair)
    for name, digest in {**plan['original_source_manifest'], **plan['reviewed_helper_source_manifest']}.items():
        path = repo_file(O / 'originals' / (name + '.lean'))
        assert sha(path) == digest
        paths.append(path)
    return plan, guards, {str(path): sha(path) for path in paths}, verify_worker(plan)


def verified_scope(scope, plan, module, driver, latest):
    """Reconstruct a completed scope's proof state from its bound evidence."""
    targets = SCOPES[scope]
    definitions, theorems = COUNTS[scope]
    audit = U / ('pro-graph11-' + scope + '-audit')
    summary = load(O / (scope + '-VERIFICATION_SUMMARY.json'))
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert summary['targets'] == targets == load(O / (scope + '-TARGETS.json'))
    assert summary['definitions'] == definitions and summary['theorems'] == theorems
    assert summary['declarations'] == definitions + theorems and summary['public_headers_exact'] is True
    assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == len(targets)
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['whole_graph11_complete'] is False and summary['audit'] == str(audit.relative_to(R))
    assert not load(audit / 'active-targeted-replay.json')['active']
    final, receipts = load(audit / 'BOUND_AUDIT_FINAL.json'), load(audit / 'TARGETED_REPLAY_RECEIPTS.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert final['main_theorem_claim'] is False
    assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in targets]
    assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
               and not row['binding_drift_paths'] for row in receipts)
    assert (audit / 'analytic-type-axioms.log').read_text().count('GRAPH11_CLOSURE_AXIOMS_PASS ') == definitions + theorems
    binding = load(audit / 'PREPARATION_BINDINGS.json')
    assert binding['schema'] == 1 and binding['audit_folder'] == str(audit.resolve())
    assert binding['targets'] == binding['replays'] == targets
    assert load(audit / 'TARGETS.json') == load(audit / 'REPLAY_TARGETS.json') == targets
    assert final['binding_sha256'] == sha(audit / 'PREPARATION_BINDINGS.json')
    assert final['source_map_sha256'] == sha(audit / 'SOURCE_MAP.json')
    protected = {str(repo_file(path)): digest for path, digest in binding['files'].items()}
    assert all(sha(path) == digest for path, digest in protected.items())
    source_map = load(O / (scope + '-SOURCE_MAP.json'))
    sources = source_map['sources']
    evidence = load(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
    assert source_map['base_commit'] == summary['base_commit']
    assert len(sources) == summary['source_closure_modules'] and set(sources) == set(evidence)
    assert binding['project_sources'] == {name: item['sha256'] for name, item in sources.items()}
    artifacts = {}
    for name, item in sources.items():
        assert item['path'] == 'D1Bound5/' + name + '.lean' and sha(repo_file(item['path'])) == item['sha256']
        key = module.fingerprint(driver.closure(name))
        expected = driver.expected_manifest(name, key, latest)
        assert expected and key == evidence[name]['fingerprint'], name
        assert expected == evidence[name]['artifacts'] == driver.artifacts(name), name
        for path, digest in expected.items():
            assert path not in artifacts or artifacts[path] == digest
            artifacts[path] = digest
        if name in targets:
            candidate = O / 'candidates' / (name + '.lean')
            assert item['assurance'] == ASSURANCE and item['payload_path'] == str(candidate.relative_to(R))
            assert sha(candidate) == item['sha256'] == plan['source_manifest'][name]
    assert all(artifacts.get(path) == digest for path, digest in binding['target_artifacts'].items())
    guards = load(audit / 'TARGETED_REPLAY_GUARDS.json')
    assert guards['project_sources'] == binding['project_sources']
    assert guards['compiled_artifacts'] == artifacts and guards['immutable_inputs'] == driver.static
    assert all(sha(repo_file(path)) == digest for path, digest in guards['preparation_files'].items())
    used = load(audit / 'PROVENANCE_BINDING_USED.json')
    assert sha(O / 'PROVENANCE_BINDING.json') == used['binding_sha256']
    assert all(sha(repo_file(path)) == digest for path, digest in used['source_maps'].items())
    for row in load(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json'):
        assert sha(repo_file(row['origin_map_path'])) == row['origin_map_sha256']
    state = {'sources': [[name, item['sha256']] for name, item in sorted(sources.items())],
             'configuration': driver.static,
             'build_fingerprints': {name: evidence[name]['fingerprint'] for name in targets},
             'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in targets},
             'audit_harness_sha256': sha(audit / 'AnalyticAudit.lean'),
             'accepted_checks': [{key: row[key] for key in ('label', 'exit', 'guards_unchanged')} for row in receipts]}
    assert load(O / (scope + '-PROOF_STATE.json')) == state and fingerprint(state) == summary['proof_fingerprint']
    paths = [O / (scope + '-' + suffix + '.json') for suffix in ('VERIFICATION_SUMMARY', 'SOURCE_MAP',
             'ACCEPTED_DEPENDENCY_EVIDENCE', 'PROOF_STATE', 'PREPARATION', 'TARGETS')]
    paths += [audit / filename for filename in ('BOUND_AUDIT_FINAL.json', 'TARGETED_REPLAY_RECEIPTS.json',
              'PREPARATION_BINDINGS.json', 'TARGETED_REPLAY_GUARDS.json', 'active-targeted-replay.json',
              'analytic-type-axioms.log', 'PROVENANCE_BINDING_USED.json')]
    paths += [O / 'PROVENANCE_BINDING.json'] + [repo_file(path) for path in used['source_maps']]
    protected.update({str(path): sha(path) for path in paths})
    return {'targets': targets, 'proof_fingerprint': summary['proof_fingerprint'], 'protected_files': protected}


def checkpoint(scope, plan, installed, protected, reference=None, unattempted=(), completed=()):
    assert all(sha(path) == digest for path, digest in protected.items()), 'Protected bytes changed'
    verify_worker(plan)
    module, driver = load_driver()
    active = load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    queue = load(driver.queue_path)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    # The pinned driver's atomic_json omits the snapshot's trailing newline.
    expected_queue = json.dumps(load(I / 'QUEUE_AFTER.json'), indent=2, sort_keys=True).encode()
    assert driver.queue_path.read_bytes() == expected_queue
    assert sha(R / 'D1Bound5.lean') == plan['canonical_root_sha256']
    assert driver.static == installed['configuration'] and driver.manifest_matches(driver.static, cached=False)
    configuration = O / 'CONFIGURATION.json'
    expected_config = (json.dumps(driver.static, indent=2, sort_keys=True) + '\n').encode()
    if configuration.exists():
        assert not configuration.is_symlink() and configuration.read_bytes() == expected_config
    else:
        assert scope == 'closure-pilot' and not completed, 'Missing worker configuration snapshot'
    assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == digest
               for name, digest in installed['accepted_sources'].items())
    assert driver.manifest_matches(installed['accepted_artifacts'], cached=False)
    latest = driver.latest()
    for name, item in load(I / 'ACCEPTED_INPUT_EVIDENCE.json').items():
        key = module.fingerprint(driver.closure(name))
        expected = driver.expected_manifest(name, key, latest)
        assert expected and key == item['fingerprint']
        assert expected == item['artifacts'] == driver.artifacts(name), name
    reused = {prior: verified_scope(prior, plan, module, driver, latest) for prior in PREREQUISITES[scope]}
    if reference is not None:
        assert reused == reference, 'Prior scoped proof state or bound evidence changed'
    for name in unattempted:
        assert latest.get((name, module.fingerprint(driver.closure(name)))) is None, 'Existing exact attempt: ' + name
        assert not (O / (name + '-BUILD_RECEIPT.json')).exists(), 'Existing receipt: ' + name
    for child in completed:
        name = child['name']
        receipt_path = O / (name + '-BUILD_RECEIPT.json')
        assert sha(receipt_path) == child['build_receipt_sha256']
        row, closure = load(receipt_path), driver.closure(name)
        key = module.fingerprint(closure)
        assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
        assert not row['timed_out'] and not row['interrupted']
        assert row['closure_unchanged'] and row['shared_artifacts_unchanged']
        assert row['source_sha256'] == plan['source_manifest'][name]
        assert load(O / (name + '-SOURCE_CLOSURE.json')) == closure and key == row['fingerprint']
        assert driver.expected_manifest(name, key, latest) == row['artifacts'] == driver.artifacts(name)
    return reused


def main():
    if not __debug__:
        raise RuntimeError('Do not disable verification assertions')
    assert O == C / '20261022-graph11-closure'
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
    scope = sys.argv[1]
    targets = SCOPES[scope]
    path = O / (scope + '-BUILD_BATCH.json')
    current = current_row = record = None
    signals = []

    def halt(sig, _frame):
        signals.append({'signal': sig, 'utc': utc()})
        if current is not None and current.poll() is None:
            try:
                current.send_signal(sig)
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

    with (O / 'build-scope.lock').open('a+') as batch_lock:
        fcntl.flock(batch_lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not path.exists(), 'Existing batch record: review separately; never resume or repeat'
        for sig in SIGNALS:
            signal.signal(sig, halt)
        with project_locks():
            plan, installed, protected, worker_sha = metadata()
            reused = checkpoint(scope, plan, installed, protected, unattempted=targets)
        record = {'status': 'RUNNING', 'scope': scope, 'pid': os.getpid(), 'started_utc': utc(),
                  'targets': targets, 'children': [], 'signals': [], 'worker_sha256': worker_sha,
                  'template_sha256': TEMPLATE_SHA, 'driver_sha256': DRIVER_SHA,
                  'controller_sha256': sha(Path(__file__)), 'inner_target_timeout_seconds': 240,
                  'plan_sha256': sha(O / 'PLAN.json'), 'protected_files': protected,
                  'reused_scope_evidence': reused, 'queue_changed': False,
                  'audit_acceptance_claim': False, 'whole_graph11_complete': False,
                  'main_theorem_complete': False}
        save(exclusive=True)
        try:
            for index, name in enumerate(targets):
                assert not signals, 'Stop requested'
                with project_locks():
                    checkpoint(scope, plan, installed, protected, reused,
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
                    checkpoint(scope, plan, installed, protected, reused, completed=record['children'])
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
                        # The worker must drain its own compiler before exiting.
                        # Do not replace its bounded teardown with an outer kill.
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
