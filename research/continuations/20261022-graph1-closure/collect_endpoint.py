"""Collect all seven completed graph1 scopes into two new endpoint records.

No compiler, replay, Git operation, source edit, or queue mutation is launched.
The exact original-source reconstruction uses the already reviewed pure proposal
code; the seven preserved scopes supply type, transitive-axiom, and replay evidence.
"""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import importlib.util
import json
import re
import sys

from closure_inputs import (
    TARGET, RAW, RAW_GROUPS, ORIGINAL_PINS, MERGED_SHA, MERGED_BYTES,
    declarations, digest,
)
from closure_runtime import (
    R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, PREREQUISITES,
    load, sha, fingerprint, verify_install_binding, no_live_project_compiler,
)
from generate_proposal import build_candidates, COVERAGE_TEMPLATE_SHA


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
DRIVER = W / 'continuation_driver_capacity.py'
RUNNER = U / 'bound_scoped_audit_runner_proposal_v1.py'
ENDPOINT = TARGET
ASSURANCE = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
CHUNKS = ['SmallPairGraphClosure1Chunk' + f'{index:02d}' for index in range(12)]
COVERAGE = 'SmallPairGraphClosure1Coverage'
HELPERS = CHUNKS + [COVERAGE]
CLOSURE_CORE = ['SmallPairGraphInputs1', 'SmallPairGraphWitnessData1'] + HELPERS + ['SmallPairGraphClosure1']
ASSEMBLY = ['SmallPairGraphArithmetic1'] + list(RAW_GROUPS) + [RAW,
            'SmallPairLightAssembly1', 'SmallPairGraphTriangle1', ENDPOINT]
SIDE_PILOTS = PREREQUISITES['sides-pilot']['targets']
SCOPES = [(specification['directory'].name, scope, specification['targets'],
           specification['definitions'], specification['theorems'], specification['marker'])
          for scope, specification in PREREQUISITES.items()] + [
    ('20261022-graph1-closure', 'closure-pilot',
     ['SmallPairGraphInputs1', 'SmallPairGraphWitnessData1', CHUNKS[0], COVERAGE], 9, 2, 'GRAPH1_CLOSURE_AXIOMS_PASS '),
    ('20261022-graph1-closure', 'closure-rest', CHUNKS[1:] + ['SmallPairGraphClosure1'], 0, 13, 'GRAPH1_CLOSURE_AXIOMS_PASS '),
    ('20261022-graph1-closure', 'assembly', ASSEMBLY, 4, 13, 'GRAPH1_CLOSURE_AXIOMS_PASS '),
]
EXPECTED_TOTALS = {'definitions': 32, 'theorems': 64, 'declarations': 96,
                   'guarded_builds': 58, 'targeted_same_kernel_replays': 58,
                   'analytic_type_axiom_audits': 7}


def relative(value):
    path = Path(value)
    assert not path.is_absolute() and '..' not in path.parts
    return path


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        path = R / relative(value)
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve())
    return path


def merge(destination, values):
    for key, value in values.items():
        assert re.fullmatch(r'[0-9a-f]{64}', value), key
        assert key not in destination or destination[key] == value, key
        destination[key] = value


def protect(files, path, expected=None):
    path = repo_file(path)
    actual = sha(path)
    assert expected is None or actual == expected, str(path)
    merge(files, {str(path.relative_to(R)): actual})
    return path


def verify_restored_sources(files, targets):
    """Regenerate exactly the pinned graph1 proposal from original byte snapshots."""
    binding = verify_install_binding()
    binding_path = protect(files, O / 'INSTALL_BINDING.json')
    protect(files, O / 'PROVENANCE_BINDING.json', binding['provenance_binding_sha256'])
    for filename, expected in binding['script_pins'].items():
        protect(files, O / filename, expected)
    for specification in binding['prerequisite_scopes'].values():
        for path, expected in specification['files'].items():
            protect(files, path, expected)
    assert (O / 'installation/INSTALL_BINDING_USED.json').read_bytes() == binding_path.read_bytes()
    protect(files, O / 'installation/INSTALL_BINDING_USED.json', sha(binding_path))
    assert load(protect(files, O / 'installation/SCRIPT_PINS.json')) == binding['script_pins']
    proposal = O / 'proposal'
    proposed = load(protect(files, proposal / 'PLAN.json', binding['proposal_plan_sha256']))
    payload = load(protect(files, proposal / 'PAYLOAD_SHA256.json', binding['proposal_payload_sha256']))
    for path, expected in payload.items():
        value = repo_file(proposal / relative(path))
        assert value.resolve().is_relative_to(proposal.resolve())
        protect(files, value, expected)
    plan = load(protect(files, O / 'PLAN.json'))
    assert plan['status'] == 'REVIEWED_GRAPH1_RESTORATION_NOT_BUILT'
    expected_plan = dict(proposed)
    expected_plan.update(status='REVIEWED_GRAPH1_RESTORATION_NOT_BUILT', base_commit=binding['base_commit'],
                         canonical_root_sha256=binding['canonical_root_sha256'], configuration=binding['configuration'],
                         install_binding_sha256=sha(binding_path), proposal_plan_sha256=binding['proposal_plan_sha256'],
                         proposal_payload_sha256=binding['proposal_payload_sha256'],
                         source_provenance=load(proposal / 'INPUT_PROVENANCE.json')['source_sha256'])
    assert plan == expected_plan
    assert plan['build_order'] == CLOSURE_CORE + ASSEMBLY
    assert set(plan['source_manifest']) == set(plan['build_order']) <= set(targets)
    assert load(protect(files, O / 'DECLARATION_ORIGINS.json')) == plan['origins']
    before = protect(files, O / 'installation' / (ENDPOINT + '.before.lean'), MERGED_SHA)
    merged = before.read_bytes()
    assert len(merged) == MERGED_BYTES == plan['original_merged_bytes']
    assert plan['original_merged_sha256'] == MERGED_SHA
    assert (proposal / (ENDPOINT + '.merged.before.lean')).read_bytes() == merged
    archived = {name: protect(files, O / 'originals' / (name + '.lean'), value[0]).read_bytes()
                for name, value in ORIGINAL_PINS.items()}
    coverage_template = protect(files, proposal / 'COVERAGE_TEMPLATE.before.lean', COVERAGE_TEMPLATE_SHA).read_bytes()
    inspection, originals, candidates, regenerated = build_candidates(merged, archived, coverage_template)
    assert regenerated == proposed
    assert inspection == load(protect(files, O / 'SOURCE_INSPECTION.json')) == load(proposal / 'SOURCE_INSPECTION.json')
    assert inspection['closure_rows'] == 720 and inspection['filtered_vertices'] == 718
    assert inspection['proposed_terminal_drop'] == 720
    assert inspection['declaration_counts'] == {'total': 28, 'definitions': 13, 'theorems': 15}
    expected_rows = {'smallPairClosure_1': 720, 'smallPairLarge_1': 718, 'rootPairs': 720,
                     'destinations': 720, 'leftCached': 360, 'leftRows': 360,
                     'rightCached': 358, 'rightRows': 358}
    assert {name: item['rows'] for name, item in inspection['literal_evidence'].items()} == expected_rows
    assert inspection['destination_index_min'] == 0 and inspection['destination_index_max'] == 719
    assert plan['prefix_parts'] == [{'module': name, 'offset': index * 64, 'count': 64 if index < 11 else 16}
                                    for index, name in enumerate(CHUNKS)]
    assert set(originals) == set(ORIGINAL_PINS) | set(HELPERS)
    for name, data in originals.items():
        assert protect(files, O / 'originals' / (name + '.lean'), digest(data)).read_bytes() == data
    current_declarations = []
    for name, data in candidates.items():
        candidate = protect(files, O / 'candidates' / (name + '.lean'), digest(data))
        assert candidate.read_bytes() == data
        current = protect(files, 'D1Bound5/' + name + '.lean', digest(data))
        assert current.read_bytes() == data and plan['source_manifest'][name] == digest(data)
        current_declarations.extend(declarations(data.decode()))
    assert len(current_declarations) == len({item['name'] for item in current_declarations}) == 41
    assert sum(item['kind'] == 'def' for item in current_declarations) == 13
    assert sum(item['kind'] == 'theorem' for item in current_declarations) == 28
    public = plan['original_public_headers']
    assert len(public) == plan['original_public_declarations'] == 28
    assert sum(' '.join(header.split()) == 'theorem smallPairLarge_1_count : smallPairLarge_1.length = 718'
               for header in public) == 1
    assert sum(' '.join(header.split()) ==
               'theorem smallPairNoTriangle_1_checked : pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_1 = true'
               for header in public) == 1
    assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
    protect(files, R / 'D1Bound5.lean', binding['canonical_root_sha256'])
    return public, binding['canonical_root_sha256']


def write_new(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    assert Path(__file__).resolve().parent == O == C / '20261022-graph1-closure'
    assert len(sys.argv) == 1
    outputs = [O / 'ENDPOINT_PROOF_STATE.json', O / 'ENDPOINT_VERIFICATION.json']
    assert all(not path.exists() and not path.is_symlink() for path in outputs)
    assert sha(DRIVER) == DRIVER_SHA and sha(RUNNER) == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph1_endpoint_collection_driver', DRIVER)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        no_live_project_compiler()
        driver = module.Driver(R, W)
        runtime = {str(path): sha(path) for path in [driver.queue_path, driver.active_path,
                                                   driver.state_path, driver.baseline_path]}
        active = load(driver.active_path)
        assert not active.get('active') and not active.get('protected_closure')
        queue, _, closures, accepted, _, _ = driver.snapshot()
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        latest = driver.latest()
        targets, declaration_names = [], []
        source_guards, artifact_guards, file_guards, scope_evidence = {}, {}, {}, {}
        protect(file_guards, DRIVER, DRIVER_SHA)
        protect(file_guards, RUNNER, RUNNER_SHA)
        protect(file_guards, __file__)
        totals = {key: 0 for key in EXPECTED_TOTALS}
        for unit, scope, expected_targets, definitions, theorems, marker in SCOPES:
            folder = C / unit
            summary_path = protect(file_guards, folder / (scope + '-VERIFICATION_SUMMARY.json'))
            summary = load(summary_path)
            assert summary['status'] == 'SCOPED_VERIFICATION_PASS' and summary['public_headers_exact'] is True
            assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
            assert summary['whole_graph1_complete'] is False
            unit_targets = summary['targets']
            assert unit_targets == expected_targets == load(protect(file_guards, folder / (scope + '-TARGETS.json')))
            assert len(unit_targets) == len(set(unit_targets)) and not set(targets) & set(unit_targets)
            targets.extend(unit_targets)
            unit_plan = load(protect(file_guards, folder / 'PLAN.json'))
            assert set(unit_targets) <= set(unit_plan['source_manifest'])
            audit = R / relative(summary['audit'])
            assert audit == U / ('pro-graph1-' + scope + '-audit')
            assert not load(protect(file_guards, audit / 'active-targeted-replay.json'))['active']
            final = load(protect(file_guards, audit / 'BOUND_AUDIT_FINAL.json'))
            receipts = load(protect(file_guards, audit / 'TARGETED_REPLAY_RECEIPTS.json'))
            assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
            assert final['main_theorem_claim'] is False
            assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in unit_targets]
            assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
                       and not row['binding_drift_paths'] for row in receipts)
            for row in receipts:
                log = relative(row['log'])
                assert len(log.parts) == 1
                protect(file_guards, audit / log)
            assert (audit / 'analytic-type-axioms.log').read_text().count(marker) == definitions + theorems
            binding_path = protect(file_guards, audit / 'PREPARATION_BINDINGS.json', final['binding_sha256'])
            binding = load(binding_path)
            assert binding['schema'] == 1 and binding['audit_folder'] == str(audit.resolve())
            assert binding['targets'] == binding['replays'] == unit_targets
            assert load(audit / 'TARGETS.json') == load(audit / 'REPLAY_TARGETS.json') == unit_targets
            assert final['source_map_sha256'] == sha(audit / 'SOURCE_MAP.json')
            for path, value in binding['files'].items():
                protect(file_guards, path, value)
            records = load(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json')
            assert [record['module'] for record in records] == unit_targets
            actual_declarations = []
            for name, record in zip(unit_targets, records):
                current = repo_file('D1Bound5/' + name + '.lean')
                protect(file_guards, folder / 'candidates' / (name + '.lean'), unit_plan['source_manifest'][name])
                assert sha(current) == unit_plan['source_manifest'][name] == record['current_sha256']
                protect(file_guards, record['original_path'], record['original_sha256'])
                if 'origin_map_path' in record:
                    protect(file_guards, record['origin_map_path'], record['origin_map_sha256'])
                current_declarations = declarations(current.read_text())
                assert len(current_declarations) == len(record['declarations'])
                for old, new in zip(record['declarations'], current_declarations):
                    assert all(key in new and new[key] == value for key, value in old.items()), name
                actual_declarations.extend(record['declarations'])
            names = [item['name'] for item in actual_declarations]
            assert names == load(audit / 'DECLARATION_NAMES.json') and len(names) == len(set(names))
            assert not set(declaration_names) & set(names)
            declaration_names.extend(names)
            assert sum(item['kind'] == 'def' for item in actual_declarations) == definitions
            assert sum(item['kind'] == 'theorem' for item in actual_declarations) == theorems
            assert summary['definitions'] == definitions and summary['theorems'] == theorems
            assert summary['declarations'] == len(names) == definitions + theorems

            source_map_path = protect(file_guards, folder / (scope + '-SOURCE_MAP.json'))
            evidence_path = protect(file_guards, folder / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
            source_map, evidence = load(source_map_path), load(evidence_path)
            sources = source_map['sources']
            assert source_map['base_commit'] == summary['base_commit']
            assert re.fullmatch(r'[0-9a-f]{40}', summary['base_commit'])
            assert set(sources) == set(evidence) and len(sources) == summary['source_closure_modules']
            assert binding['project_sources'] == {name: item['sha256'] for name, item in sources.items()}
            scope_artifacts = {}
            for name, item in sources.items():
                assert item['path'] == 'D1Bound5/' + name + '.lean'
                assert sha(repo_file(item['path'])) == item['sha256'] and name in accepted, name
                closure = driver.closure(name)
                key = module.fingerprint(closure)
                expected = driver.expected_manifest(name, key, latest)
                assert expected and key == evidence[name]['fingerprint'], name
                assert expected == evidence[name]['artifacts'] == driver.artifacts(name), name
                merge(source_guards, {name: item['sha256']})
                merge(scope_artifacts, expected)
                if 'payload_path' in item:
                    protect(file_guards, R / relative(item['payload_path']), item['sha256'])
                else:
                    assert re.fullmatch(r'[0-9a-f]{40}', item['base_commit'])
                    relative(item['base_path'])
                if name in unit_targets:
                    assert item['assurance'] == ASSURANCE
            merge(artifact_guards, scope_artifacts)
            assert all(scope_artifacts.get(path) == value for path, value in binding['target_artifacts'].items())
            configuration = load(protect(file_guards, folder / 'CONFIGURATION.json'))
            assert configuration == driver.static and driver.manifest_matches(configuration, cached=False)
            guards = load(protect(file_guards, audit / 'TARGETED_REPLAY_GUARDS.json'))
            assert guards['project_sources'] == binding['project_sources']
            assert guards['compiled_artifacts'] == scope_artifacts and guards['immutable_inputs'] == configuration
            expected_preparation_files = dict(binding['files'])
            assert str(binding_path) not in expected_preparation_files
            expected_preparation_files[str(binding_path)] = sha(binding_path)
            assert guards['preparation_files'] == expected_preparation_files
            for path, value in guards['preparation_files'].items():
                protect(file_guards, path, value)
            state_path = protect(file_guards, folder / (scope + '-PROOF_STATE.json'))
            state = load(state_path)
            expected_state = {
                'sources': [[name, item['sha256']] for name, item in sorted(sources.items())],
                'configuration': configuration,
                'build_fingerprints': {name: evidence[name]['fingerprint'] for name in unit_targets},
                'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in unit_targets},
                'audit_harness_sha256': sha(audit / 'AnalyticAudit.lean'),
                'accepted_checks': [{key: row[key] for key in ('label', 'exit', 'guards_unchanged')} for row in receipts],
            }
            assert state == expected_state and fingerprint(state) == summary['proof_fingerprint']
            assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == len(unit_targets)
            if 'pilot_reuse_evidence' in summary:
                reuse = load(protect(file_guards, R / relative(summary['pilot_reuse_evidence']), summary['pilot_reuse_evidence_sha256']))
                pilot_path = str((C / '20261022-graph1-sides/sides-pilot-VERIFICATION_SUMMARY.json').relative_to(R))
                assert reuse['summary_path'] == pilot_path and reuse['targets'] == SIDE_PILOTS
                assert reuse['proof_fingerprint'] == scope_evidence[pilot_path]['proof_fingerprint']
                for path, value in reuse['protected_files'].items():
                    protect(file_guards, path, value)
            provenance_used = audit / 'PROVENANCE_BINDING_USED.json'
            if unit == '20261022-graph1-closure':
                used = load(protect(file_guards, provenance_used))
                protect(file_guards, O / 'PROVENANCE_BINDING.json', used['binding_sha256'])
                for path, value in used['source_maps'].items():
                    protect(file_guards, R / relative(path), value)
            protect(file_guards, folder / (scope + '-PREPARATION.json'))
            for key in ('definitions', 'theorems', 'declarations', 'guarded_builds', 'targeted_same_kernel_replays'):
                totals[key] += summary[key]
            totals['analytic_type_axiom_audits'] += 1
            scope_evidence[str(summary_path.relative_to(R))] = {
                'sha256': sha(summary_path), 'proof_fingerprint': summary['proof_fingerprint'],
                'proof_state_sha256': sha(state_path), 'bound_audit_sha256': sha(audit / 'BOUND_AUDIT_FINAL.json'),
                'binding_sha256': sha(binding_path), 'base_commit': summary['base_commit'],
                'targets': unit_targets, 'definitions': definitions, 'theorems': theorems,
            }

        assert len(targets) == len(set(targets)) == 58 and set(targets) <= accepted
        assert len(declaration_names) == len(set(declaration_names)) == 96
        assert totals == EXPECTED_TOTALS and len(scope_evidence) == 7
        endpoint_closure = driver.closure(ENDPOINT)
        assert endpoint_closure == closures[ENDPOINT]
        assert set(endpoint_closure) <= accepted and ENDPOINT in targets
        assert all(source_guards.get(name) == value for name, value in endpoint_closure.items())
        endpoint_key = module.fingerprint(endpoint_closure)
        endpoint_artifacts = driver.expected_manifest(ENDPOINT, endpoint_key, latest)
        assert endpoint_artifacts and driver.artifacts(ENDPOINT) == endpoint_artifacts
        public, root_sha = verify_restored_sources(file_guards, targets)
        assert all(sha(repo_file(path)) == value for path, value in file_guards.items())
        assert all(sha(R / 'D1Bound5' / (name + '.lean')) == value for name, value in source_guards.items())
        assert driver.manifest_matches(artifact_guards, cached=False) and driver.manifest_matches(driver.static, cached=False)
        assert all(sha(path) == value for path, value in runtime.items())
        assert all(not path.exists() and not path.is_symlink() for path in outputs)
        no_live_project_compiler()
        proof_state = {
            'schema': 1, 'module': ENDPOINT, 'targets': targets, 'declaration_names': declaration_names,
            'module_and_check_totals': totals, 'endpoint_source_closure': endpoint_closure,
            'endpoint_build_fingerprint': endpoint_key, 'endpoint_artifacts': endpoint_artifacts,
            'verified_sources': source_guards, 'verified_artifacts': artifact_guards,
            'verified_files': file_guards, 'configuration': driver.static, 'scope_evidence': scope_evidence,
            'original_public_headers_sha256': fingerprint(public), 'canonical_root_sha256': root_sha,
            'closure_rows': 720, 'filtered_vertices': 718, 'model': {'tau': 0, 'nu': 1},
            'whole_graph1_complete': True, 'root_integration': False, 'main_theorem_complete': False,
        }
        result = {
            'schema': 1, 'status': 'GRAPH1_WORKING_ENDPOINT_SCOPED_VERIFIED',
            'utc': datetime.now(timezone.utc).isoformat(), 'module': ENDPOINT,
            'closure_rows': 720, 'filtered_vertices': 718, 'original_public_declarations_preserved': 28,
            'scope_count': 7, 'unique_target_count': 58, 'module_and_check_totals': totals,
            'source_closure_modules': len(endpoint_closure), 'scope_evidence': scope_evidence,
            'proof_fingerprint': fingerprint(proof_state), 'whole_graph1_complete': True,
            'root_integration': False, 'main_theorem_complete': False,
            'publication': 'PREPARED_NOT_YET_PUSHED', 'compiler_run_by_collector': False,
            'git_run_by_collector': False, 'proof_or_queue_mutated_by_collector': False,
        }
        write_new(outputs[0], proof_state)
        result['proof_state_sha256'] = sha(outputs[0])
        write_new(outputs[1], result)
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
