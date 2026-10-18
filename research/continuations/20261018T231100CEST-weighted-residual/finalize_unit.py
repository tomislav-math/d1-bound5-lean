"""Finalize verified local records only. No compiler or Git mutations."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, shutil, sys
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
run_id='20261018T231100CEST-weighted-residual'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(name,v): (out/name).write_text(json.dumps(v,indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_final',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
declarations=json.loads((out/'DECLARATIONS.json').read_text());targets=list(declarations)
receipts=json.loads((out/'TARGETED_REPLAY_RECEIPTS.json').read_text())
assert [x['label'] for x in receipts]==['weighted-residual-type-axioms','BennettWeightedHeight-targeted-replay','BennettResiduesAtInfinity-targeted-replay','BennettResidualBound-targeted-replay']
assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in receipts)
assert not json.loads((out/'active-targeted-replay.json').read_text())['active']
audit=(out/'weighted-residual-type-axioms.log').read_text()
assert audit.count('WEIGHTED_RESIDUAL_AXIOMS_PASS')==sum(map(len,declarations.values()))
assert 'sorryAx' not in audit
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work);active=json.loads(driver.active_path.read_text())
 assert not active['active'] and not active['protected_closure']
 queue,names,closures,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and queue['max_parallel']==1 and queue['pause_after_current']
 assert all(t in accepted for t in targets)
 guards=json.loads((out/'TARGETED_REPLAY_GUARDS.json').read_text())
 assert all(sha(root/'D1Bound5'/(t+'.lean'))==h for t,h in guards['project_sources'].items())
 assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(driver.static)
 now=datetime.now().astimezone().isoformat();results={};all_sources={};public=private=0
 headers=lambda s:re.findall(r'(?ms)^(?:private\s+)?(?:theorem|lemma)\s+.*?:= by',s)
 for t in targets:
  p=root/'D1Bound5'/(t+'.lean');text=p.read_text();before=(out/(t+'.before.lean')).read_text()
  assert headers(text)==headers(before),t
  row=[r for r in driver.rows if r['name']==t][-1]
  assert row['accepted_build'] and row['exit']==0 and row['source_sha256']==sha(p)
  assert row['fingerprint']==mod.fingerprint(closures[t]) and row['closure_unchanged'] and row['shared_artifacts_unchanged']
  shutil.copyfile(p,out/p.name);shutil.copyfile(row['log'],out/(t+'-build.log'))
  save(t+'-SOURCE_CLOSURE.json',closures[t]);save(t+'-BUILD_RECEIPT.json',row)
  public+=len(re.findall(r'^(?:@\[[^\n]*\]\s*)?(?:theorem|lemma)\s+',text,re.M))
  private+=len(re.findall(r'^private\s+(?:theorem|lemma)\s+',text,re.M))
  results[t]={'source_sha256':sha(p),'build_exit':0,'build_seconds':row['seconds'],'original_theorem_headers_unchanged':True}
  all_sources.update(closures[t])
 def deps(text):
  text=re.sub(r'/\-.*?\-/','',text,flags=re.S);text=re.sub(r'--[^\n]*','',text)
  return re.findall(r'^(?:public\s+)?import\s+D1Bound5\.([A-Za-z0-9_]+)\s*$',text,re.M)
 root_set=set()
 def visit(t):
  if t in root_set:return
  root_set.add(t)
  for d in deps((root/'D1Bound5'/(t+'.lean')).read_text()):visit(d)
 for t in deps((root/'D1Bound5.lean').read_text()):visit(t)
 assert not set(targets)&root_set
 for t in all_sources:
  text=(root/'D1Bound5'/(t+'.lean')).read_text();text=re.sub(r'/\-.*?\-/','',text,flags=re.S);text=re.sub(r'--[^\n]*','',text)
  assert not re.search(r'\b(sorry|admit|sorryAx|native_decide|axiom|unsafe)\b',text),t
 summary={'outcome':'COMPLETED_UNIT','time':now,'targets':results,'public_theorems':public,'private_helpers':private,'public_declarations':sum(map(len,declarations.values())),'checks':receipts,'project_source_closure':all_sources,'root_integrated':False,'independent_review':False,'clean_checkout':False,'main_statement_proved':False}
 save('VERIFICATION_SUMMARY.json',summary)
 save('SOURCE_MAP.json',{t:{'working_source':'D1Bound5/'+t+'.lean','preservation_copy':str(out.relative_to(root)/(t+'.lean')),'source_sha256':sha(root/'D1Bound5'/(t+'.lean')),'root_imported':False} for t in targets})
 next_targets=['BennettTwoResidualBound','BennettTwoResidualRate','BennettRootTransfer','FullRingOrdinaryHeight','UnitPairFirstExtensionBound']
 next_info={}
 for t in next_targets:
  missing=[d for d in closures[t] if d!=t and d not in accepted]
  next_info[t]={'accepted':t in accepted,'eligible':t in eligible,'unaccepted_dependencies':missing,'ready_prerequisites':[d for d in missing if d in eligible]}
 save('NEXT_DEPENDENCIES.json',{'time':now,'unknown':unknown,'targets':next_info})
 title='## 18 October 2026 — weighted height and actual Bennett residual verified'
 paragraph=('Six working modules now prove the combined weighted column height, exact analytic residue evaluation, the inverse-denominator/repeated-node coefficient identity, and the actual arbitrary-order residual bound including its exact Gamma specialization. All original theorem headers are unchanged. The guarded pinned builds, exact public type/transitive-axiom audit and targeted installed SAME-kernel replays of the weighted-height, infinity and residual-bound endpoints passed with only propext, Classical.choice and Quot.sound. Applying the integral clearing factor and residual rate, the full-ring all-order inequalities, root integration, exhaustive finite checks and MainStatement remain open. Evidence: research/continuations/'+run_id+'/VERIFICATION_SUMMARY.json.')
 for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
  p=root/name;text=p.read_text();assert title not in text
  block=title+'\n\n'+paragraph+'\n'
  if name in ['STATUS.md','records/open-obligations.md']:
   h,tail=text.split('\n',1);p.write_text(h+'\n\n'+block+'\n'+tail.lstrip('\n'))
  else:p.write_text(text.rstrip()+'\n\n'+block)
 finish=('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT for the six separately verified modules. '+paragraph+'\n\nAll owned compiler/checker results must be collected before the final report. The driver is paused between jobs and the inherited staged receipt is preserved. Private publication is subject to the subsequent separate reviewed Git calls and post-push verification; no publication is claimed by this pre-commit record. No automations or frozen sources were changed.\n')
 (root/'records/runs'/(run_id+'-FINISH.md')).write_text(finish)
 (out/'README.md').write_text('# Verified weighted height and actual residual\n\n'+paragraph+'\n\nCanonical Lean imports resolve through D1Bound5/, not through this research directory. The final .lean preservation copies match the guarded-compiled sources; .before.lean and .trial files are failed or unverified historical trials and are never accepted dependencies. See individual build receipts, WeightedResidualAudit.lean, the targeted replay receipts, the statement self-review and NEXT_DEPENDENCIES.json. This is not independent review or final root acceptance.\n')
 print('UNIT_VERIFIED',public,'public theorems;',private,'private helpers;',len(all_sources),'project dependencies',flush=True)
 print('NEXT',json.dumps({t:{'eligible':v['eligible'],'missing':len(v['unaccepted_dependencies']),'ready':v['ready_prerequisites']} for t,v in next_info.items()}),flush=True)
