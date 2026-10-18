"""Targeted type/axiom and same-kernel checks with both project locks.
No Git, queue changes, source edits, or second proof driver.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
name=sys.argv[1]
audits={'CoherentRetainedMixedSizes':'MixedSizesAudit.lean','CoherentRetainedMixedForms':'MixedFormsAudit.lean','CoherentRetainedMixedGap':'MixedGapAudit.lean'}
assert name in audits
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('mixed_guarded_checks',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
commands=[('type-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(out/audits[name])]),('targeted-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+name])]
records=[]
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work)
 active=json.loads(driver.active_path.read_text())
 assert not active.get('active') and not active.get('protected_closure')
 queue,names,closures,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and queue.get('max_parallel')==1 and name in accepted
 frozen=closures[name];expected={};latest=driver.latest()
 for dep in frozen:
  manifest=driver.expected_manifest(dep,mod.fingerprint(closures[dep]),latest)
  assert manifest, 'Missing artifact baseline'
  expected.update(manifest)
 def stable():
  return all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in frozen.items()) and driver.manifest_matches(expected) and driver.manifest_matches(driver.static)
 assert stable()
 (out/(name+'-CHECK_GUARDS.json')).write_text(json.dumps({'sources':frozen,'artifacts':expected,'static':driver.static},indent=2)+'\n')
 for label,args in commands:
  assert stable()
  log=out/(name+'-'+label+'.log');start=time.monotonic();timed_out=False
  with log.open('w') as stream:
   p=subprocess.Popen(args,cwd=root,env={**os.environ,'LEAN_NUM_THREADS':'1'},stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
   entry={'name':name,'label':label,'pid':p.pid,'command':args,'time':datetime.now().astimezone().isoformat()}
   (out/'active-check.json').write_text(json.dumps({'active':True,**entry},indent=2)+'\n');print(json.dumps(entry),flush=True)
   try:p.wait(timeout=180)
   except subprocess.TimeoutExpired:
    timed_out=True;os.killpg(p.pid,signal.SIGTERM)
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
  rec={**entry,'exit':p.returncode,'seconds':time.monotonic()-start,'timed_out':timed_out,'guards_unchanged':stable(),'log':log.name}
  records.append(rec)
  (out/(name+'-CHECK_RECEIPTS.json')).write_text(json.dumps(records,indent=2)+'\n')
  (out/'active-check.json').write_text(json.dumps({'active':False,'last':rec},indent=2)+'\n');print(json.dumps(rec),flush=True)
  if p.returncode or timed_out or not rec['guards_unchanged']:sys.exit(1)
 print('TARGETED_CHECKS_PASS '+name,flush=True)
