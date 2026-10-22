"""Bind accepted graph46 foundation builds to exact originals and committed provenance."""
from pathlib import Path
import fcntl
import importlib.util
import json
import os
import re
import subprocess
import sys

from foundation_inputs import (
    DRIVER_SHA, RUNNER_SHA, GROUPS, ORIGINAL_NAMES, TARGETS, declarations,
    digest, inspect_sources, load_binding, source_hash, verify_prepared,
)


if not __debug__:
    raise RuntimeError('Do not disable verification assertions')
sys.dont_write_bytecode = True
R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
U = R / 'research/continuations/20261020T100000CEST-work-resume'
O = Path(__file__).resolve().parent
scope = 'foundation'
A = U / 'pro-graph46-foundation-audit'


def load(path):
    return json.loads(Path(path).read_text())


def put(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def absent(path):
    assert not path.exists() and not path.is_symlink(), str(path)


def repo_file(value):
    path = Path(value)
    if not path.is_absolute():
        assert '..' not in path.parts
        path = R / path
    assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(R.resolve()), str(path)
    return path


def git(*arguments):
    return subprocess.check_output(['git', *arguments], cwd=R, text=True, timeout=30).strip()


def verify_prepared_inputs(driver):
    """Recheck exact prepared bytes, installation, and current project inputs."""
    binding, plan, payload = verify_prepared(O)
    installation = load(repo_file(O / 'INSTALL_RECEIPT.json'))
    assert installation['status'] == 'EXACT_GRAPH46_LITERAL_PARTITION_INSTALLED_NOT_BUILT'
    assert source_hash(O / 'PLAN.json') == installation['plan_sha256']
    assert source_hash(O / 'PREPARED_PAYLOAD_SHA256.json') == installation['prepared_payload_sha256']
    assert source_hash(O / 'GRAPH46_BINDING.json') == plan['input_binding_sha256'] == installation['input_binding_sha256']
    assert installation['source_manifest'] == plan['source_manifest']
    assert plan['targets'] == load(repo_file(O / 'foundation-TARGETS.json')) == TARGETS
    assert set(plan['source_manifest']) == set(TARGETS)
    for item in (plan, installation):
        assert item['root_integration'] is False and item['main_theorem_complete'] is False
    assert source_hash(driver.queue_path) == installation['queue_after_sha256']
    queue = load(driver.queue_path)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert set(TARGETS) <= set(queue['names'])
    assert driver.static == plan['configuration'] == binding['configuration'] == load(repo_file(O / 'CONFIGURATION.json'))
    assert driver.manifest_matches(binding['configuration'], cached=False)
    assert source_hash(R / 'D1Bound5.lean') == binding['canonical_root_sha256'] == plan['canonical_root_sha256']
    assert all(source_hash(repo_file('D1Bound5/' + name + '.lean')) == expected
               for name, expected in plan['source_manifest'].items())
    return binding, plan, installation


def no_compiler():
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
                       for item in process.stdout.splitlines()), pid


def main():
    assert O == R / 'research/continuations/20261022-graph46-foundation'
    assert len(sys.argv) == 2 and sys.argv[1] == scope
    binding = load_binding(O)
    assert source_hash(W / 'continuation_driver_capacity.py') == DRIVER_SHA
    assert source_hash(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
    with (W / 'continuation-driver.lock').open('r+') as owner, \
            (W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        active_bytes = (W / 'continuation-active.json').read_bytes()
        active = json.loads(active_bytes)
        assert not active.get('active') and not active.get('protected_closure')
        no_compiler()
        assert git('branch', '--show-current') == 'main' and not git('diff', '--cached', '--name-only')
        base = git('rev-parse', 'HEAD')
        assert base == binding['base_commit']
        index_path = Path(git('rev-parse', '--git-path', 'index'))
        index_path = index_path if index_path.is_absolute() else R / index_path
        index_sha = source_hash(index_path)
        spec = importlib.util.spec_from_file_location('graph46_prepare_driver', W / 'continuation_driver_capacity.py')
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)
        driver = module.Driver(R, W)
        latest = driver.latest()
        checked_binding, plan, installation = verify_prepared_inputs(driver)
        assert checked_binding == binding
        runtime = {str(path): source_hash(path) for path in (
            driver.queue_path, driver.active_path, driver.state_path, driver.baseline_path,
            O / 'INSTALL_RECEIPT.json',
        )}
        assert plan['targets'] == load(O / 'foundation-TARGETS.json') == TARGETS
        assert plan['original_source_manifest'] == binding['source_evidence']['original_source_manifest']
        assert plan['declaration_counts'] == binding['source_evidence']['declaration_counts']
        assert plan['original_public_declarations'] == plan['declaration_counts']['total']
        assert plan['root_integration'] is False and plan['main_theorem_complete'] is False
        original_paths = {name: O / 'installation' / (name + '.before.lean') for name in ORIGINAL_NAMES}
        original_bytes = {}
        for name, path in original_paths.items():
            assert source_hash(path) == plan['original_source_manifest'][name]
            original_bytes[name] = path.read_bytes()
        assert inspect_sources(original_bytes) == binding['source_evidence']
        original_declarations = {name: declarations(data.decode()) for name, data in original_bytes.items()}
        origin_path = O / 'DECLARATION_ORIGINS.json'
        origin_sha = source_hash(origin_path)
        origins = load(origin_path)
        expected_origins = {name: {'original_module': ORIGINAL_NAMES[0], 'names': group}
                            for name, group in GROUPS.items()}
        expected_origins[ORIGINAL_NAMES[0]] = {'original_module': ORIGINAL_NAMES[0], 'names': []}
        for name in ORIGINAL_NAMES[1:]:
            expected_origins[name] = {'original_module': name,
                                      'names': [item['local_name'] for item in original_declarations[name]]}
        assert origins == expected_origins
        provenance_path = O / 'PROVENANCE_BINDING.json'
        provenance_sha = source_hash(provenance_path)
        provenance = load(provenance_path)
        assert provenance['schema'] == 1 and provenance['status'] == 'COMMITTED_PROVENANCE_BOUND'
        assert provenance['base_commit'] == base and provenance['source_maps']
        oldmap, used_maps = {}, {}
        for item in provenance['source_maps']:
            relative, expected = Path(item['path']), item['sha256']
            assert not relative.is_absolute() and '..' not in relative.parts
            assert isinstance(expected, str) and re.fullmatch(r'[0-9a-f]{64}', expected)
            path = R / relative
            assert path.resolve().is_relative_to(R) and source_hash(path) == expected
            blob = subprocess.check_output(['git', 'show', base + ':' + str(relative)], cwd=R, timeout=15)
            assert digest(blob) == expected, 'Provenance map must be committed: ' + str(relative)
            assert str(relative) not in used_maps
            used_maps[str(relative)] = expected
            for name, entry in load(path)['sources'].items():
                oldmap[(name, entry['sha256'])] = entry

        absent(A)
        for suffix in ('-SOURCE_MAP.json', '-ACCEPTED_DEPENDENCY_EVIDENCE.json', '-PREPARATION.json',
                       '-PROOF_STATE.json', '-VERIFICATION_SUMMARY.json'):
            absent(O / (scope + suffix))
        all_declarations, audit_sources, receipt_map, records, union, snapshots = [], {}, {}, [], {}, {}
        receipt_guards = {}
        for name in TARGETS:
            source = R / 'D1Bound5' / (name + '.lean')
            current_sha = source_hash(source)
            assert current_sha == plan['source_manifest'][name] == source_hash(O / 'candidates' / (name + '.lean'))
            row = load(O / (name + '-BUILD_RECEIPT.json'))
            closure = load(O / (name + '-SOURCE_CLOSURE.json'))
            assert row['name'] == name and row['accepted_build'] is True and row['exit'] == 0
            assert row['timed_out'] is False and row['interrupted'] is False and row['timeout_seconds'] == 240
            assert row['closure_unchanged'] is True and row['shared_artifacts_unchanged'] is True
            assert row['source_sha256'] == current_sha and driver.closure(name) == closure
            assert module.fingerprint(closure) == row['fingerprint'] and driver.artifacts(name) == row['artifacts']
            assert driver.expected_manifest(name, row['fingerprint'], latest) == row['artifacts']
            assert load(O / (name + '-ORIGINAL_SOURCES.json')) == closure
            snapshots[name] = source.read_bytes()
            assert (O / (name + '.lean')).read_bytes() == snapshots[name]
            for suffix in ('.lean', '-SOURCE_CLOSURE.json', '-BUILD_RECEIPT.json', '-ORIGINAL_SOURCES.json'):
                path = repo_file(O / (name + suffix))
                receipt_guards[str(path)] = source_hash(path)
            for key, value in closure.items():
                assert key not in union or union[key] == value
                union[key] = value
            origin = origins[name]
            original = original_paths[origin['original_module']]
            available = {item['local_name']: item for item in original_declarations[origin['original_module']]}
            before = [available[local_name] for local_name in origin['names']]
            assert before == declarations(snapshots[name].decode()), name
            if name in ORIGINAL_NAMES[1:]:
                assert snapshots[name] == original_bytes[name]
            if name == ORIGINAL_NAMES[0]:
                assert snapshots[name] == ''.join('import D1Bound5.' + part + '\n' for part in GROUPS).encode()
            source_hashes = {item['name']: digest(item['source_text'].encode()) for item in before}
            public = [{key: value for key, value in item.items() if key != 'source_text'} for item in before]
            audit_sources[name] = {'source': str(source.relative_to(R)),
                                   'snapshot': str((A / (name + '.lean')).relative_to(R)), 'sha256': current_sha}
            receipt_map[name] = {'receipt': str((O / (name + '-BUILD_RECEIPT.json')).relative_to(R)),
                                 'closure': str((O / (name + '-SOURCE_CLOSURE.json')).relative_to(R))}
            records.append({'module': name, 'original_path': str(original), 'original_source_path': str(original),
                            'original_sha256': source_hash(original), 'current_sha256': current_sha,
                            'raw_original_module': origin['original_module'],
                            'origin_map_path': str(origin_path), 'origin_map_sha256': origin_sha,
                            'declaration_source_sha256': source_hashes, 'normalizations': [], 'declarations': public})
            all_declarations.extend(public)
        names = [item['name'] for item in all_declarations]
        counts = binding['source_evidence']['declaration_counts']
        original_names = [item['name'] for group in original_declarations.values() for item in group]
        assert len(names) == len(set(names)) == counts['total'] and set(names) == set(original_names)
        assert sum(item['kind'] == 'def' for item in all_declarations) == counts['definitions']
        assert sum(item['kind'] == 'theorem' for item in all_declarations) == counts['theorems']

        source_map, evidence, artifact_guards = {}, {}, {}
        for name, expected in sorted(union.items()):
            assert source_hash(repo_file('D1Bound5/' + name + '.lean')) == expected
            key = module.fingerprint(driver.closure(name))
            artifacts = driver.expected_manifest(name, key, latest)
            assert artifacts and driver.artifacts(name) == artifacts, name
            for path, value in artifacts.items():
                assert path not in artifact_guards or artifact_guards[path] == value
                artifact_guards[path] = value
            if name in plan['source_manifest']:
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
                                    'base_commit': commit, 'base_path': path,
                                    'assurance': 'reused_accepted_source_and_artifacts'}
            evidence[name] = {'fingerprint': key, 'artifacts': artifacts, 'original_receipt': latest.get((name, key)),
                              'baseline_entry': None if (name, key) in latest else driver.baseline['accepted'][name]}

        harness = ''.join('import D1Bound5.' + name + '\n' for name in TARGETS)
        harness += 'import Lean.Elab.Command\nimport Lean.Util.CollectAxioms\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
        harness += 'run_cmd do\n  let names : List Lean.Name := [\n    ' + ',\n    '.join('`' + name for name in names) + ']\n'
        harness += ('  for name in names do\n    let ax ← Lean.collectAxioms name\n'
                    '    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n'
                    '    unless bad.isEmpty do\n      Lean.throwError "Unexpected axioms in {name}: {bad}"\n'
                    '    Lean.logInfo m!"GRAPH46_FOUNDATION_AXIOMS_PASS {name}: {ax}"\n\n')
        for item in all_declarations:
            harness += ('namespace ' + item['namespace'] + '\n' + '\n'.join(item['opens']) + '\nexample\n'
                        + item['header'] + ' :=\n  _root_.' + item['name'] + '\nend ' + item['namespace'] + '\n\n')
        harness += ''.join('#check @_root_.' + name + '\n' for name in names)
        assert re.findall(r'^example\s*(.*?)\s*:=', harness, re.M | re.S) == [item['header'] for item in all_declarations]
        assert source_hash(origin_path) == origin_sha and source_hash(provenance_path) == provenance_sha
        assert all(source_hash(path) == plan['original_source_manifest'][name] for name, path in original_paths.items())
        assert all(source_hash(repo_file(path)) == expected for path, expected in used_maps.items())
        assert all(source_hash(repo_file('D1Bound5/' + name + '.lean')) == expected for name, expected in union.items())
        assert all(source_hash(repo_file(path)) == expected for path, expected in receipt_guards.items())
        assert driver.manifest_matches(artifact_guards, cached=False)
        assert verify_prepared_inputs(driver) == (binding, plan, installation)
        assert all(source_hash(path) == expected for path, expected in runtime.items())
        assert (W / 'continuation-active.json').read_bytes() == active_bytes
        assert source_hash(W / 'continuation_driver_capacity.py') == DRIVER_SHA
        assert source_hash(U / 'bound_scoped_audit_runner_proposal_v1.py') == RUNNER_SHA
        assert git('rev-parse', 'HEAD') == base and git('branch', '--show-current') == 'main'
        assert source_hash(index_path) == index_sha and not git('diff', '--cached', '--name-only')
        no_compiler()
        A.mkdir()
        for name, data in snapshots.items():
            with (A / (name + '.lean')).open('xb') as stream:
                stream.write(data)
        with (A / 'AnalyticAudit.lean').open('x') as stream:
            stream.write(harness)
        for filename, value in [('TARGETS.json', TARGETS), ('REPLAY_TARGETS.json', TARGETS),
                                ('SOURCE_MAP.json', audit_sources), ('BUILD_RECEIPT_MAP.json', receipt_map),
                                ('SCOPED_ORIGINAL_DECLARATIONS.json', records), ('DECLARATION_NAMES.json', names)]:
            put(A / filename, value)
        put(A / 'PROVENANCE_BINDING_USED.json', {'binding_sha256': provenance_sha, 'source_maps': used_maps})
        put(O / 'foundation-SOURCE_MAP.json', {'base_commit': base, 'sources': source_map})
        put(O / 'foundation-ACCEPTED_DEPENDENCY_EVIDENCE.json', evidence)
        summary = {'targets': TARGETS, 'declarations': len(names), 'theorems': counts['theorems'],
                   'definitions': counts['definitions'], 'source_closure_modules': len(union),
                   'audit': str(A.relative_to(R)), 'public_headers_exact': True, 'base_commit': base,
                   'input_binding_sha256': source_hash(O / 'GRAPH46_BINDING.json'),
                   'root_integration': False, 'main_theorem_complete': False}
        put(O / 'foundation-PREPARATION.json', summary)
        print(json.dumps({'status': 'ACCEPTED_UNIT_PREPARED_FOR_AUDIT', **summary}), flush=True)


if __name__ == '__main__':
    main()
