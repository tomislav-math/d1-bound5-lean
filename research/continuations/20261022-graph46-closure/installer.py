"""Install a reviewed graph46 closure proposal after committed foundation/sides.

Usage: python3.12 -B installer.py INSTALL_BINDING_SHA256
No compiler, replay, Git mutation, or accepted-root edit is performed.
"""
from pathlib import Path
import ast
import fcntl
import importlib.util
import json
import os
import re
import sys

from closure_inputs import MERGED_SHA, ORIGINAL_PINS, RAW_GROUPS, TARGET, read_source, top_imports
from closure_runtime import (
    R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, digest, sha, load, git, repo_file, fingerprint, merge,
    no_live_project_compiler, verify_install_binding, verify_proposal, verify_prerequisites,
    verify_original_attempts,
)
from generate_proposal import build_candidates, COVERAGE_TEMPLATE_SHA


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True


def put(path, data):
    if isinstance(data, str):
        data = data.encode()
    with path.open('xb') as stream:
        stream.write(data)


def save(path, value):
    put(path, json.dumps(value, indent=2, sort_keys=True) + '\n')


def absent(path):
    assert not path.exists() and not path.is_symlink(), str(path)


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) == 2 and re.fullmatch(r'[0-9a-f]{64}', sys.argv[1])
    binding_path = O / 'INSTALL_BINDING.json'
    binding_bytes = read_source(binding_path)
    assert digest(binding_bytes) == sys.argv[1]
    binding = verify_install_binding()
    verified_proposal, verified_inspection, proposal_guards = verify_proposal(binding)
    proposal = O / 'proposal'
    assert sha(proposal / 'PLAN.json') == binding['proposal_plan_sha256']
    assert sha(proposal / 'PAYLOAD_SHA256.json') == binding['proposal_payload_sha256']
    payload = load(proposal / 'PAYLOAD_SHA256.json')
    for relative, expected in payload.items():
        path = proposal / relative
        assert not Path(relative).is_absolute() and '..' not in Path(relative).parts
        assert path.resolve().is_relative_to(proposal) and sha(path) == expected, relative
    proposed = load(proposal / 'PLAN.json')
    assert proposed == verified_proposal
    provenance = load(proposal / 'INPUT_PROVENANCE.json')
    assert repo_file(provenance['merged_path']) == R / 'D1Bound5' / (TARGET + '.lean')
    archive = Path(provenance['archive_directory'])
    assert archive == W / 'prepared-light-remaining39/D1Bound5'
    template_path = repo_file(provenance['coverage_template_path'])
    assert template_path == R / 'D1Bound5/SmallPairGraphClosure29Coverage.lean'
    assert sha(template_path) == COVERAGE_TEMPLATE_SHA
    merged = read_source(R / 'D1Bound5' / (TARGET + '.lean'))
    archived = {name: read_source(repo_file(archive / (name + '.lean'))) for name in ORIGINAL_PINS}
    source_evidence, originals, candidates, regenerated = build_candidates(merged, archived, read_source(template_path))
    assert regenerated == proposed and source_evidence == verified_inspection == load(proposal / 'SOURCE_INSPECTION.json')
    assert read_source(proposal / 'SmallPairGraphData46.merged.before.lean') == merged
    assert read_source(proposal / 'COVERAGE_TEMPLATE.before.lean') == read_source(template_path)
    assert all(read_source(proposal / 'originals' / (name + '.lean')) == data for name, data in originals.items())
    assert all(read_source(proposal / 'candidates' / (name + '.lean')) == data for name, data in candidates.items())
    assert all(sha(repo_file(path)) == expected for path, expected in provenance['source_sha256'].items())
    assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
    assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    spec = importlib.util.spec_from_file_location('graph46_closure_install_driver', W / 'continuation_driver_capacity.py')
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    order = proposed['build_order']
    pins = {name: proposed['source_manifest'][name] for name in order}
    template = (O / 'bounded_build_template.py').read_text()
    assert template.count('__REVIEWED_SOURCE_PINS__') == 1
    worker = template.replace('__REVIEWED_SOURCE_PINS__', repr(pins)).encode()
    ast.parse(worker.decode())
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert git('rev-parse', 'HEAD') == binding['base_commit'] and git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        index_path = Path(git('rev-parse', '--git-path', 'index'))
        index_path = index_path if index_path.is_absolute() else R / index_path
        index_hash = sha(index_path)
        no_live_project_compiler()
        driver = module.Driver(R, W)
        assert driver.static == binding['configuration'] and driver.manifest_matches(driver.static, cached=False)
        state_bytes, baseline_bytes = driver.state_path.read_bytes(), driver.baseline_path.read_bytes()
        assert driver.rows == json.loads(state_bytes) and driver.baseline == json.loads(baseline_bytes)
        assert digest(state_bytes) == binding['baseline_endpoint_inventory']['driver_receipts_sha256']
        assert digest(baseline_bytes) == binding['baseline_endpoint_inventory']['trusted_baseline_sha256']
        active_bytes = driver.active_path.read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        assert unknown == [] and queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert len(names) == len(queue['names'])
        assert TARGET in names and TARGET not in accepted
        actual_endpoints = sorted(number for number in range(1, 49) if 'SmallPairGraphData' + str(number) in accepted)
        assert actual_endpoints == binding['baseline_endpoint_inventory']['accepted']
        assert not any(TARGET in closures[name] for name in accepted)
        new_names = [name for name in order if name != TARGET]
        for name in new_names:
            absent(R / 'D1Bound5' / (name + '.lean'))
            assert name not in names
        prerequisites = verify_prerequisites(binding, driver, module)
        candidate_imports = {name: top_imports(candidates[name])[0] for name in order}
        external = {dependency for dependencies in candidate_imports.values() for dependency in dependencies} - set(order)
        required = set(closures[TARGET]) - {TARGET}
        for name in external | {'SmallPairGraphClosure29Coverage'}:
            required.update(driver.closure(name))
        assert required <= accepted
        for key, value in queue.items():
            if key == 'blocked_modules' or key.startswith('held_until_'):
                assert not set(value) & (required | set(order))
        latest, sources, artifacts, evidence = driver.latest(), {}, {}, {}
        for name in sorted(required):
            closure = driver.closure(name)
            key = module.fingerprint(closure)
            manifest = driver.expected_manifest(name, key, latest)
            assert manifest and driver.artifacts(name) == manifest
            sources[name] = closure[name]
            evidence[name] = {'fingerprint': key, 'artifacts': manifest,
                              'original_receipt': latest.get((name, key)),
                              'baseline_entry': None if (name, key) in latest else driver.baseline['accepted'][name]}
            for path, expected in manifest.items():
                assert path not in artifacts or artifacts[path] == expected
                artifacts[path] = expected

        def proposed_closure(name, visiting=()):
            assert name not in visiting, 'Cycle in proposed source imports: ' + name
            if name not in candidate_imports:
                value = driver.closure(name)
                assert set(value) <= accepted
                return value
            result = {name: pins[name]}
            for dependency in candidate_imports[name]:
                merge(result, proposed_closure(dependency, visiting + (name,)))
            return result

        proposed_closures = {name: proposed_closure(name) for name in order}
        proposed_fingerprints = {name: module.fingerprint(value) for name, value in proposed_closures.items()}
        assert all((name, key) not in latest for name, key in proposed_fingerprints.items()), \
            'A proposed exact source fingerprint has already been attempted'
        assert all(name not in driver.baseline['accepted'] or
                   driver.baseline['accepted'][name]['fingerprint'] != key
                   for name, key in proposed_fingerprints.items())
        historical = [{'name': name, 'fingerprint': key, 'receipt': row}
                      for (name, key), row in sorted(latest.items()) if name in order]
        attempt_files, absent_attempt_files = {}, []
        for row in driver.rows:
            if row['name'] not in order:
                continue
            log = Path(row['log'])
            assert log.is_absolute() and log.resolve().is_relative_to(W.resolve())
            assert log.suffix == '.log'
            for path in (log, log.with_suffix('.sources.json'), log.with_suffix('.lean')):
                assert not path.is_symlink()
                if path.exists():
                    merge(attempt_files, {str(repo_file(path)): sha(path)})
                else:
                    absent_attempt_files.append(str(path))
        original_attempts = {
            'schema': 1, 'status': 'ACTUAL_PREINSTALL_ATTEMPT_HISTORY', 'target_names': order,
            'original_target': TARGET, 'original_source_sha256': MERGED_SHA,
            'original_target_closure': closures[TARGET],
            'original_target_fingerprint': module.fingerprint(closures[TARGET]),
            'prior_receipt_count': len(driver.rows), 'prior_receipts_fingerprint': fingerprint(driver.rows),
            'baseline_sha256': digest(baseline_bytes), 'attempts': historical,
            'protected_attempt_files': attempt_files, 'absent_attempt_files': sorted(set(absent_attempt_files)),
            'proposed_fingerprints': proposed_fingerprints,
            'previous_receipts_changed': False, 'compiler_started': False,
        }
        queue_bytes = driver.queue_path.read_bytes()
        assert digest(queue_bytes) == binding['queue_before_sha256']
        assert sha(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
        installation = O / 'installation'
        temporary = R / 'D1Bound5/SmallPairGraphData46.partition.tmp'
        for path in [installation, O / 'originals', O / 'candidates', O / 'PLAN.json',
                     O / 'DECLARATION_ORIGINS.json', O / 'bounded_build.py', O / 'CONFIGURATION.json', temporary] \
                    + [O / (scope + '-TARGETS.json') for scope in proposed['scopes']]:
            absent(path)

        def stable(expected_target_sha, expected_queue):
            assert git('rev-parse', 'HEAD') == binding['base_commit']
            assert sha(index_path) == index_hash and not git('diff', '--cached', '--name-only')
            assert driver.queue_path.read_bytes() == expected_queue and driver.active_path.read_bytes() == active_bytes
            assert driver.state_path.read_bytes() == state_bytes and driver.baseline_path.read_bytes() == baseline_bytes
            assert sha(R / 'D1Bound5' / (TARGET + '.lean')) == expected_target_sha
            assert sha(R / 'D1Bound5.lean') == binding['canonical_root_sha256']
            assert binding_path.read_bytes() == binding_bytes
            assert sha(O / 'PROVENANCE_BINDING.json') == binding['provenance_binding_sha256']
            assert all(sha(O / name) == expected for name, expected in binding['script_pins'].items())
            assert all(sha(path) == expected for path, expected in prerequisites['protected_files'].items())
            assert all(sha(path) == expected for path, expected in proposal_guards.items())
            assert all(sha(path) == expected for path, expected in attempt_files.items())
            assert all(not Path(path).exists() and not Path(path).is_symlink() for path in absent_attempt_files)
            assert all(sha(R / 'D1Bound5' / (name + '.lean')) == expected for name, expected in sources.items())
            assert driver.manifest_matches(artifacts, cached=False) and driver.manifest_matches(binding['configuration'], cached=False)
            assert all(sha(repo_file(path)) == expected for path, expected in provenance['source_sha256'].items()
                       if Path(path) != R / 'D1Bound5' / (TARGET + '.lean'))
            assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
            assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
            no_live_project_compiler()

        stable(MERGED_SHA, queue_bytes)
        installation.mkdir()
        (O / 'originals').mkdir()
        (O / 'candidates').mkdir()
        put(installation / (TARGET + '.before.lean'), merged)
        put(installation / 'QUEUE_BEFORE.json', queue_bytes)
        put(installation / 'ACTIVE_BEFORE.json', active_bytes)
        put(installation / 'INSTALL_BINDING_USED.json', binding_bytes)
        save(installation / 'SCRIPT_PINS.json', binding['script_pins'])
        save(installation / 'PREREQUISITES_VERIFIED.json', prerequisites)
        save(installation / 'ORIGINAL_ATTEMPTS_BEFORE.json', original_attempts)
        for name, data in originals.items():
            put(O / 'originals' / (name + '.lean'), data)
        for name in order:
            put(O / 'candidates' / (name + '.lean'), candidates[name])
        plan = dict(proposed)
        plan.update(status='REVIEWED_GRAPH46_RESTORATION_NOT_BUILT', base_commit=binding['base_commit'],
                    canonical_root_sha256=binding['canonical_root_sha256'], configuration=binding['configuration'],
                    install_binding_sha256=digest(binding_bytes), proposal_plan_sha256=binding['proposal_plan_sha256'],
                    proposal_payload_sha256=binding['proposal_payload_sha256'],
                    source_provenance=provenance['source_sha256'])
        save(O / 'PLAN.json', plan)
        save(O / 'DECLARATION_ORIGINS.json', proposed['origins'])
        save(installation / 'GUARDS_BEFORE.json', {
            'head': binding['base_commit'], 'index_sha256': index_hash, 'accepted_sources': sources,
            'accepted_artifacts': artifacts, 'configuration': binding['configuration'],
            'original_target_closure': closures[TARGET], 'canonical_root_sha256': binding['canonical_root_sha256'],
        })
        save(installation / 'ACCEPTED_INPUT_EVIDENCE.json', evidence)
        stable(MERGED_SHA, queue_bytes)
        for name in new_names:
            put(R / 'D1Bound5' / (name + '.lean'), candidates[name])
        absent(temporary)
        put(temporary, candidates[TARGET])
        assert sha(R / 'D1Bound5' / (TARGET + '.lean')) == MERGED_SHA
        os.replace(temporary, R / 'D1Bound5' / (TARGET + '.lean'))
        after = json.loads(queue_bytes)
        after['names'] += new_names
        assert len(after['names']) == len(set(after['names']))
        assert {key: value for key, value in after.items() if key != 'names'} == {key: value for key, value in queue.items() if key != 'names'}
        module.atomic_json(driver.queue_path, after)
        after_bytes = driver.queue_path.read_bytes()
        assert after_bytes == json.dumps(after, indent=2, sort_keys=True).encode()
        stable(pins[TARGET], after_bytes)
        assert all(sha(R / 'D1Bound5' / (name + '.lean')) == expected for name, expected in pins.items())
        _, _, _, accepted_after, unknown_after, _ = driver.snapshot()
        assert unknown_after == [] and accepted <= accepted_after
        assert all(driver.closure(name) == proposed_closures[name] for name in order)
        assert verify_original_attempts(driver, module) == original_attempts
        save(installation / 'QUEUE_AFTER.json', after)
        put(O / 'bounded_build.py', worker)
        save(installation / 'WORKER_SHA256.json', {'sha256': digest(worker), 'template_sha256': sha(O / 'bounded_build_template.py')})
        for scope, targets in proposed['scopes'].items():
            save(O / (scope + '-TARGETS.json'), targets)
        result = {
            'status': 'GRAPH46_RESTORED_UNCOMPILED', 'utc': module.utc(), 'new_modules': new_names,
            'original_declarations_preserved': proposed['original_public_declarations'],
            'complete_rows': proposed['closure_rows'], 'filtered_vertices': proposed['filtered_vertices'],
            'partition_counts': [part['count'] for part in proposed['prefix_parts']],
            'raw_data_modules': list(RAW_GROUPS), 'all_original_literal_definitions_byte_identical': True,
            'both_mutation_signs_and_global_indices_preserved': True,
            'prerequisite_scope_fingerprints': prerequisites['scopes'], 'both_locks_held': True,
            'original_attempt_history_sha256': sha(installation / 'ORIGINAL_ATTEMPTS_BEFORE.json'),
            'proposed_fingerprints': proposed_fingerprints, 'previous_attempts_preserved': True,
            'install_binding_sha256': digest(binding_bytes), 'compiler_started': False,
            'root_integration': False, 'main_theorem_complete': False,
        }
        save(installation / 'APPLICATION_RECEIPT.json', result)
        print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
