"""Shared guarded graph46 closure metadata and completed-scope verification.

Importing this module performs no filesystem access or subprocess operation.
The installer must hold both project locks before verifying prerequisites.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys

from closure_inputs import (
    TARGET, RAW, RAW_GROUPS, ORIGINAL_PINS, MERGED_SHA, MERGED_BYTES,
    LITERAL_COUNTS, BROAD_INSPECTION_SHA, declarations, read_source,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = C / '20261022-graph46-closure'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
TOOLCHAIN_SHA = '3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71'
LAKE_MANIFEST_SHA = '7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4'
ROOT_SHA = '33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2'
FOUNDATION = C / '20261022-graph46-foundation'
SIDES = C / '20261022-graph46-sides'
FOUNDATION_INPUTS_SHA = '7bddb13018a45ef5f65aaf5b7f64d845e08cde31f91f64a0da23397f4e5c301f'
FOUNDATION_INSPECTION_SHA = 'e5ebda74206e24c4b086986c801753b4d5b99f5e77997a8402f44f252cd46d5b'
SIDE_PAYLOAD_SHA = '0a5f79888d094e6111fa6279bc14d72a784981734fe93735dc8c57f62308b3e3'
SOURCE_INSPECTION_SHA = 'a2e6cfff7ccb0c38a00459f711ef65a8784239a5db0e93d1b2239f7d5a774041'
PROPOSAL_PLAN_SHA = '371d93de63a74168ab771eef77537b47a4bd44941b6421f9c3de30870ffe6a43'
PROPOSAL_PAYLOAD_SHA = '0911a39d4056e8c7b9e44f3b835908dea0c91454848156ee79985f7feb2496c2'
CLOSURE_SCOPE_NAMES = ('closure-pilot', 'closure-rest', 'assembly')
SCRIPT_NAMES = {
    'closure_inputs.py', 'generate_proposal.py', 'closure_runtime.py', 'installer.py',
    'bounded_build_template.py', 'prepare_checks.py', 'finish_checks.py', 'build_scope.py',
}
FOUNDATION_TARGETS = [
    'SmallPairLightData46Left', 'SmallPairLightData46LeftRows',
    'SmallPairLightData46Right', 'SmallPairLightData46RightRows',
    'SmallPairLightData46', 'SmallPairLightAdaptiveData46', 'SmallPairLightAdaptiveValidation46',
]
SIDE_SCOPES = {'sides-pilot': ['SmallPairLightAdaptiveLeft46_000Part00', 'SmallPairLightAdaptiveRight46_000Part00']}
for side in ('left', 'right'):
    prefix = 'SmallPairLightAdaptive' + side.title() + '46_'
    SIDE_SCOPES[side + '-rest'] = (
        [prefix + '000Part' + f'{number:02d}' for number in range(1, 6)] + [prefix + '000']
        + [prefix + '001Part' + f'{number:02d}' for number in range(4)]
        + [prefix + '001', 'SmallPairLight' + side.title() + '46']
    )
PREREQUISITES = {
    'foundation': {'directory': C / '20261022-graph46-foundation', 'targets': FOUNDATION_TARGETS,
                   'definitions': 19, 'theorems': 4, 'marker': 'GRAPH46_FOUNDATION_AXIOMS_PASS '},
    **{scope: {'directory': C / '20261022-graph46-sides', 'targets': targets,
               'definitions': 0, 'theorems': 2 if scope == 'sides-pilot' else 15,
               'marker': 'GRAPH46_SIDES_AXIOMS_PASS '} for scope, targets in SIDE_SCOPES.items()},
}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    path = Path(path)
    assert path.is_file() and not path.is_symlink(), str(path)
    return digest(path.read_bytes())


def load(path):
    return json.loads(Path(path).read_text())


def fingerprint(value):
    return digest(json.dumps(value, sort_keys=True, separators=(',', ':')).encode())


def repo_file(value):
    path = Path(value)
    path = path if path.is_absolute() else R / path
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve()), str(path)
    return path


def git(*arguments):
    return subprocess.check_output(['git', *arguments], cwd=R, text=True, timeout=30).strip()


def no_live_project_compiler():
    output = subprocess.check_output(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True, timeout=10)
    for line in output.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid():
            continue
        pid, _, executable, _ = fields
        if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
            continue
        process = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                                 capture_output=True, text=True, timeout=10)
        if process.returncode and subprocess.run(['ps', '-p', pid, '-o', 'pid='],
                capture_output=True, timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify live compiler cwd: ' + pid)
        assert not any(item == 'n' + str(R) or item.startswith('n' + str(R) + '/')
                       for item in process.stdout.splitlines()), 'Another project compiler: ' + pid


def merge(destination, incoming):
    for key, value in incoming.items():
        assert key not in destination or destination[key] == value, key
        destination[key] = value


def scope_counts(plan):
    """Return counts from an actual proposal; callers verify its saved bytes."""
    assert set(plan['scopes']) == set(plan['scope_counts']) == set(CLOSURE_SCOPE_NAMES)
    result = {}
    for scope, targets in plan['scopes'].items():
        item = plan['scope_counts'][scope]
        assert set(item) == {'targets', 'definitions', 'theorems', 'declarations'}
        assert all(type(value) is int and value >= 0 for value in item.values())
        assert item['targets'] == len(targets) == len(set(targets))
        assert item['declarations'] == item['definitions'] + item['theorems']
        result[scope] = (item['targets'], item['definitions'], item['theorems'])
    assert sum(item[0] for item in result.values()) == len(plan['build_order'])
    return result


def verify_proposal(binding):
    """Regenerate the complete actual proposal without running Git or Lean."""
    from generate_proposal import build_candidates, COVERAGE_TEMPLATE_SHA
    assert binding['source_inspection_sha256'] == SOURCE_INSPECTION_SHA
    assert binding['proposal_plan_sha256'] == PROPOSAL_PLAN_SHA
    assert binding['proposal_payload_sha256'] == PROPOSAL_PAYLOAD_SHA
    proposal = O / 'proposal'
    protected = {}

    def protect(path, expected=None):
        path = repo_file(path)
        actual = sha(path)
        assert expected is None or actual == expected, str(path)
        merge(protected, {str(path): actual})
        return path

    proposed = load(protect(proposal / 'PLAN.json', binding['proposal_plan_sha256']))
    payload = load(protect(proposal / 'PAYLOAD_SHA256.json', binding['proposal_payload_sha256']))
    for relative, expected in payload.items():
        path = Path(relative)
        assert not path.is_absolute() and '..' not in path.parts
        assert re.fullmatch(r'[0-9a-f]{64}', expected)
        value = protect(proposal / path, expected)
        assert value.resolve().is_relative_to(proposal.resolve())
    merged = protect(proposal / (TARGET + '.merged.before.lean'), MERGED_SHA).read_bytes()
    assert len(merged) == MERGED_BYTES
    archived = {name: protect(proposal / 'originals' / (name + '.lean'), pin[0]).read_bytes()
                for name, pin in ORIGINAL_PINS.items()}
    template = protect(proposal / 'COVERAGE_TEMPLATE.before.lean', COVERAGE_TEMPLATE_SHA).read_bytes()
    inspection, originals, candidates, regenerated = build_candidates(merged, archived, template)
    assert regenerated == proposed
    assert inspection == load(protect(proposal / 'SOURCE_INSPECTION.json'))
    narrow = protect(O / 'SOURCE_INSPECTION.json', binding['source_inspection_sha256'])
    assert load(narrow) == inspection
    assert inspection['broad_inspection_sha256'] == BROAD_INSPECTION_SHA
    expected_paths = {'PLAN.json', 'SOURCE_INSPECTION.json', 'DECLARATION_ORIGINS.json',
                      'INPUT_PROVENANCE.json', 'COVERAGE_TEMPLATE.before.lean',
                      TARGET + '.merged.before.lean'}
    expected_paths |= {'originals/' + name + '.lean' for name in originals}
    expected_paths |= {'candidates/' + name + '.lean' for name in candidates}
    expected_paths |= {scope + '-TARGETS.json' for scope in proposed['scopes']}
    assert set(payload) == expected_paths
    assert load(protect(proposal / 'DECLARATION_ORIGINS.json')) == proposed['origins']
    for name, data in originals.items():
        assert protect(proposal / 'originals' / (name + '.lean'), digest(data)).read_bytes() == data
    for name, data in candidates.items():
        assert protect(proposal / 'candidates' / (name + '.lean'), digest(data)).read_bytes() == data
        assert proposed['source_manifest'][name] == digest(data)
    counts = scope_counts(proposed)
    names = []
    for scope, targets in proposed['scopes'].items():
        assert load(protect(proposal / (scope + '-TARGETS.json'))) == targets
        found = [item for name in targets for item in declarations(candidates[name].decode())]
        assert counts[scope] == (len(targets), sum(item['kind'] == 'def' for item in found),
                                sum(item['kind'] == 'theorem' for item in found))
        names.extend(item['name'] for item in found)
    assert len(names) == len(set(names))
    assert len(names) == inspection['declaration_counts']['total'] + len(proposed['prefix_parts']) + 1
    provenance = load(protect(proposal / 'INPUT_PROVENANCE.json'))
    archive = W / 'prepared-light-remaining39/D1Bound5'
    assert provenance['merged_path'] == str(R / 'D1Bound5' / (TARGET + '.lean'))
    assert provenance['archive_directory'] == str(archive)
    assert provenance['coverage_template_path'] == str(R / 'D1Bound5/SmallPairGraphClosure29Coverage.lean')
    expected_sources = {provenance['merged_path']: MERGED_SHA,
                        provenance['coverage_template_path']: COVERAGE_TEMPLATE_SHA}
    expected_sources.update({str(archive / (name + '.lean')): pin[0] for name, pin in ORIGINAL_PINS.items()})
    assert provenance['source_sha256'] == expected_sources
    # The current merged project source becomes a facade after installation.
    # Every archived original and the coverage template remain immutable.
    for path, expected in expected_sources.items():
        if path != provenance['merged_path']:
            protect(path, expected)
    return proposed, inspection, protected


def scope_files(directory, scope, audit):
    return [directory / (scope + '-' + suffix + '.json') for suffix in (
        'VERIFICATION_SUMMARY', 'SOURCE_MAP', 'ACCEPTED_DEPENDENCY_EVIDENCE', 'PROOF_STATE', 'TARGETS',
        'PREPARATION',
    )] + [directory / 'CONFIGURATION.json'] + [audit / name for name in (
        'PREPARATION_BINDINGS.json', 'BOUND_AUDIT_FINAL.json', 'TARGETED_REPLAY_RECEIPTS.json',
        'TARGETED_REPLAY_GUARDS.json', 'SCOPED_ORIGINAL_DECLARATIONS.json', 'DECLARATION_NAMES.json',
    )]


def reviewed_foundation_files():
    """Exact file set of the frozen graph46 sides foundation-binding interface."""
    paths = [FOUNDATION / name for name in (
        'foundation-VERIFICATION_SUMMARY.json', 'foundation-SOURCE_MAP.json',
        'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json', 'foundation-PROOF_STATE.json',
        'CONFIGURATION.json', 'foundation-TARGETS.json', 'foundation-PREPARATION.json',
        'GRAPH46_BINDING.json', 'PROVENANCE_BINDING.json', 'SOURCE_INSPECTION.json',
        'REVIEWED_SCRIPT_PINS.json', 'PREPARED_PAYLOAD_SHA256.json',
        'PLAN.json', 'INSTALL_RECEIPT.json', 'DECLARATION_ORIGINS.json',
    )]
    audit = U / 'pro-graph46-foundation-audit'
    paths += [audit / name for name in (
        'PREPARATION_BINDINGS.json', 'BOUND_AUDIT_FINAL.json', 'TARGETED_REPLAY_RECEIPTS.json',
        'TARGETED_REPLAY_GUARDS.json', 'PROVENANCE_BINDING_USED.json', 'SCOPED_ORIGINAL_DECLARATIONS.json',
    )]
    paths += publication_files('foundation')
    return paths


def prerequisite_metadata():
    """Read exact completed-phase inputs without requiring their old HEAD now."""
    protected = {}

    def protect(path, expected=None):
        path = repo_file(path)
        actual = sha(path)
        assert expected is None or actual == expected, str(path)
        merge(protected, {str(path): actual})
        return path

    helper_path = protect(FOUNDATION / 'foundation_inputs.py', FOUNDATION_INPUTS_SHA)
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location('graph46_closure_foundation_inputs', helper_path)
    helper = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = helper
    spec.loader.exec_module(helper)
    assert helper.REPOSITORY == R and helper.TARGETS == FOUNDATION_TARGETS
    input_binding, foundation_plan, foundation_payload = helper.verify_prepared(FOUNDATION)
    protect(FOUNDATION / 'SOURCE_INSPECTION.json', FOUNDATION_INSPECTION_SHA)
    for relative, expected in foundation_payload.items():
        protect(FOUNDATION / relative, expected)
    for filename in ('PREPARED_PAYLOAD_SHA256.json', 'INSTALL_RECEIPT.json', 'CONFIGURATION.json'):
        protect(FOUNDATION / filename)
    installation = load(FOUNDATION / 'INSTALL_RECEIPT.json')
    assert installation['status'] == 'EXACT_GRAPH46_LITERAL_PARTITION_INSTALLED_NOT_BUILT'
    assert installation['source_manifest'] == foundation_plan['source_manifest']
    assert installation['plan_sha256'] == sha(FOUNDATION / 'PLAN.json')
    assert installation['prepared_payload_sha256'] == sha(FOUNDATION / 'PREPARED_PAYLOAD_SHA256.json')
    assert installation['input_binding_sha256'] == sha(FOUNDATION / 'GRAPH46_BINDING.json')
    assert foundation_plan['configuration'] == input_binding['configuration'] == load(FOUNDATION / 'CONFIGURATION.json')
    assert foundation_plan['canonical_root_sha256'] == input_binding['canonical_root_sha256'] == ROOT_SHA
    for entry in load(FOUNDATION / 'PROVENANCE_BINDING.json')['source_maps']:
        protect(entry['path'], entry['sha256'])
    foundation_counts = input_binding['source_evidence']['declaration_counts']
    specifications = {
        'foundation': {'directory': FOUNDATION, 'targets': foundation_plan['targets'],
                       'definitions': foundation_counts['definitions'], 'theorems': foundation_counts['theorems'],
                       'marker': 'GRAPH46_FOUNDATION_AXIOMS_PASS '},
    }
    side_payload_path = protect(SIDES / 'payload/PAYLOAD_SHA256.json', SIDE_PAYLOAD_SHA)
    side_payload = load(side_payload_path)
    for relative, expected in side_payload.items():
        path = Path(relative)
        assert not path.is_absolute() and '..' not in path.parts
        protect(SIDES / 'payload' / path, expected)
    side_proposal = load(SIDES / 'payload/PLAN.json')
    assert side_proposal['status'] == 'PREPARED_NOT_BUILT'
    assert side_proposal['model'] == {'tau': 1, 'nu': 6}
    assert side_proposal['source_inspection_sha256'] == BROAD_INSPECTION_SHA
    assert side_proposal['source_evidence_sha256'] == sha(SIDES / 'payload/SOURCE_EVIDENCE.json')
    side_source_evidence = load(SIDES / 'payload/SOURCE_EVIDENCE.json')
    assert side_source_evidence['source_inspection_sha256'] == BROAD_INSPECTION_SHA
    assert side_source_evidence['original_foundation_source_sha256'] == input_binding['source_evidence']['original_source_manifest']
    side_sources = dict(side_proposal['candidate_module_sha256'])
    side_sources.update({name: item['source_sha256'] for name, item in side_proposal['unchanged_wrappers'].items()})
    side_plan = load(protect(SIDES / 'PLAN.json'))
    side_installation = load(protect(SIDES / 'INSTALL_RECEIPT.json'))
    reviewed_foundation = load(protect(SIDES / 'REVIEWED_FOUNDATION_BINDING.json'))
    assert reviewed_foundation['schema'] == 1 and reviewed_foundation['status'] == 'REVIEWED_FOUNDATION_BINDING'
    assert reviewed_foundation['graph'] == 46
    assert re.fullmatch(r'[0-9a-f]{40}', reviewed_foundation['base_commit'])
    assert re.fullmatch(r'[0-9a-f]{40}', reviewed_foundation['foundation_published_commit'])
    assert reviewed_foundation['root_integration'] is False and reviewed_foundation['main_theorem_complete'] is False
    assert set(reviewed_foundation['files']) == {str(path.relative_to(R)) for path in reviewed_foundation_files()}
    for path, expected in reviewed_foundation['files'].items():
        protect(path, expected)
    assert side_plan['status'] == 'BOTH_SIDES_PREPARED_NOT_COMPILED'
    assert side_installation['status'] == 'BOTH_SIDE_PARTITIONS_INSTALLED_NOT_COMPILED'
    assert side_plan['base_commit'] == side_installation['base_commit'] == reviewed_foundation['base_commit']
    assert side_plan['foundation_published_commit'] == reviewed_foundation['foundation_published_commit']
    assert side_plan['foundation_proof_fingerprint'] == reviewed_foundation['foundation_proof_fingerprint']
    assert side_installation['foundation_proof_fingerprint'] == reviewed_foundation['foundation_proof_fingerprint']
    assert side_plan['reviewed_foundation_binding_sha256'] == side_installation['reviewed_foundation_binding_sha256'] == sha(SIDES / 'REVIEWED_FOUNDATION_BINDING.json')
    assert side_plan['payload_manifest_sha256'] == side_installation['payload_manifest_sha256'] == SIDE_PAYLOAD_SHA
    assert side_plan['payload_plan_sha256'] == sha(SIDES / 'payload/PLAN.json')
    assert side_plan['source_manifest'] == side_installation['source_manifest'] == side_sources
    assert side_plan['model'] == [1, 6] and side_plan['heads_per_side'] == {'left': 360, 'right': 358}
    assert side_plan['original_parent_counts'] == {'left': [137, 223], 'right': [138, 220]}
    assert side_plan['scope_targets'] == side_installation['scope_targets'] == SIDE_SCOPES
    assert side_proposal['pilot_targets'] == SIDE_SCOPES['sides-pilot']
    for side in ('left', 'right'):
        assert side_proposal['nominal_remainder_targets'][side] == SIDE_SCOPES[side + '-rest']
    for item in (side_plan, side_installation):
        assert item['root_integration'] is False and item['main_theorem_complete'] is False
        assert item['whole_graph46_complete'] is False
    assert side_plan['canonical_root_sha256'] == ROOT_SHA
    assert set(side_sources) == {name for targets in SIDE_SCOPES.values() for name in targets}
    for name, expected in side_sources.items():
        candidate = protect(SIDES / 'candidates' / (name + '.lean'), expected)
        original = protect(SIDES / 'originals' / (name + '.lean'))
        expected_original = side_plan['original_source_sha256'].get(name, expected)
        assert sha(original) == expected_original
        expected_path = (SIDES / 'payload/candidates' / (name + '.lean') if name in side_proposal['candidate_module_sha256']
                         else SIDES / 'payload/originals' / (name + '.lean'))
        assert candidate.read_bytes() == expected_path.read_bytes()
        if name in side_plan['original_source_sha256']:
            assert original.read_bytes() == (SIDES / 'payload/originals' / (name + '.lean')).read_bytes()
    for filename in ('CONFIGURATION.json', 'FOUNDATION_REUSE_EVIDENCE.json',
                     'EXTERNAL_DEPENDENCY_GUARDS.json', 'QUEUE_BEFORE.json', 'QUEUE_AFTER.json'):
        protect(SIDES / filename)
    for scope, targets in SIDE_SCOPES.items():
        found = [item for name in targets for item in declarations((SIDES / 'candidates' / (name + '.lean')).read_text())]
        specifications[scope] = {
            'directory': SIDES, 'targets': targets,
            'definitions': sum(item['kind'] == 'def' for item in found),
            'theorems': sum(item['kind'] == 'theorem' for item in found), 'marker': 'GRAPH46_SIDES_AXIOMS_PASS ',
        }
    assert specifications == PREREQUISITES
    return specifications, protected


def publication_files(group):
    assert group in ('foundation', 'sides')
    folder = C / ('20261022-graph46-' + group + '-publication')
    return [folder / name for name in ('POST_PUSH_RECEIPT.json', 'OWNER.json', 'RELEASE.json',
                                      'SELECTED_FILES_SHA256.json', 'STAGING_PATHS.txt')]


def verify_publication(group, head, reviewed, evidence_paths):
    """Require actual private publication and released ownership, using read-only Git."""
    paths = publication_files(group)
    assert set(reviewed['files']) == {str(path.relative_to(R)) for path in paths}
    for path, expected in reviewed['files'].items():
        assert re.fullmatch(r'[0-9a-f]{64}', expected) and sha(repo_file(path)) == expected
    receipt, owner, release = map(load, paths[:3])
    assert receipt['status'] == 'PRIVATE_PUSH_VERIFIED'
    assert receipt['commit_exit'] == receipt['push_exit'] == receipt['staged_count'] == 0
    assert receipt['repository'] == 'tomislav-math/d1-bound5-lean' and receipt['visibility'] == 'PRIVATE'
    assert receipt['selected_committed_blobs_match'] is True
    assert receipt['root_integration'] is False and receipt['main_theorem_complete'] is False
    published = receipt['local_head']
    assert re.fullmatch(r'[0-9a-f]{40}', published)
    assert receipt['remote_head'] == reviewed['commit'] == published
    assert subprocess.run(['git', 'merge-base', '--is-ancestor', published, head],
                          cwd=R, capture_output=True, timeout=30).returncode == 0
    assert owner['active'] is False and owner['reason'] == 'released'
    assert owner['timeout_seconds'] == 240 and owner['child_processes'] == []
    assert isinstance(release, dict)
    selected, staging = load(paths[3]), paths[4].read_text().splitlines()
    assert isinstance(selected, dict) and selected
    assert len(staging) == len(set(staging)) == receipt['selected_files']
    assert set(staging) == set(selected) | {str(path.relative_to(R)) for path in paths[3:]}
    for relative, expected in selected.items():
        path = Path(relative)
        assert not path.is_absolute() and not any(part in ('.git', '.lake', '..') for part in path.parts)
        assert re.fullmatch(r'[0-9a-f]{64}', expected)
        blob = subprocess.check_output(['git', 'show', published + ':' + relative], cwd=R, timeout=30)
        assert digest(blob) == expected, relative
    for path in paths[3:]:
        blob = subprocess.check_output(['git', 'show', published + ':' + str(path.relative_to(R))], cwd=R, timeout=30)
        assert digest(blob) == sha(path)
    for path in evidence_paths:
        path = repo_file(path)
        relative = str(path.relative_to(R))
        assert relative in selected and selected[relative] == sha(path), relative
        blob = subprocess.check_output(['git', 'show', published + ':' + relative], cwd=R, timeout=30)
        assert digest(blob) == sha(path), relative
    return {'commit': published, 'receipt_sha256': sha(paths[0]),
            'protected_files': {str(path): sha(path) for path in paths},
            'owner_inactive_and_released': True, 'selected_committed_blobs_match': True}


def verify_original_attempts(driver, module):
    """Protect historical receipts; the new facade never erases failed attempts."""
    path = O / 'installation/ORIGINAL_ATTEMPTS_BEFORE.json'
    record = load(repo_file(path))
    assert record['schema'] == 1 and record['status'] == 'ACTUAL_PREINSTALL_ATTEMPT_HISTORY'
    assert record['original_source_sha256'] == MERGED_SHA and record['original_target'] == TARGET
    assert record['original_target_closure'][TARGET] == MERGED_SHA
    assert module.fingerprint(record['original_target_closure']) == record['original_target_fingerprint']
    actual_rows = load(repo_file(driver.state_path))
    assert actual_rows == driver.rows, 'Driver receipt cache differs from current stored receipts'
    count = record['prior_receipt_count']
    assert type(count) is int and 0 <= count <= len(actual_rows)
    assert fingerprint(actual_rows[:count]) == record['prior_receipts_fingerprint']
    assert sha(driver.baseline_path) == record['baseline_sha256']
    assert load(driver.baseline_path) == driver.baseline
    latest = {(item['name'], item['fingerprint']): item for item in actual_rows}
    original_latest = {(item['name'], item['fingerprint']): item for item in actual_rows[:count]}
    assert len(record['target_names']) == len(set(record['target_names']))
    assert set(record['proposed_fingerprints']) == set(record['target_names'])
    assert all(re.fullmatch(r'[0-9a-f]{64}', key) and (name, key) not in original_latest
               for name, key in record['proposed_fingerprints'].items())
    assert record['previous_receipts_changed'] is False and record['compiler_started'] is False
    keys = set()
    for item in record['attempts']:
        key = (item['name'], item['fingerprint'])
        assert key not in keys and key[0] in record['target_names']
        assert re.fullmatch(r'[0-9a-f]{64}', key[1])
        keys.add(key)
        assert latest.get(key) == item['receipt'], 'Historical attempt changed: ' + str(key)
    assert keys == {key for key in original_latest if key[0] in record['target_names']}
    for path, expected in record['protected_attempt_files'].items():
        assert sha(repo_file(path)) == expected
    for value in record['absent_attempt_files']:
        path = Path(value)
        assert path.is_absolute() and path.resolve().is_relative_to(W.resolve())
        assert not path.exists() and not path.is_symlink()
    return record


def verify_install_binding(directory=O):
    directory = Path(directory)
    assert directory.resolve() == O
    path = directory / 'INSTALL_BINDING.json'
    binding = load(repo_file(path))
    assert binding['schema'] == 1 and binding['status'] == 'REVIEWED_GRAPH46_CLOSURE_INSTALL_BINDING'
    assert re.fullmatch(r'[0-9a-f]{40}', binding['base_commit'])
    for key in ('proposal_plan_sha256', 'proposal_payload_sha256', 'source_inspection_sha256', 'canonical_root_sha256', 'queue_before_sha256',
                'provenance_binding_sha256'):
        assert isinstance(binding[key], str) and re.fullmatch(r'[0-9a-f]{64}', binding[key]), key
    assert sha(directory / 'PROVENANCE_BINDING.json') == binding['provenance_binding_sha256']
    provenance = load(directory / 'PROVENANCE_BINDING.json')
    assert provenance['schema'] == 1 and provenance['status'] == 'COMMITTED_PROVENANCE_BOUND'
    assert provenance['base_commit'] == binding['base_commit']
    assert provenance['root_integration'] is False and provenance['main_theorem_complete'] is False
    assert set(provenance['external_modules_by_scope']) == set(CLOSURE_SCOPE_NAMES)
    maps = provenance['source_maps']
    assert maps and len(maps) == len({item['path'] for item in maps})
    for item in maps:
        path = Path(item['path'])
        assert not path.is_absolute() and '..' not in path.parts
        assert re.fullmatch(r'[0-9a-f]{64}', item['sha256']) and sha(repo_file(path)) == item['sha256']
        assert len(item['scopes']) == len(set(item['scopes'])) and set(item['scopes']) == set(CLOSURE_SCOPE_NAMES)
    assert binding['max_parallel'] == 1 and binding['target_timeout_seconds'] == 240
    assert binding['canonical_root_sha256'] == ROOT_SHA
    assert sha(directory / 'SOURCE_INSPECTION.json') == binding['source_inspection_sha256']
    assert binding['root_integration'] is False and binding['main_theorem_complete'] is False
    assert binding['driver_sha256'] == DRIVER_SHA and binding['audit_runner_sha256'] == RUNNER_SHA
    configuration = binding['configuration']
    assert isinstance(configuration, dict) and configuration['lean-toolchain'] == TOOLCHAIN_SHA
    assert configuration['lake-manifest.json'] == LAKE_MANIFEST_SHA
    assert set(binding['script_pins']) == SCRIPT_NAMES
    for name, expected in binding['script_pins'].items():
        assert re.fullmatch(r'[0-9a-f]{64}', expected) and sha(directory / name) == expected, name
    assert set(binding['prerequisite_scopes']) == set(PREREQUISITES)
    for scope, specification in PREREQUISITES.items():
        item = binding['prerequisite_scopes'][scope]
        assert re.fullmatch(r'[0-9a-f]{64}', item['proof_fingerprint'])
        audit = U / ('pro-graph46-' + scope + '-audit')
        expected_paths = {str(path.relative_to(R)) for path in scope_files(specification['directory'], scope, audit)}
        assert set(item['files']) == expected_paths
        for relative, expected in item['files'].items():
            assert re.fullmatch(r'[0-9a-f]{64}', expected) and sha(repo_file(relative)) == expected
    specifications, prerequisite_inputs = prerequisite_metadata()
    assert specifications == PREREQUISITES
    assert binding['prerequisite_inputs'] == {str(Path(path).relative_to(R)): expected
                                             for path, expected in prerequisite_inputs.items()}
    assert set(binding['prerequisite_publications']) == {'foundation', 'sides'}
    for group, item in binding['prerequisite_publications'].items():
        assert re.fullmatch(r'[0-9a-f]{40}', item['commit'])
        assert set(item['files']) == {str(path.relative_to(R)) for path in publication_files(group)}
        for relative, expected in item['files'].items():
            assert re.fullmatch(r'[0-9a-f]{64}', expected) and sha(repo_file(relative)) == expected
    baseline = binding['baseline_endpoint_inventory']
    assert baseline['accepted'] == sorted(set(baseline['accepted']))
    assert all(type(number) is int and 1 <= number <= 48 for number in baseline['accepted'])
    assert 46 not in baseline['accepted']
    assert baseline['total_endpoints'] == 48 and baseline['root_integration'] is False
    assert baseline['main_theorem_complete'] is False
    assert baseline['schema'] == 1 and baseline['status'] == 'ACTUAL_PREINSTALL_WORKING_ENDPOINT_INVENTORY'
    assert baseline['accepted_count'] == len(baseline['accepted'])
    assert baseline['remaining'] == sorted(set(range(1, 49)) - set(baseline['accepted']))
    assert set(baseline['evidence']) == {str(number) for number in baseline['accepted']}
    assert re.fullmatch(r'[0-9a-f]{64}', baseline['driver_receipts_sha256'])
    assert re.fullmatch(r'[0-9a-f]{64}', baseline['trusted_baseline_sha256'])
    return binding


def verify_scope(directory, scope, targets, definitions, theorems, marker,
                 driver, module, configuration, committed_head=None):
    """Reconstruct a completed scope's proof state and protect its actual evidence."""
    directory = Path(directory)
    audit = U / ('pro-graph46-' + scope + '-audit')
    summary = load(directory / (scope + '-VERIFICATION_SUMMARY.json'))
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert summary['targets'] == load(directory / (scope + '-TARGETS.json')) == targets
    assert len(targets) == len(set(targets))
    assert summary['definitions'] == definitions and summary['theorems'] == theorems
    assert summary['declarations'] == definitions + theorems and summary['public_headers_exact'] is True
    assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == len(targets)
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['whole_graph46_complete'] is False and summary['audit'] == str(audit.relative_to(R))
    plan = load(directory / 'PLAN.json')
    assert summary['base_commit'] == plan['base_commit']
    assert set(targets) <= set(plan['source_manifest'])
    if directory == FOUNDATION:
        assert summary['input_binding_sha256'] == sha(FOUNDATION / 'GRAPH46_BINDING.json')
    elif directory == O:
        assert summary['install_binding_sha256'] == sha(O / 'INSTALL_BINDING.json')
    assert not load(audit / 'active-targeted-replay.json')['active']
    receipts = load(audit / 'TARGETED_REPLAY_RECEIPTS.json')
    final = load(audit / 'BOUND_AUDIT_FINAL.json')
    assert final['status'] == 'BOUND_SCOPED_AUDIT_PASS' and final['records'] == receipts
    assert final['main_theorem_claim'] is False
    assert [item['label'] for item in receipts] == ['analytic-type-axioms'] + [name + '-targeted-replay' for name in targets]
    assert all(item['exit'] == 0 and not item['timed_out'] and item['guards_unchanged']
               and not item['binding_drift_paths'] for item in receipts)
    assert (audit / 'analytic-type-axioms.log').read_text().count(marker) == definitions + theorems
    preparation_path = audit / 'PREPARATION_BINDINGS.json'
    preparation = load(preparation_path)
    assert preparation['schema'] == 1 and preparation['audit_folder'] == str(audit.resolve())
    assert preparation['targets'] == preparation['replays'] == targets
    assert final['binding_sha256'] == sha(preparation_path)
    assert final['source_map_sha256'] == sha(audit / 'SOURCE_MAP.json')
    protected = {str(repo_file(path)): expected for path, expected in preparation['files'].items()}
    assert all(sha(path) == expected for path, expected in protected.items())
    commands = [['/Users/tp/.elan/bin/lake', 'env', 'lean', str(audit / 'AnalyticAudit.lean')]]
    commands += [['/Users/tp/.elan/bin/lake', 'env', 'leanchecker', '--verbose', 'D1Bound5.' + name]
                 for name in targets]
    for receipt, command in zip(receipts, commands):
        assert receipt['command'] == command and receipt['log'] == receipt['label'] + '.log'
        log = repo_file(audit / receipt['log'])
        protected[str(log)] = sha(log)
    active_replay = repo_file(audit / 'active-targeted-replay.json')
    protected[str(active_replay)] = sha(active_replay)
    source_map = load(directory / (scope + '-SOURCE_MAP.json'))
    assert source_map['base_commit'] == summary['base_commit']
    sources = source_map['sources']
    evidence = load(directory / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
    assert set(sources) == set(evidence)
    assert set(targets) <= set(sources) and len(sources) == summary['source_closure_modules']
    assert preparation['project_sources'] == {name: item['sha256'] for name, item in sources.items()}
    artifacts, target_artifacts, latest = {}, {}, driver.latest()
    for name, item in sources.items():
        assert item['path'] == 'D1Bound5/' + name + '.lean' and sha(repo_file(item['path'])) == item['sha256']
        key = module.fingerprint(driver.closure(name))
        manifest = driver.expected_manifest(name, key, latest)
        assert manifest and key == evidence[name]['fingerprint']
        assert manifest == evidence[name]['artifacts'] == driver.artifacts(name)
        for path, expected in manifest.items():
            assert path not in artifacts or artifacts[path] == expected
            artifacts[path] = expected
        if name in targets:
            merge(target_artifacts, manifest)
            assert item['assurance'] == 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
            assert item['sha256'] == plan['source_manifest'][name]
            row = load(directory / (name + '-BUILD_RECEIPT.json'))
            closure = driver.closure(name)
            assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
            assert row['timed_out'] is False and row['interrupted'] is False and row['timeout_seconds'] == 240
            assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
            assert row['source_sha256'] == item['sha256'] and row['fingerprint'] == key and row['artifacts'] == manifest
            assert latest.get((name, key)) == row
            assert load(directory / (name + '-SOURCE_CLOSURE.json')) == load(directory / (name + '-ORIGINAL_SOURCES.json')) == closure
            assert sha(directory / (name + '.lean')) == sha(directory / 'candidates' / (name + '.lean')) == item['sha256']
            for suffix in ('.lean', '-BUILD_RECEIPT.json', '-SOURCE_CLOSURE.json', '-ORIGINAL_SOURCES.json', '-build.log'):
                path = repo_file(directory / (name + suffix))
                protected[str(path)] = sha(path)
        if committed_head:
            commit, relative = ((committed_head, item['payload_path']) if 'payload_path' in item
                                else (item['base_commit'], item['base_path']))
            blob = subprocess.check_output(['git', 'show', commit + ':' + relative], cwd=R, timeout=30)
            assert digest(blob) == item['sha256'], name
    assert preparation['target_artifacts'] == target_artifacts
    assert all(artifacts.get(path) == expected for path, expected in target_artifacts.items())
    assert load(directory / 'CONFIGURATION.json') == configuration == driver.static
    assert driver.manifest_matches(configuration, cached=False)
    guards = load(audit / 'TARGETED_REPLAY_GUARDS.json')
    assert guards['project_sources'] == preparation['project_sources']
    assert guards['compiled_artifacts'] == artifacts and guards['immutable_inputs'] == configuration
    preparation_files = dict(preparation['files'])
    assert str(preparation_path) not in preparation_files
    preparation_files[str(preparation_path)] = sha(preparation_path)
    assert guards['preparation_files'] == preparation_files
    records = load(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json')
    assert [record['module'] for record in records] == targets
    declaration_names = []
    for record in records:
        name = record['module']
        assert sha(repo_file(record['original_path'])) == record['original_sha256']
        assert repo_file(record['original_source_path']) == repo_file(record['original_path'])
        assert record['current_sha256'] == sources[name]['sha256']
        assert record['normalizations'] == []
        before = declarations(repo_file(record['original_path']).read_text())
        current = declarations(repo_file(sources[name]['path']).read_text())
        available = {item['name']: item for item in before}
        selected = [available[item['name']] for item in record['declarations']]
        assert len(current) == len(selected) == len(record['declarations'])
        for old, original, now in zip(record['declarations'], selected, current):
            assert all(original.get(key) == value and now.get(key) == value for key, value in old.items()), name
        if 'declaration_source_sha256' in record:
            assert record['declaration_source_sha256'] == {item['name']: digest(item['source_text'].encode()) for item in selected}
        declaration_names.extend(item['name'] for item in selected)
        if 'origin_map_path' in record:
            assert sha(repo_file(record['origin_map_path'])) == record['origin_map_sha256']
    assert declaration_names == load(audit / 'DECLARATION_NAMES.json')
    assert len(declaration_names) == len(set(declaration_names)) == definitions + theorems
    assert sum(item['kind'] == 'def' for record in records for item in record['declarations']) == definitions
    assert sum(item['kind'] == 'theorem' for record in records for item in record['declarations']) == theorems
    if scope == 'foundation' or scope in CLOSURE_SCOPE_NAMES:
        used_path = repo_file(audit / 'PROVENANCE_BINDING_USED.json')
        used = load(used_path)
        assert used['binding_sha256'] == sha(directory / 'PROVENANCE_BINDING.json')
        protected[str(used_path)] = sha(used_path)
        protected[str(directory / 'PROVENANCE_BINDING.json')] = used['binding_sha256']
        for path, expected in used['source_maps'].items():
            assert sha(repo_file(path)) == expected
            protected[str(repo_file(path))] = expected
    state = {
        'sources': [[name, item['sha256']] for name, item in sorted(sources.items())],
        'configuration': configuration,
        'build_fingerprints': {name: evidence[name]['fingerprint'] for name in targets},
        'artifact_fingerprints': {name: evidence[name]['artifacts'] for name in targets},
        'audit_harness_sha256': sha(audit / 'AnalyticAudit.lean'),
        'accepted_checks': [{key: item[key] for key in ('label', 'exit', 'guards_unchanged')} for item in receipts],
    }
    assert load(directory / (scope + '-PROOF_STATE.json')) == state
    assert fingerprint(state) == summary['proof_fingerprint']
    for path in scope_files(directory, scope, audit):
        protected[str(path)] = sha(path)
        if committed_head:
            relative = str(path.relative_to(R))
            blob = subprocess.check_output(['git', 'show', committed_head + ':' + relative], cwd=R, timeout=30)
            assert digest(blob) == sha(path), relative
    assert all(sha(repo_file(path)) == expected for path, expected in protected.items())
    assert driver.manifest_matches(artifacts, cached=False)
    return {'proof_fingerprint': summary['proof_fingerprint'], 'protected_files': protected,
            'sources': {name: item['sha256'] for name, item in sources.items()}, 'artifacts': artifacts}


def verify_prerequisites(binding, driver, module):
    results, protected, sources, artifacts = {}, {}, {}, {}
    specifications, inputs = prerequisite_metadata()
    assert binding['prerequisite_inputs'] == {str(Path(path).relative_to(R)): expected for path, expected in inputs.items()}
    merge(protected, inputs)
    for scope, specification in specifications.items():
        result = verify_scope(specification['directory'], scope, specification['targets'],
                              specification['definitions'], specification['theorems'], specification['marker'],
                              driver, module, binding['configuration'], binding['base_commit'])
        assert result['proof_fingerprint'] == binding['prerequisite_scopes'][scope]['proof_fingerprint']
        for destination, incoming in ((protected, result['protected_files']), (sources, result['sources']),
                                      (artifacts, result['artifacts'])):
            for key, expected in incoming.items():
                assert key not in destination or destination[key] == expected
                destination[key] = expected
        results[scope] = result['proof_fingerprint']
    publications = {}
    for group, directory in (('foundation', FOUNDATION), ('sides', SIDES)):
        paths = [Path(path) for path in inputs if Path(path).is_relative_to(directory)]
        for scope, specification in specifications.items():
            if specification['directory'] == directory:
                paths.extend(scope_files(directory, scope, U / ('pro-graph46-' + scope + '-audit')))
        publications[group] = verify_publication(group, binding['base_commit'],
                                                 binding['prerequisite_publications'][group], sorted(set(paths)))
        merge(protected, publications[group]['protected_files'])
    assert load(SIDES / 'REVIEWED_FOUNDATION_BINDING.json')['foundation_published_commit'] == publications['foundation']['commit']
    assert all(sha(repo_file(path)) == expected for path, expected in protected.items())
    assert driver.manifest_matches(artifacts, cached=False)
    return {'scopes': results, 'publications': publications, 'protected_files': protected,
            'sources': sources, 'artifacts': artifacts}
