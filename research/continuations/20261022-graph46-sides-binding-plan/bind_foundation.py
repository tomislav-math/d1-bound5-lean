"""Create the actual graph46 sides foundation binding after private publication.

Usage: python3.12 -B bind_foundation.py REVIEWED_HEAD PUBLISHED_FOUNDATION_COMMIT PROOF_FINGERPRINT
The arguments must come from actual reviewed results. The frozen sides verifier
accepts this prospective binding in memory, so no circular output file is needed.
Write exactly one new research binding; run no compiler or Git mutation and
change no project source, queue, accepted baseline, or proof receipt.
"""
from pathlib import Path
import fcntl
import hashlib
import importlib.util
import json
import re
import sys


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True

R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = C / '20261022-graph46-sides-binding-plan'
SIDES = C / '20261022-graph46-sides'
FOUNDATION = C / '20261022-graph46-foundation'
VERIFIER_SHA = '61c868f4cfa1ed33bcbc179da509ee7a827d51df3c66cdc0d9dd5d16b3946294'
TEMPLATE_SHA = 'fc961e35e15ead32935b591315985383a0ef1b4efba21d70f697fe8fc3a4fa19'
PAYLOAD_SHA = '0a5f79888d094e6111fa6279bc14d72a784981734fe93735dc8c57f62308b3e3'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
ROOT_SHA = '33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2'
TOOLCHAIN_SHA = '3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71'
MANIFEST_SHA = '7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        assert '..' not in path.parts
        path = R / path
    assert path.is_file() and not path.is_symlink(), str(path)
    assert path.resolve().is_relative_to(R.resolve()), str(path)
    return path


def sha(path):
    return digest(repo_file(path).read_bytes())


def load(path):
    return json.loads(repo_file(path).read_text())


def absent(path):
    assert not path.exists() and not path.is_symlink(), str(path)


def protect(files, path, expected=None):
    path = repo_file(path)
    actual = sha(path)
    assert expected is None or actual == expected, str(path)
    key = str(path)
    assert key not in files or files[key] == actual, key
    files[key] = actual
    return path


def import_pinned(name, path, expected):
    path = repo_file(path)
    assert sha(path) == expected
    specification = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(specification)
    sys.modules[name] = module
    specification.loader.exec_module(module)
    return module


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) == 4
    head, published, proof = sys.argv[1:]
    assert all(re.fullmatch(r'[0-9a-f]{40}', value) for value in (head, published))
    assert re.fullmatch(r'[0-9a-f]{64}', proof)
    destination = SIDES / 'REVIEWED_FOUNDATION_BINDING.json'
    absent(destination)
    verifier = import_pinned('graph46_binding_sides_verifier', SIDES / 'installer.py', VERIFIER_SHA)
    assert verifier.ROOT == R and verifier.WORK == W and verifier.OUT == verifier.EXPECTED_OUT == SIDES
    assert verifier.FOUNDATION == FOUNDATION and verifier.PAYLOAD_SHA == PAYLOAD_SHA
    driver_module = import_pinned('graph46_binding_driver', W / 'continuation_driver_capacity.py', DRIVER_SHA)
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        verifier.no_live_project_compiler()
        assert verifier.git('rev-parse', 'HEAD') == head and verifier.git('branch', '--show-current') == 'main'
        assert not verifier.git('diff', '--cached', '--name-only')
        index = Path(verifier.git('rev-parse', '--git-path', 'index'))
        index = index if index.is_absolute() else R / index
        driver = driver_module.Driver(R, W)
        protected = {}
        for path in (Path(__file__), index, driver.queue_path, driver.active_path,
                     driver.state_path, driver.baseline_path):
            protect(protected, path)
        protect(protected, SIDES / 'installer.py', VERIFIER_SHA)
        protect(protected, W / 'continuation_driver_capacity.py', DRIVER_SHA)
        protect(protected, U / 'bound_scoped_audit_runner_proposal_v1.py', RUNNER_SHA)
        protect(protected, R / 'D1Bound5.lean', ROOT_SHA)
        assert driver.rows == load(driver.state_path) and driver.baseline == load(driver.baseline_path)
        active = load(driver.active_path)
        assert not active.get('active') and not active.get('protected_closure')
        queue, names, closures, accepted, unknown, _ = driver.snapshot()
        assert unknown == [] and queue == load(driver.queue_path)
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert len(names) == len(queue['names']) == len(set(queue['names']))
        assert driver.static['lean-toolchain'] == TOOLCHAIN_SHA and driver.static['lake-manifest.json'] == MANIFEST_SHA
        assert driver.manifest_matches(driver.static, cached=False)
        assert set(verifier.FOUNDATION_TARGETS) <= accepted
        assert set(verifier.ORIGINAL_SHA) <= set(names)
        assert not set(verifier.ORIGINAL_SHA) & accepted
        assert all(not set(verifier.ORIGINAL_SHA) & set(closures[name]) for name in accepted)
        for path in (SIDES / 'PLAN.json', SIDES / 'INSTALL_RECEIPT.json', SIDES / 'INSTALL_STARTED.json',
                     SIDES / 'originals', SIDES / 'candidates'):
            absent(path)
        for scope in ('sides-pilot', 'left-rest', 'right-rest'):
            absent(U / ('pro-graph46-' + scope + '-audit'))

        template = load(protect(protected, SIDES / 'REVIEWED_FOUNDATION_BINDING.TEMPLATE.json', TEMPLATE_SHA))
        assert template['schema'] == 1 and template['graph'] == 46 and template['status'] == 'UNBOUND_DO_NOT_RUN'
        required = verifier.foundation_binding_files()
        assert len(required) == len(set(required)) == 26
        assert set(template['files']) == {str(path.relative_to(R)) for path in required}
        files = {str(path.relative_to(R)): sha(protect(protected, path)) for path in required}
        payload = load(protect(protected, SIDES / 'payload/PAYLOAD_SHA256.json', PAYLOAD_SHA))
        for value, expected in payload.items():
            relative = Path(value)
            assert not relative.is_absolute() and '..' not in relative.parts
            assert re.fullmatch(r'[0-9a-f]{64}', expected)
            path = protect(protected, SIDES / 'payload' / relative, expected)
            assert path.resolve().is_relative_to((SIDES / 'payload').resolve())
        for name, expected in verifier.ORIGINAL_SHA.items():
            source = protect(protected, 'D1Bound5/' + name + '.lean', expected)
            assert source.read_bytes() == (SIDES / 'payload/originals' / (name + '.lean')).read_bytes()

        binding = {
            'schema': 1, 'status': 'REVIEWED_FOUNDATION_BINDING', 'graph': 46,
            'base_commit': head, 'foundation_published_commit': published,
            'foundation_proof_fingerprint': proof, 'files': files,
            'root_integration': False, 'main_theorem_complete': False,
        }
        # No destination binding is read here: the frozen verifier consumes the
        # prospective object in memory and checks the actual published evidence.
        absent(destination)
        verified = verifier.verify_foundation(driver, driver_module, driver.latest(), head, binding)
        assert verified['proof_fingerprint'] == proof and verified['publication']['commit'] == published
        assert verified['committed_head'] == head and verified['configuration'] == driver.static
        for path, expected in verified['protected_files'].items():
            protect(protected, path, expected)
        for name, expected in verified['source_manifest'].items():
            protect(protected, 'D1Bound5/' + name + '.lean', expected)
        latest = driver.latest()
        for name in verifier.FOUNDATION_TARGETS:
            closure = driver.closure(name)
            assert latest.get((name, driver_module.fingerprint(closure))) == load(FOUNDATION / (name + '-BUILD_RECEIPT.json'))
        assert driver.manifest_matches(verified['artifacts'], cached=False)
        assert driver.manifest_matches(driver.static, cached=False)
        assert driver.rows == load(driver.state_path) and driver.baseline == load(driver.baseline_path)
        assert all(sha(path) == expected for path, expected in protected.items())
        assert verifier.git('rev-parse', 'HEAD') == head and verifier.git('branch', '--show-current') == 'main'
        assert not verifier.git('diff', '--cached', '--name-only')
        verifier.no_live_project_compiler()
        assert all(sha(path) == expected for path, expected in protected.items())
        absent(destination)
        data = (json.dumps(binding, indent=2, sort_keys=True) + '\n').encode()
        with destination.open('xb') as stream:
            stream.write(data)
        assert sha(destination) == digest(data)
        print(json.dumps({
            'status': 'ACTUAL_GRAPH46_FOUNDATION_BINDING_CREATED', 'binding_path': str(destination.relative_to(R)),
            'binding_sha256': digest(data), 'base_commit': head, 'foundation_published_commit': published,
            'foundation_proof_fingerprint': proof, 'bound_files': len(files), 'both_locks_held': True,
            'source_files_changed': False, 'queue_changed': False, 'proof_receipts_changed': False,
            'compiler_run': False, 'git_mutation': False, 'root_integration': False, 'main_theorem_complete': False,
        }), flush=True)


if __name__ == '__main__':
    main()
