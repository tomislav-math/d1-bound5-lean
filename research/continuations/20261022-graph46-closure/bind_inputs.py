"""Bind actual committed graph46 prerequisites and current external provenance.

Usage: python3.12 -B bind_inputs.py HEAD QUEUE_SHA INSPECTION_SHA PLAN_SHA PAYLOAD_SHA [EXTRA_MAP ...]
All five inputs must be supplied from separately reviewed actual observations.
The three source-evidence hashes must also match the successful source-only runs.
EXTRA_MAP values are repository-relative paths to actual committed source maps.
Only new research binding/evidence files are written. No project source, queue,
Git state, compiler, replay, proof acceptance, or canonical root is changed.
"""
from pathlib import Path
import fcntl
import importlib.util
import json
import re
import subprocess
import sys

from closure_inputs import TARGET, MERGED_SHA, top_imports
from closure_runtime import (
    R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, TOOLCHAIN_SHA, LAKE_MANIFEST_SHA, ROOT_SHA,
    SOURCE_INSPECTION_SHA, PROPOSAL_PLAN_SHA, PROPOSAL_PAYLOAD_SHA, SCRIPT_NAMES,
    CLOSURE_SCOPE_NAMES, digest, sha, load, git, repo_file, scope_files, merge,
    prerequisite_metadata, publication_files, no_live_project_compiler,
    verify_proposal, verify_prerequisites,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def put(path, data):
    with path.open('xb') as stream:
        stream.write(data)


def committed(path, head):
    path = repo_file(path)
    relative = str(path.relative_to(R))
    blob = subprocess.check_output(['git', 'show', head + ':' + relative], cwd=R, timeout=30)
    expected = sha(path)
    assert digest(blob) == expected, 'Uncommitted or changed provenance: ' + relative
    return expected


def actual_endpoint_baseline(driver, module, closures, accepted):
    """Use current driver acceptance for all historical endpoints, without a guessed list."""
    latest, evidence, sources, artifacts = driver.latest(), {}, {}, {}
    current = []
    for number in range(1, 49):
        name = 'SmallPairGraphData' + str(number)
        repo_file('D1Bound5/' + name + '.lean')
        if name not in accepted:
            continue
        closure = closures[name]
        key = module.fingerprint(closure)
        manifest = driver.expected_manifest(name, key, latest)
        assert manifest and driver.manifest_matches(manifest, cached=False), name
        current.append(number)
        merge(sources, closure)
        merge(artifacts, manifest)
        evidence[str(number)] = {
            'module': name, 'source_sha256': closure[name], 'source_closure_modules': len(closure),
            'build_fingerprint': key, 'accepted_artifacts': manifest, 'basis': 'current_driver_acceptance',
        }
    assert 46 not in current
    return {
        'schema': 1, 'status': 'ACTUAL_PREINSTALL_WORKING_ENDPOINT_INVENTORY',
        'accepted': current, 'accepted_count': len(current), 'total_endpoints': 48,
        'remaining': sorted(set(range(1, 49)) - set(current)), 'evidence': evidence,
        'driver_receipts_sha256': sha(driver.state_path), 'trusted_baseline_sha256': sha(driver.baseline_path),
        'root_integration': False, 'main_theorem_complete': False,
    }, sources, artifacts


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) >= 6 and re.fullmatch(r'[0-9a-f]{40}', sys.argv[1])
    assert all(re.fullmatch(r'[0-9a-f]{64}', value) for value in sys.argv[2:6])
    head, queue_sha, inspection_sha, plan_sha, payload_sha = sys.argv[1:6]
    assert (inspection_sha, plan_sha, payload_sha) == (
        SOURCE_INSPECTION_SHA, PROPOSAL_PLAN_SHA, PROPOSAL_PAYLOAD_SHA,
    )
    outputs = [O / name for name in ('INSTALL_BINDING.json', 'PROVENANCE_BINDING.json', 'BINDING_EVIDENCE.json')]
    assert all(not path.exists() and not path.is_symlink() for path in outputs)
    assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
    assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    script_pins_path = repo_file(O / 'REVIEWED_SCRIPT_PINS.json')
    script_pins = load(script_pins_path)
    assert set(script_pins) == SCRIPT_NAMES
    assert all(re.fullmatch(r'[0-9a-f]{64}', expected) and sha(O / name) == expected
               for name, expected in script_pins.items())
    source_binding = {
        'source_inspection_sha256': inspection_sha, 'proposal_plan_sha256': plan_sha,
        'proposal_payload_sha256': payload_sha,
    }
    proposed, inspection, protected = verify_proposal(source_binding)
    assert proposed['status'] == 'REVIEWED_GRAPH46_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED'
    assert set(proposed['scopes']) == set(CLOSURE_SCOPE_NAMES)
    assert proposed['closure_rows'] == inspection['closure_rows']
    assert proposed['filtered_vertices'] == inspection['filtered_vertices']
    merge(protected, {str(script_pins_path): sha(script_pins_path), str(Path(__file__)): sha(Path(__file__))})
    merge(protected, {str(O / name): expected for name, expected in script_pins.items()})
    proposal = O / 'proposal'
    spec = importlib.util.spec_from_file_location('graph46_closure_binding_driver', W / 'continuation_driver_capacity.py')
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert git('rev-parse', 'HEAD') == head and git('branch', '--show-current') == 'main'
        assert not git('diff', '--cached', '--name-only')
        index = Path(git('rev-parse', '--git-path', 'index'))
        index = index if index.is_absolute() else R / index
        index_sha = sha(index)
        no_live_project_compiler()
        driver = module.Driver(R, W)
        state_bytes, baseline_bytes = driver.state_path.read_bytes(), driver.baseline_path.read_bytes()
        assert driver.rows == json.loads(state_bytes) and driver.baseline == json.loads(baseline_bytes)
        active_bytes = driver.active_path.read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        queue_bytes = driver.queue_path.read_bytes()
        queue, names, closures, accepted, unknown, _ = driver.snapshot()
        assert digest(queue_bytes) == queue_sha and queue == json.loads(queue_bytes)
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True and unknown == []
        assert len(names) == len(set(queue['names'])) == len(queue['names'])
        assert TARGET in names and TARGET not in accepted and closures[TARGET][TARGET] == MERGED_SHA
        assert not any(TARGET in closures[name] for name in accepted)
        assert driver.static['lean-toolchain'] == TOOLCHAIN_SHA
        assert driver.static['lake-manifest.json'] == LAKE_MANIFEST_SHA
        assert driver.manifest_matches(driver.static, cached=False)
        assert sha(R / 'D1Bound5.lean') == ROOT_SHA
        merged_path = repo_file('D1Bound5/' + TARGET + '.lean')
        assert sha(merged_path) == MERGED_SHA
        merge(protected, {str(merged_path): MERGED_SHA})

        specifications, prerequisite_inputs = prerequisite_metadata()
        prerequisites = {}
        for scope, specification in specifications.items():
            directory, audit = specification['directory'], U / ('pro-graph46-' + scope + '-audit')
            summary = load(directory / (scope + '-VERIFICATION_SUMMARY.json'))
            files = {str(path.relative_to(R)): committed(path, head) for path in scope_files(directory, scope, audit)}
            prerequisites[scope] = {'proof_fingerprint': summary['proof_fingerprint'], 'files': files}
        publications = {}
        publication_control = set()
        for group in ('foundation', 'sides'):
            paths = publication_files(group)
            receipt = load(repo_file(paths[0]))
            publications[group] = {
                'commit': receipt['local_head'],
                'files': {str(path.relative_to(R)): sha(repo_file(path)) for path in paths},
            }
            publication_control.update(str(path) for path in paths[:3])
        # Post-push receipt, owner and release records necessarily postdate the
        # publication they describe. The verifier below binds their actual bytes
        # and checks published selection manifests and committed project blobs.
        for path, expected in prerequisite_inputs.items():
            if path not in publication_control:
                assert committed(path, head) == expected
        baseline, baseline_sources, baseline_artifacts = actual_endpoint_baseline(driver, module, closures, accepted)
        binding = {
            'schema': 1, 'status': 'REVIEWED_GRAPH46_CLOSURE_INSTALL_BINDING', 'base_commit': head,
            **source_binding, 'canonical_root_sha256': ROOT_SHA, 'queue_before_sha256': queue_sha,
            'max_parallel': 1, 'target_timeout_seconds': 240, 'driver_sha256': DRIVER_SHA,
            'audit_runner_sha256': RUNNER_SHA, 'configuration': driver.static,
            'script_pins': script_pins, 'prerequisite_scopes': prerequisites,
            'prerequisite_inputs': {str(Path(path).relative_to(R)): expected
                                    for path, expected in prerequisite_inputs.items()},
            'prerequisite_publications': publications, 'baseline_endpoint_inventory': baseline,
            'root_integration': False, 'main_theorem_complete': False,
        }
        verified = verify_prerequisites(binding, driver, module)
        merge(protected, verified['protected_files'])
        required_maps = [specification['directory'] / (scope + '-SOURCE_MAP.json')
                         for scope, specification in specifications.items()]
        maps = required_maps + [C / '20261020-completed-checkpoint/SOURCE_MAP.json']
        for value in sys.argv[6:]:
            relative = Path(value)
            assert not relative.is_absolute() and '..' not in relative.parts
            maps.append(repo_file(relative))
        assert len(maps) == len(set(maps)), 'Duplicate provenance map'
        source_maps, oldmap = [], {}
        for path in maps:
            expected = committed(path, head)
            relative = str(path.relative_to(R))
            source_maps.append({'path': relative, 'sha256': expected, 'scopes': list(CLOSURE_SCOPE_NAMES)})
            merge(protected, {str(path): expected})
            for name, item in load(path)['sources'].items():
                oldmap[(name, item['sha256'])] = (relative, item)
        candidate_imports = {
            name: top_imports((proposal / 'candidates' / (name + '.lean')).read_bytes())[0]
            for name in proposed['source_manifest']}

        def external_closure(name, visiting=()):
            assert name not in visiting, 'Cycle in candidate import graph'
            if name not in candidate_imports:
                return set(driver.closure(name))
            union = set()
            for dependency in candidate_imports[name]:
                union.update(external_closure(dependency, visiting + (name,)))
            return union

        external_by_scope = {
            scope: sorted(set().union(*(external_closure(name) for name in proposed['scopes'][scope])))
            for scope in CLOSURE_SCOPE_NAMES}
        external = set().union(*map(set, external_by_scope.values()))
        assert 'PairClosureIndexedChunks' in external and external <= accepted
        for key, value in queue.items():
            if key == 'blocked_modules' or key.startswith('held_until_'):
                assert not set(value) & (external | set(proposed['build_order']))
        latest, evidence, artifacts, source_pins = driver.latest(), {}, {}, {}
        for name in sorted(external):
            closure = driver.closure(name)
            expected = closure[name]
            key = module.fingerprint(closure)
            manifest = driver.expected_manifest(name, key, latest)
            assert manifest and driver.artifacts(name) == manifest, 'Unaccepted external: ' + name
            assert (name, expected) in oldmap, 'No committed provenance map covers external: ' + name
            source_map, item = oldmap[(name, expected)]
            commit, path = ((head, item['payload_path']) if 'payload_path' in item
                            else (item['base_commit'], item['base_path']))
            relative = Path(path)
            assert not relative.is_absolute() and '..' not in relative.parts
            assert re.fullmatch(r'[0-9a-f]{40}', commit)
            blob = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=R, timeout=30)
            assert digest(blob) == expected and sha(repo_file('D1Bound5/' + name + '.lean')) == expected
            evidence[name] = {'source_sha256': expected, 'source_map': source_map, 'base_commit': commit,
                              'base_path': path, 'fingerprint': key, 'artifacts': manifest}
            source_pins[name] = expected
            merge(artifacts, manifest)
        provenance = {
            'schema': 1, 'status': 'COMMITTED_PROVENANCE_BOUND', 'base_commit': head,
            'source_maps': source_maps, 'external_modules_by_scope': external_by_scope,
            'root_integration': False, 'main_theorem_complete': False,
        }
        provenance_bytes = encoded(provenance)
        binding['provenance_binding_sha256'] = digest(provenance_bytes)
        binding_bytes = encoded(binding)

        assert all(sha(repo_file(path)) == expected for path, expected in protected.items())
        assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected for name, expected in source_pins.items())
        assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected for name, expected in baseline_sources.items())
        assert driver.manifest_matches(artifacts, cached=False) and driver.manifest_matches(driver.static, cached=False)
        assert driver.manifest_matches(baseline_artifacts, cached=False)
        assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
        assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
        assert sha(R / 'D1Bound5.lean') == ROOT_SHA
        assert driver.queue_path.read_bytes() == queue_bytes and driver.active_path.read_bytes() == active_bytes
        assert driver.state_path.read_bytes() == state_bytes and driver.baseline_path.read_bytes() == baseline_bytes
        assert git('rev-parse', 'HEAD') == head and sha(index) == index_sha
        assert git('branch', '--show-current') == 'main' and not git('diff', '--cached', '--name-only')
        no_live_project_compiler()
        assert all(not path.exists() and not path.is_symlink() for path in outputs)
        put(O / 'PROVENANCE_BINDING.json', provenance_bytes)
        put(O / 'INSTALL_BINDING.json', binding_bytes)
        put(O / 'BINDING_EVIDENCE.json', encoded({
            'status': 'ACTUAL_COMMITTED_INPUTS_BOUND_NO_INSTALLATION', 'base_commit': head,
            'install_binding_sha256': digest(binding_bytes), 'provenance_binding_sha256': digest(provenance_bytes),
            'script_pins_sha256': sha(script_pins_path), 'prerequisite_scopes': verified['scopes'],
            'prerequisite_publications': verified['publications'],
            'source_inspection_sha256': inspection_sha, 'proposal_plan_sha256': plan_sha,
            'proposal_payload_sha256': payload_sha, 'baseline_endpoint_inventory': baseline,
            'external_modules': evidence, 'protected_files': protected,
            'compiler_started': False, 'queue_changed': False, 'source_files_changed': False,
            'root_integration': False, 'main_theorem_complete': False,
        }))
        print(json.dumps({
            'status': 'ACTUAL_COMMITTED_INPUTS_BOUND_NO_INSTALLATION',
            'install_binding_sha256': digest(binding_bytes), 'provenance_binding_sha256': digest(provenance_bytes),
            'external_modules': len(external), 'source_maps': len(source_maps),
            'current_accepted_endpoints': baseline['accepted'],
        }), flush=True)


if __name__ == '__main__':
    main()
