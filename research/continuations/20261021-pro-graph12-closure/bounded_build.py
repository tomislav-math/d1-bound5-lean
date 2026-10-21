"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairGraphInputs12': 'f4a07feaecbd9759d73a502405a7b84fc24831c7d2336548e6ffbde2fa30f1b0', 'SmallPairGraphArithmetic12': 'f63837b55c69bdb709897de72e83d4ac38d1ee00669f9ffa16acb6f62232a866', 'SmallPairGraphWitnessData12': 'b4c14668eb5200cf5e171249f2240243271c678dc26431089cd222d974641dc0', 'SmallPairGraphClosure12': 'c9bc50e1b25d7ad0caa0e149d8113ce4803c9e520fc7dee649f6e12e1acf6986', 'SmallPairRawSelectedData12': 'ae7df2e33e86b16824b9aeb75cedb47199e7ce352388405387d80306a29f1d2a', 'SmallPairLightAssembly12': 'f97804cda6000ca5224866d4c03f9dac3bc3dfdcf5a143f857e57e3150616c7e', 'SmallPairGraphTriangle12': '784ba1e429ba058107836205f2eb02895ec3d918c8bff82e7fa6ecd813be5ac0', 'SmallPairGraphData12': 'ad2a46e887c9ca361cf657fa0b33affe672dc9b06ccc9064441889c5aee7fc9f', 'SmallPairGraphClosure12Chunk00': '79fb3da15ad291a07d4377faed03cba0adda08da1b6ffd1e3326c288af8763af', 'SmallPairGraphClosure12Chunk01': '9f15da4b8a7be37a40283bfd8d9f0eeb356aceac154e86a070004888bdcb4ecb', 'SmallPairGraphClosure12Chunk02': 'cde36d849d8370f82d634d4accadbe3764ea226f40ab0b569a4801434d1dba52', 'SmallPairGraphClosure12Chunk03': '0e406d98b9ce4a1e81d22189036fc620afe6239301446886ae8b4a2f4015d04a', 'SmallPairGraphClosure12Chunk04': '543e7e42fe922ff80429a54a3a4d4750e221a165d71bd0080e53e909a70c8890', 'SmallPairGraphClosure12Chunk05': 'd01999e9fcd3e10b10b4d8579b994d8368050b665c99673b592cb71211f5e669', 'SmallPairGraphClosure12Coverage': '0b58c40a6eca773db716549bed5dac966d3e596e51c4286a6b9b706029e88612'}
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
   assert not active.get('active') and not active.get('protected_closure'), 'Reconcile active ownership before building'
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
