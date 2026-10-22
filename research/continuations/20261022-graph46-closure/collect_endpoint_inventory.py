"""Read-only current endpoint inventory after graph46's seven-scope PASS.

The installation's actual bound baseline supplies the previous accepted set and
endpoint universe. Reconstruct graph46 evidence afresh; other graph endpoints
retain the pinned driver's existing acceptance rule. Print JSON without writes,
Git commands, compilation, replay, or queue mutation.
"""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import json
import sys


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True

from collect_endpoint import (
    R, C, W, O, ENDPOINT, ENDPOINT_NUMBER, load, sha, fingerprint, repo_file, merge,
    load_driver, runtime_guards, collect_endpoint_state, verify_current_state,
    endpoint_summary, no_live_project_compiler,
)


def main():
    assert Path(__file__).resolve().parent == O == C / '20261022-graph46-closure'
    assert len(sys.argv) == 1
    module = load_driver('graph46_endpoint_inventory_driver')
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        no_live_project_compiler()
        driver = module.Driver(R, W)
        summary_path = repo_file(O / 'ENDPOINT_VERIFICATION.json')
        state_path = repo_file(O / 'ENDPOINT_PROOF_STATE.json')
        runtime = runtime_guards(driver, [summary_path, state_path, Path(__file__)])
        endpoint, state = load(summary_path), load(state_path)
        current_state, metadata = collect_endpoint_state(driver, module)
        assert current_state == state
        expected_summary = endpoint_summary(state)
        assert set(endpoint) == set(expected_summary) | {'utc', 'proof_state_sha256'}
        assert all(endpoint[key] == value for key, value in expected_summary.items())
        assert isinstance(endpoint['utc'], str) and endpoint['utc']
        assert endpoint['proof_state_sha256'] == sha(state_path)
        assert endpoint['proof_fingerprint'] == fingerprint(state)
        assert endpoint['module_and_check_totals'] == metadata['totals']
        assert endpoint['unique_target_count'] == len(metadata['targets'])
        assert endpoint['scope_count'] == len(metadata['specifications'])
        baseline = metadata['binding']['baseline_endpoint_inventory']
        previous = baseline['accepted']
        total = baseline['total_endpoints']
        assert type(total) is int and total > 0
        universe = set(range(1, total + 1))
        assert previous == sorted(set(previous)) and set(previous) <= universe
        assert ENDPOINT_NUMBER in universe and ENDPOINT_NUMBER not in previous
        expected_current = sorted(set(previous) | {ENDPOINT_NUMBER})
        expected_remaining = sorted(universe - set(expected_current))
        queue, _, closures, accepted, unknown, _ = driver.snapshot()
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert ENDPOINT in accepted and set(metadata['targets']) <= accepted
        assert set(state['verified_sources']) <= accepted
        assert closures[ENDPOINT] == state['endpoint_source_closure']
        modules = {number: 'SmallPairGraphData' + str(number) for number in sorted(universe)}
        for name in modules.values():
            repo_file('D1Bound5/' + name + '.lean')
        current = sorted(number for number, name in modules.items() if name in accepted)
        current_evidence, current_sources, current_artifacts = {}, {}, {}
        latest = driver.latest()
        for number in current:
            name = modules[number]
            closure = driver.closure(name)
            assert closure == closures[name]
            key = module.fingerprint(closure)
            manifest = driver.expected_manifest(name, key, latest)
            # Earlier endpoints keep their existing driver acceptance semantics;
            # their older proof layouts are not silently assigned graph46 audits.
            assert manifest and driver.manifest_matches(manifest, cached=False), name
            merge(current_sources, closure)
            merge(current_artifacts, manifest)
            current_evidence[str(number)] = {
                'module': name, 'source_sha256': closure[name], 'source_closure_modules': len(closure),
                'build_fingerprint': key, 'accepted_artifacts': manifest, 'basis': 'current_driver_acceptance',
            }
        remaining = sorted(universe - set(current))
        added = sorted(set(current) - set(previous))
        removed = sorted(set(previous) - set(current))
        expected_transition = added == [ENDPOINT_NUMBER] and not removed and current == expected_current
        no_live_project_compiler()
        verify_current_state(driver, module, state, metadata, runtime)
        assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected
                   for name, expected in current_sources.items())
        assert driver.manifest_matches(current_artifacts, cached=False)
        assert all(sha(repo_file(path)) == expected for path, expected in runtime.items())
        result = {
            'schema': 1, 'status': 'CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH46_PASS',
            'utc': datetime.now(timezone.utc).isoformat(),
            'baseline_install_binding_sha256': state['install_binding_sha256'],
            'previous_accepted_endpoints': previous, 'previous_accepted_endpoint_count': len(previous),
            'current_accepted_endpoints': current, 'accepted_endpoint_count': len(current),
            'remaining_endpoints': remaining, 'remaining_endpoint_count': len(remaining), 'total_endpoints': total,
            'added_endpoints': added, 'removed_endpoints': removed,
            'expected_added_endpoints': [ENDPOINT_NUMBER], 'expected_accepted_endpoint_count': len(expected_current),
            'expected_remaining_endpoints': expected_remaining,
            'expected_transition_matches': expected_transition, 'current_endpoint_evidence': current_evidence,
            'unknown_modules': unknown, 'max_parallel': queue['max_parallel'],
            'pause_after_current': queue['pause_after_current'],
            'graph46_endpoint_summary_sha256': sha(summary_path),
            'graph46_endpoint_proof_state_sha256': sha(state_path),
            'graph46_endpoint_proof_fingerprint': endpoint['proof_fingerprint'],
            'graph46_source_closure_modules': len(closures[ENDPOINT]),
            'module_and_check_totals': metadata['totals'],
            'main_theorem_complete': False, 'root_integration': False,
            'read_only': True, 'files_written': [], 'compiler_run': False, 'git_run': False,
            'interpretation': 'Current working graph endpoints only; graph counts are not an overall proof-completion percentage.',
        }
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
