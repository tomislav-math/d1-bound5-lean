"""Read-only current endpoint inventory after graph11's seven-scope PASS.

Print JSON to stdout. No files, Git state, queue state, or proof state are written;
no compiler or replay is launched. Other graph endpoints use the existing
driver's acceptance criterion, without imposing graph11's new audit layout.
"""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import re
import sys


R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
O = Path(__file__).resolve().parent
DRIVER = W / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
ENDPOINT = 'SmallPairGraphData11'
PREVIOUS = [2, 9, 12, 13, 16, 17, 18, 20, 22, 25, 26, 27, 29, 31, 32,
            33, 34, 35, 37, 38, 40, 41, 42, 44, 45, 47, 48]
EXPECTED_CURRENT = sorted(PREVIOUS + [11])
EXPECTED_REMAINING = [1, 3, 4, 5, 6, 7, 8, 10, 14, 15, 19, 21, 23, 24, 28, 30, 36, 39, 43, 46]
EXPECTED_TOTALS = {'definitions': 32, 'theorems': 64, 'declarations': 96,
                   'guarded_builds': 58, 'targeted_same_kernel_replays': 58,
                   'analytic_type_axiom_audits': 7}


def load(path):
    return json.loads(Path(path).read_text())


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def fingerprint(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        assert '..' not in path.parts
        path = R / path
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve())
    return path


def main():
    assert O == R / 'research/continuations/20261022-graph11-closure' and len(sys.argv) == 1
    assert sha(DRIVER) == DRIVER_SHA
    assert len(PREVIOUS) == 27 and len(EXPECTED_CURRENT) == 28 and len(EXPECTED_REMAINING) == 20
    assert EXPECTED_REMAINING == sorted(set(range(1, 49)) - set(EXPECTED_CURRENT))
    spec = importlib.util.spec_from_file_location('graph11_endpoint_inventory_driver', DRIVER)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        driver = module.Driver(R, W)
        summary_path = repo_file(O / 'ENDPOINT_VERIFICATION.json')
        state_path = repo_file(O / 'ENDPOINT_PROOF_STATE.json')
        runtime = {str(path): sha(path) for path in [driver.queue_path, driver.active_path,
                                                   driver.state_path, driver.baseline_path,
                                                   summary_path, state_path]}
        active = load(driver.active_path)
        assert not active.get('active') and not active.get('protected_closure')
        endpoint, state = load(summary_path), load(state_path)
        assert endpoint['schema'] == state['schema'] == 1
        assert endpoint['status'] == 'GRAPH11_WORKING_ENDPOINT_SCOPED_VERIFIED'
        assert endpoint['module'] == state['module'] == ENDPOINT
        assert endpoint['whole_graph11_complete'] is True and state['whole_graph11_complete'] is True
        assert endpoint['main_theorem_complete'] is False and endpoint['root_integration'] is False
        assert state['main_theorem_complete'] is False and state['root_integration'] is False
        assert sha(state_path) == endpoint['proof_state_sha256'] and fingerprint(state) == endpoint['proof_fingerprint']
        assert endpoint['module_and_check_totals'] == state['module_and_check_totals'] == EXPECTED_TOTALS
        assert endpoint['scope_count'] == len(endpoint['scope_evidence']) == len(state['scope_evidence']) == 7
        assert endpoint['scope_evidence'] == state['scope_evidence']
        assert endpoint['unique_target_count'] == len(state['targets']) == len(set(state['targets'])) == 58
        assert len(state['declaration_names']) == len(set(state['declaration_names'])) == 96
        queue, _, closures, accepted, unknown, _ = driver.snapshot()
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert ENDPOINT in accepted and set(state['targets']) <= accepted
        assert set(state['verified_sources']) <= accepted
        assert closures[ENDPOINT] == state['endpoint_source_closure']
        assert endpoint['source_closure_modules'] == len(closures[ENDPOINT])
        assert module.fingerprint(closures[ENDPOINT]) == state['endpoint_build_fingerprint']
        latest = driver.latest()
        assert driver.expected_manifest(ENDPOINT, state['endpoint_build_fingerprint'], latest) == state['endpoint_artifacts']
        assert driver.artifacts(ENDPOINT) == state['endpoint_artifacts']
        assert driver.static == state['configuration']
        assert sha(repo_file('D1Bound5.lean')) == state['canonical_root_sha256']
        for path, digest in state['verified_files'].items():
            assert re.fullmatch(r'[0-9a-f]{64}', digest) and sha(repo_file(path)) == digest, path
        for name, digest in state['verified_sources'].items():
            assert re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*', name)
            assert sha(repo_file('D1Bound5/' + name + '.lean')) == digest, name
        assert driver.manifest_matches(state['verified_artifacts'], cached=False)
        assert driver.manifest_matches(state['configuration'], cached=False)

        modules = {number: 'SmallPairGraphData' + str(number) for number in range(1, 49)}
        for name in modules.values():
            repo_file('D1Bound5/' + name + '.lean')
        current = sorted(number for number, name in modules.items() if name in accepted)
        current_evidence = {}
        for number in current:
            name = modules[number]
            closure = closures[name]
            key = module.fingerprint(closure)
            expected = driver.expected_manifest(name, key, latest)
            # Preserve the driver's historical acceptance rule for earlier graphs.
            # Do not require graph11-style audit files or reject extra artifacts.
            assert expected and driver.manifest_matches(expected, cached=False), name
            current_evidence[str(number)] = {'module': name, 'source_sha256': closure[name],
                                             'source_closure_modules': len(closure),
                                             'build_fingerprint': key, 'accepted_artifacts': expected,
                                             'basis': 'current_driver_acceptance'}
        remaining = sorted(set(range(1, 49)) - set(current))
        added, removed = sorted(set(current) - set(PREVIOUS)), sorted(set(PREVIOUS) - set(current))
        expected_transition = current == EXPECTED_CURRENT and remaining == EXPECTED_REMAINING
        assert all(sha(path) == digest for path, digest in runtime.items())
        assert all(sha(repo_file(path)) == digest for path, digest in state['verified_files'].items())
        assert driver.manifest_matches(state['verified_artifacts'], cached=False)
        result = {
            'schema': 1, 'status': 'CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH11_PASS',
            'utc': datetime.now(timezone.utc).isoformat(),
            'previous_accepted_endpoints': PREVIOUS, 'previous_accepted_endpoint_count': 27,
            'current_accepted_endpoints': current, 'accepted_endpoint_count': len(current),
            'remaining_endpoints': remaining, 'remaining_endpoint_count': len(remaining), 'total_endpoints': 48,
            'added_endpoints': added, 'removed_endpoints': removed,
            'expected_added_endpoints': [11], 'expected_accepted_endpoint_count': 28,
            'expected_remaining_endpoints': EXPECTED_REMAINING,
            'expected_transition_matches': expected_transition, 'current_endpoint_evidence': current_evidence,
            'unknown_modules': unknown, 'max_parallel': queue['max_parallel'],
            'pause_after_current': queue['pause_after_current'],
            'graph11_endpoint_summary_sha256': sha(summary_path),
            'graph11_endpoint_proof_state_sha256': sha(state_path),
            'graph11_endpoint_proof_fingerprint': endpoint['proof_fingerprint'],
            'graph11_source_closure_modules': len(closures[ENDPOINT]),
            'main_theorem_complete': False, 'root_integration': False,
            'read_only': True, 'files_written': [], 'compiler_run': False, 'git_run': False,
            'interpretation': 'Current working graph endpoints only; graph counts are not an overall proof-completion percentage.',
        }
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
