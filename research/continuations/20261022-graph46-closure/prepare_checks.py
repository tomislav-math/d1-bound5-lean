"""Bind graph46 closure scopes to exact declarations and committed provenance.

This prepares audit inputs only. It does not start Lean, replay a target, change
the queue, or make a proof-acceptance claim.
"""
from pathlib import Path
import fcntl
import importlib.util
import json
import os
import re
import subprocess
import sys

from closure_inputs import (
    ORIGINAL_PINS, PROHIBITED, RAW, RAW_GROUPS, TARGET, declarations, digest,
    read_source, split_raw, top_imports,
)
from closure_runtime import (
    R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, load, sha, verify_install_binding,
    verify_proposal, verify_original_attempts, scope_counts,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True

COVERAGE = 'SmallPairGraphClosure46Coverage'
CLOSURE = 'SmallPairGraphClosure46'
SCOPE_NAMES = ('closure-pilot', 'closure-rest', 'assembly')


def put(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def absent(path):
    path = Path(path)
    assert not path.exists() and not path.is_symlink(), str(path)


def repo_file(path):
    path = Path(path)
    if not path.is_absolute():
        assert '..' not in path.parts
        path = R / path
    assert path.is_file() and not path.is_symlink(), str(path)
    assert path.resolve().is_relative_to(R.resolve()), str(path)
    return path


def git(*arguments):
    return subprocess.check_output(['git', *arguments], cwd=R, text=True, timeout=30).strip()


def no_compiler():
    output = subprocess.check_output(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True, timeout=10)
    for line in output.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid():
            continue
        pid, _, executable, _ = fields
        if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
            continue
        result = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                                capture_output=True, text=True, timeout=10)
        if result.returncode and subprocess.run(['ps', '-p', pid, '-o', 'pid='],
                capture_output=True, timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify live compiler cwd: ' + pid)
        assert not any(item == 'n' + str(R) or item.startswith('n' + str(R) + '/')
                       for item in result.stdout.splitlines()), 'Another project compiler: ' + pid


def public_record(declaration):
    return {key: value for key, value in declaration.items() if key != 'source_text'}


def protect_file(protected, path, expected=None):
    path = repo_file(path)
    actual = sha(path)
    assert expected is None or actual == expected, str(path)
    key = str(path)
    assert key not in protected or protected[key] == actual, key
    protected[key] = actual
    return path


def verify_target_builds(driver, module, plan, targets):
    """Require the actual accepted worker row and its immutable source snapshots."""
    latest, rows, protected = driver.latest(), {}, {}
    for name in targets:
        paths = {suffix: protect_file(protected, O / (name + suffix)) for suffix in (
            '-BUILD_RECEIPT.json', '-SOURCE_CLOSURE.json', '-ORIGINAL_SOURCES.json', '.lean', '-build.log',
        )}
        row = load(paths['-BUILD_RECEIPT.json'])
        closure = driver.closure(name)
        key = module.fingerprint(closure)
        assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
        assert row['timed_out'] is False and row['interrupted'] is False and row['timeout_seconds'] == 240
        assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
        assert row['source_sha256'] == closure[name] == plan['source_manifest'][name]
        assert row['fingerprint'] == key and latest.get((name, key)) == row
        assert load(paths['-SOURCE_CLOSURE.json']) == load(paths['-ORIGINAL_SOURCES.json']) == closure
        assert sha(paths['.lean']) == plan['source_manifest'][name]
        expected = driver.expected_manifest(name, key, latest)
        assert expected and expected == row['artifacts'] == driver.artifacts(name), name
        rows[name] = row
    assert all(sha(path) == expected for path, expected in protected.items())
    return rows, protected


def freeze_runtime_inputs(driver, binding, plan):
    """Capture the actual immutable inputs and idle driver/index state for this audit."""
    _, _, proposal_files = verify_proposal(binding)
    protected = {}
    for path, expected in proposal_files.items():
        protect_file(protected, path, expected)
    for filename in ('INSTALL_BINDING.json', 'PROVENANCE_BINDING.json', 'PLAN.json',
                     'SOURCE_INSPECTION.json', 'DECLARATION_ORIGINS.json', 'CONFIGURATION.json',
                     'bounded_build.py'):
        protect_file(protected, O / filename)
    for filename in ('INSTALL_BINDING_USED.json', 'SCRIPT_PINS.json', 'GUARDS_BEFORE.json',
                     'ACCEPTED_INPUT_EVIDENCE.json', 'QUEUE_BEFORE.json', 'QUEUE_AFTER.json',
                     'APPLICATION_RECEIPT.json', 'PREREQUISITES_VERIFIED.json', 'WORKER_SHA256.json',
                     'ORIGINAL_ATTEMPTS_BEFORE.json', TARGET + '.before.lean'):
        protect_file(protected, O / 'installation' / filename)
    for filename, expected in binding['script_pins'].items():
        protect_file(protected, O / filename, expected)
    for scope in plan['scopes']:
        protect_file(protected, O / (scope + '-TARGETS.json'))
    for name, expected in plan['source_manifest'].items():
        protect_file(protected, R / 'D1Bound5' / (name + '.lean'), expected)
        protect_file(protected, O / 'candidates' / (name + '.lean'), expected)
    for name, expected in {**plan['original_source_manifest'], **plan['reviewed_helper_source_manifest']}.items():
        protect_file(protected, O / 'originals' / (name + '.lean'), expected)
    for entry in load(O / 'PROVENANCE_BINDING.json')['source_maps']:
        protect_file(protected, entry['path'], entry['sha256'])
    for prerequisite in binding['prerequisite_scopes'].values():
        for path, expected in prerequisite['files'].items():
            protect_file(protected, path, expected)
    protect_file(protected, W / 'continuation_driver_capacity.py', DRIVER_SHA)
    protect_file(protected, U / 'bound_scoped_audit_runner_proposal_v1.py', RUNNER_SHA)
    protect_file(protected, R / 'D1Bound5.lean', binding['canonical_root_sha256'])
    index = Path(git('rev-parse', '--git-path', 'index'))
    protect_file(protected, index if index.is_absolute() else R / index)
    for path in (driver.queue_path, driver.active_path, driver.state_path, driver.baseline_path):
        protect_file(protected, path)
    assert driver.rows == load(driver.state_path) and driver.baseline == load(driver.baseline_path)
    assert all(sha(path) == expected for path, expected in protected.items())
    return protected


def check_origins(plan):
    """Verify every original declaration once, including untrimmed raw bodies."""
    inspection = load(repo_file(O / 'SOURCE_INSPECTION.json'))
    parts, rows = plan['prefix_parts'], inspection['closure_rows']
    assert type(rows) is int and rows > 0
    chunks = [part['module'] for part in parts]
    assert parts == [
        {'module': 'SmallPairGraphClosure46Chunk' + f'{index:02d}', 'offset': offset,
         'count': min(64, rows - offset)} for index, offset in enumerate(range(0, rows, 64))
    ]
    helpers = chunks + [COVERAGE]
    core = ['SmallPairGraphInputs46', 'SmallPairGraphWitnessData46'] + chunks + [COVERAGE, CLOSURE]
    assembly = ['SmallPairGraphArithmetic46'] + list(RAW_GROUPS) + [
        RAW, 'SmallPairLightAssembly46', 'SmallPairGraphTriangle46', TARGET,
    ]
    order = core + assembly
    scopes = {'closure-pilot': core[:2] + [chunks[0], COVERAGE],
              'closure-rest': chunks[1:] + [CLOSURE], 'assembly': assembly}
    assert plan['build_order'] == order and len(order) == len(set(order))
    assert plan['scopes'] == scopes and set(scopes) == set(SCOPE_NAMES)
    counts = scope_counts(plan)
    original_counts = inspection['declaration_counts']
    assert all(type(value) is int and value >= 0 for value in original_counts.values())
    assert original_counts['total'] == original_counts['definitions'] + original_counts['theorems']
    assert plan['original_public_declarations'] == original_counts['total']
    assert plan['closure_rows'] == rows and plan['filtered_vertices'] == inspection['filtered_vertices']
    assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
    assert plan['exact_merged_reconstruction'] is True
    assert plan['all_original_literal_definitions_byte_identical'] is True
    assert plan['both_mutation_signs_and_global_indices_preserved'] is True
    origins = load(O / 'DECLARATION_ORIGINS.json')
    assert origins == plan['origins'] and set(origins) == set(plan['source_manifest']) == set(order)
    original_manifest = plan['original_source_manifest']
    helper_manifest = plan['reviewed_helper_source_manifest']
    assert original_manifest == {name: value[0] for name, value in ORIGINAL_PINS.items()}
    assert set(helper_manifest) == set(helpers) and len(helper_manifest) == len(parts) + 1
    assert inspection['original_source_manifest'] == original_manifest
    assert inspection['original_merged_sha256'] == plan['original_merged_sha256']
    assert inspection['original_merged_bytes'] == plan['original_merged_bytes']
    assert inspection['proposed_prefix_parts'] == plan['prefix_parts']
    assert inspection['proposed_terminal_drop'] == rows and inspection['exact_merged_reconstruction'] is True
    partition = plan['raw_literal_partition']
    assert partition == inspection['raw_literal_partition']
    assert partition['original_module'] == RAW and partition['groups'] == RAW_GROUPS
    assert partition['exact_byte_reconstruction'] is True
    assert partition['original_imports_preserved_in_each_data_module'] is True
    manifests = {**original_manifest, **helper_manifest}
    original_bytes, raw = {}, {}
    for name, expected in manifests.items():
        path = repo_file(O / 'originals' / (name + '.lean'))
        data = read_source(path)
        assert digest(data) == expected, name
        if name in ORIGINAL_PINS:
            assert len(data) == ORIGINAL_PINS[name][1], name
        original_bytes[name] = data
        raw[name] = declarations(data.decode())
        assert len(raw[name]) == len({item['local_name'] for item in raw[name]})
        if name in ORIGINAL_PINS:
            assert [public_record(item) for item in raw[name]] == inspection['original_declarations'][name]
            assert {item['name']: digest(item['source_text'].encode()) for item in raw[name]} == \
                inspection['merged_segments'][name]['declaration_source_sha256']
        else:
            assert len(raw[name]) == 1 and raw[name][0]['kind'] == 'theorem'
    original_declarations = [item for name in ORIGINAL_PINS for item in raw[name]]
    assert len(original_declarations) == len({item['name'] for item in original_declarations}) == original_counts['total']
    assert [item['raw_header'] for item in original_declarations] == plan['original_public_headers']
    assert sum(item['kind'] == 'def' for item in original_declarations) == original_counts['definitions']
    assert sum(item['kind'] == 'theorem' for item in original_declarations) == original_counts['theorems']
    fragments, blocks, prefix, suffix = split_raw(original_bytes[RAW])
    assert partition['definition_sha256'] == {name: digest(data) for name, data in blocks.items()}
    assert partition['prefix_sha256'] == digest(prefix) and partition['suffix_sha256'] == digest(suffix)
    assert partition['source_manifest'] == {name: digest(data) for name, data in fragments.items()}
    assert partition['source_bytes'] == {name: len(data) for name, data in fragments.items()}
    selected, assigned = {}, {name: [] for name in manifests}
    for name in order:
        expected_origin = RAW if name in RAW_GROUPS or name == RAW else name
        expected_mode = ('exact_declaration_source' if name in RAW_GROUPS else
                         'imports_only_wrapper' if name == RAW else
                         'original_headers_only' if name == CLOSURE else
                         'new_reviewed_helper' if name in helpers else 'exact_module_bytes')
        expected_names = (RAW_GROUPS[name] if name in RAW_GROUPS else [] if name == RAW else
                          [item['local_name'] for item in raw[expected_origin]])
        assert origins[name] == {'original_module': expected_origin, 'names': expected_names,
                                 'preservation': expected_mode}, name
        available = {item['local_name']: item for item in raw[expected_origin]}
        before = [available[local_name] for local_name in expected_names]
        assigned[expected_origin].extend(expected_names)
        candidate = repo_file(O / 'candidates' / (name + '.lean'))
        candidate_bytes = read_source(candidate)
        assert digest(candidate_bytes) == plan['source_manifest'][name], name
        assert len(candidate_bytes) == plan['source_bytes'][name], name
        assert read_source(repo_file('D1Bound5/' + name + '.lean')) == candidate_bytes, name
        after = declarations(candidate_bytes.decode())
        assert [public_record(item) for item in before] == [public_record(item) for item in after], name
        if expected_mode == 'original_headers_only':
            assert len(before) == 2 and before[1]['source_text'] == after[1]['source_text'], name
            marker = b'theorem smallPairClosure_46_checked'
            assert candidate_bytes[candidate_bytes.index(marker):] == original_bytes[name][original_bytes[name].index(marker):]
        elif expected_mode == 'imports_only_wrapper':
            assert not before and candidate_bytes == ''.join(
                'import D1Bound5.' + module + '\n' for module in RAW_GROUPS).encode()
        else:
            assert before == after, name
            if expected_mode in ('exact_module_bytes', 'new_reviewed_helper'):
                assert candidate_bytes == original_bytes[expected_origin], name
            else:
                assert candidate_bytes == fragments[name]
                assert top_imports(candidate_bytes)[0] == top_imports(original_bytes[RAW])[0]
                for item in before:
                    assert digest(item['source_text'].encode()) == partition['definition_sha256'][item['local_name']]
        assert not re.search(PROHIBITED, candidate_bytes), name
        selected[name] = before
    for name, names in assigned.items():
        assert names == [item['local_name'] for item in raw[name]], name
    all_declarations = [item for name in order for item in selected[name]]
    assert len(all_declarations) == len({item['name'] for item in all_declarations}) == original_counts['total'] + len(helpers)
    assert sum(item['kind'] == 'def' for item in all_declarations) == original_counts['definitions']
    assert sum(item['kind'] == 'theorem' for item in all_declarations) == original_counts['theorems'] + len(helpers)
    for scope, targets in scopes.items():
        found = [item for name in targets for item in selected[name]]
        assert counts[scope] == (len(targets), sum(item['kind'] == 'def' for item in found),
                                 sum(item['kind'] == 'theorem' for item in found))
    return origins, manifests, selected


def check_installation(driver):
    """Check the installed proposal, pinned runtime, queue, root, and accepted inputs."""
    binding = verify_install_binding()
    proposed, inspection, proposal_files = verify_proposal(binding)
    installation = O / 'installation'
    assert read_source(O / 'INSTALL_BINDING.json') == read_source(installation / 'INSTALL_BINDING_USED.json')
    scripts = load(installation / 'SCRIPT_PINS.json')
    assert scripts == binding['script_pins']
    assert all(sha(repo_file(O / name)) == expected for name, expected in scripts.items())
    proposal = O / 'proposal'
    assert proposed['status'] == 'REVIEWED_GRAPH46_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED'
    provenance = load(proposal / 'INPUT_PROVENANCE.json')
    expected_plan = dict(proposed)
    expected_plan.update(
        status='REVIEWED_GRAPH46_RESTORATION_NOT_BUILT', base_commit=binding['base_commit'],
        canonical_root_sha256=binding['canonical_root_sha256'], configuration=binding['configuration'],
        install_binding_sha256=sha(repo_file(O / 'INSTALL_BINDING.json')),
        proposal_plan_sha256=binding['proposal_plan_sha256'],
        proposal_payload_sha256=binding['proposal_payload_sha256'],
        source_provenance=provenance['source_sha256'],
    )
    plan = load(O / 'PLAN.json')
    assert plan == expected_plan
    assert load(O / 'SOURCE_INSPECTION.json') == inspection
    scope_counts(plan)
    assert load(O / 'DECLARATION_ORIGINS.json') == plan['origins']
    for scope, targets in plan['scopes'].items():
        assert load(O / (scope + '-TARGETS.json')) == targets
    for name, expected in plan['source_manifest'].items():
        assert sha(repo_file(O / 'candidates' / (name + '.lean'))) == expected
        assert sha(repo_file('D1Bound5/' + name + '.lean')) == expected
    for name, expected in {**plan['original_source_manifest'], **plan['reviewed_helper_source_manifest']}.items():
        assert sha(repo_file(O / 'originals' / (name + '.lean'))) == expected
    assert sha(repo_file(installation / (TARGET + '.before.lean'))) == inspection['original_merged_sha256']
    template = read_source(O / 'bounded_build_template.py').decode()
    placeholder = '__REVIEWED_SOURCE_PINS__'
    assert template.count(placeholder) == 1
    pins = {name: plan['source_manifest'][name] for name in plan['build_order']}
    worker = template.replace(placeholder, repr(pins)).encode()
    assert read_source(O / 'bounded_build.py') == worker
    assert load(installation / 'WORKER_SHA256.json') == {
        'sha256': digest(worker), 'template_sha256': sha(O / 'bounded_build_template.py'),
    }
    guards = load(installation / 'GUARDS_BEFORE.json')
    assert guards['head'] == binding['base_commit']
    assert plan['configuration'] == guards['configuration'] == binding['configuration']
    assert driver.static == binding['configuration'] == load(O / 'CONFIGURATION.json')
    assert driver.manifest_matches(binding['configuration'], cached=False)
    assert plan['canonical_root_sha256'] == guards['canonical_root_sha256'] == binding['canonical_root_sha256']
    assert sha(repo_file('D1Bound5.lean')) == plan['canonical_root_sha256']
    application = load(installation / 'APPLICATION_RECEIPT.json')
    assert application['status'] == 'GRAPH46_RESTORED_UNCOMPILED'
    assert application['compiler_started'] is False and application['both_locks_held'] is True
    assert application['complete_rows'] == inspection['closure_rows']
    assert application['filtered_vertices'] == inspection['filtered_vertices']
    assert application['original_declarations_preserved'] == inspection['declaration_counts']['total']
    assert application['new_modules'] == [name for name in plan['build_order'] if name != TARGET]
    assert application['partition_counts'] == [part['count'] for part in plan['prefix_parts']]
    assert application['raw_data_modules'] == list(RAW_GROUPS)
    assert application['all_original_literal_definitions_byte_identical'] is True
    assert application['both_mutation_signs_and_global_indices_preserved'] is True
    history_path = repo_file(installation / 'ORIGINAL_ATTEMPTS_BEFORE.json')
    history = load(history_path)
    assert application['original_attempt_history_sha256'] == sha(history_path)
    assert application['previous_attempts_preserved'] is True
    assert history['target_names'] == plan['build_order']
    assert history['original_target_closure'] == guards['original_target_closure']
    assert application['proposed_fingerprints'] == history['proposed_fingerprints']
    assert set(application['proposed_fingerprints']) == set(plan['build_order'])
    prerequisite_fingerprints = {scope: item['proof_fingerprint'] for scope, item in binding['prerequisite_scopes'].items()}
    assert application['prerequisite_scope_fingerprints'] == prerequisite_fingerprints
    assert load(installation / 'PREREQUISITES_VERIFIED.json')['scopes'] == prerequisite_fingerprints
    assert application['install_binding_sha256'] == sha(repo_file(O / 'INSTALL_BINDING.json'))
    assert application['root_integration'] is False and application['main_theorem_complete'] is False
    assert sha(repo_file(installation / 'QUEUE_BEFORE.json')) == binding['queue_before_sha256']
    expected_queue = json.dumps(load(installation / 'QUEUE_AFTER.json'), indent=2, sort_keys=True).encode()
    assert read_source(driver.queue_path) == expected_queue
    queue = json.loads(expected_queue)
    before_queue = load(installation / 'QUEUE_BEFORE.json')
    assert queue['names'] == before_queue['names'] + application['new_modules']
    assert {key: value for key, value in queue.items() if key != 'names'} == \
        {key: value for key, value in before_queue.items() if key != 'names'}
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert set(plan['build_order']) <= set(queue['names']) and len(queue['names']) == len(set(queue['names']))
    assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected
               for name, expected in guards['accepted_sources'].items())
    assert driver.manifest_matches(guards['accepted_artifacts'], cached=False)
    input_evidence = load(installation / 'ACCEPTED_INPUT_EVIDENCE.json')
    assert set(input_evidence) == set(guards['accepted_sources'])
    current_artifacts, latest = {}, driver.latest()
    for name, item in input_evidence.items():
        closure = driver.closure(name)
        assert closure[name] == guards['accepted_sources'][name]
        # Match the pinned driver's closure fingerprint serialization exactly.
        key = digest(json.dumps(closure, sort_keys=True).encode())
        assert key == item['fingerprint']
        manifest = driver.expected_manifest(name, key, latest)
        assert manifest and manifest == item['artifacts'] == driver.artifacts(name), name
        for path, expected in manifest.items():
            assert path not in current_artifacts or current_artifacts[path] == expected
            current_artifacts[path] = expected
    assert current_artifacts == guards['accepted_artifacts']
    assert all(sha(repo_file(path)) == expected for path, expected in proposal_files.items())
    return binding, plan


def main():
    assert Path(__file__).resolve().parent == O == C / '20261022-graph46-closure'
    assert len(sys.argv) == 2 and sys.argv[1] in SCOPE_NAMES
    scope = sys.argv[1]
    audit = U / ('pro-graph46-' + scope + '-audit')
    assert sha(repo_file(W / 'continuation_driver_capacity.py')) == DRIVER_SHA
    assert sha(repo_file(U / 'bound_scoped_audit_runner_proposal_v1.py')) == RUNNER_SHA
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        active_bytes = (W / 'continuation-active.json').read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        no_compiler()
        assert git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        base = git('rev-parse', 'HEAD')
        spec = importlib.util.spec_from_file_location('graph46_closure_prepare_driver', W / 'continuation_driver_capacity.py')
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)
        driver = module.Driver(R, W)
        install_binding, plan = check_installation(driver)
        assert base == install_binding['base_commit']
        targets = plan['scopes'][scope]
        assert load(O / (scope + '-TARGETS.json')) == targets
        protected = freeze_runtime_inputs(driver, install_binding, plan)
        original_attempts = verify_original_attempts(driver, module)
        assert original_attempts['target_names'] == plan['build_order']
        for path, expected in original_attempts['protected_attempt_files'].items():
            protect_file(protected, path, expected)
        origins, original_manifest, selected = check_origins(plan)
        build_rows, build_inputs = verify_target_builds(driver, module, plan, targets)
        for path, expected in build_inputs.items():
            protect_file(protected, path, expected)
        origin_sha = sha(repo_file(O / 'DECLARATION_ORIGINS.json'))
        latest = driver.latest()
        provenance_path = repo_file(O / 'PROVENANCE_BINDING.json')
        provenance_sha = sha(provenance_path)
        provenance_binding = load(provenance_path)
        assert provenance_binding['schema'] == 1 and provenance_binding['status'] == 'COMMITTED_PROVENANCE_BOUND'
        assert provenance_binding['base_commit'] == base
        required_maps = {str(C.relative_to(R) / '20261022-graph46-foundation/foundation-SOURCE_MAP.json')}
        required_maps |= {str(C.relative_to(R) / '20261022-graph46-sides' / (unit + '-SOURCE_MAP.json'))
                          for unit in ('sides-pilot', 'left-rest', 'right-rest')}
        assert required_maps <= {entry['path'] for entry in provenance_binding['source_maps']}
        oldmap, used_maps = {}, {}
        assert len(provenance_binding['source_maps']) == len({entry['path'] for entry in provenance_binding['source_maps']})
        for entry in provenance_binding['source_maps']:
            relative, expected = Path(entry['path']), entry['sha256']
            assert not relative.is_absolute() and '..' not in relative.parts
            assert isinstance(expected, str) and re.fullmatch(r'[0-9a-f]{64}', expected)
            assert isinstance(entry['scopes'], list) and entry['scopes']
            assert len(entry['scopes']) == len(set(entry['scopes'])) and set(entry['scopes']) <= set(plan['scopes'])
            if scope not in entry['scopes'] and str(relative) not in required_maps:
                continue
            path = repo_file(relative)
            assert sha(path) == expected, str(relative)
            protect_file(protected, path, expected)
            committed = subprocess.check_output(['git', 'show', base + ':' + str(relative)], cwd=R, timeout=15)
            assert digest(committed) == expected, 'Provenance map must be committed: ' + str(relative)
            assert str(relative) not in used_maps
            used_maps[str(relative)] = expected
            if scope in entry['scopes']:
                for name, item in load(path)['sources'].items():
                    oldmap[(name, item['sha256'])] = item
        assert required_maps <= set(used_maps)
        absent(audit)
        for suffix in ('TARGETS',):
            assert load(O / (scope + '-' + suffix + '.json')) == targets
        for suffix in ('SOURCE_MAP', 'ACCEPTED_DEPENDENCY_EVIDENCE', 'PREPARATION', 'PROOF_STATE', 'VERIFICATION_SUMMARY'):
            absent(O / (scope + '-' + suffix + '.json'))
        all_declarations, snapshots, audit_sources, receipt_map, records, union = [], {}, {}, {}, [], {}
        for name in targets:
            source = repo_file('D1Bound5/' + name + '.lean')
            current_sha = sha(source)
            assert current_sha == plan['source_manifest'][name] == sha(repo_file(O / 'candidates' / (name + '.lean')))
            row = build_rows[name]
            closure = load(repo_file(O / (name + '-SOURCE_CLOSURE.json')))
            assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
            assert row['timed_out'] is False and row['interrupted'] is False
            assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
            assert row['timeout_seconds'] == 240
            assert row['source_sha256'] == current_sha and driver.closure(name) == closure
            assert module.fingerprint(closure) == row['fingerprint'] and driver.artifacts(name) == row['artifacts']
            snapshots[name] = read_source(source)
            assert read_source(repo_file(O / (name + '.lean'))) == snapshots[name]
            for key, value in closure.items():
                assert key not in union or union[key] == value
                union[key] = value
            origin = origins[name]
            original = repo_file(O / 'originals' / (origin['original_module'] + '.lean'))
            assert sha(original) == original_manifest[origin['original_module']]
            before = selected[name]
            assert [public_record(item) for item in before] == [public_record(item) for item in declarations(snapshots[name].decode())]
            source_hashes = {item['name']: digest(item['source_text'].encode()) for item in before}
            public = [public_record(item) for item in before]
            audit_sources[name] = {'source': str(source.relative_to(R)),
                                   'snapshot': str((audit / (name + '.lean')).relative_to(R)), 'sha256': current_sha}
            receipt_map[name] = {'receipt': str((O / (name + '-BUILD_RECEIPT.json')).relative_to(R)),
                                 'closure': str((O / (name + '-SOURCE_CLOSURE.json')).relative_to(R))}
            records.append({'module': name, 'original_path': str(original), 'original_source_path': str(original),
                            'original_sha256': sha(original), 'current_sha256': current_sha,
                            'raw_original_module': origin['original_module'], 'preservation': origin['preservation'],
                            'origin_map_path': str(O / 'DECLARATION_ORIGINS.json'), 'origin_map_sha256': origin_sha,
                            'declaration_source_sha256': source_hashes, 'normalizations': [], 'declarations': public})
            all_declarations.extend(public)
        target_count, definitions, theorems = scope_counts(plan)[scope]
        names = [item['name'] for item in all_declarations]
        assert len(targets) == target_count and len(names) == len(set(names)) == definitions + theorems
        assert sum(item['kind'] == 'def' for item in all_declarations) == definitions
        assert sum(item['kind'] == 'theorem' for item in all_declarations) == theorems
        source_map, evidence, artifacts = {}, {}, {}
        for name, expected in sorted(union.items()):
            protect_file(protected, 'D1Bound5/' + name + '.lean', expected)
            closure = driver.closure(name)
            assert closure[name] == expected
            key = module.fingerprint(closure)
            manifest = driver.expected_manifest(name, key, latest)
            assert manifest and driver.artifacts(name) == manifest, name
            for path, value in manifest.items():
                assert path not in artifacts or artifacts[path] == value
                artifacts[path] = value
            if name in plan['source_manifest']:
                assert sha(repo_file(O / 'candidates' / (name + '.lean'))) == expected
                source_map[name] = {'path': 'D1Bound5/' + name + '.lean', 'sha256': expected,
                                    'payload_path': str((O / 'candidates' / (name + '.lean')).relative_to(R)),
                                    'assurance': 'guarded_build_pass_current_audit_pending'}
            else:
                item = oldmap[(name, expected)]
                commit, path = ((base, item['payload_path']) if 'payload_path' in item
                                else (item['base_commit'], item['base_path']))
                blob = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=R, timeout=15)
                assert digest(blob) == expected
                source_map[name] = {'path': 'D1Bound5/' + name + '.lean', 'sha256': expected,
                                    'base_commit': commit, 'base_path': path, 'assurance': 'reused_accepted_source_and_artifacts'}
            evidence[name] = {'fingerprint': key, 'artifacts': manifest,
                              'original_receipt': latest.get((name, key)),
                              'baseline_entry': None if (name, key) in latest else driver.baseline['accepted'][name]}
        harness = ''.join('import D1Bound5.' + name + '\n' for name in targets)
        harness += 'import Lean.Elab.Command\nimport Lean.Util.CollectAxioms\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
        harness += 'run_cmd do\n  let names : List Lean.Name := [\n    ' + ',\n    '.join('`' + name for name in names) + ']\n'
        harness += ('  for name in names do\n    let ax ← Lean.collectAxioms name\n'
                    '    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n'
                    '    unless bad.isEmpty do\n      Lean.throwError "Unexpected axioms in {name}: {bad}"\n'
                    '    Lean.logInfo m!"GRAPH46_CLOSURE_AXIOMS_PASS {name}: {ax}"\n\n')
        for item in all_declarations:
            harness += ('namespace ' + item['namespace'] + '\n' + '\n'.join(item['opens']) + '\nexample\n'
                        + item['header'] + ' :=\n  _root_.' + item['name'] + '\nend ' + item['namespace'] + '\n\n')
        harness += ''.join('#check @_root_.' + name + '\n' for name in names)
        assert re.findall(r'^example\s*(.*?)\s*:=', harness, re.M | re.S) == [item['header'] for item in all_declarations]
        assert sha(repo_file(O / 'DECLARATION_ORIGINS.json')) == origin_sha
        assert sha(provenance_path) == provenance_sha
        assert all(sha(repo_file(path)) == expected for path, expected in used_maps.items())
        assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected for name, expected in union.items())
        assert driver.manifest_matches(artifacts, cached=False)
        assert check_installation(driver) == (install_binding, plan)
        assert check_origins(plan) == (origins, original_manifest, selected)
        assert verify_target_builds(driver, module, plan, targets) == (build_rows, build_inputs)
        assert verify_original_attempts(driver, module) == original_attempts
        assert all(sha(path) == expected for path, expected in protected.items())
        assert (W / 'continuation-active.json').read_bytes() == active_bytes
        assert git('rev-parse', 'HEAD') == base and git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        no_compiler()
        absent(audit)
        for suffix in ('SOURCE_MAP', 'ACCEPTED_DEPENDENCY_EVIDENCE', 'PREPARATION', 'PROOF_STATE', 'VERIFICATION_SUMMARY'):
            absent(O / (scope + '-' + suffix + '.json'))
        audit.mkdir()
        for name, data in snapshots.items():
            with (audit / (name + '.lean')).open('xb') as stream:
                stream.write(data)
        with (audit / 'AnalyticAudit.lean').open('x') as stream:
            stream.write(harness)
        for filename, value in [('TARGETS.json', targets), ('REPLAY_TARGETS.json', targets),
                                ('SOURCE_MAP.json', audit_sources), ('BUILD_RECEIPT_MAP.json', receipt_map),
                                ('SCOPED_ORIGINAL_DECLARATIONS.json', records), ('DECLARATION_NAMES.json', names)]:
            put(audit / filename, value)
        put(audit / 'PROVENANCE_BINDING_USED.json', {'binding_sha256': provenance_sha, 'source_maps': used_maps})
        put(O / (scope + '-SOURCE_MAP.json'), {'base_commit': base, 'sources': source_map})
        put(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'), evidence)
        summary = {'targets': targets, 'declarations': len(names), 'definitions': definitions, 'theorems': theorems,
                   'source_closure_modules': len(union), 'audit': str(audit.relative_to(R)), 'public_headers_exact': True,
                   'base_commit': base, 'install_binding_sha256': sha(repo_file(O / 'INSTALL_BINDING.json')),
                   'root_integration': False, 'main_theorem_complete': False}
        put(O / (scope + '-PREPARATION.json'), summary)
        print(json.dumps({'status': 'ACCEPTED_UNIT_PREPARED_FOR_AUDIT', **summary}), flush=True)


if __name__ == '__main__':
    main()
