"""Finalize verified A4/A5 groups from actual guarded receipts; no compiler or Git mutation."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,v):
    with p.open('x') as f: f.write(json.dumps(v,indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_a45_finalizer',work/'continuation_driver_capacity.py')
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
groups=sys.argv[1:];assert groups and all(g=='assembly-audit' or re.fullmatch(r'a[45]-audit(?:-v[0-9]+)?', g) for g in groups)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
    d=m.Driver(root,work);q,ns,cs,acc,unk,eligible=d.snapshot();assert not unk and q['max_parallel']==1 and q['pause_after_current'] is True
    targets=[];decls=[];checks=[];sources={};artifacts={};builds=[];source_map={};coverage={}
    for group in groups:
        p=out/group;names=json.loads((p/'TARGETS.json').read_text());targets+=names
        dec=json.loads((p/'DECLARATIONS.json').read_text());decls+=dec
        exact=json.loads((p/'EXACT_ORIGINAL_STATEMENT_EXAMPLES.json').read_text())
        assert len(exact)==sum(x['kind']=='theorem' for x in dec)
        wanted=['analytic-type-axioms']+[x+'-targeted-replay' for x in json.loads((p/'REPLAY_TARGETS.json').read_text())]
        receipt=json.loads((p/'TARGETED_REPLAY_RECEIPTS.json').read_text());assert [x['label'] for x in receipt]==wanted
        assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in receipt)
        assert json.loads((p/'active-targeted-replay.json').read_text())['active'] is False
        log=(p/'analytic-type-axioms.log').read_text();assert log.count('ANALYTIC_AXIOMS_PASS ')==len(dec)
        assert not any(x.startswith('error:') for x in log.splitlines());checks+=receipt
        g=json.loads((p/'TARGETED_REPLAY_GUARDS.json').read_text())
        for n,h in g['project_sources'].items():
            assert sha(root/'D1Bound5'/(n+'.lean'))==h and (n not in sources or sources[n]==h);sources[n]=h
        for n,h in {**g['compiled_artifacts'],**g['immutable_inputs']}.items():
            assert sha(root/n)==h and (n not in artifacts or artifacts[n]==h);artifacts[n]=h
        coverage[group]={'modules':len(names),'theorems':len(exact),'declarations':len(dec),'targeted_replays':len(receipt)-1}
    assert len(targets)==len(set(targets)) and len(decls)==len({x['name'] for x in decls})
    latest=d.latest();snap=out/'verified-sources';snap.mkdir()
    for n in targets:
        assert n in acc
        row=latest[(n,m.fingerprint(cs[n]))];assert row['exit']==0 and row['accepted_build'] and row['source_sha256']==sha(root/'D1Bound5'/(n+'.lean'))
        builds.append(row);p=snap/(n+'.lean');p.write_bytes((root/'D1Bound5'/(n+'.lean')).read_bytes())
        source_map[n]={'source':'D1Bound5/'+n+'.lean','snapshot':str(p.relative_to(root)),'sha256':sha(p)}
    flags=[]
    for n in sources:
        text=(root/'D1Bound5'/(n+'.lean')).read_text();text=re.sub(r'/\-[\s\S]*?\-/','',text);text=re.sub(r'--[^\n]*','',text)
        bad=re.findall(r'\b(?:sorry|admit|sorryAx|native_decide)\b|decide\s+\+native|^\s*axiom\b|debug\.skipKernelTC|^\s*unsafe\s+(?:def|theorem)',text,re.M)
        if bad:flags.append({'module':n,'flags':bad})
    assert not flags,flags
    now=datetime.now().astimezone().isoformat()
    summary={'time':now,'outcome':'COMPLETED_UNIT','groups':coverage,'targets':targets,'public_theorems':sum(x['kind']=='theorem' for x in decls),'public_declarations':len(decls),'targeted_installed_same_kernel_replays':sum(len(json.loads((out/g/'REPLAY_TARGETS.json').read_text())) for g in groups),'source_closure_modules':len(sources),'source_scan_flags':flags,'allowed_axioms':['propext','Classical.choice','Quot.sound'],'original_public_statements_preserved':True,'root_integrated':False,'independent_review':False,'clean_checkout':False,'main_statement_proved':False}
    for n,v in [('VERIFICATION_SUMMARY.json',summary),('SOURCE_MAP.json',source_map),('FINAL_SOURCE_GUARDS.json',sources),('FINAL_ARTIFACT_GUARDS.json',artifacts),('BUILD_RECEIPTS.json',builds),('CHECK_RECEIPTS.json',checks)]:dump(out/n,v)
    text='# FINISH\n\n'+now+'\nOutcome: COMPLETED_UNIT.\n\nVerified the listed finite-family constructions through the actual full-ring inequalities and entire closed forbidden intervals, with original coefficients and size hypotheses. Exact matrices, determinants, residue identities, coefficient bounds and integral nonzero-row transfer were compiled in the pinned environment. Public theorem statements, transitive axioms and targeted installed SAME-kernel milestones all passed. The shared unequal-pole theorem was reused, not counted as new.\n\n'+json.dumps(coverage,indent=2)+'\n\nSource and artifact guards cover '+str(len(sources))+' project modules. No custom axioms, unproved hypotheses, trusted native evaluation or source shortcuts were introduced. This is not an independent review or a clean-checkout build. All failed trials remain labelled separately. The frozen manuscript and root imports were preserved.\n\nPrivate Git synchronization follows as a separate action, and this record does not claim a future push. Preserve all inherited staged entries. Other approximation and graph dependencies, accepted-root integration and the main theorem remain open.\n'
    with (root/'records/runs'/(out.name+'-FINISH.md')).open('x') as f:f.write(text)
    print('A4_A5_VERIFICATION_FINISHED',json.dumps(summary))
