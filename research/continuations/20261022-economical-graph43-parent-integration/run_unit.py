"""Bounded serial proof unit for graph43, preserving complete tails and original sources."""
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
with (W/'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 with d.locked():
  idle();assert not git('diff','--cached','--name-only')
  assert len(sys.argv)==2 and git('rev-parse','HEAD')==sys.argv[1]
  assert not (O/'PLAN.json').exists()
  proposal=R/'research/continuations/20261022-economical-graph43-parent-proposal'
  plan=json.loads((proposal/'PLAN.json').read_text());assert plan['status']=='PREPARED_NOT_PROVED'
  for side in ['Left','Right']:
   for block in ['000','001','002']:
    n='SmallPairLight'+side+'43Prefix'+block;c=d.closure(n);key=m.fingerprint(c);expected=d.expected_manifest(n,key,d.latest())
    assert expected and expected==d.artifacts(n),'Missing current verified prefix '+n
  (O/'originals').mkdir()
  parents=list(plan['parents'])
  for n,pins in plan['parents'].items():
   src=R/'D1Bound5'/(n+'.lean');old=proposal/'originals'/(n+'.lean');new=proposal/'candidates'/(n+'.lean')
   assert sha(src)==sha(old)==pins['original'] and sha(new)==pins['candidate']
   assert old.read_text().split('theorem ',1)[1].split(':=',1)[0]==new.read_text().split('theorem ',1)[1].split(':=',1)[0]
   (O/'originals'/(n+'.lean')).write_bytes(old.read_bytes())
  for n in parents:(R/'D1Bound5'/(n+'.lean')).write_bytes((proposal/'candidates'/(n+'.lean')).read_bytes())
  targets=['SmallPairLightData43','SmallPairLightAdaptiveData43']+parents+['SmallPairLightAdaptiveValidation43','SmallPairLightLeft43','SmallPairLightRight43']
  proof_targets=parents+['SmallPairLightAdaptiveValidation43','SmallPairLightLeft43','SmallPairLightRight43']
  counts=[]
  q=json.loads(d.queue_path.read_text());assert q['max_parallel']==1 and q['pause_after_current'] is True
  save('QUEUE_BEFORE.json',q)
  for n in targets:
   assert n not in q.get('blocked_modules',[])
   if n not in q['names']:q['names'].append(n)
   q.setdefault('target_timeout_seconds',{})[n]=240
  m.atomic_json(d.queue_path,q);save('QUEUE_AFTER.json',q)
  sources={}
  for n in targets:sources.update(d.closure(n))
  (O/'sources').mkdir()
  for n in sources:(O/'sources'/(n+'.lean')).write_bytes((R/'D1Bound5'/(n+'.lean')).read_bytes())
  save('PLAN.json',{'targets':targets,'source_closure':sources,'configuration':d.static,'parts':counts,'heads':962,'start_offset':0,'complete_tails':True,'base_commit':git('rev-parse','HEAD'),'graph43_complete':False})
  save('OWNER.json',{'active':True,'pid':os.getpid(),'utc':m.utc()})
 audits=[];builds=[]
 try:
  for n in targets:
   with d.locked():
    idle();assert not d.stop and d.manifest_matches(d.static)
    assert all(sha(R/'D1Bound5'/(x+'.lean'))==h for x,h in sources.items())
    c=d.closure(n);key=m.fingerprint(c);prior=d.latest().get((n,key));expected=d.expected_manifest(n,key,d.latest())
    if expected and expected==d.artifacts(n):
     builds.append({'name':n,'reused_current_accepted_build':True});continue
    assert prior is None,'Prior exact attempt: '+n
    assert d.launch(n,c,240)
   while d.jobs:
    time.sleep(2)
    with d.locked(),(O/'driver-events.log').open('a') as log,contextlib.redirect_stdout(log):d.reap()
   row=d.rows[-1];save(n+'-BUILD_RECEIPT.json',row);(O/(n+'-build.log')).write_bytes(Path(row['log']).read_bytes())
   builds.append(row);save('BUILD_RESULTS.json',builds)
   print(json.dumps({k:row[k] for k in ['name','exit','accepted_build','seconds']}),flush=True)
   assert row['name']==n and row['accepted_build'] and not d.stop
  import re
  audit=''.join('import D1Bound5.'+n+'\n' for n in proof_targets)+'import Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n'
  names=[];headers={}
  for n in proof_targets:
   text=(R/'D1Bound5'/(n+'.lean')).read_text();ns=re.search(r'^namespace (\S+)',text,re.M).group(1)
   preserved=(O/'originals'/(n+'.lean')).read_text() if n in parents else text
   headers[n]=[]
   for match in re.finditer(r'^theorem (\w+)\s*(:[\s\S]*?):=',text,re.M):
    name,ty=match.groups();original=re.search(r'^theorem '+name+r'\s*(:[\s\S]*?):=',preserved,re.M);assert original and original.group(1)==ty
    audit+='namespace '+ns+'\nexample '+ty+':= '+name+'\nend '+ns+'\n';names.append(ns+'.'+name);headers[n].append(name+ty)
  save('PRESERVED_THEOREM_HEADERS.json',headers)
  audit+='run_cmd do\n  for name in (['+', '.join(chr(96)+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
  (O/'AnalyticAudit.lean').write_text(audit);frozen={n:d.artifacts(n) for n in sources}
  commands=[('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in proof_targets]
  for label,args in commands:
   row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits)
   assert row['exit']==0 and not row['timed_out'] and not d.stop
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
  assert all(d.artifacts(n)==a for n,a in frozen.items()) and d.manifest_matches(d.static)
  save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'heads':962,'start_offset':0,'full_tails':True,'parts':counts,'new_part_theorems':0,'existing_trial_now_guarded':0,'preserved_parent_theorems':6,'light_side_certificates':2,'targeted_kernel_replays':len(proof_targets),'type_axiom_audit_exit':0,'source_closure':sources,'artifacts':frozen,'configuration':d.static,'main_theorem_complete':False,'graph43_endpoint_complete':False,'root_integration':False})
  print('GRAPH43_PARENT_INTEGRATION_SCOPED_VERIFICATION_PASS',flush=True)
 except BaseException as e:
  save('FAILURE.json',{'utc':m.utc(),'type':type(e).__name__,'detail':str(e)});raise
 finally:
  d.stop=True
  while d.jobs:
   with d.locked(),(O/'driver-events.log').open('a') as log,contextlib.redirect_stdout(log):d.reap()
   time.sleep(1)
  if child is not None and child.poll() is None:
   os.killpg(child.pid,signal.SIGTERM)
   try:child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);child.wait()
  save('OWNER.json',{'active':False,'pid':os.getpid(),'utc':m.utc(),'child_processes':[]})
