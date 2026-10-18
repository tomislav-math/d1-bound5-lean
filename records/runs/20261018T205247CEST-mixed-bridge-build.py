"""Bounded compilation of current mixed-retained proof dependencies.
Uses the existing reviewed driver and its locks. No Git operations or queue edits.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, os, sys, time
root = Path('/Users/tp/Lean/D1Bound5')
work = root/'research/continuations/20261018T010800CEST-main-continuation'
out = root/'research/continuations/20261018T205247CEST-mixed-bridge'
name = sys.argv[1]
assert name in {'CoherentRetainedMixedSizes','CoherentRetainedMixedForms','CoherentRetainedMixedGap'}
assert hashlib.sha256((work/'continuation_driver_capacity.py').read_bytes()).hexdigest() == 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
os.environ['LEAN_NUM_THREADS'] = '1'
spec = importlib.util.spec_from_file_location('d1_mixed_existing_driver',work/'continuation_driver_capacity.py')
mod = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = mod
spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner:
    fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
    driver = mod.Driver(root,work)
    with driver.locked():
        active = json.loads(driver.active_path.read_text())
        assert not active.get('active') and not active.get('protected_closure'), 'Existing proof owner'
        queue,names,closures,accepted,unknown,eligible = driver.snapshot()
        assert not unknown and queue.get('max_parallel') == 1
        assert driver.manifest_matches(driver.static), 'Pinned input drift'
        assert name in eligible, 'Not eligible: accepted, attempted fingerprint, or unmet dependency'
        out.mkdir(exist_ok=True)
        stamp = datetime.now().astimezone().strftime('%Y%m%dT%H%M%S%z')
        stem = name+'-'+stamp
        start = {'scope':'Prepared module verification, NOT a final theorem','time':datetime.now().astimezone().isoformat(),'target':name,'unknown':unknown,'source_closure':closures[name],'main_statement_proved':False}
        (out/(stem+'-START.json')).write_text(json.dumps(start,indent=2)+'\n')
        (root/'records/runs'/(stem+'-START.md')).write_text('# START — bounded mixed-retained verification\n\n'+json.dumps(start,indent=2)+'\n')
        (out/(stem+'.lean')).write_bytes((root/'D1Bound5'/(name+'.lean')).read_bytes())
        print(json.dumps({'stage':'BUILD_START','name':name,'time':start['time'],'source_sha256':closures[name][name]}),flush=True)
        assert driver.launch(name,closures[name],240), 'Dependency/artifact launch guard failed'
    try:
        while driver.jobs:
            time.sleep(1)
            with driver.locked(): driver.reap()
    except BaseException:
        driver.stop = True
        while driver.jobs:
            with driver.locked(): driver.reap()
            time.sleep(1)
        raise
    row = driver.rows[-1]
    (out/(stem+'-BUILD.json')).write_text(json.dumps(row,indent=2)+'\n')
    (out/(stem+'.log')).write_bytes(Path(row['log']).read_bytes())
    print(json.dumps({'stage':'BUILD_FINISH','name':name,'result':row}),flush=True)
    sys.exit(0 if row.get('accepted_build') else 1)
