"""Audit the selected verified targets serially under both existing project locks.
No Git mutations, source changes, queue modifications or new compiler driver.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
targets=['PellLightMatchingField47', 'PellLightMatchingField71', 'PellLightMatchingField79', 'PellLightMatchingField103', 'PellLightPrefixData8', 'PellLightPrefixData9', 'PellLightPrefixData10', 'PellLightPrefixData11', 'PellLightPrefixData12', 'PellLightPrefixData13', 'PellLightPrefixData14', 'PellLightPrefixData15']
expected_driver='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(work/'continuation_driver_capacity.py') == expected_driver
spec=importlib.util.spec_from_file_location('d1_analytic_checks_driver',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
commands=[('pell-certificate-type-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(out/'PellCertificateAudit.lean')])] + [(t+'-targeted-replay',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+t]) for t in targets]
records=[]
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work)
 active=json.loads(driver.active_path.read_text())
 assert not active.get('active') and not active.get('protected_closure'), 'Another live proof owner'
 queue,names,closures,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and queue.get('max_parallel')==1
 assert all(t in accepted for t in targets), 'All selected exact targets must have guarded accepted builds'
 frozen={}
 for t in targets: frozen.update(closures[t])
 expected={}
 latest=driver.latest()
 for dep in frozen:
  expected.update(driver.expected_manifest(dep,mod.fingerprint(closures[dep]),latest))
 assert driver.manifest_matches(expected) and driver.manifest_matches(driver.static)
 guards={'project_sources':frozen,'compiled_artifacts':expected,'immutable_inputs':driver.static,'time':datetime.now().astimezone().isoformat()}
 (out/'TARGETED_REPLAY_GUARDS.json').write_text(json.dumps(guards,indent=2)+'\n')
 def stable():
  return all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in frozen.items()) and driver.manifest_matches(expected) and driver.manifest_matches(driver.static)
 for label,args in commands:
  assert stable(), 'Source/dependency/artifact drift before audit'
  log=out/(label+'.log'); start=time.monotonic(); timed_out=False
  with log.open('w') as stream:
   p=subprocess.Popen(args,cwd=root,env={**os.environ,'LEAN_NUM_THREADS':'1'},stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
   entry={'label':label,'pid':p.pid,'command':args,'time':datetime.now().astimezone().isoformat()}
   (out/'active-targeted-replay.json').write_text(json.dumps({'active':True,**entry},indent=2)+'\n')
   print(json.dumps(entry),flush=True)
   try: p.wait(timeout=240)
   except subprocess.TimeoutExpired:
    timed_out=True;os.killpg(p.pid,signal.SIGTERM)
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
  result={**entry,'exit':p.returncode,'seconds':time.monotonic()-start,'timed_out':timed_out,'guards_unchanged':stable(),'log':log.name}
  records.append(result)
  (out/'TARGETED_REPLAY_RECEIPTS.json').write_text(json.dumps(records,indent=2)+'\n')
  (out/'active-targeted-replay.json').write_text(json.dumps({'active':False,'last':result},indent=2)+'\n')
  print(json.dumps(result),flush=True)
  if result['exit'] or timed_out or not result['guards_unchanged']:sys.exit(1)
print('PELL_BATCH_CHECKS_PASS',flush=True)
