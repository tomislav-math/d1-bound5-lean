"""Record only completed exact graph11 closure scopes with current source/artifact equality."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl, hashlib, importlib.util, json, sys

R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
U = R / 'research/continuations/20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
COUNTS = {'closure-pilot': (4, 9, 2), 'closure-rest': (12, 0, 13), 'assembly': (9, 4, 13)}
assert O == R / 'research/continuations/20261022-graph11-closure'
assert len(sys.argv) == 2 and sys.argv[1] in COUNTS
scope = sys.argv[1]
A = U / ('pro-graph11-' + scope + '-audit')


def read(path):
    return json.loads(Path(path).read_text())


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write(path, value):
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


assert sha(W / 'continuation_driver_capacity.py') == 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
with (W / 'continuation-driver.lock').open('r+') as owner, (W / 'continuation-intake.lock').open('r+') as intake:
    for lock in (owner, intake):
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = read(W / 'continuation-active.json')
    assert not active.get('active') and not active.get('protected_closure')
    assert not read(A / 'active-targeted-replay.json')['active']
    summary = read(O / (scope + '-PREPARATION.json'))
    targets = summary['targets']
    target_count, definitions, theorems = COUNTS[scope]
    assert targets == read(O / (scope + '-TARGETS.json')) and len(targets) == len(set(targets)) == target_count
    assert summary['definitions'] == definitions and summary['theorems'] == theorems
    assert summary['declarations'] == definitions + theorems and summary['public_headers_exact'] is True
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['audit'] == str(A.relative_to(R))
    assert not (O / (scope + '-PROOF_STATE.json')).exists() and not (O / (scope + '-VERIFICATION_SUMMARY.json')).exists()
    receipts = read(A / 'TARGETED_REPLAY_RECEIPTS.json')
    final = read(A / 'BOUND_AUDIT_FINAL.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert final['main_theorem_claim'] is False
    assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in targets]
    assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged'] and not row['binding_drift_paths'] for row in receipts)
    assert (A / 'analytic-type-axioms.log').read_text().count('GRAPH11_CLOSURE_AXIOMS_PASS ') == summary['declarations']
    binding = read(A / 'PREPARATION_BINDINGS.json')
    assert binding['schema'] == 1 and binding['audit_folder'] == str(A.resolve())
    assert binding['targets'] == binding['replays'] == targets
    assert final['binding_sha256'] == sha(A / 'PREPARATION_BINDINGS.json')
    assert final['source_map_sha256'] == sha(A / 'SOURCE_MAP.json')
    for path, digest in binding['files'].items():
        file = Path(path) if Path(path).is_absolute() else R / path
        assert file.is_file() and not file.is_symlink() and file.resolve().is_relative_to(R.resolve())
        assert sha(file) == digest, str(file)
    spec = importlib.util.spec_from_file_location('graph11_closure_finish_driver', W / 'continuation_driver_capacity.py')
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    driver = mod.Driver(R, W)
    source_map = read(O / (scope + '-SOURCE_MAP.json'))
    evidence = read(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
    assert set(source_map['sources']) == set(evidence)
    assert binding['project_sources'] == {name: item['sha256'] for name, item in source_map['sources'].items()}
    for name, item in source_map['sources'].items():
        assert item['path'] == 'D1Bound5/' + name + '.lean' and sha(R / item['path']) == item['sha256']
        assert mod.fingerprint(driver.closure(name)) == evidence[name]['fingerprint']
        assert driver.artifacts(name) == evidence[name]['artifacts']
        if name in targets:
            item['assurance'] = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
    assert driver.static == read(O / 'CONFIGURATION.json') and driver.manifest_matches(driver.static)
    for record in read(A / 'SCOPED_ORIGINAL_DECLARATIONS.json'):
        assert sha(record['origin_map_path']) == record['origin_map_sha256']
    used = read(A / 'PROVENANCE_BINDING_USED.json')
    assert sha(O / 'PROVENANCE_BINDING.json') == used['binding_sha256']
    assert all(sha(R / path) == digest for path, digest in used['source_maps'].items())
    state = {'sources': [[name, item['sha256']] for name, item in sorted(source_map['sources'].items())],
             'configuration': driver.static, 'build_fingerprints': {name: evidence[name]['fingerprint'] for name in targets},
             'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in targets},
             'audit_harness_sha256': sha(A / 'AnalyticAudit.lean'),
             'accepted_checks': [{'label': row['label'], 'exit': row['exit'], 'guards_unchanged': row['guards_unchanged']} for row in receipts]}
    fingerprint = hashlib.sha256(json.dumps(state, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
    write(O / (scope + '-SOURCE_MAP.json'), source_map)
    write(O / (scope + '-PROOF_STATE.json'), state)
    summary.update(status='SCOPED_VERIFICATION_PASS', utc=datetime.now(timezone.utc).isoformat(),
                   guarded_builds=len(targets), targeted_same_kernel_replays=len(targets), proof_fingerprint=fingerprint,
                   whole_graph11_complete=False, publication='PREPARED_NOT_YET_PUSHED')
    write(O / (scope + '-VERIFICATION_SUMMARY.json'), summary)
    print(json.dumps(summary), flush=True)
