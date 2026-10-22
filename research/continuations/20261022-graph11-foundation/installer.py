"""Prepare, then install, an exact literal partition of graph11 foundation data.

No compiler, replay, Git mutation, or accepted-root edit is performed here.
"""
from pathlib import Path
import fcntl, hashlib, importlib.util, json, os, re, subprocess, sys

R = Path('/Users/tp/Lean/D1Bound5')
W = R / 'research/continuations/20261018T010800CEST-main-continuation'
O = Path(__file__).resolve().parent
assert O == R / 'research/continuations/20261022-graph11-foundation'
D = W / 'continuation_driver_capacity.py'
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
ORIGINAL = {
    'SmallPairLightData11': '64718f23e6a892255fdf1a0972ee451dce5338e39e3574bf24587bc4b1af2b24',
    'SmallPairLightAdaptiveData11': 'e363601e1f8ad8d058fee259a0b6e71200da85795a9b06a7bac76285671940e0',
    'SmallPairLightAdaptiveValidation11': '8a6f9acc4561a31457b2ac5842534035619e3e9f980e0d4088fdc08ffdb61997',
}
GROUPS = {
    'SmallPairLightData11Left': ['sieve', 'leftVertices', 'leftCached'],
    'SmallPairLightData11LeftRows': ['leftRows'],
    'SmallPairLightData11Right': ['rightVertices', 'rightCached'],
    'SmallPairLightData11RightRows': ['rightRows'],
}

def sha(data): return hashlib.sha256(data).hexdigest()
def load(p): return json.loads(Path(p).read_text())
def put(p, v):
    with Path(p).open('x') as f: f.write(json.dumps(v, indent=2, sort_keys=True) + '\n')
def copy(p, data):
    with Path(p).open('xb') as f: f.write(data)

def no_compiler():
    ps = subprocess.check_output(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True, timeout=10)
    for line in ps.splitlines():
        fields = line.strip().split(None, 3)
        if len(fields) < 4 or int(fields[0]) == os.getpid(): continue
        pid, _, exe, _ = fields
        if Path(exe).name not in ('lean', 'lake', 'leanchecker'): continue
        p = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'], capture_output=True, text=True, timeout=10)
        if p.returncode and subprocess.run(['ps', '-p', pid, '-o', 'pid='], capture_output=True, timeout=10).returncode == 0:
            raise RuntimeError('Cannot identify live compiler cwd: ' + pid)
        assert not any(x == 'n' + str(R) or x.startswith('n' + str(R) + '/') for x in p.stdout.splitlines()), pid

assert sha(D.read_bytes()) == DRIVER_SHA
spec = importlib.util.spec_from_file_location('graph11_install_driver', D)
mod = importlib.util.module_from_spec(spec); sys.modules[spec.name] = mod; spec.loader.exec_module(mod)
mode = sys.argv[1]; assert mode in ['--prepare', '--install']
with (W / 'continuation-driver.lock').open('r+') as owner, (W / 'continuation-intake.lock').open('r+') as intake:
    for f in [owner, intake]: fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = load(W / 'continuation-active.json')
    assert not active.get('active') and not active.get('protected_closure')
    no_compiler()
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=R, text=True).strip() == 'main'
    assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=R)
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=R, text=True).strip()
    assert head == load(O / 'START.json')['head']
    d = mod.Driver(R, W); q, names, closures, accepted, unknown, eligible = d.snapshot()
    assert unknown == [] and q['max_parallel'] == 1 and q['pause_after_current'] is True
    assert len(names) == len(q['names'])
    assert not set(ORIGINAL) & accepted
    assert all(not (set(ORIGINAL) & set(closures[n])) for n in accepted), 'An accepted dependent would be changed'
    raw = {}
    for n, h in ORIGINAL.items():
        p = R / 'D1Bound5' / (n + '.lean')
        assert p.is_file() and not p.is_symlink()
        raw[n] = p.read_bytes(); assert sha(raw[n]) == h, n
    for n in GROUPS: assert not (R / 'D1Bound5' / (n + '.lean')).exists(), n
    assert not (O / 'INSTALL_RECEIPT.json').exists()
    qraw = d.queue_path.read_bytes()

    if mode == '--prepare':
        assert not (O / 'PLAN.json').exists()
        original = raw['SmallPairLightData11']
        matches = list(re.finditer(rb'^def (\w+)\s*:', original, re.M))
        end = original.rfind(b'end D1Bound5.PairLightPrepared11')
        assert end > matches[-1].start()
        prefix, suffix = original[:matches[0].start()], original[end:]
        blocks = {m[1].decode(): original[m.start():matches[i+1].start() if i+1 < len(matches) else end] for i, m in enumerate(matches)}
        expected_names = [n for group in GROUPS.values() for n in group]
        assert list(blocks) == expected_names
        assert prefix + b''.join(blocks.values()) + suffix == original
        assert prefix.startswith(b'import D1Bound5.PairLightArithmetic\n')
        assert prefix.count(b'namespace ') == 1 and suffix.strip() == b'end D1Bound5.PairLightPrepared11'
        for n, b in blocks.items():
            assert re.match(rb'def \w+\s*:[^\n]*:= \[\n', b)
            assert sum(line.startswith(b'  ') for line in b.splitlines()) == (25 if n == 'sieve' else 359), n
        candidates = {n: prefix + b''.join(blocks[x] for x in group) + suffix for n, group in GROUPS.items()}
        candidates['SmallPairLightData11'] = ''.join('import D1Bound5.' + n + '\n' for n in GROUPS).encode()
        for n in ['SmallPairLightAdaptiveData11', 'SmallPairLightAdaptiveValidation11']: candidates[n] = raw[n]
        assert len(candidates) == 7
        for n, b in candidates.items():
            assert not re.search(rb'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe)\b', b), n
        origins = {n: {'original_module': 'SmallPairLightData11', 'names': group} for n, group in GROUPS.items()}
        origins['SmallPairLightData11'] = {'original_module': 'SmallPairLightData11', 'names': []}
        for n in ['SmallPairLightAdaptiveData11', 'SmallPairLightAdaptiveValidation11']:
            origins[n] = {'original_module': n, 'names': re.findall(r'^(?:def|theorem)\s+(\S+)\s*:', raw[n].decode(), re.M)}
        assert sum(len(v['names']) for v in origins.values()) == 23
        (O / 'installation').mkdir(); (O / 'candidates').mkdir()
        for n, b in raw.items(): copy(O / 'installation' / (n + '.before.lean'), b)
        copy(O / 'installation/continuation-queue.before.json', qraw)
        for n, b in candidates.items(): copy(O / 'candidates' / (n + '.lean'), b)
        plan = {'status': 'EXACT_GRAPH11_LITERAL_PARTITION_PREPARED_NOT_INSTALLED', 'base_commit': head,
                'source_manifest': {n: sha(b) for n, b in candidates.items()}, 'original_source_manifest': ORIGINAL,
                'targets': list(candidates), 'original_data_definition_sha256': {n: sha(b) for n, b in blocks.items()},
                'queue_before_sha256': sha(qraw), 'configuration': d.static,
                'definition_partition_exact': True, 'original_public_declarations': 23,
                'source_bytes': {n: len(b) for n, b in candidates.items()},
                'main_theorem_complete': False, 'root_integration': False,
                'canonical_root_sha256': sha((R / 'D1Bound5.lean').read_bytes())}
        put(O / 'PLAN.json', plan); put(O / 'DECLARATION_ORIGINS.json', origins)
        put(O / 'foundation-TARGETS.json', list(candidates))
        template = (O / 'bounded_build_template.py').read_text()
        assert template.count('__REVIEWED_SOURCE_PINS__') == 1
        copy(O / 'bounded_build.py', template.replace('__REVIEWED_SOURCE_PINS__', repr(plan['source_manifest'])).encode())
        payload = {str(p.relative_to(O)): sha(p.read_bytes()) for p in O.rglob('*') if p.is_file() and p.name != 'START.json'}
        put(O / 'PREPARED_PAYLOAD_SHA256.json', payload)
        print(json.dumps({'status': plan['status'], 'plan_sha256': sha((O / 'PLAN.json').read_bytes()), 'payload_sha256': sha((O / 'PREPARED_PAYLOAD_SHA256.json').read_bytes()), 'targets': plan['targets'], 'source_bytes': plan['source_bytes']}))
    else:
        assert len(sys.argv) == 4
        assert sha((O / 'PLAN.json').read_bytes()) == sys.argv[2]
        assert sha((O / 'PREPARED_PAYLOAD_SHA256.json').read_bytes()) == sys.argv[3]
        payload = load(O / 'PREPARED_PAYLOAD_SHA256.json')
        for rel, h in payload.items():
            p = O / rel
            assert p.resolve().is_relative_to(O) and not p.is_symlink() and sha(p.read_bytes()) == h, rel
        plan = load(O / 'PLAN.json'); assert plan['original_source_manifest'] == ORIGINAL
        assert head == plan['base_commit']
        assert sha(qraw) == plan['queue_before_sha256'] and d.static == plan['configuration']
        assert sha((R / 'D1Bound5.lean').read_bytes()) == plan['canonical_root_sha256']
        candidates = {n: (O / 'candidates' / (n + '.lean')).read_bytes() for n in plan['targets']}
        assert {n: sha(b) for n, b in candidates.items()} == plan['source_manifest']
        union = {}
        def proposed_closure(n):
            if n in union: return
            b = candidates[n] if n in candidates else (R / 'D1Bound5' / (n + '.lean')).read_bytes()
            union[n] = sha(b)
            for line in mod.IMPORT_LINE.findall(b):
                content = line.split(b'--', 1)[0]; imports = mod.IMPORT_NAME.findall(content)
                assert b'D1Bound5' not in content or imports
                for dep in imports: proposed_closure(dep.decode())
        for n in candidates: proposed_closure(n)
        assert not set(union) & set(q.get('blocked_modules', []))
        latest = d.latest()
        for n in set(union) - set(candidates):
            closure = d.closure(n); mf = d.expected_manifest(n, mod.fingerprint(closure), latest)
            assert mf and d.artifacts(n) == mf, n
        for n, b in candidates.items():
            p = R / 'D1Bound5' / (n + '.lean')
            if n not in ORIGINAL: copy(p, b)
            elif b != raw[n]:
                temp = p.with_name(p.name + '.graph11-install.' + str(os.getpid()))
                copy(temp, b); os.replace(temp, p)
        where = q['names'].index('SmallPairLightData11')
        q['names'][where:where] = list(GROUPS)
        mod.atomic_json(d.queue_path, q)
        q2, names2, closures2, accepted2, unknown2, eligible2 = d.snapshot()
        assert unknown2 == [] and accepted <= accepted2
        assert set(GROUPS) <= set(eligible2)
        receipt = {'status': 'EXACT_GRAPH11_LITERAL_PARTITION_INSTALLED_NOT_BUILT', 'utc': mod.utc(),
                   'plan_sha256': sys.argv[2], 'prepared_payload_sha256': sys.argv[3],
                   'source_manifest': plan['source_manifest'], 'queue_after_sha256': sha(d.queue_path.read_bytes()),
                   'unknown': unknown2, 'previous_accepted_sources_retained': True,
                   'main_theorem_complete': False, 'root_integration': False}
        put(O / 'INSTALL_RECEIPT.json', receipt)
        print(json.dumps(receipt))
