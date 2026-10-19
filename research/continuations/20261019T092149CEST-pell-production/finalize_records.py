"""Finalize only this verified batch after every owned check has ended.
No Git mutations, queue changes, source edits, or trust-baseline changes.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;tag=out.name
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,a):p.write_text(json.dumps(a,indent=2)+'\n')
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
targets=json.loads((out/'TARGETS.json').read_text());review=json.loads((out/'PRE_BUILD_SOURCE_REVIEW.json').read_text())
rows=json.loads((out/'BATCH_RESULTS.json').read_text());checks=json.loads((out/'TARGETED_REPLAY_RECEIPTS.json').read_text())
assert len(rows)==20 and [r['name'] for r in rows]==targets
assert len(checks)==21 and [r['label'] for r in checks]==['pell-certificate-type-axioms']+[t+'-targeted-replay' for t in targets]
assert all(r['accepted_build'] and r['exit']==0 and r['closure_unchanged'] and r['shared_artifacts_unchanged'] and not r['timed_out'] for r in rows)
assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] for r in checks)
assert not json.loads((out/'active-targeted-replay.json').read_text())['active']
assert 'PELL_BATCH_CHECKS_PASS' in (out/'checks-console.log').read_text()
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_finalize_guard',work/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
 queue,names,closures,accepted,unknown,eligible=driver.snapshot();assert not unknown and queue['max_parallel']==1 and queue['pause_after_current'] is True
 assert all(t in accepted for t in targets)
 guards=json.loads((out/'TARGETED_REPLAY_GUARDS.json').read_text())
 assert all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in guards['project_sources'].items())
 assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(guards['immutable_inputs'])
 assert len(guards['project_sources'])==22
 inherited=json.loads((out/'INHERITED_INDEX.json').read_text());current={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
 assert current==inherited,'Index changed before own staging'
 initial=json.loads((out/'INITIAL_STATE.json').read_text());assert git('rev-parse','HEAD').decode().strip()==initial['head']
 assert not git('diff','--name-only').strip(),'Tracked files changed by another writer'
 assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
 source_map=json.loads((out/'SOURCE_MAP.json').read_text())
 for t in targets:
  assert (root/'D1Bound5'/(t+'.lean')).read_bytes()==(out/(t+'.lean')).read_bytes()
  assert sha(out/(t+'.lean'))==review[t]['sha256']
  source_map[t]['status']='Separately compiled, exact-type/axiom audited and targeted SAME-kernel replayed; not accepted-root integrated'
 save(out/'SOURCE_MAP.json',source_map)
 ax=json.loads((out/'TYPE_AXIOM_SUMMARY.json').read_text());assert len(ax['per_declaration'])==536 and len(ax['nonempty_axioms'])==8
 ax['targeted_replays_status']='ALL_TWENTY_PASSED';save(out/'TYPE_AXIOM_SUMMARY.json',ax)
 now=datetime.now().astimezone().isoformat()
 next_names=['PellLightMatchingField191','PellLightMatchingField199','PellLightMatchingField223','PellLightMatchingField239','PellLightPrefixData32','PellLightPrefixData33','PellUnitPairBounded']
 nxt={n:{'accepted':n in accepted,'eligible':n in eligible,'missing_prerequisite_count':len(set(closures[n])-accepted-{n})} for n in next_names if n in closures}
 save(out/'NEXT_DEPENDENCIES.json',nxt)
 summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'original_theorems':268,'data_definitions':268,'new_prefix_fields':256,'new_matching_fields':[119,127,151,167],'matching_pairs':13703,'builds':rows,'checks':checks,'axioms_nonempty':ax['nonempty_axioms'],'project_source_closure_count':22,'mathematical_sources_changed':False,'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'automations_modified':False,'build_tool_pid':86731,'build_exit':0,'check_tool_pid':87292}
 save(out/'VERIFICATION_SUMMARY.json',summary)
 title='19 October 2026 — 256 further Pell prefixes and four matching fields verified'
 paragraph='Twenty unchanged prepared modules now supply 256 exact Pell prefix/stopping/list certificates (Data16--31) and complete distinct-magnitude matching checks for d=119,127,151,167 covering 13703 unordered pairs. All 268 original theorems and 268 data definitions passed pinned builds, exact elaborated-type/transitive-axiom audit and twenty targeted installed SAME-kernel replays. Eight mask/matching theorems use only propext; all other declarations have no axioms. Twenty-two project source modules and their compiled artifacts remained unchanged. The frozen-v4 recurrence, cutoff and both-sign square tests are preserved. This is separately verified finite production, not aggregate full-ring exclusion, accepted-root integration, independent review, clean-checkout validation or proof of MainStatement. Evidence: research/continuations/'+tag+'/VERIFICATION_SUMMARY.json.'
 for p in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
  f=root/p;old=f.read_text();assert title not in old;f.write_text(old.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
 (root/'records/runs'/(tag+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll twenty compiler results and the complete audit/replay batch have terminal results. The driver stays paused between owned batches and both existing locks are released. The inherited staged record is unchanged. Next ready work includes matching fields 191,199,223,239 and prefix blocks 32 onward. Ordinary private Git synchronization must still be established by separate actual calls; this pre-commit record does not claim a push.\n')
 print('VERIFIED_UNIT',now,'268 theorems; 256 prefixes; four matching fields; 13703 pairs',flush=True);print('NEXT',json.dumps(nxt),flush=True)
