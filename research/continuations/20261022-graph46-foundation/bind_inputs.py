"""Bind actual idle graph46 foundation inputs and committed external provenance.

Usage: python3.12 -B bind_inputs.py HEAD QUEUE_SHA INSPECTION_SHA SOURCE_MAP [SOURCE_MAP ...]
Source-map arguments are repository-relative paths. Only new research evidence
files are written; this does not install sources, edit Git/queue state, or compile.
"""
from pathlib import Path
import fcntl
import importlib.util
import json
import re
import subprocess
import sys

from foundation_inputs import (
    GRAPH, DRIVER_SHA, RUNNER_SHA, TOOLCHAIN_SHA, LAKE_MANIFEST_SHA, CANONICAL_ROOT_SHA,
    REPOSITORY as R, ORIGINAL_NAMES, GROUPS, SCRIPT_NAMES, inspect_sources, source_hash, digest,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
C = R / 'research/continuations'
W = C / '20261018T010800CEST-main-continuation'
U = C / '20261020T100000CEST-work-resume'
O = C / '20261022-graph46-foundation'
SOURCE_RESEARCH = {
    'research/continuations/20261022-graph46-inspection/inspect_graph46.py':
        '6e3cd9d44a8e27ffa37c78cdf00e6a543c9b749c69e853b1776e17d96bf6ab8f',
    'research/continuations/20261022-graph46-inspection/SOURCE_INSPECTION.json':
        'f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54',
}


def load(path):
    return json.loads(Path(path).read_text())


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def put(path, data):
    with path.open('xb') as stream:
        stream.write(data)


def git(*arguments):
    return subprocess.check_output(['git', *arguments], cwd=R, text=True, timeout=30).strip()


def repo_file(value):
    relative = Path(value)
    assert not relative.is_absolute() and '..' not in relative.parts
    path = R / relative
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve())
    return path


def no_compiler():
    from installer import no_compiler as check
    check()


def main():
    assert Path(__file__).resolve().parent == O
    assert len(sys.argv) >= 5 and re.fullmatch(r'[0-9a-f]{40}', sys.argv[1])
    assert all(re.fullmatch(r'[0-9a-f]{64}', value) for value in sys.argv[2:4])
    head, queue_sha, inspection_sha = sys.argv[1:4]
    map_paths = [repo_file(value) for value in sys.argv[4:]]
    assert len(map_paths) == len(set(map_paths))
    output_paths = [O / name for name in ('GRAPH46_BINDING.json', 'PROVENANCE_BINDING.json', 'BINDING_EVIDENCE.json')]
    assert all(not path.exists() and not path.is_symlink() for path in output_paths)
    driver_path = W / 'continuation_driver_capacity.py'
    runner_path = U / 'bound_scoped_audit_runner_proposal_v1.py'
    assert source_hash(driver_path) == DRIVER_SHA and source_hash(runner_path) == RUNNER_SHA
    inspection_path = O / 'SOURCE_INSPECTION.json'
    assert source_hash(inspection_path) == inspection_sha
    source_evidence = load(inspection_path)
    script_manifest = O / 'REVIEWED_SCRIPT_PINS.json'
    scripts = load(script_manifest)
    assert set(scripts) == SCRIPT_NAMES
    assert all(re.fullmatch(r'[0-9a-f]{64}', expected) and source_hash(O / name) == expected
               for name, expected in scripts.items())
    protected = {str(inspection_path): inspection_sha, str(script_manifest): source_hash(script_manifest)}
    for relative, expected in SOURCE_RESEARCH.items():
        path = repo_file(relative)
        assert source_hash(path) == expected
        protected[str(path)] = expected
    broad = load(C / '20261022-graph46-inspection/SOURCE_INSPECTION.json')
    assert broad['graph'] == GRAPH and broad['source_snapshot_stable'] is True and not broad['errors']
    assert broad['existing_light_fragments'] == [] and not broad['acceptance_claimed']
    for name in ORIGINAL_NAMES:
        item = broad['sources'][name]
        assert source_evidence['original_source_manifest'][name] == item['sha256']
        assert source_evidence['original_source_bytes'][name] == item['bytes']
        assert source_evidence['original_imports'][name] == item['imports']
        before = source_evidence['declaration_headers'][name]
        after = item['declarations']
        assert len(before) == len(after)
        for old, current in zip(before, after):
            assert all(old[key] == current[key] for key in ('kind', 'local_name', 'name', 'namespace', 'header', 'raw_header'))
    assert source_evidence['literal_row_counts'] == broad['literal_counts'][ORIGINAL_NAMES[0]]
    fragments = broad['light_data_partition_offsets']['proposed_fragments']
    assert source_evidence['fragment_source_manifest'] == {name: item['sha256'] for name, item in fragments.items()}
    assert source_evidence['fragment_source_bytes'] == {name: item['bytes'] for name, item in fragments.items()}
    spec = importlib.util.spec_from_file_location('graph46_foundation_binding_driver', driver_path)
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
        index_sha = source_hash(index)
        no_compiler()
        driver = module.Driver(R, W)
        active_bytes = driver.active_path.read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        assert source_hash(driver.queue_path) == queue_sha and unknown == []
        assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
        assert len(names) == len(queue['names'])
        assert set(ORIGINAL_NAMES) <= set(names) and not set(ORIGINAL_NAMES) & accepted
        assert not set(GROUPS) & set(names)
        assert all(not (R / 'D1Bound5' / (name + '.lean')).exists()
                   and not (R / 'D1Bound5' / (name + '.lean')).is_symlink() for name in GROUPS)
        assert all(not set(ORIGINAL_NAMES) & set(closures[name]) for name in accepted)
        assert driver.static['lean-toolchain'] == TOOLCHAIN_SHA and driver.static['lake-manifest.json'] == LAKE_MANIFEST_SHA
        assert driver.manifest_matches(driver.static, cached=False)
        assert source_hash(R / 'D1Bound5.lean') == CANONICAL_ROOT_SHA
        raw = {name: (R / 'D1Bound5' / (name + '.lean')).read_bytes() for name in ORIGINAL_NAMES}
        assert inspect_sources(raw) == source_evidence
        entries, oldmap = [], {}
        for path in map_paths:
            relative = str(path.relative_to(R))
            expected = source_hash(path)
            blob = subprocess.check_output(['git', 'show', head + ':' + relative], cwd=R, timeout=30)
            assert digest(blob) == expected, 'Source map must be committed at the reviewed HEAD: ' + relative
            entries.append({'path': relative, 'sha256': expected})
            protected[str(path)] = expected
            for name, item in load(path)['sources'].items():
                oldmap[(name, item['sha256'])] = (relative, item)
        external = set().union(*(set(closures[name]) for name in ORIGINAL_NAMES)) - set(ORIGINAL_NAMES)
        assert external <= accepted
        latest, evidence, artifacts, source_pins = driver.latest(), {}, {}, {}
        for name in sorted(external):
            closure = driver.closure(name)
            expected = closure[name]
            key = module.fingerprint(closure)
            manifest = driver.expected_manifest(name, key, latest)
            assert manifest and driver.artifacts(name) == manifest
            assert (name, expected) in oldmap, 'Missing committed external provenance: ' + name
            source_map, item = oldmap[(name, expected)]
            commit, path = ((head, item['payload_path']) if 'payload_path' in item
                            else (item['base_commit'], item['base_path']))
            blob = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=R, timeout=30)
            assert digest(blob) == expected and source_hash(repo_file('D1Bound5/' + name + '.lean')) == expected
            evidence[name] = {'source_sha256': expected, 'source_map': source_map,
                              'base_commit': commit, 'base_path': path, 'fingerprint': key, 'artifacts': manifest}
            source_pins[name] = expected
            for artifact, value in manifest.items():
                assert artifact not in artifacts or artifacts[artifact] == value
                artifacts[artifact] = value
        provenance = {'schema': 1, 'status': 'COMMITTED_PROVENANCE_BOUND', 'base_commit': head,
                      'source_maps': entries, 'review': 'Actual committed map/source bytes and current accepted artifacts checked.'}
        provenance_bytes = encoded(provenance)
        binding = {
            'schema': 1, 'graph': GRAPH, 'status': 'GRAPH46_INPUTS_BOUND', 'base_commit': head,
            'queue_before_sha256': queue_sha, 'canonical_root_sha256': CANONICAL_ROOT_SHA,
            'source_inspection_sha256': inspection_sha, 'source_evidence': source_evidence,
            'provenance_binding_sha256': digest(provenance_bytes), 'configuration': driver.static,
            'script_pins': scripts, 'driver_sha256': DRIVER_SHA, 'audit_runner_sha256': RUNNER_SHA,
            'lean_toolchain_sha256': TOOLCHAIN_SHA, 'lake_manifest_sha256': LAKE_MANIFEST_SHA,
            'target_timeout_seconds': 240, 'max_parallel': 1,
            'root_integration': False, 'main_theorem_complete': False,
        }
        binding_bytes = encoded(binding)
        assert all(source_hash(Path(path)) == expected for path, expected in protected.items())
        assert all(source_hash(O / name) == expected for name, expected in scripts.items())
        assert all(source_hash(repo_file('D1Bound5/' + name + '.lean')) == expected for name, expected in source_pins.items())
        assert all(source_hash(repo_file('D1Bound5/' + name + '.lean')) == digest(data) for name, data in raw.items())
        assert driver.manifest_matches(artifacts, cached=False) and driver.manifest_matches(driver.static, cached=False)
        assert source_hash(driver_path) == DRIVER_SHA and source_hash(runner_path) == RUNNER_SHA
        assert source_hash(R / 'D1Bound5.lean') == CANONICAL_ROOT_SHA
        assert source_hash(driver.queue_path) == queue_sha and driver.active_path.read_bytes() == active_bytes
        assert git('rev-parse', 'HEAD') == head and source_hash(index) == index_sha
        assert not git('diff', '--cached', '--name-only')
        no_compiler()
        assert all(not path.exists() and not path.is_symlink() for path in output_paths)
        put(O / 'PROVENANCE_BINDING.json', provenance_bytes)
        put(O / 'GRAPH46_BINDING.json', binding_bytes)
        put(O / 'BINDING_EVIDENCE.json', encoded({
            'status': 'ACTUAL_GRAPH46_FOUNDATION_INPUTS_BOUND_NO_INSTALLATION', 'base_commit': head,
            'input_binding_sha256': digest(binding_bytes), 'provenance_binding_sha256': digest(provenance_bytes),
            'source_inspection_sha256': inspection_sha, 'source_research_files': SOURCE_RESEARCH,
            'external_sources': evidence, 'protected_files': protected,
            'original_target_fingerprints': {name: module.fingerprint(closures[name]) for name in ORIGINAL_NAMES},
            'original_target_latest_attempts': {name: latest.get((name, module.fingerprint(closures[name]))) for name in ORIGINAL_NAMES},
            'original_targets_eligible': {name: name in eligible for name in ORIGINAL_NAMES},
            'compiler_started': False, 'source_files_changed': False, 'queue_changed': False,
            'root_integration': False, 'main_theorem_complete': False,
        }))
        print(json.dumps({'status': 'ACTUAL_GRAPH46_FOUNDATION_INPUTS_BOUND_NO_INSTALLATION',
                          'input_binding_sha256': digest(binding_bytes),
                          'provenance_binding_sha256': digest(provenance_bytes),
                          'external_sources': len(external), 'source_maps': len(entries)}), flush=True)


if __name__ == '__main__':
    main()
