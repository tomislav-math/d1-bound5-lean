"""Record a completed graph46 foundation audit only with exact current bindings."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import importlib.util
import json
import sys

from foundation_inputs import DRIVER_SHA, RUNNER_SHA, TARGETS, declarations, digest, load_binding, source_hash
from prepare_checks import git, no_compiler, repo_file, verify_prepared_inputs


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
U = R / 'research/continuations/20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
scope = 'foundation'
A = U / 'pro-graph46-foundation-audit'


def read(path):
    return json.loads(Path(path).read_text())


def put(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def absent(path):
    assert not path.exists() and not path.is_symlink(), str(path)


def main():
    assert O == R / 'research/continuations/20261022-graph46-foundation'
    assert len(sys.argv) == 2 and sys.argv[1] == scope
    input_binding = load_binding(O)
    assert source_hash(W / 'continuation_driver_capacity.py') == DRIVER_SHA
    assert source_hash(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        active_bytes = (W / 'continuation-active.json').read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        assert not read(A / 'active-targeted-replay.json')['active']
        no_compiler()
        assert git('rev-parse', 'HEAD') == input_binding['base_commit'] and git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        index_path = Path(git('rev-parse', '--git-path', 'index'))
        index_path = index_path if index_path.is_absolute() else R / index_path
        index_sha = source_hash(index_path)
        summary = read(O / 'foundation-PREPARATION.json')
        counts = input_binding['source_evidence']['declaration_counts']
        assert summary['targets'] == read(O / 'foundation-TARGETS.json') == TARGETS
        assert len(TARGETS) == len(set(TARGETS))
        assert summary['definitions'] == counts['definitions'] and summary['theorems'] == counts['theorems']
        assert summary['declarations'] == counts['total'] and summary['public_headers_exact'] is True
        assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
        assert summary['audit'] == str(A.relative_to(R))
        assert summary['base_commit'] == input_binding['base_commit']
        assert summary['input_binding_sha256'] == source_hash(O / 'GRAPH46_BINDING.json')
        absent(O / 'foundation-PROOF_STATE.json')
        absent(O / 'foundation-VERIFICATION_SUMMARY.json')
        receipts = read(A / 'TARGETED_REPLAY_RECEIPTS.json')
        final = read(A / 'BOUND_AUDIT_FINAL.json')
        assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
        assert final['main_theorem_claim'] is False
        assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in TARGETS]
        assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
                   and not row['binding_drift_paths'] for row in receipts)
        assert (A / 'analytic-type-axioms.log').read_text().count('GRAPH46_FOUNDATION_AXIOMS_PASS ') == counts['total']
        binding = read(A / 'PREPARATION_BINDINGS.json')
        assert binding['schema'] == 1 and binding['audit_folder'] == str(A.resolve())
        assert binding['targets'] == binding['replays'] == TARGETS
        assert final['binding_sha256'] == source_hash(A / 'PREPARATION_BINDINGS.json')
        assert final['source_map_sha256'] == source_hash(A / 'SOURCE_MAP.json')
        for relative, expected in binding['files'].items():
            path = Path(relative)
            path = path if path.is_absolute() else R / path
            assert path.resolve().is_relative_to(R) and source_hash(path) == expected, str(path)
        spec = importlib.util.spec_from_file_location('graph46_finish_driver', W / 'continuation_driver_capacity.py')
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)
        driver = module.Driver(R, W)
        checked_binding, plan, installation = verify_prepared_inputs(driver)
        assert checked_binding == input_binding
        runtime = {str(path): source_hash(repo_file(path)) for path in (
            driver.queue_path, driver.active_path, driver.state_path, driver.baseline_path,
            O / 'INSTALL_RECEIPT.json', O / 'foundation-PREPARATION.json',
            O / 'foundation-SOURCE_MAP.json', O / 'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json',
            A / 'PREPARATION_BINDINGS.json', A / 'BOUND_AUDIT_FINAL.json',
            A / 'TARGETED_REPLAY_RECEIPTS.json', A / 'TARGETED_REPLAY_GUARDS.json',
            A / 'PROVENANCE_BINDING_USED.json', A / 'active-targeted-replay.json',
        )}
        source_map_path = O / 'foundation-SOURCE_MAP.json'
        assert source_map_path.is_file() and not source_map_path.is_symlink()
        source_map = read(source_map_path)
        assert source_map['base_commit'] == input_binding['base_commit']
        evidence = read(O / 'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json')
        assert set(source_map['sources']) == set(evidence)
        assert len(source_map['sources']) == summary['source_closure_modules']
        assert set(TARGETS) <= set(source_map['sources'])
        assert binding['project_sources'] == {name: item['sha256'] for name, item in source_map['sources'].items()}
        accepted_artifacts, latest = {}, driver.latest()
        for name, item in source_map['sources'].items():
            assert item['path'] == 'D1Bound5/' + name + '.lean' and source_hash(R / item['path']) == item['sha256']
            closure = driver.closure(name)
            key = module.fingerprint(closure)
            assert key == evidence[name]['fingerprint']
            expected = driver.expected_manifest(name, key, latest)
            assert expected and expected == driver.artifacts(name) == evidence[name]['artifacts']
            for path, artifact_sha in evidence[name]['artifacts'].items():
                assert path not in accepted_artifacts or accepted_artifacts[path] == artifact_sha
                accepted_artifacts[path] = artifact_sha
            if name in TARGETS:
                assert item['sha256'] == plan['source_manifest'][name]
                assert item['assurance'] == 'guarded_build_pass_current_audit_pending'
                row = read(O / (name + '-BUILD_RECEIPT.json'))
                assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
                assert row['timed_out'] is False and row['interrupted'] is False and row['timeout_seconds'] == 240
                assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
                assert row['source_sha256'] == item['sha256'] and row['fingerprint'] == key and row['artifacts'] == expected
                assert read(O / (name + '-SOURCE_CLOSURE.json')) == read(O / (name + '-ORIGINAL_SOURCES.json')) == closure
                item['assurance'] = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
        assert driver.static == read(O / 'CONFIGURATION.json') == input_binding['configuration']
        assert driver.manifest_matches(input_binding['configuration'], cached=False)
        guards = read(A / 'TARGETED_REPLAY_GUARDS.json')
        assert guards['immutable_inputs'] == input_binding['configuration']
        assert guards['project_sources'] == binding['project_sources']
        assert guards['compiled_artifacts'] == accepted_artifacts
        expected_preparation_files = dict(binding['files'])
        self_path = str((A / 'PREPARATION_BINDINGS.json').resolve())
        assert self_path not in expected_preparation_files
        expected_preparation_files[self_path] = source_hash(A / 'PREPARATION_BINDINGS.json')
        assert guards['preparation_files'] == expected_preparation_files
        assert all(accepted_artifacts.get(path) == expected for path, expected in binding['target_artifacts'].items())
        assert source_hash(R / 'D1Bound5.lean') == input_binding['canonical_root_sha256'] == plan['canonical_root_sha256']
        assert source_hash(driver.queue_path) == installation['queue_after_sha256']
        records = read(A / 'SCOPED_ORIGINAL_DECLARATIONS.json')
        assert [record['module'] for record in records] == TARGETS
        origins = read(O / 'DECLARATION_ORIGINS.json')
        all_declarations = []
        for record in records:
            name = record['module']
            assert repo_file(record['origin_map_path']) == O / 'DECLARATION_ORIGINS.json'
            assert source_hash(record['origin_map_path']) == record['origin_map_sha256']
            original = repo_file(record['original_source_path'])
            origin = origins[name]
            assert original == O / 'installation' / (origin['original_module'] + '.before.lean')
            assert record['original_path'] == str(original) and record['raw_original_module'] == origin['original_module']
            assert source_hash(original) == record['original_sha256']
            assert record['normalizations'] == []
            available = {item['local_name']: item for item in declarations(original.read_bytes().decode())}
            before = [available[local] for local in origin['names']]
            current = repo_file('D1Bound5/' + name + '.lean')
            assert record['current_sha256'] == source_hash(current) == plan['source_manifest'][name]
            assert before == declarations(current.read_bytes().decode())
            assert record['declaration_source_sha256'] == {item['name']: digest(item['source_text'].encode()) for item in before}
            public = [{key: value for key, value in item.items() if key != 'source_text'} for item in before]
            assert record['declarations'] == public
            all_declarations.extend(public)
        names = [item['name'] for item in all_declarations]
        assert names == read(A / 'DECLARATION_NAMES.json') and len(names) == len(set(names)) == counts['total']
        assert sum(item['kind'] == 'def' for item in all_declarations) == counts['definitions']
        assert sum(item['kind'] == 'theorem' for item in all_declarations) == counts['theorems']
        used = read(A / 'PROVENANCE_BINDING_USED.json')
        assert source_hash(O / 'PROVENANCE_BINDING.json') == used['binding_sha256']
        assert all(source_hash(repo_file(path)) == expected for path, expected in used['source_maps'].items())
        assert verify_prepared_inputs(driver) == (input_binding, plan, installation)
        assert all(source_hash(repo_file(path)) == expected for path, expected in expected_preparation_files.items())
        assert all(source_hash(repo_file(item['path'])) == item['sha256'] for item in source_map['sources'].values())
        assert driver.manifest_matches(accepted_artifacts, cached=False)
        assert driver.manifest_matches(input_binding['configuration'], cached=False)
        assert all(source_hash(repo_file(path)) == expected for path, expected in runtime.items())
        assert (W / 'continuation-active.json').read_bytes() == active_bytes
        assert source_hash(W / 'continuation_driver_capacity.py') == DRIVER_SHA
        assert source_hash(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
        assert git('rev-parse', 'HEAD') == input_binding['base_commit'] and git('branch', '--show-current') == 'main'
        assert source_hash(index_path) == index_sha and not git('diff', '--cached', '--name-only')
        absent(O / 'foundation-PROOF_STATE.json')
        absent(O / 'foundation-VERIFICATION_SUMMARY.json')
        no_compiler()
        state = {
            'sources': [[name, item['sha256']] for name, item in sorted(source_map['sources'].items())],
            'configuration': driver.static,
            'build_fingerprints': {name: evidence[name]['fingerprint'] for name in TARGETS},
            'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in TARGETS},
            'audit_harness_sha256': source_hash(A / 'AnalyticAudit.lean'),
            'accepted_checks': [{'label': row['label'], 'exit': row['exit'], 'guards_unchanged': row['guards_unchanged']}
                                for row in receipts],
        }
        fingerprint = digest(json.dumps(state, sort_keys=True, separators=(',', ':')).encode())
        source_map_path.write_text(json.dumps(source_map, indent=2, sort_keys=True) + '\n')
        put(O / 'foundation-PROOF_STATE.json', state)
        summary.update(status='SCOPED_VERIFICATION_PASS', utc=datetime.now(timezone.utc).isoformat(),
                       guarded_builds=len(TARGETS), targeted_same_kernel_replays=len(TARGETS),
                       proof_fingerprint=fingerprint, whole_graph46_complete=False,
                       publication='PREPARED_NOT_YET_PUSHED')
        put(O / 'foundation-VERIFICATION_SUMMARY.json', summary)
        print(json.dumps(summary), flush=True)


if __name__ == '__main__':
    main()
