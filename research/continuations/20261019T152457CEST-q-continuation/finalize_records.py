"""Finalize the bounded Q-family unit only after successful actual verification.
All Git operations in this script are read-only. No root, queue or trust baseline is changed.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, subprocess, sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;aud=out/'audit'
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*a): return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
def save(p,v):
    with p.open('x') as f: f.write(json.dumps(v,indent=2)+'\n')
def strip_comments(s):
    result=[];i=0;depth=0
    while i<len(s):
        if depth:
            if s.startswith('/-',i):depth+=1;i+=2
            elif s.startswith('-/',i):depth-=1;i+=2
            else:i+=1
        elif s.startswith('/-',i):depth=1;i+=2;result.append(' ')
        elif s.startswith('--',i):
            j=s.find('\n',i);i=len(s) if j<0 else j;result.append(' ')
        elif s[i]=='"':
            i+=1
            while i<len(s):
                if ord(s[i])==92:i+=2
                elif s[i]=='"':i+=1;break
                else:i+=1
            result.append(' ')
        else:result.append(s[i]);i+=1
    assert depth==0
    return ''.join(result)
targets=json.loads((aud/'TARGETS.json').read_text());replays=json.loads((aud/'REPLAY_TARGETS.json').read_text())
checks=json.loads((aud/'TARGETED_REPLAY_RECEIPTS.json').read_text());decls=json.loads((aud/'DECLARATIONS.json').read_text())
assert len(targets)==8 and len(replays)==4
assert [r['label'] for r in checks]==['analytic-type-axioms']+[n+'-targeted-replay' for n in replays]
assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] for r in checks)
assert not json.loads((aud/'active-targeted-replay.json').read_text())['active']
assert 'ANALYTIC_CHECKS_PASS' in (aud/'checks-console.log').read_text()
log=(aud/'analytic-type-axioms.log').read_text();assert not re.search(r'(^|\n).*\berror:',log)
axes=dict(re.findall(r'ANALYTIC_AXIOMS_PASS (\S+): (\[[^\]]*\])',log));assert len(axes)==len(decls)
for d in decls:
    n=d['name'];assert n in axes
    assert re.search(r'^@?'+re.escape(n)+r'(?:\.\{[^}]+\})?(?=\s|:)',log,re.M),'Missing displayed type '+n
    assert set(a.strip() for a in axes[n].strip('[]').split(',') if a.strip())<={'propext','Classical.choice','Quot.sound'}
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('q_finalize',work/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=mod.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active['active'] and not active.get('protected_closure')
    queue,names,closures,accepted,unknown,eligible=driver.snapshot()
    assert unknown==[] and queue['max_parallel']==1 and queue['pause_after_current'] is True and set(targets)<=accepted
    guard=json.loads((aud/'TARGETED_REPLAY_GUARDS.json').read_text())
    assert driver.manifest_matches(guard['compiled_artifacts']) and driver.manifest_matches(guard['immutable_inputs'])
    baseline=json.loads((out/'SYNC_BASELINE.json').read_text())
    index={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert index==baseline['inherited_index'] and git('rev-parse','HEAD').decode().strip()==baseline['head']
    assert git('branch','--show-current').decode().strip()=='main' and not git('diff','--name-only').strip()
    assert (root/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.33.1'
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    coverage={}
    for n,h in guard['project_sources'].items():
        p=root/'D1Bound5'/(n+'.lean');assert sha(p)==h;s=strip_comments(p.read_text())
        assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s),n
        imports=re.findall(r'^import\s+([^\n]+)',s,re.M);assert not any('research' in x or 'snapshot' in x for x in imports)
        coverage[n]={'sha256':h,'imports':imports,'bytes':p.stat().st_size}
    originals=json.loads((out/'ORIGINAL_HEADERS.json').read_text());headers={}
    for n,v in originals.items():
        s=(root/'D1Bound5'/(n+'.lean')).read_text()
        current=re.findall(r'^(?:@\[[^\n]*\]\s*)?theorem (.*?) := by',s,re.M|re.S)
        assert current==v['headers'],'Original public statement changed: '+n
        headers[n]={'original_headers_unchanged':True,'theorems':len(current)}
    canon=out/'verified';canon.mkdir(exist_ok=False);source_map={};builds=[]
    for n in targets:
        fp=mod.fingerprint(driver.closure(n));p=root/'D1Bound5'/(n+'.lean')
        row=next(x for x in reversed(driver.rows) if x['name']==n and x['fingerprint']==fp)
        assert row['accepted_build'] and row['exit']==0 and not row['timed_out'] and row['closure_unchanged'] and row['shared_artifacts_unchanged'] and row['source_sha256']==sha(p)
        snap=canon/(n+'.lean');snap.write_bytes(p.read_bytes());save(canon/(n+'-BUILD_RECEIPT.json'),row)
        (canon/(n+'-build.log')).write_bytes(Path(row['log']).read_bytes())
        source_map[n]={'source':str(p.relative_to(root)),'snapshot':str(snap.relative_to(root)),'sha256':sha(p),'status':'Guarded pinned compilation, public type/axiom audit and targeted milestone SAME-kernel checks; not accepted-root integrated'};builds.append(row)
    save(out/'SOURCE_MAP.json',source_map);save(out/'SOURCE_IMPORT_REVIEW.json',{'count':len(coverage),'modules':coverage})
    save(out/'FINAL_HEADER_REVIEW.json',headers);save(out/'TYPE_AXIOM_SUMMARY.json',{'declarations':len(decls),'theorems':sum(d['kind']=='theorem' for d in decls),'per_declaration':axes,'exact_endpoint_examples':3,'replays':replays})
    nextstate={}
    for n in ['MainTheorem','AllLargeImpossible','OneSmallImpossible','ThreeSmallExclusion','SmallTripleCheck','SmallPairGraphs','FiniteN2Matrix','FiniteN3Matrix','FiniteA3Matrix','FiniteA4Matrix','FiniteA5Matrix']:
        cl=driver.closure(n);nextstate[n]={'accepted_build':n in accepted,'eligible':n in eligible,'missing_prerequisites':sorted(set(cl)-accepted-{n})}
    save(out/'NEXT_DEPENDENCIES.json',nextstate)
    now=datetime.now().astimezone().isoformat()
    summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'public_declarations':len(decls),'public_theorems':sum(d['kind']=='theorem' for d in decls),'builds':builds,'checks':checks,'source_closure_count':len(coverage),'public_headers_unchanged':True,'determinant_repair':'Sparse generic determinant expansion with forty local kernel-proved Fin index equalities, then polynomial substitution; no time-cap increase','root_integrated':False,'main_statement_proved':False,'independent_review':False,'clean_checkout':False,'automations_modified':False,'recovery_commit':baseline['head']}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — finite Q closed interval verified'
    paragraph='The actual finite Q family now has its exact nonzero determinant, convergent fourth/fifth Taylor remainder bounds, root-column height, integral nonzero row selection and full-ring closed interval exclusion. All eight working modules passed guarded pinned compilation, all public declaration type/transitive-axiom checks, three original endpoint type examples and four installed SAME-kernel milestone replays. The slow determinant was repaired by separating sparse matrix expansion, finite index evaluation and polynomial substitution. Original public statements, constants, boundary inclusions and frozen v4 are unchanged. This also preserves the earlier recovered analytic package already privately synchronized in e95f549. Remaining main cases, graph production, accepted-root integration and final MainStatement gates stay open. Evidence: research/continuations/'+out.name+'/VERIFICATION_SUMMARY.json.'
    for n in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/n;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    (root/'records/runs'/(out.name+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll owned compiler and checker terminal results are collected. Meaningful failed attempts remain separate. The inherited staged receipt and frozen manuscript are unchanged. Private Git commit/push for this new Q unit remain subsequent separate operations.\n')
    print('VERIFIED_Q_UNIT',now,'modules',len(targets),'declarations',len(decls),'source_closure',len(coverage))
