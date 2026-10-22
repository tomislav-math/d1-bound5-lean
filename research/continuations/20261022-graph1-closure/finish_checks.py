"""Accept a graph1 closure scope only after exact, bound audit and replay checks."""
from datetime import datetime, timezone
from pathlib import Path
import fcntl
import importlib.util
import json
import sys

from closure_inputs import digest
from closure_runtime import R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, load, sha
from prepare_checks import (
    SCOPES, COUNTS, absent, check_installation, check_origins, git, no_compiler,
    public_record, put, repo_file,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True


def main():
    assert Path(__file__).resolve().parent == O == C / '20261022-graph1-closure'
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
    scope = sys.argv[1]
    targets = SCOPES[scope]
    audit = U / ('pro-graph1-' + scope + '-audit')
    assert sha(repo_file(W / 'continuation_driver_capacity.py')) == DRIVER_SHA
    assert sha(repo_file(U / 'bound_scoped_audit_runner_proposal_v1.py')) == RUNNER_SHA
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        active_bytes = (W / 'continuation-active.json').read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        replay_state_bytes = (audit / 'active-targeted-replay.json').read_bytes()
        assert json.loads(replay_state_bytes)['active'] is False
        no_compiler()
        assert git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        base = git('rev-parse', 'HEAD')
        spec = importlib.util.spec_from_file_location('graph1_closure_finish_driver', W / 'continuation_driver_capacity.py')
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)
        driver = module.Driver(R, W)
        install_binding, plan = check_installation(driver)
        assert base == install_binding['base_commit']
        origins, original_manifest, selected = check_origins(plan)
        summary_path = repo_file(O / (scope + '-PREPARATION.json'))
        summary = load(summary_path)
        target_count, definitions, theorems = COUNTS[scope]
        assert summary['targets'] == load(O / (scope + '-TARGETS.json')) == targets
        assert len(targets) == len(set(targets)) == target_count
        assert summary['definitions'] == definitions and summary['theorems'] == theorems
        assert summary['declarations'] == definitions + theorems and summary['public_headers_exact'] is True
        assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
        assert summary['audit'] == str(audit.relative_to(R)) and summary['base_commit'] == base
        assert summary['install_binding_sha256'] == sha(repo_file(O / 'INSTALL_BINDING.json'))
        absent(O / (scope + '-PROOF_STATE.json'))
        absent(O / (scope + '-VERIFICATION_SUMMARY.json'))
        receipts_path = repo_file(audit / 'TARGETED_REPLAY_RECEIPTS.json')
        final_path = repo_file(audit / 'BOUND_AUDIT_FINAL.json')
        receipts, final = load(receipts_path), load(final_path)
        assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
        assert final['main_theorem_claim'] is False
        assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in targets]
        assert all(row['exit'] == 0 and row['timed_out'] is False and row['guards_unchanged'] is True
                   and not row['binding_drift_paths'] for row in receipts)
        log_path = repo_file(audit / 'analytic-type-axioms.log')
        assert log_path.read_text().count('GRAPH1_CLOSURE_AXIOMS_PASS ') == definitions + theorems
        binding_path = repo_file(audit / 'PREPARATION_BINDINGS.json')
        binding = load(binding_path)
        assert binding['schema'] == 1 and binding['audit_folder'] == str(audit.resolve())
        assert binding['targets'] == binding['replays'] == targets
        assert load(audit / 'TARGETS.json') == load(audit / 'REPLAY_TARGETS.json') == targets
        assert final['binding_sha256'] == sha(binding_path)
        assert final['source_map_sha256'] == sha(repo_file(audit / 'SOURCE_MAP.json'))
        protected = {str(repo_file(path)): expected for path, expected in binding['files'].items()}
        assert all(sha(path) == expected for path, expected in protected.items())
        source_map_path = repo_file(O / (scope + '-SOURCE_MAP.json'))
        evidence_path = repo_file(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
        source_map, evidence = load(source_map_path), load(evidence_path)
        assert source_map['base_commit'] == base
        assert len(source_map['sources']) == summary['source_closure_modules']
        assert set(source_map['sources']) == set(evidence)
        assert binding['project_sources'] == {name: item['sha256'] for name, item in source_map['sources'].items()}
        latest, artifacts = driver.latest(), {}
        for name, item in source_map['sources'].items():
            assert item['path'] == 'D1Bound5/' + name + '.lean'
            assert sha(repo_file(item['path'])) == item['sha256']
            key = module.fingerprint(driver.closure(name))
            expected = driver.expected_manifest(name, key, latest)
            assert expected and key == evidence[name]['fingerprint']
            assert expected == evidence[name]['artifacts'] == driver.artifacts(name), name
            for path, value in expected.items():
                assert path not in artifacts or artifacts[path] == value
                artifacts[path] = value
            if name in targets:
                assert item['assurance'] == 'guarded_build_pass_current_audit_pending'
                candidate = repo_file(O / 'candidates' / (name + '.lean'))
                assert item['payload_path'] == str(candidate.relative_to(R))
                assert item['sha256'] == plan['source_manifest'][name] == sha(candidate)
                item['assurance'] = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
        assert all(artifacts.get(path) == expected for path, expected in binding['target_artifacts'].items())
        replay_guards_path = repo_file(audit / 'TARGETED_REPLAY_GUARDS.json')
        replay_guards = load(replay_guards_path)
        assert replay_guards['project_sources'] == binding['project_sources']
        assert replay_guards['compiled_artifacts'] == artifacts
        assert replay_guards['immutable_inputs'] == install_binding['configuration'] == driver.static
        # binding_for_run freezes the binding file itself in memory. The saved
        # preparation binding therefore has exactly one fewer file entry.
        expected_preparation_files = dict(binding['files'])
        binding_self = str(binding_path)
        assert binding_self not in expected_preparation_files
        expected_preparation_files[binding_self] = sha(binding_path)
        assert replay_guards['preparation_files'] == expected_preparation_files
        assert all(sha(repo_file(path)) == expected for path, expected in replay_guards['preparation_files'].items())
        assert driver.manifest_matches(install_binding['configuration'], cached=False)
        records_path = repo_file(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json')
        records = load(records_path)
        assert [record['module'] for record in records] == targets
        expected_names = [item['name'] for name in targets for item in selected[name]]
        assert load(audit / 'DECLARATION_NAMES.json') == expected_names
        for record in records:
            name = record['module']
            origin = origins[name]
            original = repo_file(O / 'originals' / (origin['original_module'] + '.lean'))
            assert repo_file(record['original_path']) == original
            assert repo_file(record['original_source_path']) == original
            assert record['original_sha256'] == sha(original) == original_manifest[origin['original_module']]
            assert record['current_sha256'] == plan['source_manifest'][name]
            assert record['raw_original_module'] == origin['original_module']
            assert record['preservation'] == origin['preservation'] and record['normalizations'] == []
            assert repo_file(record['origin_map_path']) == O / 'DECLARATION_ORIGINS.json'
            assert sha(record['origin_map_path']) == record['origin_map_sha256']
            assert record['declarations'] == [public_record(item) for item in selected[name]]
            assert record['declaration_source_sha256'] == {
                item['name']: digest(item['source_text'].encode()) for item in selected[name]
            }
        used_path = repo_file(audit / 'PROVENANCE_BINDING_USED.json')
        used = load(used_path)
        provenance_path = repo_file(O / 'PROVENANCE_BINDING.json')
        assert sha(provenance_path) == used['binding_sha256']
        assert all(sha(repo_file(path)) == expected for path, expected in used['source_maps'].items())
        protected.update({str(path): sha(path) for path in [
            summary_path, receipts_path, final_path, log_path, binding_path, replay_guards_path,
            source_map_path, evidence_path, records_path, used_path, provenance_path,
        ]})
        state = {
            'sources': [[name, item['sha256']] for name, item in sorted(source_map['sources'].items())],
            'configuration': driver.static,
            'build_fingerprints': {name: evidence[name]['fingerprint'] for name in targets},
            'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in targets},
            'audit_harness_sha256': sha(repo_file(audit / 'AnalyticAudit.lean')),
            'accepted_checks': [{'label': row['label'], 'exit': row['exit'], 'guards_unchanged': row['guards_unchanged']}
                                for row in receipts],
        }
        fingerprint = digest(json.dumps(state, sort_keys=True, separators=(',', ':')).encode())
        assert check_installation(driver) == (install_binding, plan)
        assert check_origins(plan) == (origins, original_manifest, selected)
        assert all(sha(path) == expected for path, expected in protected.items())
        assert driver.manifest_matches(artifacts, cached=False)
        assert (W / 'continuation-active.json').read_bytes() == active_bytes
        assert (audit / 'active-targeted-replay.json').read_bytes() == replay_state_bytes
        assert git('rev-parse', 'HEAD') == base and not git('diff', '--cached', '--name-only')
        no_compiler()
        source_map_path.write_text(json.dumps(source_map, indent=2, sort_keys=True) + '\n')
        put(O / (scope + '-PROOF_STATE.json'), state)
        summary.update(status='SCOPED_VERIFICATION_PASS', utc=datetime.now(timezone.utc).isoformat(),
                       guarded_builds=len(targets), targeted_same_kernel_replays=len(targets),
                       proof_fingerprint=fingerprint, whole_graph1_complete=False,
                       publication='PREPARED_NOT_YET_PUSHED')
        put(O / (scope + '-VERIFICATION_SUMMARY.json'), summary)
        print(json.dumps(summary), flush=True)


if __name__ == '__main__':
    main()
