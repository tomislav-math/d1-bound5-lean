"""Shared guarded graph1 closure metadata and completed-scope verification.

Importing this module performs no filesystem access or subprocess operation.
The installer must hold both project locks before verifying prerequisites.
"""
from pathlib import Path
import hashlib
import json
import os
import re
import subprocess


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')

R = Path('/Users/tp/Lean/D1Bound5')
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = C / '20261022-graph1-closure'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
TOOLCHAIN_SHA = '3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71'
LAKE_MANIFEST_SHA = '7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4'
SCRIPT_NAMES = {
    'closure_inputs.py', 'generate_proposal.py', 'closure_runtime.py', 'installer.py',
    'bounded_build_template.py', 'prepare_checks.py', 'finish_checks.py', 'build_scope.py',
}
FOUNDATION_TARGETS = [
    'SmallPairLightData1Left', 'SmallPairLightData1LeftRows',
    'SmallPairLightData1Right', 'SmallPairLightData1RightRows',
    'SmallPairLightData1', 'SmallPairLightAdaptiveData1', 'SmallPairLightAdaptiveValidation1',
]
SIDE_SCOPES = {'sides-pilot': ['SmallPairLightAdaptiveLeft1_000Part00', 'SmallPairLightAdaptiveRight1_000Part00']}
for side in ('left', 'right'):
    prefix = 'SmallPairLightAdaptive' + side.title() + '1_'
    SIDE_SCOPES[side + '-rest'] = (
        [prefix + '000Part' + f'{number:02d}' for number in range(1, 6)] + [prefix + '000']
        + [prefix + '001Part' + f'{number:02d}' for number in range(4)]
        + [prefix + '001', 'SmallPairLight' + side.title() + '1']
    )
PREREQUISITES = {
    'foundation': {'directory': C / '20261022-graph1-foundation', 'targets': FOUNDATION_TARGETS,
                   'definitions': 19, 'theorems': 4, 'marker': 'GRAPH1_FOUNDATION_AXIOMS_PASS '},
    **{scope: {'directory': C / '20261022-graph1-sides', 'targets': targets,
               'definitions': 0, 'theorems': 2 if scope == 'sides-pilot' else 15,
               'marker': 'GRAPH1_SIDES_AXIOMS_PASS '} for scope, targets in SIDE_SCOPES.items()},
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


def scope_files(directory, scope, audit):
    return [directory / (scope + '-' + suffix + '.json') for suffix in (
        'VERIFICATION_SUMMARY', 'SOURCE_MAP', 'ACCEPTED_DEPENDENCY_EVIDENCE', 'PROOF_STATE', 'TARGETS'
    )] + [directory / 'CONFIGURATION.json'] + [audit / name for name in (
        'PREPARATION_BINDINGS.json', 'BOUND_AUDIT_FINAL.json', 'TARGETED_REPLAY_RECEIPTS.json',
        'TARGETED_REPLAY_GUARDS.json',
    )]


def verify_install_binding(directory=O):
    directory = Path(directory)
    assert directory.resolve() == O
    path = directory / 'INSTALL_BINDING.json'
    binding = load(repo_file(path))
    assert binding['schema'] == 1 and binding['status'] == 'REVIEWED_GRAPH1_CLOSURE_INSTALL_BINDING'
    assert re.fullmatch(r'[0-9a-f]{40}', binding['base_commit'])
    for key in ('proposal_plan_sha256', 'proposal_payload_sha256', 'canonical_root_sha256', 'queue_before_sha256',
                'provenance_binding_sha256'):
        assert isinstance(binding[key], str) and re.fullmatch(r'[0-9a-f]{64}', binding[key]), key
    assert sha(directory / 'PROVENANCE_BINDING.json') == binding['provenance_binding_sha256']
    assert binding['max_parallel'] == 1 and binding['target_timeout_seconds'] == 240
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
        audit = U / ('pro-graph1-' + scope + '-audit')
        expected_paths = {str(path.relative_to(R)) for path in scope_files(specification['directory'], scope, audit)}
        assert set(item['files']) == expected_paths
        for relative, expected in item['files'].items():
            assert re.fullmatch(r'[0-9a-f]{64}', expected) and sha(repo_file(relative)) == expected
    return binding


def verify_scope(directory, scope, targets, definitions, theorems, marker,
                 driver, module, configuration, committed_head=None):
    """Reconstruct a completed scope's proof state and protect its actual evidence."""
    directory = Path(directory)
    audit = U / ('pro-graph1-' + scope + '-audit')
    summary = load(directory / (scope + '-VERIFICATION_SUMMARY.json'))
    assert summary['status'] == 'SCOPED_VERIFICATION_PASS'
    assert summary['targets'] == load(directory / (scope + '-TARGETS.json')) == targets
    assert len(targets) == len(set(targets))
    assert summary['definitions'] == definitions and summary['theorems'] == theorems
    assert summary['declarations'] == definitions + theorems and summary['public_headers_exact'] is True
    assert summary['guarded_builds'] == summary['targeted_same_kernel_replays'] == len(targets)
    assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
    assert summary['whole_graph1_complete'] is False and summary['audit'] == str(audit.relative_to(R))
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
    sources = load(directory / (scope + '-SOURCE_MAP.json'))['sources']
    evidence = load(directory / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
    assert set(sources) == set(evidence)
    assert preparation['project_sources'] == {name: item['sha256'] for name, item in sources.items()}
    artifacts, latest = {}, driver.latest()
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
            assert item['assurance'] == 'guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
        if committed_head:
            commit, relative = ((committed_head, item['payload_path']) if 'payload_path' in item
                                else (item['base_commit'], item['base_path']))
            blob = subprocess.check_output(['git', 'show', commit + ':' + relative], cwd=R, timeout=30)
            assert digest(blob) == item['sha256'], name
    assert all(artifacts.get(path) == expected for path, expected in preparation['target_artifacts'].items())
    assert load(directory / 'CONFIGURATION.json') == configuration == driver.static
    assert driver.manifest_matches(configuration, cached=False)
    guards = load(audit / 'TARGETED_REPLAY_GUARDS.json')
    assert guards['project_sources'] == preparation['project_sources']
    assert guards['compiled_artifacts'] == artifacts and guards['immutable_inputs'] == configuration
    preparation_files = dict(preparation['files'])
    assert str(preparation_path) not in preparation_files
    preparation_files[str(preparation_path)] = sha(preparation_path)
    assert guards['preparation_files'] == preparation_files
    for record in load(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json'):
        assert sha(repo_file(record['original_path'])) == record['original_sha256']
        if 'origin_map_path' in record:
            assert sha(repo_file(record['origin_map_path'])) == record['origin_map_sha256']
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
    return {'proof_fingerprint': summary['proof_fingerprint'], 'protected_files': protected,
            'sources': {name: item['sha256'] for name, item in sources.items()}, 'artifacts': artifacts}


def verify_prerequisites(binding, driver, module):
    results, protected, sources, artifacts = {}, {}, {}, {}
    for scope, specification in PREREQUISITES.items():
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
    return {'scopes': results, 'protected_files': protected, 'sources': sources, 'artifacts': artifacts}
