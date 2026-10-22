"""Install the exact reviewed graph46 left/right partitions without compiling.

Usage: python3.12 -B installer.py PAYLOAD_MANIFEST_SHA256 FOUNDATION_BINDING_SHA256
The manifest is payload/PAYLOAD_SHA256.json under this run directory.
The foundation must already be verified and privately published. Its actual
receipt bytes are separately bound; a post-push receipt need not be in its own
publication commit. No executable binding is supplied with this workflow.
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
EXPECTED_OUT = ROOT / 'research/continuations/20261022-graph46-sides'
FOUNDATION = ROOT / 'research/continuations/20261022-graph46-foundation'
FOUNDATION_AUDIT = ROOT / 'research/continuations/20261020T100000CEST-work-resume/pro-graph46-foundation-audit'
FOUNDATION_PUBLICATION = ROOT / 'research/continuations/20261022-graph46-foundation-publication'
FOUNDATION_INPUTS_SHA = '7bddb13018a45ef5f65aaf5b7f64d845e08cde31f91f64a0da23397f4e5c301f'
PAYLOAD_SHA = '0a5f79888d094e6111fa6279bc14d72a784981734fe93735dc8c57f62308b3e3'
SOURCE_INSPECTION_SHA = 'f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54'
DRIVER = WORK / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER = ROOT / 'research/continuations/20261020T100000CEST-work-resume/bound_scoped_audit_runner_proposal_v1.py'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
ORIGINAL_SHA = {'SmallPairLightAdaptiveLeft46_000': '46c376bdddd78e7c67db1dfb83d386424166b5f668f5310b0c2576b5ac29da87', 'SmallPairLightAdaptiveLeft46_001': 'a9e484173812ad57d929216f84a84db1ba6c094bc38f29abb0d20d79e1db15ab', 'SmallPairLightAdaptiveRight46_000': 'e7d2efd8a67e4d7c5acd0229b230835e8097d9e72669ddd71672da450a79dd3d', 'SmallPairLightAdaptiveRight46_001': 'ef7af6e7b0267c4f8e9e22f0e90835f085e3a6ed69d902ca1008372b7998f71d', 'SmallPairLightLeft46': '1f83b52da398d7859b2344f560660efce4764f16abde756d5407b114342d3f4f', 'SmallPairLightRight46': '739c702ff1f9840879a27681847c112e22b302f45be3cd1ea64e1144781104cd'}
FOUNDATION_TARGETS = [
    'SmallPairLightData46Left', 'SmallPairLightData46LeftRows',
    'SmallPairLightData46Right', 'SmallPairLightData46RightRows',
    'SmallPairLightData46', 'SmallPairLightAdaptiveData46',
    'SmallPairLightAdaptiveValidation46',
]
PARTITIONS = {'left': [('000', 0, 137, [16, 20, 22, 24, 26, 29]), ('001', 137, 223, [34, 42, 56, 91])], 'right': [('000', 0, 138, [16, 20, 22, 24, 26, 30]), ('001', 138, 220, [34, 42, 56, 88])]}
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


def foundation_binding_files():
    files = [FOUNDATION / name for name in (
        'foundation-VERIFICATION_SUMMARY.json', 'foundation-SOURCE_MAP.json',
        'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json', 'foundation-PROOF_STATE.json',
        'CONFIGURATION.json', 'foundation-TARGETS.json', 'foundation-PREPARATION.json',
        'GRAPH46_BINDING.json', 'PROVENANCE_BINDING.json', 'SOURCE_INSPECTION.json',
        'REVIEWED_SCRIPT_PINS.json', 'PREPARED_PAYLOAD_SHA256.json',
        'PLAN.json', 'INSTALL_RECEIPT.json', 'DECLARATION_ORIGINS.json')]
    files += [FOUNDATION_AUDIT / name for name in (
        'PREPARATION_BINDINGS.json', 'BOUND_AUDIT_FINAL.json', 'TARGETED_REPLAY_RECEIPTS.json',
        'TARGETED_REPLAY_GUARDS.json', 'PROVENANCE_BINDING_USED.json',
        'SCOPED_ORIGINAL_DECLARATIONS.json')]
    files += [FOUNDATION_PUBLICATION / name for name in (
        'POST_PUSH_RECEIPT.json', 'OWNER.json', 'RELEASE.json',
        'SELECTED_FILES_SHA256.json', 'STAGING_PATHS.txt')]
    return files


def verify_foundation_publication(head, reviewed_binding):
    """Verify historical published blobs and separately bound post-push records."""
    receipt = load(FOUNDATION_PUBLICATION / 'POST_PUSH_RECEIPT.json')
    assert receipt['status'] == 'PRIVATE_PUSH_VERIFIED'
    assert receipt['commit_exit'] == receipt['push_exit'] == receipt['staged_count'] == 0
    assert receipt['repository'] == 'tomislav-math/d1-bound5-lean' and receipt['visibility'] == 'PRIVATE'
    assert receipt['selected_committed_blobs_match'] is True
    assert receipt['root_integration'] is False and receipt['main_theorem_complete'] is False
    published = receipt['local_head']
    assert re.fullmatch(r'[0-9a-f]{40}', published)
    assert receipt['remote_head'] == reviewed_binding['foundation_published_commit'] == published
    assert subprocess.run(['git', 'merge-base', '--is-ancestor', published, head],
                          cwd=ROOT, capture_output=True, timeout=30).returncode == 0
    owner = load(FOUNDATION_PUBLICATION / 'OWNER.json')
    assert owner['active'] is False and owner['reason'] == 'released'
    assert owner['timeout_seconds'] == 240 and owner['child_processes'] == []
    assert isinstance(load(FOUNDATION_PUBLICATION / 'RELEASE.json'), dict)
    selected_path = FOUNDATION_PUBLICATION / 'SELECTED_FILES_SHA256.json'
    staging_path = FOUNDATION_PUBLICATION / 'STAGING_PATHS.txt'
    selected, staging = load(selected_path), staging_path.read_text().splitlines()
    assert isinstance(selected, dict) and selected
    expected_paths = set(selected) | {str(selected_path.relative_to(ROOT)), str(staging_path.relative_to(ROOT))}
    assert len(staging) == len(set(staging)) == receipt['selected_files']
    assert set(staging) == expected_paths
    for relative, expected in selected.items():
        path = Path(relative)
        assert not path.is_absolute() and not any(part in ('.git', '.lake', '..') for part in path.parts)
        assert re.fullmatch(r'[0-9a-f]{64}', expected)
        blob = subprocess.check_output(['git', 'show', published + ':' + relative], cwd=ROOT, timeout=30)
        assert sha(blob) == expected, 'Published selected blob mismatch: ' + relative
    for path in (selected_path, staging_path):
        blob = subprocess.check_output(['git', 'show', published + ':' + str(path.relative_to(ROOT))],
                                       cwd=ROOT, timeout=30)
        assert sha(blob) == file_sha(path)
    # Publication receipts and owner/release records are produced after the
    # publication commit. Their bytes are reviewed/bound without a circular
    # demand that they appear in that same commit.
    for path in foundation_binding_files():
        if path.parent == FOUNDATION_PUBLICATION:
            continue
        relative = str(path.relative_to(ROOT))
        blob = subprocess.check_output(['git', 'show', published + ':' + relative], cwd=ROOT, timeout=30)
        assert sha(blob) == file_sha(path), 'Foundation evidence differs from published commit: ' + relative
    return {'commit': published, 'receipt_path': str((FOUNDATION_PUBLICATION / 'POST_PUSH_RECEIPT.json').relative_to(ROOT)),
            'receipt_sha256': file_sha(FOUNDATION_PUBLICATION / 'POST_PUSH_RECEIPT.json'),
            'selected_files': len(staging), 'owner_inactive_and_released': True,
            'selected_committed_blobs_match': True}


def verify_foundation(driver, module, latest, head, reviewed_binding):
    """Read the actual completed foundation receipts and current protected bytes."""
    helper_path = project_file(FOUNDATION / 'foundation_inputs.py')
    assert file_sha(helper_path) == FOUNDATION_INPUTS_SHA
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location('graph46_sides_foundation_inputs', helper_path)
    helper = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = helper
    spec.loader.exec_module(helper)
    assert helper.TARGETS == FOUNDATION_TARGETS and helper.REPOSITORY == ROOT
    input_binding, prepared_plan, prepared_payload = helper.verify_prepared(FOUNDATION)
    side_evidence = load(OUT / 'payload/SOURCE_EVIDENCE.json')
    assert side_evidence['source_inspection_sha256'] == SOURCE_INSPECTION_SHA
    assert input_binding['source_evidence']['original_source_manifest'] == side_evidence['original_foundation_source_sha256']
    assert input_binding['source_evidence']['declaration_counts'] == {'definitions': 19, 'theorems': 4, 'total': 23}
    assert input_binding['source_evidence']['literal_row_counts'] == {
        'sieve': 25, 'leftVertices': 360, 'leftCached': 360, 'leftRows': 360,
        'rightVertices': 358, 'rightCached': 358, 'rightRows': 358}
    summary_path = FOUNDATION / 'foundation-VERIFICATION_SUMMARY.json'
    summary = load(summary_path)
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert summary['targets'] == FOUNDATION_TARGETS == load(FOUNDATION / 'foundation-TARGETS.json')
    assert summary['public_headers_exact'] is True
    assert summary['definitions'] == 19 and summary['theorems'] == 4 and summary['declarations'] == 23
    assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == 7
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['whole_graph46_complete'] is False
    assert summary['base_commit'] == input_binding['base_commit']
    assert summary['input_binding_sha256'] == file_sha(FOUNDATION / 'GRAPH46_BINDING.json')
    assert summary['audit'] == str(FOUNDATION_AUDIT.relative_to(ROOT))
    assert not load(FOUNDATION_AUDIT / 'active-targeted-replay.json')['active']
    final = load(FOUNDATION_AUDIT / 'BOUND_AUDIT_FINAL.json')
    receipts = load(FOUNDATION_AUDIT / 'TARGETED_REPLAY_RECEIPTS.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert final['main_theorem_claim'] is False
    assert [row['label'] for row in receipts] == ['analytic-type-axioms'] + [
        name + '-targeted-replay' for name in FOUNDATION_TARGETS]
    assert all(row['exit'] == 0 and not row['timed_out'] and row['guards_unchanged']
               and not row['binding_drift_paths'] for row in receipts)
    assert (FOUNDATION_AUDIT / 'analytic-type-axioms.log').read_text().count('GRAPH46_FOUNDATION_AXIOMS_PASS ') == 23
    binding_path = FOUNDATION_AUDIT / 'PREPARATION_BINDINGS.json'
    binding = load(binding_path)
    assert binding['schema'] == 1 and binding['audit_folder'] == str(FOUNDATION_AUDIT.resolve())
    assert binding['targets'] == binding['replays'] == FOUNDATION_TARGETS
    assert load(FOUNDATION_AUDIT / 'TARGETS.json') == load(FOUNDATION_AUDIT / 'REPLAY_TARGETS.json') == FOUNDATION_TARGETS
    assert final['binding_sha256'] == file_sha(binding_path)
    assert final['source_map_sha256'] == file_sha(FOUNDATION_AUDIT / 'SOURCE_MAP.json')
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
            assert row['sha256'] == prepared_plan['source_manifest'][name]
            build_path = FOUNDATION / (name + '-BUILD_RECEIPT.json')
            build = load(build_path)
            assert build['name'] == name and build['exit'] == 0 and build['accepted_build'] is True
            assert build['timed_out'] is False and build['interrupted'] is False and build['timeout_seconds'] == 240
            assert build['closure_unchanged'] is True and build['shared_artifacts_unchanged'] is True
            assert build['source_sha256'] == row['sha256'] and build['fingerprint'] == key and build['artifacts'] == expected
            assert load(FOUNDATION / (name + '-SOURCE_CLOSURE.json')) == load(FOUNDATION / (name + '-ORIGINAL_SOURCES.json')) == closure
            for path in (build_path, FOUNDATION / (name + '-SOURCE_CLOSURE.json'),
                         FOUNDATION / (name + '-ORIGINAL_SOURCES.json')):
                protected[str(path)] = file_sha(project_file(path))
    assert all(artifacts.get(path) == digest for path, digest in binding['target_artifacts'].items())
    configuration = load(FOUNDATION / 'CONFIGURATION.json')
    assert configuration == input_binding['configuration'] == driver.static and driver.manifest_matches(configuration)
    guards = load(FOUNDATION_AUDIT / 'TARGETED_REPLAY_GUARDS.json')
    assert guards['project_sources'] == binding['project_sources']
    assert guards['compiled_artifacts'] == artifacts and guards['immutable_inputs'] == configuration
    expected_preparation_files = dict(binding['files'])
    self_path = str(binding_path.resolve())
    assert self_path not in expected_preparation_files
    expected_preparation_files[self_path] = file_sha(binding_path)
    assert guards['preparation_files'] == expected_preparation_files
    assert all(file_sha(project_file(path)) == digest for path, digest in expected_preparation_files.items())
    used_provenance = load(FOUNDATION_AUDIT / 'PROVENANCE_BINDING_USED.json')
    assert used_provenance['binding_sha256'] == file_sha(FOUNDATION / 'PROVENANCE_BINDING.json')
    assert all(file_sha(project_file(path)) == digest for path, digest in used_provenance['source_maps'].items())
    assert file_sha(ROOT / 'D1Bound5.lean') == input_binding['canonical_root_sha256'] == prepared_plan['canonical_root_sha256']
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
    for relative, digest in prepared_payload.items():
        path = project_file(FOUNDATION / relative)
        assert file_sha(path) == digest
        protected[str(path)] = digest
    for path in foundation_binding_files():
        protected[str(path)] = file_sha(project_file(path))
    for path, digest in used_provenance['source_maps'].items():
        protected[str(project_file(path))] = digest
    for path in [summary_path, source_map_path, evidence_path, state_path,
                 FOUNDATION / 'CONFIGURATION.json', FOUNDATION / 'foundation-TARGETS.json',
                 binding_path, FOUNDATION_AUDIT / 'BOUND_AUDIT_FINAL.json',
                 FOUNDATION_AUDIT / 'TARGETED_REPLAY_RECEIPTS.json']:
        protected[str(path)] = file_sha(path)
    publication = verify_foundation_publication(head, reviewed_binding)
    # Current HEAD retains the published verified foundation and its provenance.
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
        'publication': publication,
        'protected_files': protected,
        'source_manifest': {name: row['sha256'] for name, row in sources.items()},
        'artifacts': artifacts,
        'configuration': configuration,
    }


def main():
    if not __debug__:
        raise RuntimeError("Do not disable verification assertions")
    assert OUT == EXPECTED_OUT, 'Install only from the reviewed remote run directory'
    assert len(sys.argv) == 3 and all(re.fullmatch(r'[0-9a-f]{64}', value) for value in sys.argv[1:])
    foundation_binding_path = OUT / 'REVIEWED_FOUNDATION_BINDING.json'
    foundation_binding_bytes = project_file(foundation_binding_path).read_bytes()
    assert sha(foundation_binding_bytes) == sys.argv[2]
    foundation_binding = json.loads(foundation_binding_bytes)
    assert foundation_binding['schema'] == 1 and foundation_binding['status'] == 'REVIEWED_FOUNDATION_BINDING'
    assert foundation_binding['graph'] == 46
    assert re.fullmatch(r'[0-9a-f]{40}', foundation_binding['base_commit'])
    assert re.fullmatch(r'[0-9a-f]{40}', foundation_binding['foundation_published_commit'])
    assert re.fullmatch(r'[0-9a-f]{64}', foundation_binding['foundation_proof_fingerprint'])
    expected_foundation_files = foundation_binding_files()
    assert set(foundation_binding['files']) == {str(path.relative_to(ROOT)) for path in expected_foundation_files}
    assert all(re.fullmatch(r'[0-9a-f]{64}', digest)
               and file_sha(project_file(path)) == digest
               for path, digest in foundation_binding['files'].items())
    assert foundation_binding['root_integration'] is False and foundation_binding['main_theorem_complete'] is False
    manifest_path = OUT / 'payload/PAYLOAD_SHA256.json'
    manifest_bytes = manifest_path.read_bytes()
    assert sha(manifest_bytes) == sys.argv[1] == PAYLOAD_SHA, 'Payload manifest differs from the reviewed binding'
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
    assert proposal['model'] == {'tau': 1, 'nu': 6}
    assert proposal['source_inspection_sha256'] == SOURCE_INSPECTION_SHA
    assert proposal['source_evidence_sha256'] == file_sha(OUT / 'payload/SOURCE_EVIDENCE.json')
    assert proposal['future_foundation_binding_status'] == 'UNBOUND_REQUIRES_ACTUAL_COMPLETED_FOUNDATION'
    assert proposal['foundation_commit'] is None
    assert proposal['original_data_modified'] is False and proposal['full_tails_preserved'] is True
    assert proposal['root_integration'] is False and proposal['main_theorem_complete'] is False
    assert proposal['lean_compiled'] is False and proposal['kernel_replayed'] is False
    assert set(proposal['original_sources']) == set(ORIGINAL_SHA)
    assert {name: row['sha256'] for name, row in proposal['original_sources'].items()} == ORIGINAL_SHA
    assert file_sha(DRIVER) == DRIVER_SHA and file_sha(RUNNER) == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph46_sides_install_driver', DRIVER)
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
        assert head == foundation_binding['base_commit'], 'Bind the actual reviewed foundation commit before installation'
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
            audit = ROOT / 'research/continuations/20261020T100000CEST-work-resume' / ('pro-graph46-' + scope + '-audit')
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
        expected_payload_paths = {'PLAN.json', 'PARTITION_COVERAGE.json', 'SOURCE_EVIDENCE.json'} | {
            'originals/' + name + '.lean' for name in ORIGINAL_SHA}
        for side in SIDES:
            side_order = []
            side_coverage = []
            for suffix, global_start, parent_count, counts in PARTITIONS[side]:
                parent = 'SmallPairLightAdaptive' + side.title() + '46_' + suffix
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
                        'theorem ' + theorem + ' : pairLightSelectedFloorPrefixBool 1 6 '
                        'PairLightPrepared46.sieve ' + str(count) + ' (' + side + 'Cached' + suffix +
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
            wrapper = 'SmallPairLight' + side.title() + '46'
            candidates[wrapper] = originals[wrapper]
            side_order.append(wrapper)
            assert proposal['unchanged_wrappers'][wrapper]['source_sha256'] == ORIGINAL_SHA[wrapper]
            assert proposal['unchanged_wrappers'][wrapper]['action'] == 'KEEP_EXISTING_SOURCE_BYTE_IDENTICAL'
            assert len(side_order) == 13
            covered = [i for row in side_coverage for i in range(row['global_start'], row['global_start'] + row['head_count'])]
            assert covered == list(range({'left': 360, 'right': 358}[side]))
            record = partition_record['sides'][side]
            assert record['covered_head_count'] == record['declared_vertex_count'] == {'left': 360, 'right': 358}[side]
            assert record['covered_unordered_pairs'] == record['declared_vertex_count'] * (record['declared_vertex_count'] - 1) // 2
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
        assert set(proposal['candidate_module_sha256']) == set(candidates) - {'SmallPairLightLeft46', 'SmallPairLightRight46'}
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
        foundation = verify_foundation(driver, module, latest, head, foundation_binding)
        assert foundation['proof_fingerprint'] == foundation_binding['foundation_proof_fingerprint']
        foundation['protected_files'][str(foundation_binding_path)] = sys.argv[2]
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
            'status': 'BOTH_SIDES_PREPARED_NOT_COMPILED', 'sides': list(SIDES), 'model': [1, 6],
            'original_parent_counts': {'left': [137, 223], 'right': [138, 220]}, 'heads_per_side': {'left': 360, 'right': 358},
            'coverage': coverage, 'targets': targets, 'scope_targets': scopes,
            'source_manifest': manifest, 'original_source_sha256': ORIGINAL_SHA,
            'payload_manifest_sha256': sys.argv[1], 'payload_plan_sha256': payload['PLAN.json'],
            'partition_coverage_sha256': payload['PARTITION_COVERAGE.json'],
            'source_evidence_sha256': payload['SOURCE_EVIDENCE.json'],
            'source_inspection_sha256': SOURCE_INSPECTION_SHA,
            'foundation_summary': foundation['summary_path'],
            'foundation_published_commit': foundation['publication']['commit'],
            'foundation_proof_fingerprint': foundation['proof_fingerprint'],
            'reviewed_foundation_binding_sha256': sys.argv[2],
            'base_commit': head, 'canonical_root_sha256': root_sha,
            'remainder_status': 'DEFERRED_UNTIL_ACTUAL_PILOT_BUILD_AND_REPLAY_MEASUREMENTS',
            'root_integration': False, 'whole_graph46_complete': False, 'main_theorem_complete': False,
        }

        def stable_before_mutation():
            assert git('rev-parse', 'HEAD') == head and file_sha(ROOT / '.git/index') == index_sha
            assert driver.queue_path.read_bytes() == queue_bytes and active_path.read_bytes() == active_bytes
            assert file_sha(ROOT / 'D1Bound5.lean') == root_sha
            assert manifest_path.read_bytes() == manifest_bytes
            assert foundation_binding_path.read_bytes() == foundation_binding_bytes
            assert all(file_sha(project_file(path)) == digest for path, digest in foundation_binding['files'].items())
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

        # Check every new destination before any metadata or source is written.
        new_outputs = ['QUEUE_BEFORE.json', 'ACTIVE_BEFORE.json', 'CONFIGURATION.json',
                       'FOUNDATION_REUSE_EVIDENCE.json', 'EXTERNAL_DEPENDENCY_GUARDS.json',
                       'PLAN.json', 'INSTALL_STARTED.json', 'QUEUE_AFTER.json', 'INSTALL_RECEIPT.json']
        new_outputs += [scope + '-TARGETS.json' for scope in scopes]
        absent_paths = [OUT / relative for relative in new_outputs]
        absent_paths += [ROOT / 'D1Bound5' / (name + '.lean') for name in new_parts]
        absent_paths += [ROOT / 'D1Bound5' / (name + '.lean.graph46-sides-install.' + str(os.getpid()))
                         for name in parent_insertions]
        absent_paths.append(driver.queue_path.with_name(driver.queue_path.name + '.tmp.' + str(os.getpid())))
        assert all(not path.exists() and not path.is_symlink() for path in absent_paths)
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
        assert all(not (ROOT / 'D1Bound5' / (name + '.lean')).exists() for name in new_parts)
        for name in targets:
            if name in ('SmallPairLightLeft46', 'SmallPairLightRight46'):
                continue
            destination = ROOT / 'D1Bound5' / (name + '.lean')
            if name not in ORIGINAL_SHA:
                copy_new(destination, candidates[name])
            else:
                temporary = destination.with_name(destination.name + '.graph46-sides-install.' + str(os.getpid()))
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
            'heads_per_side': {'left': 360, 'right': 358}, 'original_parent_counts': {'left': [137, 223], 'right': [138, 220]},
            'queue_entries_added': 20, 'queue_sha256_before': sha(queue_bytes),
            'queue_sha256_after': file_sha(driver.queue_path),
            'source_closure_modules': len(union), 'wrappers_unchanged': True,
            'foundation_proof_fingerprint': foundation['proof_fingerprint'],
            'reviewed_foundation_binding_sha256': sys.argv[2],
            'previous_accepted_sources_retained': True,
            'compiler_run': False, 'baseline_changed': False,
            'root_integration': False, 'whole_graph46_complete': False, 'main_theorem_complete': False,
        }
        write_new(OUT / 'INSTALL_RECEIPT.json', receipt)
        print(json.dumps(receipt), flush=True)


if __name__ == '__main__':
    main()
