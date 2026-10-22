"""One serial graph46 closure target with an inner 240-second compiler timeout."""
from contextlib import contextmanager
from pathlib import Path
import fcntl
import importlib.util
import json
import os
import signal
import sys
import time

from closure_runtime import (
    R, W, U, O, DRIVER_SHA, RUNNER_SHA, digest, sha, load, git,
    no_live_project_compiler, verify_install_binding, verify_proposal, verify_original_attempts,
    verify_scope, scope_counts, merge,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
assert Path(__file__).resolve().parent == O
PINS = __REVIEWED_SOURCE_PINS__
os.environ['LEAN_NUM_THREADS'] = '1'
assert len(sys.argv) == 2 and sys.argv[1] in PINS
name = sys.argv[1]
binding = verify_install_binding()
verified_proposal, source_inspection, proposal_guards = verify_proposal(binding)
binding_sha = sha(O / 'INSTALL_BINDING.json')
I = O / 'installation'
plan = load(O / 'PLAN.json')
application = load(I / 'APPLICATION_RECEIPT.json')
installed = load(I / 'GUARDS_BEFORE.json')
assert plan['status'] == 'REVIEWED_GRAPH46_RESTORATION_NOT_BUILT'
assert PINS == plan['source_manifest']
assert application['status'] == 'GRAPH46_RESTORED_UNCOMPILED' and application['compiler_started'] is False
assert plan['install_binding_sha256'] == application['install_binding_sha256'] == binding_sha
assert (I / 'INSTALL_BINDING_USED.json').read_bytes() == (O / 'INSTALL_BINDING.json').read_bytes()
assert load(I / 'SCRIPT_PINS.json') == binding['script_pins']
assert plan['configuration'] == installed['configuration'] == binding['configuration']
assert plan['canonical_root_sha256'] == installed['canonical_root_sha256'] == binding['canonical_root_sha256']
assert sha(O / 'proposal/PLAN.json') == binding['proposal_plan_sha256']
assert sha(O / 'proposal/PAYLOAD_SHA256.json') == binding['proposal_payload_sha256']
proposal = O / 'proposal'
proposal_files = {str(proposal / 'PLAN.json'): binding['proposal_plan_sha256'],
                  str(proposal / 'PAYLOAD_SHA256.json'): binding['proposal_payload_sha256']}
for relative, expected in load(proposal / 'PAYLOAD_SHA256.json').items():
    relative_path = Path(relative)
    assert not relative_path.is_absolute() and '..' not in relative_path.parts
    path = proposal / relative_path
    assert path.resolve().is_relative_to(proposal.resolve()) and sha(path) == expected
    proposal_files[str(path)] = expected
proposed = load(proposal / 'PLAN.json')
assert proposed == verified_proposal
assert proposed['status'] == 'REVIEWED_GRAPH46_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED'
expected_plan = dict(proposed)
expected_plan.update(status='REVIEWED_GRAPH46_RESTORATION_NOT_BUILT', base_commit=binding['base_commit'],
                     canonical_root_sha256=binding['canonical_root_sha256'], configuration=binding['configuration'],
                     install_binding_sha256=binding_sha, proposal_plan_sha256=binding['proposal_plan_sha256'],
                     proposal_payload_sha256=binding['proposal_payload_sha256'],
                     source_provenance=load(proposal / 'INPUT_PROVENANCE.json')['source_sha256'])
assert plan == expected_plan and PINS == proposed['source_manifest']
worker_receipt = load(I / 'WORKER_SHA256.json')
assert sha(Path(__file__)) == worker_receipt['sha256']
assert worker_receipt['template_sha256'] == binding['script_pins']['bounded_build_template.py']
ordered_pins = {target: PINS[target] for target in plan['build_order']}
placeholder = '__REVIEWED_' + 'SOURCE_PINS__'
expected_worker = (O / 'bounded_build_template.py').read_text().replace(placeholder, repr(ordered_pins)).encode()
assert Path(__file__).read_bytes() == expected_worker
protected_files = {str(path): sha(path) for path in (
    O / 'PLAN.json', O / 'INSTALL_BINDING.json', O / 'PROVENANCE_BINDING.json', O / 'DECLARATION_ORIGINS.json',
    I / 'APPLICATION_RECEIPT.json', I / 'GUARDS_BEFORE.json', I / 'INSTALL_BINDING_USED.json',
    I / 'SCRIPT_PINS.json', I / 'QUEUE_AFTER.json', I / 'WORKER_SHA256.json',
    I / 'PREREQUISITES_VERIFIED.json', I / 'ACCEPTED_INPUT_EVIDENCE.json',
    I / 'ORIGINAL_ATTEMPTS_BEFORE.json', O / 'SOURCE_INSPECTION.json',
)}
prerequisites = load(I / 'PREREQUISITES_VERIFIED.json')
protected_files.update(prerequisites['protected_files'])
protected_files.update(proposal_files)
for path, expected in proposal_guards.items():
    assert path not in protected_files or protected_files[path] == expected
    protected_files[path] = expected
expected_queue = json.dumps(load(I / 'QUEUE_AFTER.json'), indent=2, sort_keys=True).encode()
assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
spec = importlib.util.spec_from_file_location('graph46_closure_build_driver', W / 'continuation_driver_capacity.py')
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)
driver = module.Driver(R, W)
reused_artifacts = {}


@contextmanager
def intake():
    with driver.lock_path.open('r+') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            yield
        finally:
            fcntl.flock(lock, fcntl.LOCK_UN)


def stop(_signal, _frame):
    driver.stop = True


for stop_signal in (signal.SIGTERM, signal.SIGINT, signal.SIGHUP):
    signal.signal(stop_signal, stop)


def put(path, value):
    if not isinstance(value, bytes):
        value = (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()
    with path.open('xb') as stream:
        stream.write(value)


def guards():
    assert git('rev-parse', 'HEAD') == binding['base_commit'] and git('branch', '--show-current') == 'main'
    assert not git('diff', '--cached', '--name-only')
    index = Path(git('rev-parse', '--git-path', 'index'))
    index = index if index.is_absolute() else R / index
    assert sha(index) == installed['index_sha256']
    assert all(sha(path) == expected for path, expected in protected_files.items())
    assert all(sha(O / filename) == expected for filename, expected in binding['script_pins'].items())
    assert sha(Path(__file__)) == worker_receipt['sha256']
    assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
    assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    assert driver.static == binding['configuration'] and driver.manifest_matches(binding['configuration'], cached=False)
    assert sha(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
    assert driver.queue_path.read_bytes() == expected_queue
    assert all(sha(R / 'D1Bound5' / (target + '.lean')) == expected for target, expected in PINS.items())
    assert all(sha(R / 'D1Bound5' / (target + '.lean')) == expected for target, expected in installed['accepted_sources'].items())
    assert driver.manifest_matches(installed['accepted_artifacts'], cached=False)
    assert driver.manifest_matches(reused_artifacts, cached=False)
    history = verify_original_attempts(driver, module)
    assert history['target_names'] == plan['build_order']


with (W / 'continuation-driver.lock').open('r+') as owner:
    fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
    try:
        with intake():
            no_live_project_compiler()
            guards()
            scope_order = ['closure-pilot', 'closure-rest', 'assembly']
            membership = [scope for scope in scope_order if name in plan['scopes'][scope]]
            assert len(membership) == 1
            for previous in scope_order[:scope_order.index(membership[0])]:
                _, definitions, theorems = scope_counts(plan)[previous]
                verified = verify_scope(O, previous, plan['scopes'][previous], definitions, theorems,
                                        'GRAPH46_CLOSURE_AXIOMS_PASS ', driver, module, binding['configuration'])
                merge(protected_files, verified['protected_files'])
                merge(reused_artifacts, verified['artifacts'])
            guards()
            active = load(driver.active_path)
            assert not active.get('active') and not active.get('protected_closure')
            queue = load(driver.queue_path)
            assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True and name in queue['names']
            closure = driver.closure(name)
            assert closure[name] == PINS[name] and not set(closure) & set(queue.get('blocked_modules', []))
            latest = driver.latest()
            assert latest.get((name, module.fingerprint(closure))) is None, \
                'Existing attempt at these exact bytes; review before retry'
            for dependency in set(closure) - {name}:
                dependency_closure = driver.closure(dependency)
                manifest = driver.expected_manifest(dependency, module.fingerprint(dependency_closure), latest)
                assert manifest and driver.artifacts(dependency) == manifest, dependency
            for suffix in ('.lean', '-SOURCE_CLOSURE.json', '-BUILD_RECEIPT.json', '-build.log', '-ORIGINAL_SOURCES.json'):
                path = O / (name + suffix)
                assert not path.exists() and not path.is_symlink(), str(path)
            configuration = O / 'CONFIGURATION.json'
            if configuration.exists() or configuration.is_symlink():
                assert configuration.is_file() and not configuration.is_symlink()
                assert load(configuration) == binding['configuration']
            else:
                assert name == plan['build_order'][0] and not list(O.glob('*-BUILD_RECEIPT.json'))
                put(configuration, binding['configuration'])
            put(O / (name + '.lean'), (R / 'D1Bound5' / (name + '.lean')).read_bytes())
            put(O / (name + '-SOURCE_CLOSURE.json'), closure)
            guards()
            assert not driver.stop
            assert driver.launch(name, closure, 240)
        while driver.jobs:
            time.sleep(2)
            with intake():
                driver.reap()
    finally:
        if driver.jobs:
            driver.stop = True
            while driver.jobs:
                with intake():
                    driver.reap()
                if driver.jobs:
                    time.sleep(2)
    with intake():
        assert driver.rows and driver.rows[-1]['name'] == name, 'No terminal target receipt'
        row = driver.rows[-1]
        put(O / (name + '-BUILD_RECEIPT.json'), row)
        put(O / (name + '-build.log'), Path(row['log']).read_bytes())
        original_closure = Path(row['log']).with_suffix('.sources.json')
        assert load(original_closure) == closure
        put(O / (name + '-ORIGINAL_SOURCES.json'), original_closure.read_bytes())
        guards()
        no_live_project_compiler()
        print('TARGET_DRAINED', json.dumps({key: row.get(key) for key in (
            'name', 'exit', 'accepted_build', 'seconds', 'timed_out', 'interrupted',
            'source_sha256', 'fingerprint', 'closure_unchanged', 'shared_artifacts_unchanged')}), flush=True)
        sys.exit(0 if row['accepted_build'] else 1)
