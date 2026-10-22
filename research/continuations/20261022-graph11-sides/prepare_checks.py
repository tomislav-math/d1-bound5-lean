"""Prepare exact graph11 side audits; never compile or grant audit acceptance."""
from pathlib import Path
import fcntl
import hashlib
import importlib.util
import json
import re
import subprocess
import sys

R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
DRIVER = W / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER = U / 'bound_scoped_audit_runner_proposal_v1.py'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
ASSURANCE = 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
MARKER = 'GRAPH11_SIDES_AXIOMS_PASS '
SCOPES = {'sides-pilot': [
    'SmallPairLightAdaptiveLeft11_000Part00',
    'SmallPairLightAdaptiveRight11_000Part00',
]}
for side in ('left', 'right'):
    prefix = 'SmallPairLightAdaptive' + side.title() + '11_'
    SCOPES[side + '-rest'] = ([prefix + '000Part' + f'{i:02d}' for i in range(1, 6)]
        + [prefix + '000'] + [prefix + '001Part' + f'{i:02d}' for i in range(4)]
        + [prefix + '001', 'SmallPairLight' + side.title() + '11'])
DECLARATION_COUNTS = {'sides-pilot': 2, 'left-rest': 15, 'right-rest': 15}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def put(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def fingerprint(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def repo_file(value):
    path = Path(value)
    path = path if path.is_absolute() else R / path
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve())
    return path


def declarations(text):
    result = []
    for match in re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=', text, re.M | re.S):
        stack, opens = [], []
        for line in text[:match.start()].splitlines():
            if line.startswith('namespace '):
                stack.append(line[10:].strip())
            elif line.startswith('end '):
                assert stack
                stack.pop()
            elif line.startswith('open '):
                opens.append(line)
        namespace = '.'.join(stack)
        assert namespace.startswith('D1Bound5')
        result.append({'kind': match[1], 'local_name': match[2],
                       'name': namespace + '.' + match[2], 'namespace': namespace,
                       'opens': list(dict.fromkeys(opens)), 'header': match[3].strip(),
                       'raw_header': text[match.start():match.end() - 2]})
    return result


def load_driver():
    assert sha(DRIVER) == DRIVER_SHA and sha(RUNNER) == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph11_sides_checks_driver', DRIVER)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module, module.Driver(R, W)


def idle(driver):
    active = load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    queue = load(driver.queue_path)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True


def verify_bound_checks(scope, sources, evidence, driver, module, latest):
    """Read completed bound receipts and recheck their current exact inputs."""
    targets = SCOPES[scope]
    audit = U / ('pro-graph11-' + scope + '-audit')
    assert not load(audit / 'active-targeted-replay.json')['active']
    final = load(audit / 'BOUND_AUDIT_FINAL.json')
    receipts = load(audit / 'TARGETED_REPLAY_RECEIPTS.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert final['main_theorem_claim'] is False
    assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [
        name + '-targeted-replay' for name in targets]
    assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
               and not row['binding_drift_paths'] for row in receipts)
    assert (audit / 'analytic-type-axioms.log').read_text().count(MARKER) == DECLARATION_COUNTS[scope]
    binding_path = audit / 'PREPARATION_BINDINGS.json'
    binding = load(binding_path)
    assert binding['schema'] == 1 and binding['audit_folder'] == str(audit.resolve())
    assert binding['targets'] == binding['replays'] == targets
    assert load(audit / 'TARGETS.json') == load(audit / 'REPLAY_TARGETS.json') == targets
    assert final['binding_sha256'] == sha(binding_path)
    assert final['source_map_sha256'] == sha(audit / 'SOURCE_MAP.json')
    protected = {str(repo_file(path)): digest for path, digest in binding['files'].items()}
    assert all(sha(path) == digest for path, digest in protected.items())
    assert set(sources) == set(evidence)
    assert binding['project_sources'] == {name: item['sha256'] for name, item in sources.items()}
    artifacts = {}
    for name, item in sources.items():
        assert item['path'] == 'D1Bound5/' + name + '.lean'
        assert sha(repo_file(item['path'])) == item['sha256'], name
        key = module.fingerprint(driver.closure(name))
        expected = driver.expected_manifest(name, key, latest)
        assert expected and key == evidence[name]['fingerprint'], name
        assert expected == evidence[name]['artifacts'] == driver.artifacts(name), name
        for path, digest in expected.items():
            assert path not in artifacts or artifacts[path] == digest
            artifacts[path] = digest
    assert all(artifacts.get(path) == digest for path, digest in binding['target_artifacts'].items())
    configuration = load(O / 'CONFIGURATION.json')
    assert configuration == driver.static and driver.manifest_matches(configuration)
    guards = load(audit / 'TARGETED_REPLAY_GUARDS.json')
    assert guards['project_sources'] == binding['project_sources']
    assert guards['compiled_artifacts'] == artifacts and guards['immutable_inputs'] == configuration
    assert all(sha(repo_file(path)) == digest for path, digest in guards['preparation_files'].items())
    state = {
        'sources': [[name, item['sha256']] for name, item in sorted(sources.items())],
        'configuration': configuration,
        'build_fingerprints': {name: evidence[name]['fingerprint'] for name in targets},
        'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in targets},
        'audit_harness_sha256': sha(audit / 'AnalyticAudit.lean'),
        'accepted_checks': [{key: row[key] for key in ('label', 'exit', 'guards_unchanged')}
                            for row in receipts],
    }
    for path in [binding_path, audit / 'BOUND_AUDIT_FINAL.json',
                 audit / 'TARGETED_REPLAY_RECEIPTS.json', audit / 'TARGETED_REPLAY_GUARDS.json',
                 audit / 'active-targeted-replay.json', audit / 'analytic-type-axioms.log',
                 O / 'CONFIGURATION.json']:
        protected[str(path)] = sha(path)
    return receipts, state, protected


def verify_pilots(driver, module, latest):
    """Both pilots must have completed exact audits, even for one-side reuse."""
    scope = 'sides-pilot'
    summary_path = O / (scope + '-VERIFICATION_SUMMARY.json')
    summary = load(summary_path)
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert summary['targets'] == SCOPES[scope] == load(O / (scope + '-TARGETS.json'))
    assert summary['public_headers_exact'] is True
    assert summary['definitions'] == 0 and summary['theorems'] == summary['declarations'] == 2
    assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == 2
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['whole_graph11_complete'] is False
    assert summary['audit'] == str((U / ('pro-graph11-' + scope + '-audit')).relative_to(R))
    source_path = O / (scope + '-SOURCE_MAP.json')
    evidence_path = O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json')
    sources, evidence = load(source_path)['sources'], load(evidence_path)
    _, state, protected = verify_bound_checks(scope, sources, evidence, driver, module, latest)
    state_path = O / (scope + '-PROOF_STATE.json')
    assert load(state_path) == state and fingerprint(state) == summary['proof_fingerprint']
    for name in SCOPES[scope]:
        item = sources[name]
        assert item['assurance'] == ASSURANCE
        candidate = O / 'candidates' / (name + '.lean')
        assert item['payload_path'] == str(candidate.relative_to(R))
        assert sha(candidate) == item['sha256']
        protected[str(candidate)] = item['sha256']
    for path in [summary_path, source_path, evidence_path, state_path,
                 O / (scope + '-TARGETS.json'), O / (scope + '-PREPARATION.json')]:
        protected[str(path)] = sha(path)
    return {'summary_path': str(summary_path.relative_to(R)),
            'proof_fingerprint': summary['proof_fingerprint'], 'targets': SCOPES[scope],
            'protected_files': protected, 'source_manifest': dict(state['sources']),
            'artifact_fingerprints': state['artifact_fingerprints'],
            'configuration': state['configuration']}


def main():
    assert O == C / '20261022-graph11-sides'
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPES
    scope = sys.argv[1]
    targets = load(O / (scope + '-TARGETS.json'))
    assert targets == SCOPES[scope]
    audit = U / ('pro-graph11-' + scope + '-audit')
    module, driver = load_driver()
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        idle(driver)
        assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=R)
        base = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R, text=True).strip()
        latest = driver.latest()
        plan = load(O / 'PLAN.json')
        assert plan['scope_targets'] == SCOPES
        assert len(plan['source_manifest']) == 26 and set(plan['source_manifest']) == {
            name for group in SCOPES.values() for name in group}
        assert plan['model'] == [0, 1] and plan['original_parent_counts'] == [138, 221]
        assert plan['heads_per_side'] == 359
        assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
        assert driver.static == load(O / 'CONFIGURATION.json') and driver.manifest_matches(driver.static)
        pilot_reuse = None if scope == 'sides-pilot' else verify_pilots(driver, module, latest)
        outputs = ['SOURCE_MAP', 'ACCEPTED_DEPENDENCY_EVIDENCE', 'PREPARATION']
        if pilot_reuse is not None:
            outputs.append('PILOT_REUSE_EVIDENCE')
        assert not audit.exists()
        assert not any((O / (scope + '-' + name + '.json')).exists() for name in outputs)
        declarations_all, source_map, receipt_map, originals, union, snapshots = [], {}, {}, [], {}, {}
        for name in targets:
            source = repo_file('D1Bound5/' + name + '.lean')
            digest = sha(source)
            assert digest == plan['source_manifest'][name] == sha(O / 'candidates' / (name + '.lean'))
            row = load(O / (name + '-BUILD_RECEIPT.json'))
            closure = load(O / (name + '-SOURCE_CLOSURE.json'))
            assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
            assert not row['timed_out'] and not row['interrupted']
            assert row['closure_unchanged'] and row['shared_artifacts_unchanged']
            assert row['source_sha256'] == digest and driver.closure(name) == closure
            assert module.fingerprint(closure) == row['fingerprint'] and driver.artifacts(name) == row['artifacts']
            assert (O / (name + '.lean')).read_bytes() == source.read_bytes()
            for dependency, value in closure.items():
                assert dependency not in union or union[dependency] == value
                union[dependency] = value
            old = repo_file(O / 'originals' / (name + '.lean'))
            expected_original = plan['original_source_sha256'].get(name, digest)
            assert sha(old) == expected_original, name
            before, after = declarations(old.read_text()), declarations(source.read_text())
            assert before == after, 'Original public declaration changed: ' + name
            assert all(item['kind'] == 'theorem' for item in before)
            snapshots[name] = source.read_bytes()
            source_map[name] = {'source': str(source.relative_to(R)),
                                'snapshot': str((audit / (name + '.lean')).relative_to(R)), 'sha256': digest}
            receipt_map[name] = {'receipt': str((O / (name + '-BUILD_RECEIPT.json')).relative_to(R)),
                                 'closure': str((O / (name + '-SOURCE_CLOSURE.json')).relative_to(R))}
            originals.append({'module': name, 'original_path': str(old), 'original_source_path': str(old),
                              'original_sha256': sha(old), 'current_sha256': digest,
                              'normalizations': [], 'declarations': before})
            declarations_all.extend(before)
        names = [item['name'] for item in declarations_all]
        assert len(names) == len(set(names)) == DECLARATION_COUNTS[scope]
        harness = ''.join('import D1Bound5.' + name + '\n' for name in targets)
        harness += ('import Lean.Elab.Command\nimport Lean.Util.CollectAxioms\n'
                    'set_option autoImplicit false\nset_option maxRecDepth 100000\n'
                    'set_option maxHeartbeats 0\n\nrun_cmd do\n  let names : List Lean.Name := [\n    ')
        harness += ',\n    '.join('`' + name for name in names)
        harness += (']\n  for name in names do\n    let ax ← Lean.collectAxioms name\n'
                    '    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n'
                    '    unless bad.isEmpty do\n      Lean.throwError "Unexpected axioms in {name}: {bad}"\n'
                    '    Lean.logInfo m!"' + MARKER + '{name}: {ax}"\n\n')
        for item in declarations_all:
            harness += ('namespace ' + item['namespace'] + '\n' + '\n'.join(item['opens'])
                        + '\nexample\n' + item['header'] + ' :=\n  _root_.' + item['name']
                        + '\nend ' + item['namespace'] + '\n\n')
        harness += ''.join('#check @_root_.' + name + '\n' for name in names)
        assert re.findall(r'^example\s*(.*?)\s*:=', harness, re.M | re.S) == [
            item['header'] for item in declarations_all]
        oldmap = {}
        for relative in ['20261020-completed-checkpoint', '20261021-pro-graph33',
                         '20261021-pro-one-small', '20261021-pro-graph17-left000',
                         '20261021-pro-graph17-left-complete', '20261021-pro-graph17-right-complete']:
            for name, item in load(C / relative / 'SOURCE_MAP.json')['sources'].items():
                oldmap[(name, item['sha256'])] = item
        foundation_map = C / '20261022-graph11-foundation/foundation-SOURCE_MAP.json'
        committed_map = subprocess.check_output(['git', 'show', base + ':' + str(foundation_map.relative_to(R))], cwd=R, timeout=15)
        assert committed_map == foundation_map.read_bytes(), 'Foundation provenance must be committed'
        for name, item in load(foundation_map)['sources'].items():
            oldmap[(name, item['sha256'])] = item
        provenance, evidence = {}, {}
        for name, digest in sorted(union.items()):
            key = module.fingerprint(driver.closure(name))
            artifacts = driver.expected_manifest(name, key, latest)
            assert artifacts and driver.artifacts(name) == artifacts, name
            if name in plan['source_manifest']:
                candidate = O / 'candidates' / (name + '.lean')
                assert digest == plan['source_manifest'][name] == sha(candidate)
                item = {'path': 'D1Bound5/' + name + '.lean', 'sha256': digest,
                        'payload_path': str(candidate.relative_to(R)),
                        'assurance': 'guarded_build_pass_current_audit_pending'}
                if name not in targets:
                    assert pilot_reuse is not None and name in SCOPES['sides-pilot']
                    assert pilot_reuse['source_manifest'][name] == digest
                    item.update(assurance='reused_scoped_verified_source_and_artifacts',
                                verification_summary=pilot_reuse['summary_path'],
                                proof_fingerprint=pilot_reuse['proof_fingerprint'])
                provenance[name] = item
            else:
                item = oldmap[(name, digest)]
                commit, path = ((base, item['payload_path']) if 'payload_path' in item
                                else (item['base_commit'], item['base_path']))
                blob = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=R, timeout=15)
                assert hashlib.sha256(blob).hexdigest() == digest
                provenance[name] = {'path': 'D1Bound5/' + name + '.lean', 'sha256': digest,
                                    'base_commit': commit, 'base_path': path,
                                    'assurance': 'reused_accepted_source_and_artifacts'}
            evidence[name] = {'fingerprint': key, 'artifacts': artifacts,
                              'original_receipt': latest.get((name, key)),
                              'baseline_entry': None if (name, key) in latest else driver.baseline['accepted'][name]}
        audit.mkdir()
        for name, data in snapshots.items():
            (audit / (name + '.lean')).write_bytes(data)
        (audit / 'AnalyticAudit.lean').write_text(harness)
        for filename, value in [('TARGETS.json', targets), ('REPLAY_TARGETS.json', targets),
                                ('SOURCE_MAP.json', source_map), ('BUILD_RECEIPT_MAP.json', receipt_map),
                                ('SCOPED_ORIGINAL_DECLARATIONS.json', originals), ('DECLARATION_NAMES.json', names)]:
            put(audit / filename, value)
        put(O / (scope + '-SOURCE_MAP.json'), {'base_commit': base, 'sources': provenance})
        put(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'), evidence)
        summary = {'targets': targets, 'declarations': len(names), 'theorems': len(names), 'definitions': 0,
                   'source_closure_modules': len(union), 'audit': str(audit.relative_to(R)),
                   'public_headers_exact': True, 'base_commit': base, 'root_integration': False,
                   'whole_graph11_complete': False, 'main_theorem_complete': False}
        if pilot_reuse is not None:
            path = O / (scope + '-PILOT_REUSE_EVIDENCE.json')
            put(path, pilot_reuse)
            summary['pilot_reuse_evidence'] = str(path.relative_to(R))
            summary['pilot_reuse_evidence_sha256'] = sha(path)
        put(O / (scope + '-PREPARATION.json'), summary)
        print(json.dumps({'status': 'ACCEPTED_UNIT_PREPARED_FOR_AUDIT', **summary}), flush=True)


if __name__ == '__main__':
    main()
