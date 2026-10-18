"""Bounded scalar proof check using the existing serial driver and original guards."""
from pathlib import Path
import fcntl, hashlib, importlib.util, json, os, sys, time
root = Path('/Users/tp/Lean/D1Bound5')
work = root / 'research/continuations/20261018T010800CEST-main-continuation'
out = root / 'research/continuations/20261018T203306CEST-retained-scalars'
name = sys.argv[1]
if name not in {'RetainedMixedFourScalar', 'RetainedMixedScalar', 'CoherentRetainedMixedGap'}:
    raise RuntimeError('Unexpected proof target')
driver_path = work / 'continuation_driver_capacity.py'
if hashlib.sha256(driver_path.read_bytes()).hexdigest() != 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db':
    raise RuntimeError('Driver changed; review required before execution')
os.environ['LEAN_NUM_THREADS'] = '1'
spec = importlib.util.spec_from_file_location('d1_retained_existing_driver', driver_path)
mod = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = mod
spec.loader.exec_module(mod)
with (work / 'continuation-driver.lock').open('a+') as owner:
    fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
    driver = mod.Driver(root, work)
    with driver.locked():
        if json.loads(driver.active_path.read_text()).get('active'):
            raise RuntimeError('Existing active proof owner; no launch')
        queue, names, closures, accepted, unknown, eligible = driver.snapshot()
        if unknown or queue.get('max_parallel') != 1:
            raise RuntimeError('Unknown dependencies or nonserial queue; no launch')
        if name not in eligible:
            raise RuntimeError('Target not eligible; no repeated old result')
        out.mkdir(parents=True, exist_ok=True)
        stamp = mod.utc().replace(':', '').replace('+', '_')
        (out / (name + '-' + stamp + '.sources.json')).write_text(json.dumps(closures[name], indent=2) + '\n')
        (out / (name + '-' + stamp + '.lean')).write_bytes((root / 'D1Bound5' / (name + '.lean')).read_bytes())
        print(json.dumps({'stage': 'START', 'target': name, 'utc': mod.utc(), 'unknown': unknown, 'queue_paused': queue.get('pause_after_current')}), flush=True)
        if not driver.launch(name, closures[name], 240):
            raise RuntimeError('Dependency guard refused launch')
    while driver.jobs:
        time.sleep(1)
        with driver.locked():
            driver.reap()
    row = driver.rows[-1]
    (out / (name + '-' + stamp + '.receipt.json')).write_text(json.dumps(row, indent=2) + '\n')
    (out / (name + '-' + stamp + '.log')).write_bytes(Path(row['log']).read_bytes())
    print(json.dumps({'stage': 'FINISH', 'result': row}), flush=True)
    sys.exit(0 if row.get('accepted_build') else 1)
