"""Record a completed graph1 foundation audit only with exact current bindings."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import importlib.util
import json
import subprocess
import sys

from foundation_inputs import DRIVER_SHA, RUNNER_SHA, TARGETS, digest, load_binding, source_hash


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
U = R / 'research/continuations/20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
assert O == R / 'research/continuations/20261022-graph1-foundation'
assert len(sys.argv) == 2 and sys.argv[1] == 'foundation'
scope = sys.argv[1]
A = U / 'pro-graph1-foundation-audit'


def read(path):
    return json.loads(Path(path).read_text())


def put(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def absent(path):
    assert not path.exists() and not path.is_symlink(), str(path)


input_binding = load_binding(O)
assert source_hash(W / 'continuation_driver_capacity.py') == DRIVER_SHA
assert source_hash(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
with (W / 'continuation-driver.lock').open('r+') as owner, \
        (W / 'continuation-intake.lock').open('r+') as intake:
    for lock in (owner, intake):
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = read(W / 'continuation-active.json')
    assert not active.get('active') and not active.get('protected_closure')
    assert not read(A / 'active-targeted-replay.json')['active']
    assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R, text=True, timeout=30).strip() == input_binding['base_commit']
    summary = read(O / 'foundation-PREPARATION.json')
    counts = input_binding['source_evidence']['declaration_counts']
    assert summary['targets'] == read(O / 'foundation-TARGETS.json') == TARGETS
    assert len(TARGETS) == len(set(TARGETS))
    assert summary['definitions'] == counts['definitions'] and summary['theorems'] == counts['theorems']
    assert summary['declarations'] == counts['total'] and summary['public_headers_exact'] is True
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['audit'] == str(A.relative_to(R))
    assert summary['input_binding_sha256'] == source_hash(O / 'GRAPH1_BINDING.json')
    absent(O / 'foundation-PROOF_STATE.json')
    absent(O / 'foundation-VERIFICATION_SUMMARY.json')
    receipts = read(A / 'TARGETED_REPLAY_RECEIPTS.json')
    final = read(A / 'BOUND_AUDIT_FINAL.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert final['main_theorem_claim'] is False
    assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in TARGETS]
    assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
               and not row['binding_drift_paths'] for row in receipts)
    assert (A / 'analytic-type-axioms.log').read_text().count('GRAPH1_FOUNDATION_AXIOMS_PASS ') == counts['total']
    binding = read(A / 'PREPARATION_BINDINGS.json')
    assert binding['schema'] == 1 and binding['audit_folder'] == str(A.resolve())
    assert binding['targets'] == binding['replays'] == TARGETS
    assert final['binding_sha256'] == source_hash(A / 'PREPARATION_BINDINGS.json')
    assert final['source_map_sha256'] == source_hash(A / 'SOURCE_MAP.json')
    for relative, expected in binding['files'].items():
        path = Path(relative)
        path = path if path.is_absolute() else R / path
        assert path.resolve().is_relative_to(R) and source_hash(path) == expected, str(path)
    spec = importlib.util.spec_from_file_location('graph1_finish_driver', W / 'continuation_driver_capacity.py')
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    driver = module.Driver(R, W)
    source_map_path = O / 'foundation-SOURCE_MAP.json'
    assert source_map_path.is_file() and not source_map_path.is_symlink()
    source_map = read(source_map_path)
    evidence = read(O / 'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json')
    assert set(source_map['sources']) == set(evidence)
    assert binding['project_sources'] == {name: item['sha256'] for name, item in source_map['sources'].items()}
    plan = read(O / 'PLAN.json')
    installation = read(O / 'INSTALL_RECEIPT.json')
    assert source_hash(O / 'PLAN.json') == installation['plan_sha256']
    assert source_hash(O / 'GRAPH1_BINDING.json') == plan['input_binding_sha256'] == installation['input_binding_sha256']
    assert source_hash(O / 'PREPARED_PAYLOAD_SHA256.json') == installation['prepared_payload_sha256']
    for relative, expected in read(O / 'PREPARED_PAYLOAD_SHA256.json').items():
        path = O / relative
        assert path.resolve().is_relative_to(O) and source_hash(path) == expected, relative
    accepted_artifacts = {}
    for name, item in source_map['sources'].items():
        assert item['path'] == 'D1Bound5/' + name + '.lean' and source_hash(R / item['path']) == item['sha256']
        assert module.fingerprint(driver.closure(name)) == evidence[name]['fingerprint']
        assert driver.artifacts(name) == evidence[name]['artifacts']
        for path, expected in evidence[name]['artifacts'].items():
            assert path not in accepted_artifacts or accepted_artifacts[path] == expected
            accepted_artifacts[path] = expected
        if name in TARGETS:
            assert item['sha256'] == plan['source_manifest'][name]
            item['assurance'] = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
    assert driver.static == read(O / 'CONFIGURATION.json') == input_binding['configuration']
    assert driver.manifest_matches(input_binding['configuration'], cached=False)
    guards = read(A / 'TARGETED_REPLAY_GUARDS.json')
    assert guards['immutable_inputs'] == input_binding['configuration']
    assert guards['project_sources'] == binding['project_sources']
    assert guards['compiled_artifacts'] == accepted_artifacts
    expected_preparation_files = dict(binding['files'])
    expected_preparation_files[str((A / 'PREPARATION_BINDINGS.json').resolve())] = source_hash(A / 'PREPARATION_BINDINGS.json')
    assert guards['preparation_files'] == expected_preparation_files
    assert all(accepted_artifacts.get(path) == expected for path, expected in binding['target_artifacts'].items())
    assert source_hash(R / 'D1Bound5.lean') == input_binding['canonical_root_sha256'] == plan['canonical_root_sha256']
    assert source_hash(driver.queue_path) == installation['queue_after_sha256']
    records = read(A / 'SCOPED_ORIGINAL_DECLARATIONS.json')
    assert [record['module'] for record in records] == TARGETS
    for record in records:
        assert source_hash(record['origin_map_path']) == record['origin_map_sha256']
        assert source_hash(record['original_source_path']) == record['original_sha256']
        assert record['normalizations'] == []
    used = read(A / 'PROVENANCE_BINDING_USED.json')
    assert source_hash(O / 'PROVENANCE_BINDING.json') == used['binding_sha256']
    assert all(source_hash(R / path) == expected for path, expected in used['source_maps'].items())
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
                   proof_fingerprint=fingerprint, whole_graph1_complete=False,
                   publication='PREPARED_NOT_YET_PUSHED')
    put(O / 'foundation-VERIFICATION_SUMMARY.json', summary)
    print(json.dumps(summary), flush=True)
