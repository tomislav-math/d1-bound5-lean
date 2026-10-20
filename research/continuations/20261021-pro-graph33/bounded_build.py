"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {
 'SmallPairGraphClosure33Chunk04': '5688771bc1a5c2c11a9ff894b510163d1a7beb2b724dba88dab9c183bc87f2a1',
 'SmallPairGraphClosure33Chunk05': 'fa10a3e47b0095347ae5301cc8d8df54e685b4a27d000a4f44cef312a8ea4c60',
 'SmallPairGraphClosure33Coverage': 'bbdf849a2fe20ad1c1dbc31b97a11b26d2a85585f3aba995282c64d92bc21f7f',
 'SmallPairGraphClosure33': '1db027bd30adce0ca5b3f438da60511eb55e9708511b55b07d7f869be862fafb',
 'SmallPairGraphData33': '9081d80bfaa58bdcfd65e67ea5836207d44886e1482948d930ae63bc677adec5'
}
os.environ['LEAN_NUM_THREADS'] = '1'
name = sys.argv[1]
assert name in PINS, 'Unreviewed target'
driver_path = WORK / 'continuation_driver_capacity.py'
assert hashlib.sha256(driver_path.read_bytes()).hexdigest() == DRIVER_SHA
spec = importlib.util.spec_from_file_location('d1_pro_guarded_driver', driver_path)
mod = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = mod
spec.loader.exec_module(mod)
driver = mod.Driver(ROOT, WORK)

@contextmanager
def intake():
 with driver.lock_path.open('r+') as lock:
  fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
  try:
   yield
  finally:
   fcntl.flock(lock, fcntl.LOCK_UN)

def on_stop(_sig, _frame):
 driver.stop = True

for sig in (signal.SIGTERM, signal.SIGINT, signal.SIGHUP):
 signal.signal(sig, on_stop)

def no_live_project_compiler():
 ps = subprocess.run(['ps', '-axo', 'pid=,ppid=,comm=,args='], text=True,
                     capture_output=True, check=True, timeout=10).stdout
 for line in ps.splitlines():
  fields = line.strip().split(None, 3)
  if len(fields) < 4 or int(fields[0]) == os.getpid():
   continue
  pid, _, executable, command = fields
  if Path(executable).name not in ('lean', 'lake', 'leanchecker'):
   continue
  cwd = subprocess.run(['/usr/sbin/lsof', '-a', '-p', pid, '-d', 'cwd', '-Fn'],
                       text=True, capture_output=True, timeout=10).stdout
  assert not any(s == 'n' + str(ROOT) or s.startswith('n' + str(ROOT) + '/')
                 for s in cwd.splitlines()), 'Another project compiler: ' + pid

with (WORK / 'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
 try:
  with intake():
   no_live_project_compiler()
   active = json.loads(driver.active_path.read_text())
   if active.get('active') or active.get('protected_closure'):
    assert len(active.get('active', [])) == 1
    old = active['active'][0]
    assert old['name'] == 'SmallPairGraphClosure33Chunk04' and old['pid'] == 55161
    stop = json.loads((ROOT / 'records/runs/20261020T214850Z-USER-REQUESTED-STOP.json').read_text())
    assert stop['status'] == 'STOPPED'
    for pid in (52229, 55161, 55182):
     try:
      os.kill(pid, 0)
     except ProcessLookupError:
      continue
     raise RuntimeError('Historical process identifier is live; resolve ownership: ' + str(pid))
    recovery = OUT / 'STALE_ACTIVE_RECOVERY.json'
    assert not recovery.exists()
    recovery.write_text(json.dumps({'utc': mod.utc(), 'previous': active,
       'verified_absent_pids': [52229, 55161, 55182],
       'locks_held': ['continuation-driver.lock', 'continuation-intake.lock'],
       'prior_attempt': 'interrupted, not accepted; exit code not reconstructed'}, indent=2) + '\n')
    driver.write_active()
   queue = json.loads(driver.queue_path.read_text())
   assert queue['max_parallel'] == 1 and queue['pause_after_current'] is True
   assert name in queue['names']
   closure = driver.closure(name)
   assert not (set(closure) & set(queue.get('blocked_modules', [])))
   assert closure[name] == PINS[name]
   latest = driver.latest()
   prior = latest.get((name, mod.fingerprint(closure)))
   assert prior is None, 'Existing attempt at these exact bytes; review before retry'
   for dep in closure:
    if dep != name:
     dc = driver.closure(dep)
     manifest = driver.expected_manifest(dep, mod.fingerprint(dc), latest)
     assert manifest and driver.artifacts(dep) == manifest, 'Unaccepted dependency: ' + dep
   source = ROOT / 'D1Bound5' / (name + '.lean')
   assert not (OUT / (name + '-BUILD_RECEIPT.json')).exists()
   (OUT / (name + '.lean')).write_bytes(source.read_bytes())
   (OUT / (name + '-SOURCE_CLOSURE.json')).write_text(json.dumps(closure, indent=2, sort_keys=True) + '\n')
   (OUT / 'CONFIGURATION.json').write_text(json.dumps(driver.static, indent=2, sort_keys=True) + '\n')
   assert not driver.stop, 'Stop requested before launch'
   assert driver.launch(name, closure, 240)
  while driver.jobs:
   time.sleep(2)
   with intake():
    driver.reap()
 finally:
  if driver.jobs:
   driver.stop = True
   while driver.jobs:
    with intake():
     driver.reap()
    if driver.jobs:
     time.sleep(2)
 if not driver.rows or driver.rows[-1]['name'] != name:
  raise RuntimeError('No terminal target receipt')
 row = driver.rows[-1]
 (OUT / (name + '-BUILD_RECEIPT.json')).write_text(json.dumps(row, indent=2, sort_keys=True) + '\n')
 (OUT / (name + '-build.log')).write_bytes(Path(row['log']).read_bytes())
 original_closure = Path(row['log']).with_suffix('.sources.json')
 assert json.loads(original_closure.read_text()) == closure
 (OUT / (name + '-ORIGINAL_SOURCES.json')).write_bytes(original_closure.read_bytes())
 no_live_project_compiler()
 print('TARGET_DRAINED', json.dumps({k: row.get(k) for k in
   ['name','exit','accepted_build','seconds','timed_out','interrupted',
    'source_sha256','fingerprint','closure_unchanged','shared_artifacts_unchanged']}), flush=True)
 sys.exit(0 if row['accepted_build'] else 1)
