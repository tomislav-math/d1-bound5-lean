"""Finalize this batch only after actual compilation and replay have completed.
No mathematical source edits, Git mutations, queue changes or baseline resets.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;tag=out.name
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):
    with p.open('x') as f:json.dump(v,f,indent=2);f.write('\n')
def git(*a):return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
targets=json.loads((out/'TARGETS.json').read_text());decls=json.loads((out/'DECLARATIONS.json').read_text())
rows=json.loads((out/'BATCH_RESULTS.json').read_text());checks=json.loads((out/'TARGETED_REPLAY_RECEIPTS.json').read_text());scope=json.loads((out/'CERTIFICATE_SCOPE.json').read_text())
assert len(targets)==25 and len(decls)==574
assert len(rows)==25 and [r['name'] for r in rows]==targets
assert len(checks)==26 and [r['label'] for r in checks]==['pell-certificate-type-axioms']+[n+'-targeted-replay' for n in targets]
assert all(r['accepted_build'] and r['exit']==0 and not r['timed_out'] and r['closure_unchanged'] and r['shared_artifacts_unchanged'] for r in rows)
assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] for r in checks)
assert not json.loads((out/'active-targeted-replay.json').read_text())['active']
assert 'PELL_BATCH_CHECKS_PASS' in (out/'checks-console.log').read_text()
collected=json.loads((out/'COLLECTED_PROCESS_RESULTS.json').read_text());assert collected['build_exit']==0 and collected['check_exit']==0
log=(out/'pell-certificate-type-axioms.log').read_text();assert not re.search(r'(^|\n).*\berror:',log)
ax=dict(re.findall(r'PELL_COMPLETE_AXIOMS_PASS (\S+): (\[[^\n]*\])',log))
assert len(ax)==len(decls)
for d in decls:
    assert d['name'] in ax
    assert re.search(r'^'+re.escape(d['name'])+r'\s*:',log,re.M),'Missing elaborated type '+d['name']
    vals=[a.strip() for a in ax[d['name']].strip('[]').split(',') if a.strip()]
    assert set(vals)<={'propext','Classical.choice','Quot.sound'}
nonempty={n:a for n,a in ax.items() if a!='[]'}
assert len(nonempty)==16 and set(nonempty.values())=={'[propext]'}
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_final_guard',work/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=m.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
    queue,names,closures,accepted,unknown,eligible=driver.snapshot();assert not unknown and queue['max_parallel']==1 and queue['pause_after_current'] is True
    assert all(n in accepted for n in targets)
    guards=json.loads((out/'TARGETED_REPLAY_GUARDS.json').read_text());assert len(guards['project_sources'])==27
    assert all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in guards['project_sources'].items())
    assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(guards['immutable_inputs'])
    initial=json.loads((out/'INITIAL_STATE.json').read_text());assert git('rev-parse','HEAD').decode().strip()==initial['head']
    inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
    index={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert index==inherited and not git('diff','--name-only').strip(),'Another writer changed tracked files or staging'
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    source_map=json.loads((out/'SOURCE_MAP.json').read_text())
    for n in targets:
        v=source_map[n];assert sha(root/v['source'])==sha(root/v['snapshot'])==v['sha256']
        v['status']='Separately pinned-compiled, exact-type/axiom audited and targeted SAME-kernel replayed; not accepted-root integrated'
    (out/'SOURCE_MAP.json').write_text(json.dumps(source_map,indent=2)+'\n')
    now=datetime.now().astimezone().isoformat()
    save(out/'TYPE_AXIOM_SUMMARY.json',{'time':now,'per_declaration':ax,'nonempty_axioms':nonempty,'exact_ground_type_examples':287,'targeted_replays':'25 successful installed SAME-kernel replays, not independent review'})
    remaining=sorted(set(closures['PellUnitPairBounded'])-accepted)
    prefix_modules=['PellLightPrefixPilot']+['PellLightPrefixData'+str(i) for i in range(1,65)]
    assert all(n in accepted for n in prefix_modules)
    params=[]
    for n in prefix_modules:params+=re.findall(r'^theorem checked_(\d+)\s*:',(root/'D1Bound5'/(n+'.lean')).read_text(),re.M)
    assert len(params)==len(set(params))==1016
    numeric=[n for n in remaining if re.fullmatch(r'PellLight(?:PrefixData|MatchingField|MatchingData)\d+',n)]
    assert len(numeric)==44 and len(remaining)==48
    # Final scope: inspect the actual MainTheorem import closure, not exploratory files.
    cache={};main_cl=driver.closure('MainTheorem',source_cache=cache)
    main_cls={n:driver.closure(n,source_cache=cache) for n in main_cl};latest=driver.latest()
    main_acc={n for n in main_cl if driver.accepted(n,main_cls,latest)}
    missing=set(main_cl)-main_acc
    computational=sorted(n for n in missing if 'decide +kernel' in (root/'D1Bound5'/(n+'.lean')).read_text())
    nexts=[n for n in ['PellLightMatchingField487','PellLightMatchingField503','PellLightMatchingField511','PellLightMatchingField527','PellLightMatchingData4','PellLightMatchingData5','PellLightAllMatchingCertificates','PellUnitPairBounded'] if n in closures]
    save(out/'NEXT_DEPENDENCIES.json',{n:{'accepted':n in accepted,'eligible':n in eligible,'missing_prerequisite_count':len(set(closures[n])-accepted-{n})} for n in nexts})
    save(out/'FINAL_REMAINING_SCOPE.json',{'time':now,'pell_computational_modules':numeric,'pell_other_remaining_modules':sorted(set(remaining)-set(numeric)),'all_prefix_modules_compiled':65,'distinct_prefix_parameter_count':1016,'main_closure_count':len(main_cl),'main_unaccepted_count':len(missing),'main_unaccepted_modules_with_decide_kernel':computational,'nominal_batches_at_24':len(computational)/24,'warning':'Structural workload proxy, not runtime, completeness percentage or guarantee on number of future invocations. Other proof repairs, exact partition refinement, integrations and final gates are additional.'})
    summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'original_theorems':287,'data_definitions':287,'new_prefix_fields':263,'new_matching_fields':list(map(int,scope['matching'])),'matching_pairs':scope['matching_pairs'],'all_prefix_parameter_count':1016,'builds':rows,'checks':checks,'axioms_nonempty':nonempty,'project_source_closure_count':27,'mathematical_sources_changed':False,'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'automations_modified':False,'collected_process_results':collected}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — remaining Pell prefixes and eight matching fields verified'
    paragraph='Twenty-five unchanged prepared modules now supply the final 263 individual Pell prefix/stopping/list certificates (Data48--64, parameters 7415 through 9991) and complete distinct-magnitude matching checks for d=359,367,383,391,431,439,463,479 covering 13123 unordered pairs. All 287 original theorems and 287 data definitions passed pinned compilation, exact elaborated-type examples, transitive-axiom audit and 25 targeted installed SAME-kernel replays. Sixteen mask/matching theorems use only propext; all other declarations have no axioms. All 1016 individual prefix parameters now have current guarded compiled sources; the aggregate field-coverage and exclusion endpoint remain open. The frozen-v4 recurrence, cutoff and both sign tests are unchanged. Separate remaining-scope records distinguish 44 pending Pell computational modules and four join/endpoint modules from the other graph and scalar proof work. Not accepted-root integration, independent review, clean-checkout validation or a proof of MainStatement. Evidence: research/continuations/'+tag+'/VERIFICATION_SUMMARY.json.'
    for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/name;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    with (root/'records/runs'/(tag+'-FINISH.md')).open('x') as f:
        f.write('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll owned build and checker results collected. No mathematical source edits. Locks released on exit, serial queue paused between batches, inherited index preserved. Private Git synchronization is a separate pending stage and must not be inferred from this pre-commit record. Next run should verify matching fields 487 onward and the grouped MatchingData4 onward; then compile the actual certificate adapters and exhaustive coverage endpoint.\n')
    print('VERIFIED',now,'287 theorems; all 1016 prefix parameters compiled; 44 Pell computational modules remain',flush=True)
    print('FINAL_SCOPE',len(computational),'unaccepted modules with decide +kernel;',len(computational)/24,'nominal batches, NOT a completion or time forecast',flush=True)
