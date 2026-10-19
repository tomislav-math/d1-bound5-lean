"""Finalize the recovered analytic unit after its actual verification gates.
All Git calls below are read-only. No trust baseline, queue or accepted root is changed.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;aud=out/'audit-final'
work=root/'research/continuations/20261018T010800CEST-main-continuation'
predecessors=['20261019T121446CEST-unit-pair-analytic','20261019T132716CEST-analytic-recovery']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*a):return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')
def strip_comments(s):
    out=[];i=0;depth=0
    while i<len(s):
        if depth:
            if s.startswith('/-',i):depth+=1;i+=2
            elif s.startswith('-/',i):depth-=1;i+=2
            else:i+=1
        elif s.startswith('/-',i):depth=1;i+=2;out.append(' ')
        elif s.startswith('--',i):
            j=s.find('\n',i);i=len(s) if j<0 else j;out.append(' ')
        elif s[i]=='"':
            i+=1
            while i<len(s):
                if ord(s[i])==92:i+=2
                elif s[i]=='"':i+=1;break
                else:i+=1
            out.append(' ')
        else:out.append(s[i]);i+=1
    assert depth==0
    return ''.join(out)
targets=json.loads((aud/'TARGETS.json').read_text());replays=json.loads((aud/'REPLAY_TARGETS.json').read_text())
checks=json.loads((aud/'TARGETED_REPLAY_RECEIPTS.json').read_text());decls=json.loads((aud/'DECLARATIONS.json').read_text())
assert len(targets)==37 and len(replays)==12
assert [r['label'] for r in checks]==['analytic-type-axioms']+[n+'-targeted-replay' for n in replays]
assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] for r in checks)
assert not json.loads((aud/'active-targeted-replay.json').read_text())['active']
assert 'ANALYTIC_CHECKS_PASS' in (aud/'checks-console.log').read_text()
log=(aud/'analytic-type-axioms.log').read_text();assert not re.search(r'(^|\n).*\berror:',log)
axes=dict(re.findall(r'ANALYTIC_AXIOMS_PASS (\S+): (\[[^\]]*\])',log))
assert len(axes)==len(decls)==110
for d in decls:
    n=d['name'];assert n in axes
    assert re.search(r'^@?'+re.escape(n)+r'(?:\.\{[^}]+\})?(?=\s|:)',log,re.M),'Missing elaborated type '+n
    assert set(a.strip() for a in axes[n].strip('[]').split(',') if a.strip())<={'propext','Classical.choice','Quot.sound'}
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_final_analytic_guard',work/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=mod.Driver(root,work);active=json.loads(driver.active_path.read_text())
    assert not active.get('active') and not active.get('protected_closure')
    queue,names,closures,accepted,unknown,eligible=driver.snapshot()
    assert unknown==[] and queue['max_parallel']==1 and queue['pause_after_current'] is True
    assert set(targets)<=accepted
    guards=json.loads((aud/'TARGETED_REPLAY_GUARDS.json').read_text())
    assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(guards['immutable_inputs'])
    coverage={}
    for n,h in guards['project_sources'].items():
        p=root/'D1Bound5'/(n+'.lean');assert sha(p)==h
        s=strip_comments(p.read_text())
        assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s),'Disallowed source token: '+n
        imports=re.findall(r'^import\s+([^\n]+)',s,re.M)
        assert not any('research' in x or 'snapshot' in x for x in imports)
        coverage[n]={'sha256':h,'imports':imports,'bytes':p.stat().st_size}
    initial=json.loads((out/'INITIAL_STATE.json').read_text());inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
    current={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert current==inherited and git('rev-parse','HEAD').decode().strip()==initial['head']
    assert git('branch','--show-current').decode().strip()=='main' and not git('diff','--name-only').strip()
    frozen=Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex')
    assert sha(frozen)=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    original=json.loads((root/'research/continuations'/predecessors[0]/'ORIGINAL_PUBLIC_STATEMENTS.json').read_text())
    hdrreview={}
    for n,v in original.items():
        s=(root/'D1Bound5'/(n+'.lean')).read_text()
        for h in v['public_tactic_theorem_headers']:assert h['header']+' := by' in s,(n,h['name'])
        hdrreview[n]=[h['name'] for h in v['public_tactic_theorem_headers']]
    for n,v in json.loads((out/'EXTRA_ORIGINAL_HEADERS.json').read_text()).items():
        s=(root/'D1Bound5'/(n+'.lean')).read_text()
        assert re.findall(r'^theorem (.*?) := by',s,re.M|re.S)==v['headers'],n
        hdrreview[n]=[x.split()[0] for x in v['headers']]
    canonical=out/'verified';canonical.mkdir(exist_ok=False);builds=[];source_map={}
    recovered=json.loads((out/'RECOVERED_BUILD_MAP.json').read_text())
    for n in targets:
        fp=mod.fingerprint(driver.closure(n));p=root/'D1Bound5'/(n+'.lean');h=sha(p)
        row=next(r for r in reversed(driver.rows) if r['name']==n and r.get('accepted_build') and r.get('fingerprint')==fp and r.get('source_sha256')==h)
        assert row['exit']==0 and row['closure_unchanged'] and row['shared_artifacts_unchanged'] and not row['timed_out']
        snap=canonical/(n+'.lean');snap.write_bytes(p.read_bytes());save(canonical/(n+'-BUILD_RECEIPT.json'),row)
        raw=Path(row['log']);assert raw.is_file();(canonical/(n+'-build.log')).write_bytes(raw.read_bytes())
        builds.append(row)
        source_map[n]={'source':str(p.relative_to(root)),'snapshot':str(snap.relative_to(root)),'sha256':h,'recovered_compilation':n in recovered,'status':'Current guarded compilation, public type/axiom audit, and dependency-covered milestone same-kernel verification; not accepted-root integrated'}
    save(out/'SOURCE_MAP.json',source_map)
    save(out/'FINAL_HEADER_REVIEW.json',hdrreview)
    save(out/'SOURCE_IMPORT_REVIEW.json',{'project_modules':coverage,'count':len(coverage),'scope':'All project imports of the 37 checked working targets; not whole-root clean checkout'})
    save(out/'TYPE_AXIOM_SUMMARY.json',{'public_declarations':len(decls),'theorems':sum(d['kind']=='theorem' for d in decls),'per_declaration':axes,'exact_endpoint_examples':3,'milestone_replays':replays,'independent_review':False})
    nextstate={}
    for n in ['MainTheorem','AllLargeImpossible','OneSmallImpossible','ThreeSmallExclusion','TwoSmallNondegenerateImpossible','DegeneratePairImpossible','UnitPairImpossible','FiniteQMatrix','FiniteQResidualIdentity','SmallPairGraphs']:
        cl=driver.closure(n);missing=sorted(set(cl)-accepted-{n})
        nextstate[n]={'accepted_build':n in accepted,'eligible':n in eligible,'missing_prerequisite_count':len(missing),'missing_prerequisites':missing}
    save(out/'NEXT_DEPENDENCIES.json',nextstate)
    now=datetime.now().astimezone().isoformat()
    summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'recovered_prior_compilation_count':len(recovered),'new_current_compilation_count':len(targets)-len(recovered),'public_declarations':len(decls),'public_theorems':sum(d['kind']=='theorem' for d in decls),'builds':builds,'checks':checks,'targeted_milestone_replay_count':len(replays),'source_closure_count':len(coverage),'original_public_headers_unchanged':True,'recovered_predecessor_directories':predecessors,'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'automations_modified':False}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — analytic two-small cutoff and degenerate-pair exclusion verified'
    paragraph='Recovered 21 guarded compiled modules from the two interrupted analytic runs and completed 16 further current compilations. The actual order-two M matrix, residual and integral-row transfer now close the full-ring two-small fifth-entry bound C < 10^550. Combined with the complete Pell lower bound, this excludes ordered sextuples beginning with {-1,1}. The unit classification and Eisenstein trace-zero extension argument also close the entire first-pair case a*b+1=0. All 37 selected working modules passed current guarded pinned compilation, all '+str(len(decls))+' public declaration type/transitive-axiom checks and twelve explicitly targeted installed SAME-kernel milestone replays. Original public headers were retained. The weaker intermediate S < 10^50 and D < 10^396 inherited from the predecessor are distinguished from the sharper manuscript estimates; the final cutoff is unchanged. MainStatement, other main cases, accepted-root integration, independent final review and clean-checkout gates remain open. Evidence: research/continuations/'+out.name+'/VERIFICATION_SUMMARY.json.'
    for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/name;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    (root/'records/runs'/(out.name+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll current owned batches and verification processes have terminal results. The two interrupted predecessors are preserved with their true mixed trial statuses. The current canonical source map and verification records supersede incomplete predecessor reports. The inherited staged receipt is untouched. Private Git synchronization is a subsequent, separately verified step, not claimed by this pre-commit note. Both locks are released on exit and the serial queue remains paused between invocations.\n')
    print('VERIFIED_ANALYTIC_AND_DEGENERATE_UNIT',now,'targets',len(targets),'public_declarations',len(decls),'source_closure',len(coverage))
    print('NEXT',json.dumps({n:{k:v for k,v in r.items() if k!='missing_prerequisites'} for n,r in nextstate.items()}))
