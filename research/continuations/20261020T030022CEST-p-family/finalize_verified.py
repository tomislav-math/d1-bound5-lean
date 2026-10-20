"""Finalize selected completed proof groups from actual guarded receipts. No Git mutations."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, sys
root = Path('/Users/tp/Lean/D1Bound5')
out = Path(__file__).resolve().parent
work = root / 'research/continuations/20261018T010800CEST-main-continuation'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p, value):
    with p.open('x') as f: f.write(json.dumps(value, indent=2) + '\n')
assert sha(work/'continuation_driver_capacity.py') == 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec = importlib.util.spec_from_file_location('d1_verified_unit_finalizer', work/'continuation_driver_capacity.py')
m = importlib.util.module_from_spec(spec); sys.modules[spec.name] = m; spec.loader.exec_module(m)
groups = json.loads((out/'VERIFIED_GROUPS.json').read_text())
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
    fcntl.flock(intake, fcntl.LOCK_EX | fcntl.LOCK_NB)
    active = json.loads((work/'continuation-active.json').read_text())
    assert not active.get('active') and not active.get('protected_closure')
    d = m.Driver(root, work)
    q, ns, cs, acc, unknown, eligible = d.snapshot()
    assert not unknown and q['max_parallel'] == 1 and q['pause_after_current'] is True
    targets = []; decls = []; sources = {}; artifacts = {}; checks = []; coverage = {}
    for relative in groups:
        p = root/relative
        assert p.is_relative_to(root/'research/continuations')
        names = json.loads((p/'TARGETS.json').read_text())
        declarations = json.loads((p/'DECLARATIONS.json').read_text())
        examples = json.loads((p/'EXACT_ORIGINAL_STATEMENT_EXAMPLES.json').read_text())
        wanted = ['analytic-type-axioms'] + [n+'-targeted-replay' for n in json.loads((p/'REPLAY_TARGETS.json').read_text())]
        receipts = json.loads((p/'TARGETED_REPLAY_RECEIPTS.json').read_text())
        assert [c['label'] for c in receipts] == wanted
        assert all(c['exit'] == 0 and not c['timed_out'] and c['guards_unchanged'] for c in receipts)
        assert json.loads((p/'active-targeted-replay.json').read_text())['active'] is False
        log = (p/'analytic-type-axioms.log').read_text()
        assert log.count('ANALYTIC_AXIOMS_PASS ') == len(declarations)
        assert not any(line.startswith('error:') for line in log.splitlines())
        assert len(examples) == sum(c['kind'] == 'theorem' for c in declarations)
        g = json.loads((p/'TARGETED_REPLAY_GUARDS.json').read_text())
        for n, h in g['project_sources'].items():
            assert sha(root/'D1Bound5'/(n+'.lean')) == h
            assert n not in sources or sources[n] == h
            sources[n] = h
        for n, h in {**g['compiled_artifacts'], **g['immutable_inputs']}.items():
            assert sha(root/n) == h and (n not in artifacts or artifacts[n] == h)
            artifacts[n] = h
        coverage[relative] = {'modules': len(names), 'theorems': len(examples), 'declarations': len(declarations), 'targeted_replays': len(receipts)-1}
        targets += names; decls += declarations; checks += receipts
    assert len(targets) == len(set(targets))
    assert len(decls) == len({c['name'] for c in decls})
    assert all(n in acc for n in targets)
    latest = d.latest(); builds = []; source_map = {}
    snap = out/'verified-sources'; snap.mkdir()
    for n in targets:
        row = latest[(n, m.fingerprint(cs[n]))]
        assert row['exit'] == 0 and row['accepted_build']
        src = root/'D1Bound5'/(n+'.lean')
        assert row['source_sha256'] == sha(src)
        dest = snap/(n+'.lean'); dest.write_bytes(src.read_bytes())
        source_map[n] = {'source': str(src.relative_to(root)), 'snapshot': str(dest.relative_to(root)), 'sha256': sha(src)}
        builds.append(row)
    flags = []
    for n in sources:
        text = (root/'D1Bound5'/(n+'.lean')).read_text()
        text = re.sub(r'/\-[\s\S]*?\-/', '', text)
        text = re.sub(r'--[^\n]*', '', text)
        bad = re.findall(r'\b(?:sorry|admit|sorryAx|native_decide)\b|decide\s+\+native|^\s*axiom\b|debug\.skipKernelTC|^\s*unsafe\s+(?:def|theorem)', text, re.M)
        if bad: flags.append({'module': n, 'flags': bad})
    assert not flags, flags
    now = datetime.now().astimezone().isoformat()
    summary = {'time': now, 'outcome': 'COMPLETED_UNIT', 'groups': coverage, 'targets': targets,
        'public_theorems': sum(c['kind'] == 'theorem' for c in decls), 'public_declarations': len(decls),
        'targeted_installed_same_kernel_replays': sum(c['targeted_replays'] for c in coverage.values()),
        'source_closure_modules': len(sources), 'source_scan_flags': flags,
        'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound'],
        'original_public_statements_preserved': True, 'root_integrated': False,
        'independent_review': False, 'clean_checkout': False, 'main_statement_proved': False}
    for n, v in [('VERIFICATION_SUMMARY.json', summary), ('SOURCE_MAP.json', source_map),
        ('FINAL_SOURCE_GUARDS.json', sources), ('FINAL_ARTIFACT_GUARDS.json', artifacts),
        ('BUILD_RECEIPTS.json', builds), ('CHECK_RECEIPTS.json', checks)]: save(out/n, v)
    print('EXACT_VERIFIED_UNIT_FINALIZED', json.dumps(summary))
