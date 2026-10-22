"""Prepare and install the reviewed exact graph46 literal foundation partition.

No compiler, replay, Git mutation, or accepted-root edit is performed here.
Execution requires actual source evidence and a separately reviewed baseline.
"""
from pathlib import Path
import fcntl
import importlib.util
import json
import os
import re
import subprocess
import sys

from foundation_inputs import (
    DRIVER_SHA, RUNNER_SHA, GROUPS, ORIGINAL_NAMES, TARGETS, digest,
    inspect_sources, load_binding, source_hash, candidate_sources, prepared_plan,
    prepared_payload_paths, verify_prepared,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
O = R / 'research/continuations/20261022-graph46-foundation'
D = W / 'continuation_driver_capacity.py'
RUNNER = R / 'research/continuations/20261020T100000CEST-work-resume/bound_scoped_audit_runner_proposal_v1.py'


def load(path):
    return json.loads(Path(path).read_text())


def copy(path, data):
    with Path(path).open('xb') as stream:
        stream.write(data)


def put(path, value):
    copy(path, (json.dumps(value, indent=2, sort_keys=True) + '\n').encode())


def absent(path):
    path = Path(path)
    assert not path.exists() and not path.is_symlink(), str(path)


def git(*args):
    return subprocess.check_output(['git', *args], cwd=R, text=True, timeout=30).strip()


def no_compiler():
    output = subprocess.check_output(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True, timeout=10)
    for line in output.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid():
            continue
        pid, _, executable, _ = fields
        if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
            continue
        process = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                                 capture_output=True, text=True, timeout=10)
        if process.returncode and subprocess.run(['ps', '-p', pid, '-o', 'pid='],
                capture_output=True, timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify live compiler cwd: ' + pid)
        assert not any(item == 'n' + str(R) or item.startswith('n' + str(R) + '/')
                       for item in process.stdout.splitlines()), pid


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) >= 2 and sys.argv[1] in ('--prepare', '--install')
    mode = sys.argv[1]
    assert len(sys.argv) == (2 if mode == '--prepare' else 4)
    if mode == '--install':
        assert all(re.fullmatch(r'[0-9a-f]{64}', value) for value in sys.argv[2:])
    binding_path = O / 'GRAPH46_BINDING.json'
    binding_bytes = binding_path.read_bytes()
    binding = load_binding(O)
    original_manifest = binding['source_evidence']['original_source_manifest']
    assert source_hash(D) == DRIVER_SHA
    assert source_hash(RUNNER) == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph46_install_driver', D)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)

    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        active_path = W / 'continuation-active.json'
        active_bytes = active_path.read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        no_compiler()
        assert git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        head = git('rev-parse', 'HEAD')
        assert head == binding['base_commit']
        index_path = Path(git('rev-parse', '--git-path', 'index'))
        index_path = index_path if index_path.is_absolute() else R / index_path
        index_hash = source_hash(index_path)
        driver = module.Driver(R, W)
        assert driver.static == binding['configuration']
        assert driver.manifest_matches(binding['configuration'], cached=False)
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        assert unknown == [] and queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert len(names) == len(queue['names'])
        assert set(ORIGINAL_NAMES) <= set(names)
        assert not set(GROUPS) & set(names), 'A proposed fragment name is already queued'
        assert not set(ORIGINAL_NAMES) & accepted
        assert all(not (set(ORIGINAL_NAMES) & set(closures[name])) for name in accepted), \
            'An accepted dependent would be changed'
        raw = {}
        for name in ORIGINAL_NAMES:
            path = R / 'D1Bound5' / (name + '.lean')
            assert source_hash(path) == original_manifest[name]
            raw[name] = path.read_bytes()
        assert inspect_sources(raw) == binding['source_evidence']
        for name in GROUPS:
            absent(R / 'D1Bound5' / (name + '.lean'))
        absent(O / 'INSTALL_RECEIPT.json')
        queue_bytes = driver.queue_path.read_bytes()
        assert digest(queue_bytes) == binding['queue_before_sha256']
        assert source_hash(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
        original_paths = {R / 'D1Bound5' / (name + '.lean'): digest(data) for name, data in raw.items()}
        prepared_guard = None

        def stable(source_pins, expected_queue):
            assert git('rev-parse', 'HEAD') == head
            assert source_hash(index_path) == index_hash and not git('diff', '--cached', '--name-only')
            assert active_path.read_bytes() == active_bytes
            assert driver.queue_path.read_bytes() == expected_queue
            assert source_hash(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
            assert binding_path.read_bytes() == binding_bytes
            assert load_binding(O) == binding
            assert source_hash(D) == DRIVER_SHA
            assert source_hash(RUNNER) == RUNNER_SHA
            assert driver.static == binding['configuration']
            assert driver.manifest_matches(binding['configuration'], cached=False)
            assert all(source_hash(path) == expected for path, expected in source_pins.items())
            if prepared_guard is not None:
                assert source_hash(O / 'PREPARED_PAYLOAD_SHA256.json') == prepared_guard['sha256']
                assert all(source_hash(O / relative) == expected for relative, expected in prepared_guard['files'].items())
            no_compiler()

        if mode == '--prepare':
            for path in [O / 'installation', O / 'candidates', O / 'PLAN.json',
                         O / 'DECLARATION_ORIGINS.json', O / 'foundation-TARGETS.json',
                         O / 'bounded_build.py', O / 'PREPARED_PAYLOAD_SHA256.json']:
                absent(path)
            candidates, blocks, counts, origins = candidate_sources(raw)
            template = (O / 'bounded_build_template.py').read_text()
            assert template.count('__REVIEWED_SOURCE_PINS__') == 1
            stable(original_paths, queue_bytes)
            (O / 'installation').mkdir()
            (O / 'candidates').mkdir()
            for name, data in raw.items():
                copy(O / 'installation' / (name + '.before.lean'), data)
            copy(O / 'installation/continuation-queue.before.json', queue_bytes)
            copy(O / 'installation/GRAPH46_BINDING_USED.json', binding_bytes)
            for name, data in candidates.items():
                copy(O / 'candidates' / (name + '.lean'), data)
            plan = prepared_plan(binding, digest(binding_bytes), candidates, blocks, counts)
            put(O / 'PLAN.json', plan)
            put(O / 'DECLARATION_ORIGINS.json', origins)
            put(O / 'foundation-TARGETS.json', TARGETS)
            copy(O / 'bounded_build.py', template.replace('__REVIEWED_SOURCE_PINS__', repr(plan['source_manifest'])).encode())
            payload = {relative: source_hash(O / relative) for relative in prepared_payload_paths()}
            put(O / 'PREPARED_PAYLOAD_SHA256.json', payload)
            prepared_guard = {'sha256': source_hash(O / 'PREPARED_PAYLOAD_SHA256.json'), 'files': payload}
            assert verify_prepared(O) == (binding, plan, payload)
            stable(original_paths, queue_bytes)
            print(json.dumps({'status': plan['status'], 'plan_sha256': source_hash(O / 'PLAN.json'),
                              'payload_sha256': source_hash(O / 'PREPARED_PAYLOAD_SHA256.json'),
                              'targets': TARGETS, 'source_bytes': plan['source_bytes']}), flush=True)
            return

        assert source_hash(O / 'PLAN.json') == sys.argv[2]
        assert source_hash(O / 'PREPARED_PAYLOAD_SHA256.json') == sys.argv[3]
        bound_again, plan, payload = verify_prepared(O)
        assert bound_again == binding
        prepared_guard = {'sha256': sys.argv[3], 'files': payload}
        for relative, expected in payload.items():
            path = O / relative
            assert path.resolve().is_relative_to(O) and source_hash(path) == expected, relative
        assert plan['status'] == 'EXACT_GRAPH46_LITERAL_PARTITION_PREPARED_NOT_INSTALLED'
        assert plan['input_binding_sha256'] == digest(binding_bytes)
        assert (O / 'installation/GRAPH46_BINDING_USED.json').read_bytes() == binding_bytes
        assert plan['original_source_manifest'] == original_manifest and plan['targets'] == TARGETS
        assert head == plan['base_commit']
        assert digest(queue_bytes) == plan['queue_before_sha256'] and driver.static == plan['configuration']
        assert source_hash(R / 'D1Bound5.lean') == plan['canonical_root_sha256']
        candidates = {name: (O / 'candidates' / (name + '.lean')).read_bytes() for name in TARGETS}
        assert candidates == candidate_sources(raw)[0]
        assert {name: digest(data) for name, data in candidates.items()} == plan['source_manifest']
        union, candidate_closures = {}, {}

        def proposed_closure(name, visiting=()):
            assert name not in visiting, 'Cycle in candidate imports'
            if name in candidate_closures:
                return candidate_closures[name]
            data = candidates[name] if name in candidates else (R / 'D1Bound5' / (name + '.lean')).read_bytes()
            closure = {name: digest(data)}
            for line in module.IMPORT_LINE.findall(data):
                content = line.split(b'--', 1)[0]
                imports = module.IMPORT_NAME.findall(content)
                assert b'D1Bound5' not in content or imports
                for dependency in imports:
                    incoming = proposed_closure(dependency.decode(), visiting + (name,))
                    for key, expected in incoming.items():
                        assert key not in closure or closure[key] == expected
                        closure[key] = expected
            candidate_closures[name] = closure
            return closure

        for name in candidates:
            for key, expected in proposed_closure(name).items():
                assert key not in union or union[key] == expected
                union[key] = expected
        assert not set(union) & set(queue.get('blocked_modules', []))
        latest, dependencies = driver.latest(), {}
        for name in TARGETS:
            assert latest.get((name, module.fingerprint(candidate_closures[name]))) is None, \
                'Existing attempt at the proposed exact fingerprint: ' + name
        for name in set(union) - set(candidates):
            closure = driver.closure(name)
            manifest = driver.expected_manifest(name, module.fingerprint(closure), latest)
            assert manifest and driver.artifacts(name) == manifest, name
            dependencies[name] = {'closure': closure, 'artifacts': manifest}
        source_pins = dict(original_paths)
        source_pins.update({R / 'D1Bound5' / (name + '.lean'): expected
                            for name, expected in union.items() if name not in candidates})
        replacements = {}
        for name, data in candidates.items():
            path = R / 'D1Bound5' / (name + '.lean')
            if name in original_manifest and data != raw[name]:
                temporary = path.with_name(path.name + '.graph46-install.' + str(os.getpid()))
                absent(temporary)
                replacements[name] = temporary
            elif name not in original_manifest:
                absent(path)
        assert set(replacements) == {ORIGINAL_NAMES[0]}
        stable(source_pins, queue_bytes)
        for name, evidence in dependencies.items():
            assert driver.closure(name) == evidence['closure'] and driver.artifacts(name) == evidence['artifacts']
        for name, data in candidates.items():
            path = R / 'D1Bound5' / (name + '.lean')
            if name not in original_manifest:
                copy(path, data)
            elif name in replacements:
                assert source_hash(path) == original_manifest[name]
                copy(replacements[name], data)
                os.replace(replacements[name], path)
        where = queue['names'].index(ORIGINAL_NAMES[0])
        queue['names'][where:where] = list(GROUPS)
        before_queue = json.loads(queue_bytes)
        assert len(queue['names']) == len(set(queue['names']))
        assert {key: value for key, value in queue.items() if key != 'names'} == {
            key: value for key, value in before_queue.items() if key != 'names'}
        module.atomic_json(driver.queue_path, queue)
        queue_after = driver.queue_path.read_bytes()
        assert queue_after == json.dumps(queue, indent=2, sort_keys=True).encode()
        source_pins.update({R / 'D1Bound5' / (name + '.lean'): digest(data)
                            for name, data in candidates.items()})
        stable(source_pins, queue_after)
        queue2, names2, closures2, accepted2, unknown2, eligible2 = driver.snapshot()
        assert unknown2 == [] and accepted <= accepted2
        assert set(GROUPS) <= set(eligible2)
        assert queue2 == queue and len(names2) == len(queue2['names'])
        for name, evidence in dependencies.items():
            assert driver.closure(name) == evidence['closure'] and driver.artifacts(name) == evidence['artifacts']
        receipt = {
            'status': 'EXACT_GRAPH46_LITERAL_PARTITION_INSTALLED_NOT_BUILT', 'utc': module.utc(),
            'plan_sha256': sys.argv[2], 'prepared_payload_sha256': sys.argv[3],
            'source_manifest': plan['source_manifest'], 'queue_after_sha256': digest(queue_after),
            'input_binding_sha256': digest(binding_bytes), 'unknown': unknown2,
            'previous_accepted_sources_retained': True,
            'main_theorem_complete': False, 'root_integration': False,
        }
        put(O / 'INSTALL_RECEIPT.json', receipt)
        print(json.dumps(receipt), flush=True)


if __name__ == '__main__':
    main()
