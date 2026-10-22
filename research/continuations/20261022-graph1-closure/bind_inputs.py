"""Bind actual committed graph1 prerequisites and external-source provenance.

Usage: python3.12 -B bind_inputs.py REVIEWED_HEAD REVIEWED_QUEUE_SHA [EXTRA_MAP ...]
EXTRA_MAP values are repository-relative paths to committed source maps.
This writes only new research binding/evidence files. It does not install sources,
modify the queue or Git, run a compiler, or accept a proof.
"""
from pathlib import Path
import fcntl
import importlib.util
import json
import re
import subprocess
import sys

from closure_inputs import top_imports
from closure_runtime import (
    R, C, W, U, O, DRIVER_SHA, RUNNER_SHA, TOOLCHAIN_SHA, LAKE_MANIFEST_SHA,
    SCRIPT_NAMES, PREREQUISITES, digest, sha, load, git, repo_file, scope_files,
    no_live_project_compiler, verify_prerequisites,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
PROPOSAL_PLAN_SHA = '0e901e4bf3712aaa018eb0df4df8edcf1297bc130d12ef22459fc44d932db728'
PROPOSAL_PAYLOAD_SHA = 'bfefaae9b2da8c223731636cf8019f520cf6ef7166234e6432f26c91f05665e5'
ROOT_SHA = '33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2'
SCOPES = ['closure-pilot', 'closure-rest', 'assembly']


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def put(path, data):
    with path.open('xb') as stream:
        stream.write(data)


def committed(path, head):
    relative = str(repo_file(path).relative_to(R))
    blob = subprocess.check_output(['git', 'show', head + ':' + relative], cwd=R, timeout=30)
    assert digest(blob) == sha(path), 'Uncommitted or changed provenance: ' + relative
    return sha(path)


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) >= 3 and re.fullmatch(r'[0-9a-f]{40}', sys.argv[1])
    assert re.fullmatch(r'[0-9a-f]{64}', sys.argv[2])
    head, queue_sha = sys.argv[1:3]
    paths = [O / name for name in ('INSTALL_BINDING.json', 'PROVENANCE_BINDING.json', 'BINDING_EVIDENCE.json')]
    assert all(not path.exists() and not path.is_symlink() for path in paths)
    assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
    assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    script_pins_path = repo_file(O / 'REVIEWED_SCRIPT_PINS.json')
    script_pins = load(script_pins_path)
    assert set(script_pins) == SCRIPT_NAMES
    assert all(re.fullmatch(r'[0-9a-f]{64}', expected) and sha(O / name) == expected
               for name, expected in script_pins.items())
    proposal = O / 'proposal'
    assert sha(proposal / 'PLAN.json') == PROPOSAL_PLAN_SHA
    assert sha(proposal / 'PAYLOAD_SHA256.json') == PROPOSAL_PAYLOAD_SHA
    protected = {str(script_pins_path): sha(script_pins_path),
                 str(proposal / 'PLAN.json'): PROPOSAL_PLAN_SHA,
                 str(proposal / 'PAYLOAD_SHA256.json'): PROPOSAL_PAYLOAD_SHA}
    for relative, expected in load(proposal / 'PAYLOAD_SHA256.json').items():
        assert not Path(relative).is_absolute() and '..' not in Path(relative).parts
        path = repo_file(proposal / relative)
        assert path.resolve().is_relative_to(proposal.resolve()) and sha(path) == expected
        protected[str(path)] = expected
    proposed = load(proposal / 'PLAN.json')
    assert proposed['status'] == 'REVIEWED_GRAPH1_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED'
    assert proposed['closure_rows'] == 720 and proposed['filtered_vertices'] == 718
    assert set(proposed['scopes']) == set(SCOPES) and len(proposed['source_manifest']) == 25
    spec = importlib.util.spec_from_file_location('graph1_closure_binding_driver', W / 'continuation_driver_capacity.py')
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
        active_bytes = driver.active_path.read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        queue = load(driver.queue_path)
        assert sha(driver.queue_path) == queue_sha and queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert driver.static['lean-toolchain'] == TOOLCHAIN_SHA and driver.static['lake-manifest.json'] == LAKE_MANIFEST_SHA
        assert driver.manifest_matches(driver.static, cached=False)
        assert sha(R / 'D1Bound5.lean') == ROOT_SHA
        prerequisites = {}
        for scope, specification in PREREQUISITES.items():
            directory, audit = specification['directory'], U / ('pro-graph1-' + scope + '-audit')
            summary = load(directory / (scope + '-VERIFICATION_SUMMARY.json'))
            files = {str(path.relative_to(R)): committed(path, head) for path in scope_files(directory, scope, audit)}
            prerequisites[scope] = {'proof_fingerprint': summary['proof_fingerprint'], 'files': files}
        binding = {
            'schema': 1, 'status': 'REVIEWED_GRAPH1_CLOSURE_INSTALL_BINDING', 'base_commit': head,
            'proposal_plan_sha256': PROPOSAL_PLAN_SHA, 'proposal_payload_sha256': PROPOSAL_PAYLOAD_SHA,
            'canonical_root_sha256': ROOT_SHA, 'queue_before_sha256': queue_sha,
            'max_parallel': 1, 'target_timeout_seconds': 240, 'driver_sha256': DRIVER_SHA,
            'audit_runner_sha256': RUNNER_SHA, 'configuration': driver.static,
            'script_pins': script_pins, 'prerequisite_scopes': prerequisites,
            'root_integration': False, 'main_theorem_complete': False,
        }
        verified = verify_prerequisites(binding, driver, module)
        protected.update(verified['protected_files'])
        required_maps = [specification['directory'] / (scope + '-SOURCE_MAP.json')
                         for scope, specification in PREREQUISITES.items()]
        maps = required_maps + [C / '20261020-completed-checkpoint/SOURCE_MAP.json']
        for value in sys.argv[3:]:
            relative = Path(value)
            assert not relative.is_absolute() and '..' not in relative.parts
            maps.append(repo_file(relative))
        assert len(maps) == len(set(maps)), 'Duplicate provenance map'
        source_maps, oldmap = [], {}
        for path in maps:
            expected = committed(path, head)
            relative = str(path.relative_to(R))
            source_maps.append({'path': relative, 'sha256': expected, 'scopes': SCOPES})
            protected[str(path)] = expected
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

        external_by_scope = {scope: sorted(set().union(*(external_closure(name) for name in proposed['scopes'][scope])))
                             for scope in SCOPES}
        external = set().union(*map(set, external_by_scope.values()))
        assert 'PairClosureIndexedChunks' in external
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
            blob = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=R, timeout=30)
            assert digest(blob) == expected and sha(repo_file('D1Bound5/' + name + '.lean')) == expected
            evidence[name] = {'source_sha256': expected, 'source_map': source_map, 'base_commit': commit,
                              'base_path': path, 'fingerprint': key, 'artifacts': manifest}
            source_pins[name] = expected
            for artifact, value in manifest.items():
                assert artifact not in artifacts or artifacts[artifact] == value
                artifacts[artifact] = value
        provenance = {'schema': 1, 'status': 'ACTUAL_COMMITTED_GRAPH1_CLOSURE_PROVENANCE',
                      'base_commit': head, 'source_maps': source_maps,
                      'external_modules_by_scope': external_by_scope, 'root_integration': False,
                      'main_theorem_complete': False}
        provenance_bytes = encoded(provenance)
        binding['provenance_binding_sha256'] = digest(provenance_bytes)
        binding_bytes = encoded(binding)
        assert all(sha(repo_file(path)) == expected for path, expected in protected.items())
        assert all(sha(O / name) == expected for name, expected in script_pins.items())
        assert all(sha(repo_file('D1Bound5/' + name + '.lean')) == expected for name, expected in source_pins.items())
        assert driver.manifest_matches(artifacts, cached=False) and driver.manifest_matches(driver.static, cached=False)
        assert sha(W / 'continuation_driver_capacity.py') == DRIVER_SHA
        assert sha(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
        assert sha(R / 'D1Bound5.lean') == ROOT_SHA
        assert sha(driver.queue_path) == queue_sha and driver.active_path.read_bytes() == active_bytes
        assert git('rev-parse', 'HEAD') == head and sha(index) == index_sha
        assert not git('diff', '--cached', '--name-only')
        no_live_project_compiler()
        assert all(not path.exists() and not path.is_symlink() for path in paths)
        put(O / 'PROVENANCE_BINDING.json', provenance_bytes)
        put(O / 'INSTALL_BINDING.json', binding_bytes)
        put(O / 'BINDING_EVIDENCE.json', encoded({
            'status': 'ACTUAL_COMMITTED_INPUTS_BOUND_NO_INSTALLATION', 'base_commit': head,
            'install_binding_sha256': digest(binding_bytes), 'provenance_binding_sha256': digest(provenance_bytes),
            'script_pins_sha256': sha(script_pins_path), 'prerequisite_scopes': verified['scopes'],
            'external_modules': evidence, 'protected_files': protected,
            'compiler_started': False, 'queue_changed': False, 'source_files_changed': False,
            'root_integration': False, 'main_theorem_complete': False,
        }))
        print(json.dumps({'status': 'ACTUAL_COMMITTED_INPUTS_BOUND_NO_INSTALLATION',
                          'install_binding_sha256': digest(binding_bytes),
                          'provenance_binding_sha256': digest(provenance_bytes),
                          'external_modules': len(external), 'source_maps': len(source_maps)}), flush=True)


if __name__ == '__main__':
    main()
