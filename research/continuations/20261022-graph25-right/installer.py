"""Install only the reviewed right25 partition; never launch a compiler or Git mutation."""
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
EXPECTED_OUT = ROOT / 'research/continuations/20261022-graph25-right'
DRIVER = WORK / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
RUNNER = ROOT / 'research/continuations/20261020T100000CEST-work-resume/bound_scoped_audit_runner_proposal_v1.py'
RUNNER_SHA = 'efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
ORIGINAL_SHA = {
    'SmallPairLightAdaptiveRight25_000': '787d58dce14397547bc0454d21afd54e633ac36191242651f80f854975fa97bc',
    'SmallPairLightAdaptiveRight25_001': '449d1e64d31b5780f8b06508068e94a7bd637fdb182221d7417e93925fdc5e40',
    'SmallPairLightRight25': '70c6248dc2dc035ca05801835bc96b2963b6f3ed535bf20987af02a53e0f30ec',
}
PARTITIONS = [
    ('000', 0, 125, [(0, 24), (24, 26), (50, 28), (78, 31), (109, 16)]),
    ('001', 125, 256, [(0, 38), (38, 46), (84, 64), (148, 108)]),
]


def sha(data):
    return hashlib.sha256(data).hexdigest()


def load(path):
    return json.loads(Path(path).read_text())


def write_new(path, value):
    with Path(path).open('x') as stream:
        stream.write(json.dumps(value, indent=2, sort_keys=True) + '\n')


def copy_new(path, data):
    with Path(path).open('xb') as stream:
        stream.write(data)


def public_headers(data):
    return [(m[1], m[2], m[3].strip()) for m in re.finditer(
        r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=', data.decode(), re.M | re.S)]


def no_live_project_compiler():
    ps = subprocess.run(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True,
                        capture_output=True, check=True, timeout=10).stdout
    for line in ps.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid():
            continue
        pid, _, executable, _ = fields
        if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
            continue
        result = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                                text=True, capture_output=True, timeout=10)
        # If the process disappeared, there is nothing to protect. A surviving
        # compiler with an unreadable cwd must be inspected instead of ignored.
        if result.returncode and subprocess.run(
                ['ps', '-p', pid, '-o', 'pid='], capture_output=True, text=True,
                timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify compiler cwd: ' + pid)
        assert not any(s == 'n' + str(ROOT) or s.startswith('n' + str(ROOT) + '/')
                       for s in result.stdout.splitlines()), 'Another project compiler: ' + pid


assert OUT == EXPECTED_OUT, 'Install only from the reviewed remote run directory'
assert sha(DRIVER.read_bytes()) == DRIVER_SHA
assert sha(RUNNER.read_bytes()) == RUNNER_SHA
payload = load(OUT / 'PAYLOAD_SHA256.json')
for rel, digest in payload.items():
    path = OUT / rel
    assert path.is_file() and not path.is_symlink()
    assert path.resolve().is_relative_to(OUT) and sha(path.read_bytes()) == digest, rel

spec = importlib.util.spec_from_file_location('right25_install_driver', DRIVER)
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)

with (WORK / 'continuation-driver.lock').open('r+') as owner, \
        (WORK / 'continuation-intake.lock').open('r+') as intake:
    for lock in (owner, intake):
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = load(WORK / 'continuation-active.json')
    assert not active.get('active') and not active.get('protected_closure')
    no_live_project_compiler()
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=ROOT,
                                   text=True, timeout=10).strip() == 'main'
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'],
                                       cwd=ROOT, timeout=10), 'Review staged work first'
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT,
                                   text=True, timeout=10).strip()
    driver = module.Driver(ROOT, WORK)
    queue_path = driver.queue_path
    queue_bytes = queue_path.read_bytes()
    queue = json.loads(queue_bytes)
    assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
    assert len(queue['names']) == len(set(queue['names'])), 'Existing duplicate queue entries'
    assert not (OUT / 'PLAN.json').exists() and not (OUT / 'INSTALL_RECEIPT.json').exists()
    audit = ROOT / 'research/continuations/20261020T100000CEST-work-resume/pro-graph25-right-audit'
    assert not audit.exists(), 'Existing right audit must be reviewed separately'

    originals = {}
    for name, expected in ORIGINAL_SHA.items():
        source = ROOT / 'D1Bound5' / (name + '.lean')
        assert source.is_file() and not source.is_symlink()
        original = source.read_bytes()
        assert sha(original) == expected, 'Original byte drift: ' + name
        reference = OUT / 'payload/originals' / (name + '.lean')
        assert original.decode().rstrip() == reference.read_text().rstrip(), name
        originals[name] = original

    candidates = {}
    targets = []
    coverage = []
    for suffix, global_start, parent_count, parts in PARTITIONS:
        cursor = 0
        for index, (start, count) in enumerate(parts):
            assert start == cursor and count > 0
            cursor += count
            name = 'SmallPairLightAdaptiveRight25_' + suffix + 'Part' + f'{index:02d}'
            assert not (ROOT / 'D1Bound5' / (name + '.lean')).exists(), name
            candidate = OUT / 'payload/candidates' / (name + '.lean')
            assert str(candidate.relative_to(OUT)) in payload
            candidates[name] = candidate.read_bytes()
            originals[name] = candidates[name]
            targets.append(name)
            coverage.append({'module': name, 'parent_suffix': suffix,
                             'local_start': start, 'global_start': global_start + start,
                             'head_count': count, 'full_tail': True})
        assert cursor == parent_count
        name = 'SmallPairLightAdaptiveRight25_' + suffix
        candidate = OUT / 'payload/candidates' / (name + '.lean')
        assert str(candidate.relative_to(OUT)) in payload
        candidates[name] = candidate.read_bytes()
        assert public_headers(candidates[name]) == public_headers(originals[name]), name
        targets.append(name)
    wrapper = 'SmallPairLightRight25'
    candidates[wrapper] = originals[wrapper]
    targets.append(wrapper)
    assert len(targets) == 12 and len(coverage) == 9
    assert set(candidates) == set(targets) == set(originals)
    assert sum(item['head_count'] for item in coverage) == 381
    for name, source in candidates.items():
        assert not re.search(rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe)\b', source), name

    def proposed_closure(name, seen=None):
        seen = {} if seen is None else seen
        if name in seen:
            return seen
        assert module.VALID_NAME.fullmatch(name)
        data = candidates[name] if name in candidates else (ROOT / 'D1Bound5' / (name + '.lean')).read_bytes()
        seen[name] = sha(data)
        for line in module.IMPORT_LINE.findall(data):
            content = line.split(b'--', 1)[0]
            imports = module.IMPORT_NAME.findall(content)
            assert b'D1Bound5' not in content or imports
            for dep in imports:
                proposed_closure(dep.decode(), seen)
        return seen

    union = {}
    for name in targets:
        for dependency, digest in proposed_closure(name).items():
            assert dependency not in union or union[dependency] == digest
            union[dependency] = digest
    assert not (set(union) & set(queue.get('blocked_modules', [])))
    latest = driver.latest()
    dependencies = {}
    for name in sorted(set(union) - set(targets)):
        closure = driver.closure(name)
        assert all(union.get(n) == h for n, h in closure.items()), name
        key = module.fingerprint(closure)
        expected = driver.expected_manifest(name, key, latest)
        assert expected and driver.artifacts(name) == expected, 'Unaccepted dependency: ' + name
        dependencies[name] = {'fingerprint': key, 'artifacts': expected}
    for name in targets:
        key = module.fingerprint(proposed_closure(name))
        assert (name, key) not in latest, 'Existing exact attempt: ' + name

    new_queue = json.loads(queue_bytes)
    for suffix, _, _, parts in PARTITIONS:
        parent = 'SmallPairLightAdaptiveRight25_' + suffix
        assert parent in new_queue['names'], 'Original parent absent from queue'
        new_parts = ['SmallPairLightAdaptiveRight25_' + suffix + 'Part' + f'{i:02d}'
                     for i in range(len(parts))]
        assert not (set(new_parts) & set(new_queue['names']))
        where = new_queue['names'].index(parent)
        new_queue['names'][where:where] = new_parts
    assert wrapper in new_queue['names']
    assert {k: v for k, v in new_queue.items() if k != 'names'} == {
        k: v for k, v in queue.items() if k != 'names'}
    assert [n for n in new_queue['names'] if n in queue['names']] == queue['names']

    manifest = {name: sha(data) for name, data in candidates.items()}
    pin_nodes = [node.value for node in ast.parse((OUT / 'bounded_build.py').read_text()).body
                 if isinstance(node, ast.Assign) and any(
                     isinstance(t, ast.Name) and t.id == 'PINS' for t in node.targets)]
    assert len(pin_nodes) == 1 and ast.literal_eval(pin_nodes[0]) == manifest, 'Static build pins differ'
    plan = {'status': 'PREPARED_NOT_COMPILED', 'side': 'right', 'model': [1, 1],
            'original_parent_counts': [125, 256], 'coverage': coverage,
            'targets': targets, 'source_manifest': manifest,
            'original_source_sha256': ORIGINAL_SHA, 'base_commit': head,
            'root_integration': False, 'whole_graph25_complete': False,
            'main_theorem_complete': False}
    (OUT / 'originals').mkdir()
    (OUT / 'candidates').mkdir()
    for name in targets:
        copy_new(OUT / 'originals' / (name + '.lean'), originals[name])
        copy_new(OUT / 'candidates' / (name + '.lean'), candidates[name])
    copy_new(OUT / 'QUEUE_BEFORE.json', queue_bytes)
    write_new(OUT / 'CONFIGURATION.json', driver.static)
    write_new(OUT / 'EXTERNAL_DEPENDENCY_GUARDS.json', dependencies)
    write_new(OUT / 'PLAN.json', plan)
    write_new(OUT / 'right-TARGETS.json', targets)
    write_new(OUT / 'INSTALL_STARTED.json', {
        'utc': datetime.now(timezone.utc).isoformat(), 'base_commit': head,
        'targets': targets, 'source_manifest': manifest, 'compiler_run': False,
        'baseline_changed': False, 'queue_sha256_before': sha(queue_bytes)})

    # Recheck protected originals immediately before replacing proof bodies.
    assert queue_path.read_bytes() == queue_bytes and driver.manifest_matches(driver.static)
    for name, expected in ORIGINAL_SHA.items():
        assert sha((ROOT / 'D1Bound5' / (name + '.lean')).read_bytes()) == expected
    for name in targets:
        if name == wrapper:
            continue  # The wrapper stays byte-for-byte unchanged in the tree.
        destination = ROOT / 'D1Bound5' / (name + '.lean')
        if name not in ORIGINAL_SHA:
            copy_new(destination, candidates[name])
        else:
            temporary = destination.with_name(destination.name + '.right25-install.' + str(os.getpid()))
            copy_new(temporary, candidates[name])
            os.replace(temporary, destination)
    for name, expected in manifest.items():
        assert sha((ROOT / 'D1Bound5' / (name + '.lean')).read_bytes()) == expected
    module.atomic_json(queue_path, new_queue)
    write_new(OUT / 'INSTALL_RECEIPT.json', {
        'status': 'RIGHT_PARTITIONS_INSTALLED_NOT_COMPILED',
        'utc': datetime.now(timezone.utc).isoformat(), 'base_commit': head,
        'targets': targets, 'source_manifest': manifest, 'coverage_parts': len(coverage),
        'queue_entries_added': len(new_queue['names']) - len(queue['names']),
        'queue_sha256_before': sha(queue_bytes), 'queue_sha256_after': sha(queue_path.read_bytes()),
        'source_closure_modules': len(union), 'wrapper_unchanged': True,
        'compiler_run': False, 'baseline_changed': False,
        'root_integration': False, 'whole_graph25_complete': False,
        'main_theorem_complete': False})
    print(json.dumps(load(OUT / 'INSTALL_RECEIPT.json')), flush=True)
