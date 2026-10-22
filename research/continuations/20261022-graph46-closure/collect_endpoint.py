"""Collect graph46's seven completed scopes using their actual bound plans.

Only two new endpoint records are written. No compiler, replay, Git operation,
source change, or queue change is launched. Importing this module is pure; the
inventory collector also reuses its filesystem-only evidence reconstruction.
"""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import importlib.util
import json
import re
import sys


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True

from closure_inputs import TARGET, RAW, RAW_GROUPS, ORIGINAL_PINS, declarations, digest
from closure_runtime import (
    R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, CLOSURE_SCOPE_NAMES,
    load, sha, fingerprint, verify_install_binding, verify_proposal, scope_counts,
    prerequisite_metadata, verify_original_attempts, verify_scope, no_live_project_compiler,
)


DRIVER = W / 'continuation_driver_capacity.py'
RUNNER = U / 'bound_scoped_audit_runner_proposal_v1.py'
ENDPOINT = TARGET
ENDPOINT_NUMBER = int(ENDPOINT.removeprefix('SmallPairGraphData'))
PREREQUISITE_ORDER = ('foundation', 'sides-pilot', 'left-rest', 'right-rest')
TOTAL_KEYS = ('definitions', 'theorems', 'declarations', 'guarded_builds',
              'targeted_same_kernel_replays', 'analytic_type_axiom_audits')


def relative(value):
    path = Path(value)
    assert not path.is_absolute() and '..' not in path.parts
    return path


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        path = R / relative(value)
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve()), str(path)
    return path


def merge(destination, values):
    for key, value in values.items():
        assert isinstance(value, str) and re.fullmatch(r'[0-9a-f]{64}', value), key
        assert key not in destination or destination[key] == value, key
        destination[key] = value


def protect(files, path, expected=None):
    path = repo_file(path)
    actual = sha(path)
    assert expected is None or actual == expected, str(path)
    merge(files, {str(path.relative_to(R)): actual})
    return path


def endpoint_metadata(files):
    """Bind exact originals, installed candidates and counts without Git or Lean."""
    binding = verify_install_binding()
    binding_path = protect(files, O / 'INSTALL_BINDING.json')
    proposed, inspection, proposal_files = verify_proposal(binding)
    prerequisites, prerequisite_files = prerequisite_metadata()
    for collection in (proposal_files, prerequisite_files):
        for path, expected in collection.items():
            protect(files, path, expected)
    for filename, expected in binding['script_pins'].items():
        protect(files, O / filename, expected)
    protect(files, O / 'PROVENANCE_BINDING.json', binding['provenance_binding_sha256'])
    for entry in load(O / 'PROVENANCE_BINDING.json')['source_maps']:
        protect(files, entry['path'], entry['sha256'])
    for group in ('prerequisite_scopes', 'prerequisite_publications'):
        for item in binding[group].values():
            for path, expected in item['files'].items():
                protect(files, path, expected)
    for path, expected in binding['prerequisite_inputs'].items():
        protect(files, path, expected)

    installation = O / 'installation'
    assert protect(files, installation / 'INSTALL_BINDING_USED.json', sha(binding_path)).read_bytes() == binding_path.read_bytes()
    assert load(protect(files, installation / 'SCRIPT_PINS.json')) == binding['script_pins']
    provenance = load(O / 'proposal/INPUT_PROVENANCE.json')
    expected_plan = dict(proposed)
    expected_plan.update(
        status='REVIEWED_GRAPH46_RESTORATION_NOT_BUILT', base_commit=binding['base_commit'],
        canonical_root_sha256=binding['canonical_root_sha256'], configuration=binding['configuration'],
        install_binding_sha256=sha(binding_path), proposal_plan_sha256=binding['proposal_plan_sha256'],
        proposal_payload_sha256=binding['proposal_payload_sha256'],
        source_provenance=provenance['source_sha256'],
    )
    plan = load(protect(files, O / 'PLAN.json'))
    assert plan == expected_plan
    assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
    assert plan['exact_merged_reconstruction'] is True
    assert plan['all_original_literal_definitions_byte_identical'] is True
    assert plan['both_mutation_signs_and_global_indices_preserved'] is True
    assert load(protect(files, O / 'DECLARATION_ORIGINS.json')) == plan['origins']
    assert set(plan['source_manifest']) == set(plan['origins']) == set(plan['build_order'])
    assert len(plan['build_order']) == len(set(plan['build_order']))
    before = protect(files, installation / (ENDPOINT + '.before.lean'), inspection['original_merged_sha256'])
    assert before.read_bytes() == (O / 'proposal' / (ENDPOINT + '.merged.before.lean')).read_bytes()
    assert len(before.read_bytes()) == inspection['original_merged_bytes']
    assert plan['closure_rows'] == inspection['closure_rows'] == inspection['proposed_terminal_drop']
    assert plan['filtered_vertices'] == inspection['filtered_vertices']
    assert plan['prefix_parts'] == inspection['proposed_prefix_parts']
    assert inspection['destination_index_min'] == 0
    assert inspection['destination_index_max'] == inspection['closure_rows'] - 1

    original_manifest = plan['original_source_manifest']
    helper_manifest = plan['reviewed_helper_source_manifest']
    assert original_manifest == inspection['original_source_manifest'] == {name: pin[0] for name, pin in ORIGINAL_PINS.items()}
    assert not set(original_manifest) & set(helper_manifest)
    assert len(helper_manifest) == len(plan['prefix_parts']) + 1
    original_bytes, original_declarations = {}, {}
    for name, expected in {**original_manifest, **helper_manifest}.items():
        data = protect(files, O / 'originals' / (name + '.lean'), expected).read_bytes()
        assert data == (O / 'proposal/originals' / (name + '.lean')).read_bytes()
        original_bytes[name] = data
        original_declarations[name] = declarations(data.decode())
    original_public = [item for name in ORIGINAL_PINS for item in original_declarations[name]]
    original_counts = inspection['declaration_counts']
    assert len(original_public) == len({item['name'] for item in original_public}) == original_counts['total']
    assert sum(item['kind'] == 'def' for item in original_public) == original_counts['definitions']
    assert sum(item['kind'] == 'theorem' for item in original_public) == original_counts['theorems']
    assert [item['raw_header'] for item in original_public] == plan['original_public_headers']
    assert len(original_public) == plan['original_public_declarations']
    selected, assigned = {}, {name: [] for name in original_bytes}
    for name in plan['build_order']:
        expected = plan['source_manifest'][name]
        candidate = protect(files, O / 'candidates' / (name + '.lean'), expected).read_bytes()
        assert candidate == (O / 'proposal/candidates' / (name + '.lean')).read_bytes()
        assert candidate == protect(files, 'D1Bound5/' + name + '.lean', expected).read_bytes()
        assert len(candidate) == plan['source_bytes'][name]
        origin = plan['origins'][name]
        available = {item['local_name']: item for item in original_declarations[origin['original_module']]}
        before_declarations = [available[local_name] for local_name in origin['names']]
        assigned[origin['original_module']].extend(origin['names'])
        current = declarations(candidate.decode())
        assert len(current) == len(before_declarations)
        assert [{key: value for key, value in item.items() if key != 'source_text'} for item in current] == [
            {key: value for key, value in item.items() if key != 'source_text'} for item in before_declarations]
        mode = origin['preservation']
        if mode == 'original_headers_only':
            assert name == 'SmallPairGraphClosure46' and len(before_declarations) >= 2
            assert current[1:] == before_declarations[1:]
            marker = before_declarations[1]['raw_header'].encode()
            original = original_bytes[origin['original_module']]
            assert candidate.count(marker) == original.count(marker) == 1
            assert candidate[candidate.index(marker):] == original[original.index(marker):]
        elif mode == 'imports_only_wrapper':
            assert name == RAW and not current
            assert candidate == ''.join('import D1Bound5.' + module + '\n' for module in RAW_GROUPS).encode()
        else:
            assert mode in ('exact_module_bytes', 'exact_declaration_source', 'new_reviewed_helper')
            assert current == before_declarations
            if mode in ('exact_module_bytes', 'new_reviewed_helper'):
                assert candidate == original_bytes[origin['original_module']]
        selected[name] = current
    for name, names in assigned.items():
        assert names == [item['local_name'] for item in original_declarations[name]]
    current_declarations = [item for name in plan['build_order'] for item in selected[name]]
    assert len(current_declarations) == len({item['name'] for item in current_declarations})
    assert len(current_declarations) == original_counts['total'] + len(helper_manifest)
    assert sum(item['kind'] == 'def' for item in current_declarations) == original_counts['definitions']
    assert sum(item['kind'] == 'theorem' for item in current_declarations) == original_counts['theorems'] + len(helper_manifest)

    template = (O / 'bounded_build_template.py').read_text()
    placeholder = '__REVIEWED_SOURCE_PINS__'
    assert template.count(placeholder) == 1
    pins = {name: plan['source_manifest'][name] for name in plan['build_order']}
    worker = template.replace(placeholder, repr(pins)).encode()
    assert protect(files, O / 'bounded_build.py', digest(worker)).read_bytes() == worker
    assert load(protect(files, installation / 'WORKER_SHA256.json')) == {
        'sha256': digest(worker), 'template_sha256': sha(O / 'bounded_build_template.py'),
    }
    assert load(protect(files, O / 'CONFIGURATION.json')) == binding['configuration']
    protect(files, R / 'D1Bound5.lean', binding['canonical_root_sha256'])

    assert set(prerequisites) == set(PREREQUISITE_ORDER)
    specifications = [(scope, prerequisites[scope]) for scope in PREREQUISITE_ORDER]
    counts = scope_counts(proposed)
    for scope in CLOSURE_SCOPE_NAMES:
        targets = plan['scopes'][scope]
        assert load(protect(files, O / (scope + '-TARGETS.json'))) == targets
        found = [item for name in targets for item in selected[name]]
        count, definitions, theorems = counts[scope]
        assert (len(targets), sum(item['kind'] == 'def' for item in found),
                sum(item['kind'] == 'theorem' for item in found)) == (count, definitions, theorems)
        specifications.append((scope, {'directory': O, 'targets': targets, 'definitions': definitions,
                                       'theorems': theorems, 'marker': 'GRAPH46_CLOSURE_AXIOMS_PASS '}))
    assert len(specifications) == 7
    targets = [name for _, specification in specifications for name in specification['targets']]
    assert len(targets) == len(set(targets)) and ENDPOINT in targets
    totals = {key: 0 for key in TOTAL_KEYS}
    for _, specification in specifications:
        count = len(specification['targets'])
        definitions, theorems = specification['definitions'], specification['theorems']
        assert type(definitions) is int and type(theorems) is int and min(definitions, theorems) >= 0
        totals['definitions'] += definitions
        totals['theorems'] += theorems
        totals['declarations'] += definitions + theorems
        totals['guarded_builds'] += count
        totals['targeted_same_kernel_replays'] += count
        totals['analytic_type_axiom_audits'] += 1
    assert totals['guarded_builds'] == len(targets)
    return {'binding': binding, 'plan': plan, 'inspection': inspection, 'specifications': specifications,
            'targets': targets, 'totals': totals, 'original_public_headers': plan['original_public_headers']}


def installation_evidence(metadata, driver, module, files):
    binding, plan, inspection = (metadata[key] for key in ('binding', 'plan', 'inspection'))
    installation = O / 'installation'
    paths = {filename: protect(files, installation / filename) for filename in (
        'GUARDS_BEFORE.json', 'ACCEPTED_INPUT_EVIDENCE.json', 'QUEUE_BEFORE.json', 'QUEUE_AFTER.json',
        'ACTIVE_BEFORE.json', 'APPLICATION_RECEIPT.json', 'PREREQUISITES_VERIFIED.json',
        'ORIGINAL_ATTEMPTS_BEFORE.json',
    )}
    guards, application = load(paths['GUARDS_BEFORE.json']), load(paths['APPLICATION_RECEIPT.json'])
    assert guards['head'] == binding['base_commit']
    assert guards['configuration'] == binding['configuration'] == driver.static
    assert guards['canonical_root_sha256'] == binding['canonical_root_sha256']
    assert application['status'] == 'GRAPH46_RESTORED_UNCOMPILED'
    assert application['compiler_started'] is False and application['both_locks_held'] is True
    assert application['root_integration'] is False and application['main_theorem_complete'] is False
    assert application['install_binding_sha256'] == sha(O / 'INSTALL_BINDING.json')
    assert application['complete_rows'] == inspection['closure_rows']
    assert application['filtered_vertices'] == inspection['filtered_vertices']
    assert application['original_declarations_preserved'] == inspection['declaration_counts']['total']
    assert application['partition_counts'] == [part['count'] for part in plan['prefix_parts']]
    assert application['raw_data_modules'] == list(RAW_GROUPS)
    assert application['all_original_literal_definitions_byte_identical'] is True
    assert application['both_mutation_signs_and_global_indices_preserved'] is True
    assert application['new_modules'] == [name for name in plan['build_order'] if name != ENDPOINT]
    fingerprints = {scope: item['proof_fingerprint'] for scope, item in binding['prerequisite_scopes'].items()}
    assert application['prerequisite_scope_fingerprints'] == fingerprints
    prerequisites = load(paths['PREREQUISITES_VERIFIED.json'])
    assert prerequisites['scopes'] == fingerprints
    for path, expected in prerequisites['protected_files'].items():
        protect(files, path, expected)
    assert sha(paths['QUEUE_BEFORE.json']) == binding['queue_before_sha256']
    queue, before_queue = load(paths['QUEUE_AFTER.json']), load(paths['QUEUE_BEFORE.json'])
    assert queue['names'] == before_queue['names'] + application['new_modules']
    assert len(queue['names']) == len(set(queue['names']))
    assert {key: value for key, value in queue.items() if key != 'names'} == {
        key: value for key, value in before_queue.items() if key != 'names'}
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert driver.queue_path.read_bytes() == json.dumps(queue, indent=2, sort_keys=True).encode()
    old_active = load(paths['ACTIVE_BEFORE.json'])
    assert not old_active.get('active') and not old_active.get('protected_closure')
    evidence = load(paths['ACCEPTED_INPUT_EVIDENCE.json'])
    assert set(evidence) == set(guards['accepted_sources'])
    artifacts, latest = {}, driver.latest()
    for name, item in evidence.items():
        closure = driver.closure(name)
        assert closure[name] == guards['accepted_sources'][name]
        protect(files, 'D1Bound5/' + name + '.lean', closure[name])
        key = module.fingerprint(closure)
        manifest = driver.expected_manifest(name, key, latest)
        assert key == item['fingerprint'] and manifest
        assert manifest == item['artifacts'] == driver.artifacts(name)
        merge(artifacts, manifest)
    assert artifacts == guards['accepted_artifacts']
    assert driver.manifest_matches(artifacts, cached=False)
    history = verify_original_attempts(driver, module)
    assert history['target_names'] == plan['build_order']
    assert history['original_target_closure'] == guards['original_target_closure']
    assert application['original_attempt_history_sha256'] == sha(paths['ORIGINAL_ATTEMPTS_BEFORE.json'])
    assert application['previous_attempts_preserved'] is True
    assert application['proposed_fingerprints'] == history['proposed_fingerprints']
    for name, key in history['proposed_fingerprints'].items():
        assert module.fingerprint(driver.closure(name)) == key
    for path, expected in history['protected_attempt_files'].items():
        protect(files, path, expected)
    return history


def collect_endpoint_state(driver, module):
    """Reconstruct the endpoint state from current completed evidence, read-only."""
    files, sources, artifacts, scope_evidence = {}, {}, {}, {}
    protect(files, DRIVER, DRIVER_SHA)
    protect(files, RUNNER, RUNNER_SHA)
    protect(files, __file__)
    metadata = endpoint_metadata(files)
    history = installation_evidence(metadata, driver, module, files)
    binding = metadata['binding']
    active = load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    queue, _, closures, accepted, _, _ = driver.snapshot()
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert set(metadata['targets']) <= accepted
    assert driver.rows == load(driver.state_path) and driver.baseline == load(driver.baseline_path)
    declaration_names, targets = [], []
    totals = {key: 0 for key in TOTAL_KEYS}
    for scope, specification in metadata['specifications']:
        folder, unit_targets = specification['directory'], specification['targets']
        definitions, theorems = specification['definitions'], specification['theorems']
        # Publication was already proved and hash-bound. Passing no HEAD keeps
        # this verification entirely independent of Git command execution.
        verified = verify_scope(folder, scope, unit_targets, definitions, theorems,
                                specification['marker'], driver, module, binding['configuration'],
                                committed_head=None)
        for path, expected in verified['protected_files'].items():
            protect(files, path, expected)
        merge(sources, verified['sources'])
        merge(artifacts, verified['artifacts'])
        assert set(verified['sources']) <= accepted
        if scope in binding['prerequisite_scopes']:
            assert verified['proof_fingerprint'] == binding['prerequisite_scopes'][scope]['proof_fingerprint']
        summary_path = protect(files, folder / (scope + '-VERIFICATION_SUMMARY.json'))
        summary = load(summary_path)
        audit = U / ('pro-graph46-' + scope + '-audit')
        protect(files, folder / 'PLAN.json')
        protect(files, audit / 'active-targeted-replay.json')
        assert load(protect(files, audit / 'TARGETS.json')) == unit_targets
        assert load(protect(files, audit / 'REPLAY_TARGETS.json')) == unit_targets
        records = load(audit / 'SCOPED_ORIGINAL_DECLARATIONS.json')
        names = load(audit / 'DECLARATION_NAMES.json')
        assert names == [item['name'] for record in records for item in record['declarations']]
        assert not set(names) & set(declaration_names)
        declaration_names.extend(names)
        assert not set(unit_targets) & set(targets)
        targets.extend(unit_targets)
        for record in records:
            protect(files, record['original_path'], record['original_sha256'])
            protect(files, folder / 'candidates' / (record['module'] + '.lean'), record['current_sha256'])
            if 'origin_map_path' in record:
                protect(files, record['origin_map_path'], record['origin_map_sha256'])
        for row in load(audit / 'TARGETED_REPLAY_RECEIPTS.json'):
            log = relative(row['log'])
            assert len(log.parts) == 1
            protect(files, audit / log)
        source_map = load(folder / (scope + '-SOURCE_MAP.json'))
        for item in source_map['sources'].values():
            if 'payload_path' in item:
                protect(files, relative(item['payload_path']), item['sha256'])
            else:
                assert re.fullmatch(r'[0-9a-f]{40}', item['base_commit'])
                relative(item['base_path'])
        if 'pilot_reuse_evidence' in summary:
            reuse = load(protect(files, relative(summary['pilot_reuse_evidence']), summary['pilot_reuse_evidence_sha256']))
            pilot = next(item for name, item in metadata['specifications'] if name == 'sides-pilot')
            pilot_path = str((pilot['directory'] / 'sides-pilot-VERIFICATION_SUMMARY.json').relative_to(R))
            assert reuse['summary_path'] == pilot_path and reuse['targets'] == pilot['targets']
            assert reuse['proof_fingerprint'] == scope_evidence[pilot_path]['proof_fingerprint']
            for path, expected in reuse['protected_files'].items():
                protect(files, path, expected)
        for key in TOTAL_KEYS[:-1]:
            totals[key] += summary[key]
        totals['analytic_type_axiom_audits'] += 1
        scope_evidence[str(summary_path.relative_to(R))] = {
            'sha256': sha(summary_path), 'proof_fingerprint': summary['proof_fingerprint'],
            'proof_state_sha256': sha(folder / (scope + '-PROOF_STATE.json')),
            'bound_audit_sha256': sha(audit / 'BOUND_AUDIT_FINAL.json'),
            'binding_sha256': sha(audit / 'PREPARATION_BINDINGS.json'), 'base_commit': summary['base_commit'],
            'targets': unit_targets, 'definitions': definitions, 'theorems': theorems,
        }
    assert targets == metadata['targets'] and len(targets) == len(set(targets))
    assert len(declaration_names) == len(set(declaration_names)) == metadata['totals']['declarations']
    assert totals == metadata['totals'] and len(scope_evidence) == totals['analytic_type_axiom_audits']
    endpoint_closure = driver.closure(ENDPOINT)
    assert endpoint_closure == closures[ENDPOINT] and set(endpoint_closure) <= accepted
    assert all(sources.get(name) == expected for name, expected in endpoint_closure.items())
    key = module.fingerprint(endpoint_closure)
    manifest = driver.expected_manifest(ENDPOINT, key, driver.latest())
    assert manifest and manifest == driver.artifacts(ENDPOINT)
    assert all(artifacts.get(path) == expected for path, expected in manifest.items())
    assert verify_original_attempts(driver, module) == history
    state = {
        'schema': 1, 'module': ENDPOINT, 'targets': targets, 'declaration_names': declaration_names,
        'module_and_check_totals': totals, 'endpoint_source_closure': endpoint_closure,
        'endpoint_build_fingerprint': key, 'endpoint_artifacts': manifest,
        'verified_sources': sources, 'verified_artifacts': artifacts, 'verified_files': files,
        'configuration': binding['configuration'], 'scope_evidence': scope_evidence,
        'original_public_headers_sha256': fingerprint(metadata['original_public_headers']),
        'original_public_declarations_preserved': metadata['inspection']['declaration_counts']['total'],
        'original_attempt_history_sha256': sha(O / 'installation/ORIGINAL_ATTEMPTS_BEFORE.json'),
        'install_binding_sha256': sha(O / 'INSTALL_BINDING.json'),
        'canonical_root_sha256': binding['canonical_root_sha256'],
        'closure_rows': metadata['inspection']['closure_rows'],
        'filtered_vertices': metadata['inspection']['filtered_vertices'], 'model': metadata['plan']['model'],
        'whole_graph46_complete': True, 'root_integration': False, 'main_theorem_complete': False,
    }
    return state, metadata


def runtime_guards(driver, extra=()):
    paths = [driver.queue_path, driver.active_path, driver.state_path, driver.baseline_path,
             DRIVER, RUNNER, Path(__file__), O / 'closure_runtime.py', *extra]
    return {str(repo_file(path)): sha(path) for path in paths}


def verify_current_state(driver, module, state, metadata, runtime):
    """Fresh checks immediately before an output, still under both owner locks."""
    assert all(sha(repo_file(path)) == expected for path, expected in runtime.items())
    assert driver.rows == load(driver.state_path) and driver.baseline == load(driver.baseline_path)
    assert verify_install_binding() == metadata['binding']
    history = verify_original_attempts(driver, module)
    assert history['target_names'] == metadata['plan']['build_order']
    assert sha(O / 'installation/ORIGINAL_ATTEMPTS_BEFORE.json') == state['original_attempt_history_sha256']
    assert all(sha(repo_file(path)) == expected for path, expected in state['verified_files'].items())
    assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected
               for name, expected in state['verified_sources'].items())
    assert driver.static == state['configuration']
    assert driver.manifest_matches(state['configuration'], cached=False)
    assert driver.manifest_matches(state['verified_artifacts'], cached=False)
    assert sha(repo_file('D1Bound5.lean')) == state['canonical_root_sha256']
    assert driver.closure(ENDPOINT) == state['endpoint_source_closure']
    assert module.fingerprint(state['endpoint_source_closure']) == state['endpoint_build_fingerprint']
    assert driver.expected_manifest(ENDPOINT, state['endpoint_build_fingerprint'], driver.latest()) == state['endpoint_artifacts']
    assert driver.artifacts(ENDPOINT) == state['endpoint_artifacts']
    active = load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    queue = load(driver.queue_path)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert all(sha(repo_file(path)) == expected for path, expected in runtime.items())


def endpoint_summary(state):
    return {
        'schema': 1, 'status': 'GRAPH46_WORKING_ENDPOINT_SCOPED_VERIFIED', 'module': ENDPOINT,
        'closure_rows': state['closure_rows'], 'filtered_vertices': state['filtered_vertices'],
        'original_public_declarations_preserved': state['original_public_declarations_preserved'],
        'scope_count': len(state['scope_evidence']), 'unique_target_count': len(state['targets']),
        'module_and_check_totals': state['module_and_check_totals'],
        'source_closure_modules': len(state['endpoint_source_closure']), 'scope_evidence': state['scope_evidence'],
        'proof_fingerprint': fingerprint(state), 'whole_graph46_complete': True,
        'root_integration': False, 'main_theorem_complete': False,
        'publication': 'PREPARED_NOT_YET_PUSHED', 'compiler_run_by_collector': False,
        'git_run_by_collector': False, 'proof_or_queue_mutated_by_collector': False,
    }


def load_driver(label):
    assert sha(DRIVER) == DRIVER_SHA and sha(RUNNER) == RUNNER_SHA
    specification = importlib.util.spec_from_file_location(label, DRIVER)
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


def write_new(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def main():
    assert Path(__file__).resolve().parent == O == C / '20261022-graph46-closure'
    assert len(sys.argv) == 1
    outputs = [O / 'ENDPOINT_PROOF_STATE.json', O / 'ENDPOINT_VERIFICATION.json']
    assert all(not path.exists() and not path.is_symlink() for path in outputs)
    module = load_driver('graph46_endpoint_collection_driver')
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        no_live_project_compiler()
        driver = module.Driver(R, W)
        runtime = runtime_guards(driver)
        state, metadata = collect_endpoint_state(driver, module)
        result = endpoint_summary(state)
        result['utc'] = datetime.now(timezone.utc).isoformat()
        no_live_project_compiler()
        verify_current_state(driver, module, state, metadata, runtime)
        assert all(not path.exists() and not path.is_symlink() for path in outputs)
        write_new(outputs[0], state)
        result['proof_state_sha256'] = sha(outputs[0])
        verify_current_state(driver, module, state, metadata, runtime)
        assert load(outputs[0]) == state and sha(outputs[0]) == result['proof_state_sha256']
        write_new(outputs[1], result)
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
