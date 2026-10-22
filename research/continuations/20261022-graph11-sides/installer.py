"""Install the exact reviewed graph11 left/right partitions without compiling.

Usage: python3.12 installer.py SHA256_OF_PAYLOAD_MANIFEST
The manifest is payload/PAYLOAD_SHA256.json under this run directory.
The foundation must already be verified and its evidence committed at HEAD.
This script performs no Git mutation, kernel replay, or accepted-root edit.
"""
from pathlib import Path
from datetime import datetime, timezone
import ast
import fcntl
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
EXPECTED_OUT = ROOT / 'research/continuations/20261022-graph11-sides'
FOUNDATION = ROOT / 'research/continuations/20261022-graph11-foundation'
FOUNDATION_AUDIT = ROOT / 'research/continuations/20261020T100000CEST-work-resume/pro-graph11-foundation-audit'
DRIVER = WORK / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER = ROOT / 'research/continuations/20261020T100000CEST-work-resume/bound_scoped_audit_runner_proposal_v1.py'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
ORIGINAL_SHA = {
    'SmallPairLightAdaptiveLeft11_000': '423c7fc759db19b77c223273634d665ed5e50b08992ae502aa44b3401edcb2d3',
    'SmallPairLightAdaptiveLeft11_001': '934b0d13cc8d3c75c2615f49841061fb83b8caa67484f543eaffc1ef767d615c',
    'SmallPairLightAdaptiveRight11_000': '62a8764eb8ade154b8bde0e94b71fb40b196621ef690dcc0a83343f9841ad988',
    'SmallPairLightAdaptiveRight11_001': '8dabfe2b8b6b16c5b072d6c0e90a10e6b4428a8b830cf2ac1fbf2a6902725986',
    'SmallPairLightLeft11': '489527f7b8484c8f8728064ca717191d6b89face009aaf1df34cbfc9e6cbe814',
    'SmallPairLightRight11': 'df0aa3ffd451b6c69d6a0e6fa43c3aa3da6cc1230bb0bc3d8ebde46d49ba607b',
}
FOUNDATION_TARGETS = [
    'SmallPairLightData11Left', 'SmallPairLightData11LeftRows',
    'SmallPairLightData11Right', 'SmallPairLightData11RightRows',
    'SmallPairLightData11', 'SmallPairLightAdaptiveData11',
    'SmallPairLightAdaptiveValidation11',
]
PARTITIONS = [
    ('000', 0, 138, [16, 20, 22, 24, 26, 30]),
    ('001', 138, 221, [34, 42, 56, 89]),
]
SIDES = ('left', 'right')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def file_sha(path):
    return sha(Path(path).read_bytes())


def load(path):
    return json.loads(Path(path).read_text())


def fingerprint(value):
    return sha(json.dumps(value, sort_keys=True, separators=(',', ':')).encode())


def write_new(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def copy_new(path, value):
    with Path(path).open('xb') as stream:
        stream.write(value)


def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT, text=True, timeout=30).strip()


def project_file(value):
    path = Path(value)
    path = path if path.is_absolute() else ROOT / path
    assert path.is_file() and not path.is_symlink()
    assert path.resolve().is_relative_to(ROOT.resolve()), str(path)
    return path


def public_headers(data):
    text = data.decode()
    return [text[m.start():text.index(':=', m.start())]
            for m in re.finditer(r'^(?:def|theorem|lemma|abbrev|structure) ', text, re.M)]


def no_live_project_compiler():
    result = subprocess.run(['ps', '-axo', 'pid=,ppid=,comm=,args='],
                            text=True, capture_output=True, check=True, timeout=10)
    for line in result.stdout.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid():
            continue
        pid, _, executable, _ = fields
        if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
            continue
        cwd = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                             text=True, capture_output=True, timeout=10)
        if cwd.returncode and subprocess.run(
                ['ps', '-p', pid, '-o', 'pid='], capture_output=True,
                timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify live compiler cwd: ' + pid)
        assert not any(value == 'n' + str(ROOT) or value.startswith('n' + str(ROOT) + '/')
                       for value in cwd.stdout.splitlines()), 'Another project compiler: ' + pid


def verify_foundation(driver, module, latest, head):
    """Read the actual completed foundation receipts and current protected bytes."""
    summary_path = FOUNDATION / 'foundation-VERIFICATION_SUMMARY.json'
    summary = load(summary_path)
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert summary['targets'] == FOUNDATION_TARGETS == load(FOUNDATION / 'foundation-TARGETS.json')
    assert summary['public_headers_exact'] is True
    assert summary['definitions'] == 19 and summary['theorems'] == 4 and summary['declarations'] == 23
    assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == 7
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['audit'] == str(FOUNDATION_AUDIT.relative_to(ROOT))
    assert not load(FOUNDATION_AUDIT / 'active-targeted-replay.json')['active']
    final = load(FOUNDATION_AUDIT / 'BOUND_AUDIT_FINAL.json')
    receipts = load(FOUNDATION_AUDIT / 'TARGETED_REPLAY_RECEIPTS.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [
        name + '-targeted-replay' for name in FOUNDATION_TARGETS]
    assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
               and not row['binding_drift_paths'] for row in receipts)
    binding_path = FOUNDATION_AUDIT / 'PREPARATION_BINDINGS.json'
    binding = load(binding_path)
    assert binding['schema'] == 1 and binding['audit_folder'] == str(FOUNDATION_AUDIT.resolve())
    assert binding['targets'] == binding['replays'] == FOUNDATION_TARGETS
    assert final['binding_sha256'] == file_sha(binding_path)
    protected = {str(project_file(path)): digest for path, digest in binding['files'].items()}
    assert all(file_sha(path) == digest for path, digest in protected.items())
    source_map_path = FOUNDATION / 'foundation-SOURCE_MAP.json'
    evidence_path = FOUNDATION / 'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json'
    sources = load(source_map_path)['sources']
    evidence = load(evidence_path)
    assert set(sources) == set(evidence)
    assert binding['project_sources'] == {name: row['sha256'] for name, row in sources.items()}
    artifacts = {}
    for name, row in sources.items():
        assert row['path'] == 'D1Bound5/' + name + '.lean'
        assert file_sha(project_file(row['path'])) == row['sha256'], name
        closure = driver.closure(name)
        key = module.fingerprint(closure)
        expected = driver.expected_manifest(name, key, latest)
        assert expected and key == evidence[name]['fingerprint'], name
        assert expected == evidence[name]['artifacts'] == driver.artifacts(name), name
        for path, digest in expected.items():
            assert path not in artifacts or artifacts[path] == digest
            artifacts[path] = digest
        if name in FOUNDATION_TARGETS:
            assert row['assurance'] == 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
    assert all(artifacts.get(path) == digest for path, digest in binding['target_artifacts'].items())
    configuration = load(FOUNDATION / 'CONFIGURATION.json')
    assert configuration == driver.static and driver.manifest_matches(configuration)
    state_path = FOUNDATION / 'foundation-PROOF_STATE.json'
    state = load(state_path)
    expected_state = {
        'sources': [[name, row['sha256']] for name, row in sorted(sources.items())],
        'configuration': configuration,
        'build_fingerprints': {name: evidence[name]['fingerprint'] for name in FOUNDATION_TARGETS},
        'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in FOUNDATION_TARGETS},
        'audit_harness_sha256': file_sha(FOUNDATION_AUDIT / 'AnalyticAudit.lean'),
        'accepted_checks': [{key: row[key] for key in ('label', 'exit', 'guards_unchanged')}
                            for row in receipts],
    }
    assert state == expected_state and fingerprint(state) == summary['proof_fingerprint']
    for path in [summary_path, source_map_path, evidence_path, state_path,
                 FOUNDATION / 'CONFIGURATION.json', FOUNDATION / 'foundation-TARGETS.json',
                 binding_path, FOUNDATION_AUDIT / 'BOUND_AUDIT_FINAL.json',
                 FOUNDATION_AUDIT / 'TARGETED_REPLAY_RECEIPTS.json']:
        protected[str(path)] = file_sha(path)
    # Local HEAD must contain the actual verified foundation state. Its successful
    # remote push is checked separately by the publication workflow.
    for path in [summary_path, source_map_path, state_path]:
        relative = str(path.relative_to(ROOT))
        blob = subprocess.check_output(['git', 'show', head + ':' + relative], cwd=ROOT, timeout=30)
        assert sha(blob) == file_sha(path), 'Foundation evidence not committed at HEAD: ' + relative
    for row in sources.values():
        commit, relative = (head, row['payload_path']) if 'payload_path' in row else (
            row['base_commit'], row['base_path'])
        blob = subprocess.check_output(['git', 'show', commit + ':' + relative], cwd=ROOT, timeout=30)
        assert sha(blob) == row['sha256'], relative
    return {
        'summary_path': str(summary_path.relative_to(ROOT)),
        'proof_fingerprint': summary['proof_fingerprint'],
        'committed_head': head,
        'protected_files': protected,
        'source_manifest': {name: row['sha256'] for name, row in sources.items()},
        'artifacts': artifacts,
        'configuration': configuration,
    }


def main():
    assert OUT == EXPECTED_OUT, 'Install only from the reviewed remote run directory'
    assert len(sys.argv) == 2 and re.fullmatch(r'[0-9a-f]{64}', sys.argv[1])
    manifest_path = OUT / 'payload/PAYLOAD_SHA256.json'
    manifest_bytes = manifest_path.read_bytes()
    assert sha(manifest_bytes) == sys.argv[1], 'Payload manifest differs from the reviewed binding'
    payload = json.loads(manifest_bytes)
    for relative, digest in payload.items():
        path = Path(relative)
        assert not path.is_absolute() and '..' not in path.parts
        full = OUT / 'payload' / path
        assert full.is_file() and not full.is_symlink() and full.resolve().is_relative_to(OUT.resolve())
        assert re.fullmatch(r'[0-9a-f]{64}', digest) and file_sha(full) == digest, relative
    proposal = load(OUT / 'payload/PLAN.json')
    partition_record = load(OUT / 'payload/PARTITION_COVERAGE.json')
    assert proposal['schema'] == partition_record['schema'] == 1
    assert proposal['status'] == 'PREPARED_NOT_BUILT'
    assert proposal['model'] == {'tau': 0, 'nu': 1}
    assert proposal['original_data_modified'] is False and proposal['full_tails_preserved'] is True
    assert proposal['root_integration'] is False and proposal['main_theorem_complete'] is False
    assert proposal['lean_compiled'] is False and proposal['kernel_replayed'] is False
    assert set(proposal['original_sources']) == set(ORIGINAL_SHA)
    assert {name: row['sha256'] for name, row in proposal['original_sources'].items()} == ORIGINAL_SHA
    assert file_sha(DRIVER) == DRIVER_SHA and file_sha(RUNNER) == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph11_sides_install_driver', DRIVER)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)

    with (WORK / 'continuation-driver.lock').open('r+') as owner, \
            (WORK / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        active_path = WORK / 'continuation-active.json'
        active_bytes = active_path.read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        no_live_project_compiler()
        assert git('branch', '--show-current') == 'main' and not git('diff', '--cached', '--name-only')
        head = git('rev-parse', 'HEAD')
        index_sha = file_sha(ROOT / '.git/index')
        root_sha = file_sha(ROOT / 'D1Bound5.lean')
        driver = module.Driver(ROOT, WORK)
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        queue_bytes = driver.queue_path.read_bytes()
        assert not unknown and queue == json.loads(queue_bytes)
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert len(queue['names']) == len(set(queue['names']))
        assert set(ORIGINAL_SHA) <= set(queue['names'])
        assert not (set(ORIGINAL_SHA) & set(accepted))
        assert all(not (set(ORIGINAL_SHA) & set(closures[name])) for name in accepted), \
            'An accepted dependent would be changed'
        for filename in ['PLAN.json', 'INSTALL_RECEIPT.json', 'INSTALL_STARTED.json']:
            assert not (OUT / filename).exists(), filename
        for scope in ['sides-pilot', 'left-rest', 'right-rest']:
            audit = ROOT / 'research/continuations/20261020T100000CEST-work-resume' / ('pro-graph11-' + scope + '-audit')
            assert not audit.exists(), 'Existing scope must be reviewed separately: ' + scope
        assert not (OUT / 'originals').exists() and not (OUT / 'candidates').exists()

        originals = {}
        for name, expected in ORIGINAL_SHA.items():
            source = project_file('D1Bound5/' + name + '.lean')
            data = source.read_bytes()
            assert sha(data) == expected, 'Original source byte drift: ' + name
            assert data == (OUT / 'payload/originals' / (name + '.lean')).read_bytes(), name
            originals[name] = data

        candidates = {}
        targets = []
        new_parts = []
        coverage = []
        side_targets = {}
        parent_insertions = {}
        expected_payload_paths = {'PLAN.json', 'PARTITION_COVERAGE.json'} | {
            'originals/' + name + '.lean' for name in ORIGINAL_SHA}
        for side in SIDES:
            side_order = []
            side_coverage = []
            for suffix, global_start, parent_count, counts in PARTITIONS:
                parent = 'SmallPairLightAdaptive' + side.title() + '11_' + suffix
                cursor = 0
                parent_parts = []
                for number, count in enumerate(counts):
                    name = parent + 'Part' + f'{number:02d}'
                    relative = 'candidates/' + name + '.lean'
                    assert relative in payload
                    expected_payload_paths.add(relative)
                    data = (OUT / 'payload' / relative).read_bytes()
                    text = data.decode()
                    theorem = side + '_prefix_' + suffix + '_part' + f'{number:02d}' + '_checked'
                    expected_header = (
                        'theorem ' + theorem + ' : pairLightSelectedFloorPrefixBool 0 1 '
                        'PairLightPrepared11.sieve ' + str(count) + ' (' + side + 'Cached' + suffix +
                        '.drop ' + str(cursor) + ') (' + side + 'Rows' + suffix + '.drop ' + str(cursor) + ') = true')
                    declarations = public_headers(data)
                    assert len(declarations) == 1 and ' '.join(declarations[0].split()) == expected_header
                    assert '.take' not in text and 'decide +kernel' in text
                    assert not (ROOT / 'D1Bound5' / (name + '.lean')).exists() and name not in queue['names']
                    candidates[name] = data
                    originals[name] = data
                    side_order.append(name)
                    new_parts.append(name)
                    parent_parts.append(name)
                    entry = {'module': name, 'side': side, 'parent_suffix': suffix,
                             'local_start': cursor, 'global_start': global_start + cursor,
                             'head_count': count, 'full_tail': True}
                    coverage.append(entry)
                    side_coverage.append(entry)
                    cursor += count
                assert cursor == parent_count
                parent_insertions[parent] = parent_parts
                relative = 'candidates/' + parent + '.lean'
                expected_payload_paths.add(relative)
                candidates[parent] = (OUT / 'payload' / relative).read_bytes()
                assert public_headers(candidates[parent]) == public_headers(originals[parent])
                assert proposal['original_parent_headers'][parent] == public_headers(originals[parent])[0]
                side_order.append(parent)
            wrapper = 'SmallPairLight' + side.title() + '11'
            candidates[wrapper] = originals[wrapper]
            side_order.append(wrapper)
            assert proposal['unchanged_wrappers'][wrapper]['source_sha256'] == ORIGINAL_SHA[wrapper]
            assert proposal['unchanged_wrappers'][wrapper]['action'] == 'KEEP_EXISTING_SOURCE_BYTE_IDENTICAL'
            assert len(side_order) == 13
            covered = [i for row in side_coverage for i in range(row['global_start'], row['global_start'] + row['head_count'])]
            assert covered == list(range(359))
            record = partition_record['sides'][side]
            assert record['covered_head_count'] == record['declared_vertex_count'] == 359
            assert len(record['parts']) == len(side_coverage) == 10
            for row, recorded in zip(side_coverage, record['parts']):
                assert (row['module'], row['local_start'], row['global_start'], row['head_count']) == (
                    recorded['module'], recorded['local_drop'], recorded['original_first_head'], recorded['head_count'])
            targets.extend(side_order)
            side_targets[side] = side_order
        assert set(payload) == expected_payload_paths
        assert len(candidates) == len(targets) == len(set(targets)) == 26
        assert set(candidates) == set(originals)
        assert len(new_parts) == len(set(new_parts)) == 20
        assert targets == proposal['nominal_full_build_order']
        pilots = [side_targets[side][0] for side in SIDES]
        scopes = {'sides-pilot': pilots,
                  'left-rest': side_targets['left'][1:],
                  'right-rest': side_targets['right'][1:]}
        assert pilots == proposal['pilot_targets']
        assert scopes['left-rest'] == proposal['nominal_remainder_targets']['left']
        assert scopes['right-rest'] == proposal['nominal_remainder_targets']['right']
        assert [len(scopes[key]) for key in ['sides-pilot', 'left-rest', 'right-rest']] == [2, 12, 12]
        manifest = {name: sha(data) for name, data in candidates.items()}
        assert {name: manifest[name] for name in proposal['candidate_module_sha256']} == proposal['candidate_module_sha256']
        assert set(proposal['candidate_module_sha256']) == set(candidates) - {'SmallPairLightLeft11', 'SmallPairLightRight11'}
        for name, data in candidates.items():
            assert not re.search(rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b', data), name
        pin_nodes = [node.value for node in ast.parse((OUT / 'bounded_build.py').read_text()).body
                     if isinstance(node, ast.Assign) and any(
                         isinstance(target, ast.Name) and target.id == 'PINS' for target in node.targets)]
        assert len(pin_nodes) == 1 and ast.literal_eval(pin_nodes[0]) == manifest

        proposed = {}
        def proposed_closure(name):
            if name in proposed:
                return proposed[name]
            result = {}
            def visit(current):
                if current in result:
                    return
                assert module.VALID_NAME.fullmatch(current)
                data = candidates[current] if current in candidates else project_file('D1Bound5/' + current + '.lean').read_bytes()
                result[current] = sha(data)
                for line in module.IMPORT_LINE.findall(data):
                    content = line.split(b'--', 1)[0]
                    imports = module.IMPORT_NAME.findall(content)
                    assert b'D1Bound5' not in content or imports
                    for dependency in imports:
                        visit(dependency.decode())
            visit(name)
            proposed[name] = result
            return result
        union = {}
        for name in targets:
            for dependency, digest in proposed_closure(name).items():
                assert dependency not in union or union[dependency] == digest
                union[dependency] = digest
        assert not (set(union) & set(queue.get('blocked_modules', [])))
        latest = driver.latest()
        foundation = verify_foundation(driver, module, latest, head)
        dependencies = {}
        for name in sorted(set(union) - set(targets)):
            closure = driver.closure(name)
            assert all(union.get(n) == digest for n, digest in closure.items())
            key = module.fingerprint(closure)
            expected = driver.expected_manifest(name, key, latest)
            assert expected and driver.artifacts(name) == expected, 'Unaccepted dependency: ' + name
            dependencies[name] = {'fingerprint': key, 'artifacts': expected}
        for name in targets:
            assert (name, module.fingerprint(proposed_closure(name))) not in latest, 'Existing exact attempt: ' + name

        new_queue = json.loads(queue_bytes)
        for parent, parts in parent_insertions.items():
            assert parent in new_queue['names'] and not (set(parts) & set(new_queue['names']))
            where = new_queue['names'].index(parent)
            new_queue['names'][where:where] = parts
        assert len(new_queue['names']) == len(queue['names']) + 20
        assert len(new_queue['names']) == len(set(new_queue['names']))
        assert [name for name in new_queue['names'] if name not in set(new_parts)] == queue['names']
        assert set(new_queue['names']) - set(queue['names']) == set(new_parts)
        assert {key: value for key, value in new_queue.items() if key != 'names'} == {
            key: value for key, value in queue.items() if key != 'names'}

        plan = {
            'status': 'BOTH_SIDES_PREPARED_NOT_COMPILED', 'sides': list(SIDES), 'model': [0, 1],
            'original_parent_counts': [138, 221], 'heads_per_side': 359,
            'coverage': coverage, 'targets': targets, 'scope_targets': scopes,
            'source_manifest': manifest, 'original_source_sha256': ORIGINAL_SHA,
            'payload_manifest_sha256': sys.argv[1], 'payload_plan_sha256': payload['PLAN.json'],
            'partition_coverage_sha256': payload['PARTITION_COVERAGE.json'],
            'foundation_summary': foundation['summary_path'],
            'foundation_proof_fingerprint': foundation['proof_fingerprint'],
            'base_commit': head, 'canonical_root_sha256': root_sha,
            'remainder_status': 'DEFERRED_UNTIL_ACTUAL_PILOT_BUILD_AND_REPLAY_MEASUREMENTS',
            'root_integration': False, 'whole_graph11_complete': False, 'main_theorem_complete': False,
        }

        def stable_before_mutation():
            assert git('rev-parse', 'HEAD') == head and file_sha(ROOT / '.git/index') == index_sha
            assert driver.queue_path.read_bytes() == queue_bytes and active_path.read_bytes() == active_bytes
            assert file_sha(ROOT / 'D1Bound5.lean') == root_sha
            assert manifest_path.read_bytes() == manifest_bytes
            assert file_sha(DRIVER) == DRIVER_SHA and file_sha(RUNNER) == RUNNER_SHA
            assert all(file_sha(OUT / 'payload' / relative) == digest for relative, digest in payload.items())
            assert all(file_sha(ROOT / 'D1Bound5' / (name + '.lean')) == digest for name, digest in ORIGINAL_SHA.items())
            assert all(file_sha(path) == digest for path, digest in foundation['protected_files'].items())
            assert all(file_sha(ROOT / 'D1Bound5' / (name + '.lean')) == digest
                       for name, digest in foundation['source_manifest'].items())
            assert driver.manifest_matches(foundation['artifacts']) and driver.manifest_matches(driver.static)
            for name, row in dependencies.items():
                assert module.fingerprint(driver.closure(name)) == row['fingerprint']
                assert driver.artifacts(name) == row['artifacts']
            no_live_project_compiler()

        stable_before_mutation()
        (OUT / 'originals').mkdir()
        (OUT / 'candidates').mkdir()
        for name in targets:
            copy_new(OUT / 'originals' / (name + '.lean'), originals[name])
            copy_new(OUT / 'candidates' / (name + '.lean'), candidates[name])
        copy_new(OUT / 'QUEUE_BEFORE.json', queue_bytes)
        copy_new(OUT / 'ACTIVE_BEFORE.json', active_bytes)
        write_new(OUT / 'CONFIGURATION.json', driver.static)
        write_new(OUT / 'FOUNDATION_REUSE_EVIDENCE.json', foundation)
        write_new(OUT / 'EXTERNAL_DEPENDENCY_GUARDS.json', dependencies)
        write_new(OUT / 'PLAN.json', plan)
        for scope, scope_targets in scopes.items():
            write_new(OUT / (scope + '-TARGETS.json'), scope_targets)
        write_new(OUT / 'INSTALL_STARTED.json', {
            'utc': datetime.now(timezone.utc).isoformat(), 'base_commit': head,
            'targets': targets, 'source_manifest': manifest,
            'payload_manifest_sha256': sys.argv[1], 'compiler_run': False,
            'baseline_changed': False, 'queue_sha256_before': sha(queue_bytes),
        })
        stable_before_mutation()
        for name in targets:
            if name in ('SmallPairLightLeft11', 'SmallPairLightRight11'):
                continue
            destination = ROOT / 'D1Bound5' / (name + '.lean')
            if name not in ORIGINAL_SHA:
                copy_new(destination, candidates[name])
            else:
                temporary = destination.with_name(destination.name + '.graph11-sides-install.' + str(os.getpid()))
                copy_new(temporary, candidates[name])
                os.replace(temporary, destination)
        assert all(file_sha(ROOT / 'D1Bound5' / (name + '.lean')) == digest for name, digest in manifest.items())
        module.atomic_json(driver.queue_path, new_queue)
        after_queue, after_names, after_closures, after_accepted, after_unknown, after_eligible = driver.snapshot()
        assert after_queue == new_queue and not after_unknown and set(accepted) <= set(after_accepted)
        assert all(after_closures[name] == closures[name] for name in accepted)
        assert all(file_sha(path) == digest for path, digest in foundation['protected_files'].items())
        assert driver.manifest_matches(foundation['artifacts']) and driver.manifest_matches(driver.static)
        assert active_path.read_bytes() == active_bytes and file_sha(ROOT / 'D1Bound5.lean') == root_sha
        assert git('rev-parse', 'HEAD') == head and file_sha(ROOT / '.git/index') == index_sha
        write_new(OUT / 'QUEUE_AFTER.json', new_queue)
        receipt = {
            'status': 'BOTH_SIDE_PARTITIONS_INSTALLED_NOT_COMPILED',
            'utc': datetime.now(timezone.utc).isoformat(), 'base_commit': head,
            'targets': targets, 'scope_targets': scopes, 'source_manifest': manifest,
            'payload_manifest_sha256': sys.argv[1], 'coverage_parts': 20,
            'heads_per_side': 359, 'original_parent_counts': [138, 221],
            'queue_entries_added': 20, 'queue_sha256_before': sha(queue_bytes),
            'queue_sha256_after': file_sha(driver.queue_path),
            'source_closure_modules': len(union), 'wrappers_unchanged': True,
            'foundation_proof_fingerprint': foundation['proof_fingerprint'],
            'previous_accepted_sources_retained': True,
            'compiler_run': False, 'baseline_changed': False,
            'root_integration': False, 'whole_graph11_complete': False, 'main_theorem_complete': False,
        }
        write_new(OUT / 'INSTALL_RECEIPT.json', receipt)
        print(json.dumps(receipt), flush=True)


if __name__ == '__main__':
    main()
