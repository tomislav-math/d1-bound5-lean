"""Bounded serial proof unit for graph39, preserving complete tails and original sources."""
from pathlib import Path
import ast,contextlib,fcntl,hashlib,importlib.util,json,os,signal,subprocess,sys,time
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation';O=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(n,x):(O/n).write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git','-C',str(R),*a],text=True).strip()
p=W/'continuation_driver_capacity.py'
assert sha(p)=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_serial',p);m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
d=m.Driver(R,W);os.environ['LEAN_NUM_THREADS']='1';child=None
def stop(sig,frame):
 d.stop=True
 if child is not None and child.poll() is None:os.killpg(child.pid,signal.SIGTERM)
for sig in (signal.SIGINT,signal.SIGTERM,signal.SIGHUP):signal.signal(sig,stop)
def idle():
 a=json.loads(d.active_path.read_text());assert not a.get('active') and not a.get('protected_closure')
 assert not any(Path(s.strip()).name in ('lean','lake','leanchecker') for s in subprocess.check_output(['ps','-axo','comm='],text=True).splitlines())
def check(label,args):
 global child
 assert not d.stop
 start=time.monotonic();timed=False
 with (O/(label+'.log')).open('w') as f:
  child=subprocess.Popen(args,cwd=R,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
  try:code=child.wait(timeout=240)
  except subprocess.TimeoutExpired:
   timed=True;os.killpg(child.pid,signal.SIGTERM)
   try:code=child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);code=child.wait()
 child=None
 row={'label':label,'command':args,'exit':code,'timed_out':timed,'seconds':round(time.monotonic()-start,3)}
 print(json.dumps(row),flush=True);return row
import shutil
with (W/'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 with d.locked():
  idle();assert not git('diff','--cached','--name-only') and not json.loads((O/'OWNER.json').read_text())['active']
  assert not (O/'VERIFICATION_SUMMARY.json').exists()
  plan=json.loads((O/'PLAN.json').read_text());sources=plan['source_closure'];targets=plan['targets'];references=dict(plan['reference_files'])
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items()) and d.manifest_matches(plan['configuration'])
  assert all(sha(R/n)==h for n,h in references.items())
  for n in targets:
   c=d.closure(n);expected=d.expected_manifest(n,m.fingerprint(c),d.latest());assert expected and expected==d.artifacts(n),'Missing current accepted build '+n
  failed=O/'failed_audit';failed.mkdir()
  for name in ['AnalyticAudit.lean','AUDIT_RESULTS.json','FAILURE.json','exact-types-axioms.log']:(O/name).rename(failed/name)
  before=(failed/'AnalyticAudit.lean').read_text();after=before.replace('example : List PairLightCachedVertex','noncomputable\nexample : List PairLightCachedVertex');assert before!=after
  assert after.replace('noncomputable\n','')==before
  (O/'AnalyticAudit.lean').write_text(after)
  save('AUDIT_RECOVERY.json',{'status':'AUDIT_CONTEXT_ONLY_CORRECTION','reason':'anonymous data type witnesses require noncomputable modifier; logical types and source terms unchanged','old_audit_sha256':sha(failed/'AnalyticAudit.lean'),'new_audit_sha256':sha(O/'AnalyticAudit.lean'),'prior_failure_preserved':True,'accepted_builds_reused_without_recompilation':targets,'proof_source_and_artifacts_changed':False})
  references.update({str(p.relative_to(R)):sha(p) for p in [O/'AUDIT_RECOVERY.json',Path(__file__)]})
  frozen={n:d.artifacts(n) for n in sources};save('OWNER.json',{'active':True,'pid':os.getpid(),'utc':m.utc()})
 audits=[]
 try:
  commands=[('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in targets]
  for label,args in commands:
   row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits);assert row['exit']==0 and not row['timed_out'] and not d.stop
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items()) and all(sha(R/n)==h for n,h in references.items())
  assert all(d.artifacts(n)==v for n,v in frozen.items()) and d.manifest_matches(plan['configuration'])
  save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'heads':12,'start_offset':0,'full_tails':True,'parts':[12],'new_part_theorems':1,'existing_trial_now_guarded':0,'composition_theorems':1,'targeted_kernel_replays':len(targets),'type_axiom_audit_exit':0,'reference_files':references,'source_closure':sources,'artifacts':frozen,'configuration':plan['configuration'],'main_theorem_complete':False,'graph39_endpoint_complete':False,'root_integration':False,'original_literal_rows_reconstructed_byte_identically':456,'original_public_type_preserved':True,'original_definition_body_structure_changed':True,'audit_context_recovered_without_rebuilding_modules':True})
  print('GRAPH39_RIGHT_PILOT12_V4_SCOPED_VERIFICATION_PASS',flush=True)
 except BaseException as e:
  save('FAILURE.json',{'utc':m.utc(),'type':type(e).__name__,'detail':str(e)});raise
 finally:
  save('OWNER.json',{'active':False,'pid':os.getpid(),'utc':m.utc(),'child_processes':[]})
