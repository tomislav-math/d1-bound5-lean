"""Collect already completed guarded proof checks. No compiler or Git mutation.
Every verification claim requires actual successful receipts and unchanged bytes.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, sys
root = Path('/Users/tp/Lean/D1Bound5')
out = Path(__file__).resolve().parent
work = root/'research/continuations/20261018T010800CEST-main-continuation'
previous = root/'research/continuations/20261019T211452CEST-analytic-final-branches'
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def write_new(path, value):
    with path.open('x') as f: f.write(json.dumps(value, indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py') == 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec = importlib.util.spec_from_file_location('verified_d1_driver', work/'continuation_driver_capacity.py')
mod = importlib.util.module_from_spec(spec); sys.modules[spec.name] = mod; spec.loader.exec_module(mod)
audits = [previous/'three-small-audit', previous/'retained-audit'] + [out/x for x in sys.argv[1:]]
assert len(audits) == len(set(audits))
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner, fcntl.LOCK_EX|fcntl.LOCK_NB); fcntl.flock(intake, fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver = mod.Driver(root, work)
    active = json.loads(driver.active_path.read_text())
    assert not active.get('active') and not active.get('protected_closure')
    queue, names, closures, accepted, unknown, eligible = driver.snapshot()
    assert not unknown and queue['max_parallel'] == 1
    latest = driver.latest(); groups = []; sources = {}; declarations = {}; builds = {}
    for folder in audits:
        targets = json.loads((folder/'TARGETS.json').read_text())
        replays = json.loads((folder/'REPLAY_TARGETS.json').read_text())
        receipts = json.loads((folder/'TARGETED_REPLAY_RECEIPTS.json').read_text())
        guards = json.loads((folder/'TARGETED_REPLAY_GUARDS.json').read_text())
        assert len(receipts) == len(replays)+1
        assert [v['label'] for v in receipts] == ['analytic-type-axioms']+[n+'-targeted-replay' for n in replays]
        assert not json.loads((folder/'active-targeted-replay.json').read_text())['active']
        assert all(v['exit'] == 0 and not v['timed_out'] and v['guards_unchanged'] for v in receipts)
        assert all(n in accepted for n in targets)
        for n,h in guards['project_sources'].items():
            assert sha(root/'D1Bound5'/(n+'.lean')) == h
            assert n not in sources or sources[n] == h
            sources[n] = h
        assert driver.manifest_matches(guards['compiled_artifacts'])
        assert driver.manifest_matches(guards['immutable_inputs'])
        decls = json.loads((folder/'DECLARATIONS.json').read_text())
        log = (folder/'analytic-type-axioms.log').read_text()
        for decl in decls:
            assert 'ANALYTIC_AXIOMS_PASS '+decl['name']+':' in log
            declarations[decl['name']] = decl
        assert not re.search(r'^.*error:', log, re.M)
        for n in targets:
            row = latest.get((n,mod.fingerprint(closures[n])))
            assert row and row.get('accepted_build') and row['source_sha256'] == sha(root/'D1Bound5'/(n+'.lean'))
            builds[n] = row
        groups.append({'folder':str(folder.relative_to(root)), 'targets':targets,
            'theorems':sum(d['kind']=='theorem' for d in decls), 'declarations':len(decls),
            'targeted_same_kernel_replays':len(replays), 'source_closure':len(guards['project_sources']),
            'recovered_from_previous_invocation':folder.parent==previous})
    flags = []
    for name in sources:
        text = (root/'D1Bound5'/(name+'.lean')).read_text()
        text = re.sub(r'/\-[\s\S]*?\-/', '', text)
        text = re.sub(r'--[^\n]*', '', text)
        if re.search(r'\b(sorry|admit|sorryAx|native_decide)\b|decide\s*\+native|^\s*axiom\s',text,re.M): flags.append(name)
    assert not flags, flags
    write_new(out/'VERIFIED_COMPILE_RECEIPTS.json', builds)
    write_new(out/'VERIFIED_SOURCE_CLOSURE.json', sources)
    write_new(out/'VERIFICATION_SUMMARY.json', {'outcome':'COMPLETED_UNIT',
        'time':datetime.now().astimezone().isoformat(), 'groups':groups,
        'distinct_audited_modules':len(builds), 'distinct_public_declarations':len(declarations),
        'distinct_public_theorems':sum(d['kind']=='theorem' for d in declarations.values()),
        'guarded_source_closure':len(sources), 'source_scan_flags':flags,
        'unknown_dependencies':unknown, 'max_parallel':1, 'root_integrated':False,
        'main_statement_proved':False, 'independent_external_review':False,
        'clean_checkout_validation':False})
print('COLLECTED_VERIFIED_UNITS',len(builds),'modules',len(declarations),'public declarations',datetime.now().astimezone().isoformat())
