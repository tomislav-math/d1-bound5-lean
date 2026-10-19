"""Finalize this batch only after all builds and targeted checks are collected.
No Git mutation, queue update, mathematical source edit, or baseline reset.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;tag=out.name
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text())
def save(p,a):
    with p.open('x') as f:f.write(json.dumps(a,indent=2)+'\n')
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
targets=load(out/'TARGETS.json');review=load(out/'PRE_BUILD_SOURCE_REVIEW.json')
rows=load(out/'BATCH_RESULTS.json');checks=load(out/'TARGETED_REPLAY_RECEIPTS.json')
decls=load(out/'DECLARATIONS.json');scope=load(out/'CERTIFICATE_SCOPE.json');processes=load(out/'COLLECTED_PROCESS_RESULTS.json')
assert len(targets)==24 and len(rows)==24 and [v['name'] for v in rows]==targets
assert len(checks)==25 and [v['label'] for v in checks]==['pell-certificate-type-axioms']+[t+'-targeted-replay' for t in targets]
assert all(v['accepted_build'] and v['exit']==0 and v['closure_unchanged'] and v['shared_artifacts_unchanged'] and not v['timed_out'] for v in rows)
assert all(v['exit']==0 and not v['timed_out'] and v['guards_unchanged'] for v in checks)
assert processes['build_exit']==0 and processes['check_exit']==0
assert not load(out/'active-targeted-replay.json')['active']
assert 'BOUNDED_BATCH_DRAINED 24' in (out/'batch-console.log').read_text()
assert 'PELL_BATCH_CHECKS_PASS' in (out/'checks-console.log').read_text()
log=(out/'pell-certificate-type-axioms.log').read_text()
assert not re.search(r'(^|\n).*\berror:',log)
ax=dict(re.findall(r'PELL_NEXT_AXIOMS_PASS (\S+): (\[[^\n]*\])',log))
expected_names={v['name'] for v in decls};assert set(ax)==expected_names and len(ax)==560
for d in decls:
    assert re.search(r'^'+re.escape(d['name'])+r'\s*:',log,re.M),'Missing elaborated type: '+d['name']
    vals=[a.strip() for a in ax[d['name']].strip('[]').split(',') if a.strip()]
    assert set(vals)<={'propext','Classical.choice','Quot.sound'}
nonempty={k:v for k,v in ax.items() if v!='[]'}
assert len(nonempty)==16 and set(nonempty.values())=={'[propext]'}
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_next_finalize',work/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=mod.Driver(root,work);active=load(driver.active_path)
    assert not active.get('active') and not active.get('protected_closure')
    queue,names,closures,accepted,unknown,eligible=driver.snapshot()
    assert not unknown and queue['max_parallel']==1 and queue['pause_after_current'] is True
    assert all(t in accepted for t in targets)
    guards=load(out/'TARGETED_REPLAY_GUARDS.json');assert len(guards['project_sources'])==26
    assert all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in guards['project_sources'].items())
    assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(guards['immutable_inputs'])
    inherited=load(out/'INHERITED_INDEX.json')
    current={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert current==inherited,'Another writer changed the index'
    assert git('rev-parse','HEAD').decode().strip()==load(out/'INITIAL_STATE.json')['head']
    assert not git('diff','--name-only').strip(),'Tracked work changed before finalization'
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    source_map=load(out/'SOURCE_MAP.json')
    for t in targets:
        assert (root/'D1Bound5'/(t+'.lean')).read_bytes()==(out/(t+'.lean')).read_bytes()
        assert sha(out/(t+'.lean'))==review[t]['sha256']
        source_map[t]['status']='Separately compiled, exact-type/axiom audited and targeted SAME-kernel replayed; not accepted-root integrated'
    (out/'SOURCE_MAP.json').write_text(json.dumps(source_map,indent=2)+'\n')
    now=datetime.now().astimezone().isoformat()
    save(out/'TYPE_AXIOM_SUMMARY.json',{'per_declaration':ax,'nonempty_axioms':nonempty,'exact_type_count':len(decls),'same_kernel_replays':24,'independent_review':False})
    next_names=['PellLightMatchingField359','PellLightMatchingField367','PellLightMatchingField383','PellLightMatchingField391','PellLightPrefixData48','PellLightPrefixData49','PellUnitPairBounded']
    nxt={n:{'accepted':n in accepted,'eligible':n in eligible,'missing_prerequisite_count':len(set(closures[n])-accepted-{n})} for n in next_names if n in closures}
    save(out/'NEXT_DEPENDENCIES.json',nxt)
    theorems=sum(v['kind']=='theorem' for v in decls);definitions=sum(v['kind']=='def' for v in decls)
    total_pairs=sum(v['unordered_pairs'] for v in scope['matching'].values())
    summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'original_theorems':theorems,'data_definitions':definitions,'new_prefix_fields':len(scope['prefix_fields']),'prefix_range':[min(scope['prefix_fields']),max(scope['prefix_fields'])],'new_matching_fields':list(map(int,scope['matching'])),'matching_pairs':total_pairs,'builds':rows,'checks':checks,'axioms_nonempty':nonempty,'project_source_closure_count':26,'mathematical_sources_changed':False,'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'automations_modified':False,'processes':processes}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — next 256 Pell prefixes and eight matching fields verified'
    paragraph='Twenty-four unchanged prepared modules now supply 256 exact Pell prefix/stopping/list certificates (Data32--47, parameters 4879 through 7391) and complete distinct-magnitude matching checks for d=191,199,223,239,263,271,287,311 covering 14292 unordered pairs. All 280 original theorems and 280 data definitions passed pinned builds, exact elaborated-type/transitive-axiom audit and 24 targeted installed SAME-kernel replays. Sixteen mask/matching theorems use only propext; all other declarations have no axioms. Twenty-six project source modules and their compiled artifacts remained unchanged. The frozen-v4 recurrence, cutoff and both-sign square tests are preserved. This is separately verified finite production, not aggregate full-ring exclusion, accepted-root integration, independent review, clean-checkout validation or proof of MainStatement. Evidence: research/continuations/'+tag+'/VERIFICATION_SUMMARY.json.'
    assert theorems==280 and definitions==280 and total_pairs==14292
    for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/name;old=p.read_text();assert title not in old
        p.write_text(old.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    with (root/'records/runs'/(tag+'-FINISH.md')).open('x') as f:
        f.write('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll owned compiler and checker processes have collected terminal results. No mathematical source changed. Both existing locks are released on exit; the serial queue remains paused between batches. The inherited index entry is unchanged. Next work includes matching fields 359,367,383,391 and prefix blocks 48 onward. Commit and private push are separate, still-pending actions at the time of this record.\n')
    print('VERIFIED_UNIT',now,theorems,'theorems;',len(scope['prefix_fields']),'prefix fields;',total_pairs,'pairs',flush=True)
    print('NEXT',json.dumps(nxt),flush=True)
