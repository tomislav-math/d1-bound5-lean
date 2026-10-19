"""Bounded serial batch using the existing reviewed continuation driver.
No Git mutation, mathematical-source editing or queue reconfiguration.
The same owner lock is held throughout this batch. All child compilers are reaped.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, os, sys, time
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
os.environ['LEAN_NUM_THREADS']='1'
targets=json.loads((out/'TARGETS.json').read_text())
review=json.loads((out/'PRE_BUILD_SOURCE_REVIEW.json').read_text())
assert hashlib.sha256((work/'continuation_driver_capacity.py').read_bytes()).hexdigest()=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_pell_batch_existing_driver',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
results=[]
with (work/'continuation-driver.lock').open('a+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work)
 with driver.locked():
  active=json.loads(driver.active_path.read_text())
  assert not active.get('active') and not active.get('protected_closure'), 'Existing proof owner'
  queue,names,closures,accepted,unknown,eligible=driver.snapshot()
  assert not unknown and queue.get('max_parallel')==1 and queue.get('pause_after_current') is True
  readiness={n:{'accepted':n in accepted,'eligible':n in eligible,'missing':[d for d in closures[n] if d!=n and d not in accepted]} for n in targets}
  (out/'INITIAL_READINESS.json').write_text(json.dumps({'utc':mod.utc(),'unknown':unknown,'targets':readiness},indent=2)+'\n')
  print('INITIAL_READINESS',json.dumps(readiness),flush=True)
 for name in targets:
  with driver.locked():
   queue,names,closures,accepted,unknown,eligible=driver.snapshot()
   assert not unknown and queue.get('max_parallel')==1 and queue.get('pause_after_current') is True
   if name in accepted:
    results.append({'name':name,'status':'ALREADY_ACCEPTED_NOT_NEW'});continue
   if name not in eligible:
    results.append({'name':name,'status':'NOT_ELIGIBLE_NOT_RUN'});continue
   source=root/'D1Bound5'/(name+'.lean');data=source.read_bytes()
   assert hashlib.sha256(data).hexdigest()==review[name]['sha256'], 'Source changed after review'
   snap=out/(name+'.lean')
   assert not snap.exists(), 'Never overwrite an existing trial'
   snap.write_bytes(data)
   (out/(name+'-SOURCE_CLOSURE.json')).write_text(json.dumps(closures[name],indent=2)+'\n')
   print('OWNED_BATCH_START',name,mod.utc(),flush=True)
   assert driver.launch(name,closures[name],240), 'Dependency guard rejected launch'
  while driver.jobs:
   time.sleep(1)
   with driver.locked():driver.reap()
  row=driver.rows[-1];assert row['name']==name
  (out/(name+'-BUILD_RECEIPT.json')).write_text(json.dumps(row,indent=2)+'\n')
  (out/(name+'-build.log')).write_bytes(Path(row['log']).read_bytes())
  result={k:row.get(k) for k in ['name','exit','accepted_build','seconds','source_sha256','closure_unchanged','shared_artifacts_unchanged','timed_out']}
  results.append(result);(out/'BATCH_RESULTS.json').write_text(json.dumps(results,indent=2)+'\n')
  print('OWNED_BATCH_RESULT',json.dumps(result),flush=True)
  if not row.get('closure_unchanged') or not row.get('shared_artifacts_unchanged'):raise RuntimeError('Source or artifact drift; stop batch')
 (out/'BATCH_RESULTS.json').write_text(json.dumps(results,indent=2)+'\n')
print('BOUNDED_BATCH_DRAINED',len(results),flush=True)
sys.exit(0 if all(r.get('accepted_build') or r.get('status')=='ALREADY_ACCEPTED_NOT_NEW' for r in results) else 1)
