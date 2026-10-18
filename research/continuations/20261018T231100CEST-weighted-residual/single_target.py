"""Run exactly one eligible existing target using unchanged driver guards and locks."""
from pathlib import Path
import fcntl, importlib.util, json, os, sys, time
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
name=sys.argv[1]
if name not in {'BennettChooseGamma', 'BennettResiduesAtInfinity', 'BennettWeightedHeight', 'BennettResidualEvaluation'}:raise RuntimeError('Unexpected target')
os.environ['LEAN_NUM_THREADS']='1'
spec=importlib.util.spec_from_file_location('d1_scalar_existing_driver',work/'continuation_driver_capacity.py')
assert __import__('hashlib').sha256((work/'continuation_driver_capacity.py').read_bytes()).hexdigest()=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=mod.Driver(root,work)
    with driver.locked():
        current=json.loads(driver.active_path.read_text())
        if current.get('active'):raise RuntimeError('Existing active proof owner; no launch')
        queue,names,closures,accepted,unknown,eligible=driver.snapshot()
        if unknown:raise RuntimeError('Unknown dependency entries; no launch')
        if queue.get('max_parallel')!=1:raise RuntimeError('Expected serial queue')
        if name not in eligible:raise RuntimeError('Target no longer eligible; no retry')
        print(json.dumps({'status':'SINGLE_TARGET_START','name':name,'queue_stays_paused':queue.get('pause_after_current'),'utc':mod.utc()}),flush=True)
        if not driver.launch(name,closures[name],240):raise RuntimeError('Dependency guard rejected launch')
    while driver.jobs:
        time.sleep(1)
        with driver.locked():driver.reap()
    row=driver.rows[-1]
    out=Path(__file__).resolve().parent
    (out/(name+'-BUILD_RECEIPT.json')).write_text(json.dumps(row,indent=2)+'\n')
    print(json.dumps({'status':'SINGLE_TARGET_FINISH','result':{k:row.get(k) for k in ['name','accepted_build','exit','seconds','log','fingerprint','source_sha256','closure_unchanged','shared_artifacts_unchanged','timed_out']}}),flush=True)
    sys.exit(0 if row.get('accepted_build') else 1)
