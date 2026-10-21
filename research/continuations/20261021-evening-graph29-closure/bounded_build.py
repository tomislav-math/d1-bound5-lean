"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairGraphInputs29': '83d8096af5153ef2a46dfecec9766ab37b4c65476c37fc8afb2c5a9bc632bc81', 'SmallPairGraphWitnessData29': '09e65a4c0cc21540226b59bcb924f1bdc8846677018cda9946e19f8ca53fb6e0', 'SmallPairGraphClosure29Chunk00': '525dbb16f308148b52f9ab266e83a448f3af19df32521fb26affaac811c82807', 'SmallPairGraphClosure29Chunk01': '6d90d691134a1885f0afd3c56fc8e68af415720ddea226409af5eda7fa06d51d', 'SmallPairGraphClosure29Chunk02': '550f9397e58980c868b5840595d086bed70228cee7b823d29fbe5ce3cf1958a7', 'SmallPairGraphClosure29Chunk03': '5c34bb7fc2dda6ce57e960b2f2797d8a343d88feb00db542784c7442da32e353', 'SmallPairGraphClosure29Chunk04': '04e1e5200c6c66da8c71974ad525d276a4c2fbaeb39bf6a9068b1c9cf9737ffc', 'SmallPairGraphClosure29Chunk05': 'a35b97cb15432ad19ee97fdc9397f64b19df3bb9a77a3551e8e338700c3adfd1', 'SmallPairGraphClosure29Chunk06': '60d59c09d2973a5038d11bd7ca6fcec5c2cb309e9430794668fead32dd1f13f1', 'SmallPairGraphClosure29Chunk07': '18bd44e29ecfe42217e21e15fa70c01d9c1ad0d5adefcb8051ef8460f39d42ed', 'SmallPairGraphClosure29Chunk08': '5f7f5565bd9ff2a8d12ae6e3ad62c5b782e12e5103fdf34ad3ba3a4da16b9d76', 'SmallPairGraphClosure29Chunk09': '0f2db35d3a529d126735caa46819a1bdd2b726c99d0bd890557cf7725340f496', 'SmallPairGraphClosure29Chunk10': 'a89f99bfee8428cd75c72cfc488399cc785ae50751e95a4524ed6e2df40b3c5a', 'SmallPairGraphClosure29Chunk11': '9d00baddf9c31ec868b43c752c0e0008d99e3273d3acccd6bd736b9dacffe0cf', 'SmallPairGraphClosure29Coverage': '16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1', 'SmallPairGraphClosure29': 'a02d88faf9018c992ccf9ce71905532ce94578632d12e96ecd5c414abb4d62fc', 'SmallPairGraphArithmetic29': '9c03dd78331bb1db2c0289b5b4d68f04d20fe5e7fa15fee676c238927f047874', 'SmallPairRawSelectedData29': 'cb250dfb0f3a845e4c45728b9aeb08186ea7efd2264d68f95718b76f733f0ce5', 'SmallPairLightAssembly29': 'dbacc8a2310d456f91b493fad40c48e58201b13c3a10f48ba7591cc4e9cbc81f', 'SmallPairGraphTriangle29': '5f677e8e8d8740cd86f7ac9d349494f4380512b84afc48192a2f3427d56e147d', 'SmallPairGraphData29': '11e0bb29f08bcff1b688adaf7f926c92c8163bd1f3915d0cf4ca37830f29dab5'}
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
