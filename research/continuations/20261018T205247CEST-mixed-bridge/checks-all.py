"""Audit six declarations and replay the three current modules serially."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
targets=['CoherentRetainedMixedSizes','CoherentRetainedMixedForms','CoherentRetainedMixedGap']
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('mixed_all_checks',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
commands=[('types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(out/'MixedBridgeAudit.lean')])]
commands += [(n+'-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in targets]
records=[]
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work)
 active=json.loads(driver.active_path.read_text())
 assert not active.get('active') and not active.get('protected_closure')
 queue,names,closures,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and queue.get('max_parallel')==1 and all(n in accepted for n in targets)
 frozen=closures[targets[-1]];expected={};latest=driver.latest()
 for dep in frozen:
  manifest=driver.expected_manifest(dep,mod.fingerprint(closures[dep]),latest)
  assert manifest, 'Missing artifact baseline'
  expected.update(manifest)
 def stable():
  return all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in frozen.items()) and driver.manifest_matches(expected) and driver.manifest_matches(driver.static)
 assert stable()
 (out/'CHECK_GUARDS.json').write_text(json.dumps({'sources':frozen,'artifacts':expected,'static':driver.static},indent=2)+'\n')
 for label,args in commands:
  assert stable()
  log=out/(label+'.log');start=time.monotonic();timed_out=False
  with log.open('w') as stream:
   p=subprocess.Popen(args,cwd=root,env={**os.environ,'LEAN_NUM_THREADS':'1'},stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
   entry={'label':label,'pid':p.pid,'command':args,'time':datetime.now().astimezone().isoformat()}
   (out/'active-all-checks.json').write_text(json.dumps({'active':True,**entry},indent=2)+'\n');print(json.dumps(entry),flush=True)
   try:p.wait(timeout=180)
   except subprocess.TimeoutExpired:
    timed_out=True;os.killpg(p.pid,signal.SIGTERM)
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
  rec={**entry,'exit':p.returncode,'seconds':time.monotonic()-start,'timed_out':timed_out,'guards_unchanged':stable(),'log':log.name}
  records.append(rec)
  (out/'CHECK_RECEIPTS.json').write_text(json.dumps(records,indent=2)+'\n')
  (out/'active-all-checks.json').write_text(json.dumps({'active':False,'last':rec},indent=2)+'\n');print(json.dumps(rec),flush=True)
  if p.returncode or timed_out or not rec['guards_unchanged']:sys.exit(1)
 print('MIXED_BRIDGE_TARGETED_CHECKS_PASS',flush=True)
