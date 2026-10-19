"""Run one eligible existing Pell target through the unchanged guarded driver.
This is a compiler action, not a rerun of the refused startup diagnostic.
No Git mutations or mathematical source edits are performed here.
"""
from pathlib import Path
import fcntl, hashlib, importlib.util, json, os, sys, time
root = Path('/Users/tp/Lean/D1Bound5')
work = root/'research/continuations/20261018T010800CEST-main-continuation'
out = Path(__file__).resolve().parent
name = sys.argv[1]
allowed = {'PellLightMatchingPilot', 'PellLightPrefixData4', 'PellLightPrefixData5'}
if name not in allowed: raise RuntimeError('Unexpected target')
os.environ['LEAN_NUM_THREADS'] = '1'
assert hashlib.sha256((work/'continuation_driver_capacity.py').read_bytes()).hexdigest() == 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec = importlib.util.spec_from_file_location('d1_pell_existing_driver', work/'continuation_driver_capacity.py')
mod = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = mod
spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner:
    fcntl.flock(owner, fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver = mod.Driver(root, work)
    with driver.locked():
        active = json.loads(driver.active_path.read_text())
        if active.get('active') or active.get('protected_closure'): raise RuntimeError('Existing proof owner')
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        if unknown or queue.get('max_parallel') != 1: raise RuntimeError('Unreconciled serial queue')
        if name not in eligible: raise RuntimeError('Target not currently eligible; no retry')
        source = root/'D1Bound5'/(name+'.lean')
        saved = out/(name+'.lean')
        if saved.exists(): raise RuntimeError('Existing run snapshot would be overwritten')
        saved.write_bytes(source.read_bytes())
        (out/(name+'-SOURCE_CLOSURE.json')).write_text(json.dumps(closures[name], indent=2)+'\n')
        print(json.dumps({'status':'SINGLE_TARGET_START','name':name,'queue_stays_paused':queue.get('pause_after_current'),'utc':mod.utc()}), flush=True)
        if not driver.launch(name, closures[name], 240): raise RuntimeError('Dependency guard rejected launch')
    while driver.jobs:
        time.sleep(1)
        with driver.locked(): driver.reap()
    row = driver.rows[-1]
    (out/(name+'-BUILD_RECEIPT.json')).write_text(json.dumps(row, indent=2)+'\n')
    (out/(name+'-build.log')).write_bytes(Path(row['log']).read_bytes())
    print(json.dumps({'status':'SINGLE_TARGET_FINISH', **{k:row.get(k) for k in ['name','accepted_build','exit','seconds','source_sha256','closure_unchanged','shared_artifacts_unchanged','timed_out']}}), flush=True)
    sys.exit(0 if row.get('accepted_build') else 1)
