"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairGraphInputs25': 'e21e9c8c3f0ad8438726b3bcb26af38e89411d1090e9304422abee471ce9c18b', 'SmallPairGraphWitnessData25': 'aad5db997a1a656ffe11b6d5627d083e2addabe315319a0bfb8ab88b70e20b6a', 'SmallPairGraphClosure25Chunk00': 'b133e4308ad08eca5b77717c5bcb485d54fc1431e936eaa55296c316f9e28616', 'SmallPairGraphClosure25Chunk01': '426085ac4121c288e28d8ead7258490e9470b9fd4a39788c74359c2df65e639e', 'SmallPairGraphClosure25Chunk02': '43efbabf94b253569d106a05b42e2cbc3f9dfaa688f10d3548d7af2c4c23625a', 'SmallPairGraphClosure25Chunk03': 'fbc0f49942b8af5216a5d54ba40545860d5a4155b27fb1367672669e48d562e9', 'SmallPairGraphClosure25Chunk04': '87887c7aeebb183e7b4dbcba6c9d5c5a59ab2fc66ffa36afc9f9efe75415a44e', 'SmallPairGraphClosure25Chunk05': '74df9399b6f9fd8eed01aae4551e9d6474bb575ea61dce8243888f833e0807bb', 'SmallPairGraphClosure25Chunk06': '897bb242c854883c3eb3fb81ece57e9fe91626d174c19459e38e1ef1612efc80', 'SmallPairGraphClosure25Chunk07': '2236268d2be17d8b3f44e28ea50e4be3df7776543a7dd9e40ae13e5120c36345', 'SmallPairGraphClosure25Chunk08': '1e1dbdddc34a2e43fb4a5a83a0052874facc2116f1b9876032ef89eb859b3ec7', 'SmallPairGraphClosure25Chunk09': '3123d0708afc842a94b70624c9934c2b454d6a1b4ae3d22a7813badb96e0678c', 'SmallPairGraphClosure25Chunk10': '58240911183a0f69264acef55e94ea9678ae650d3cde046bbd0366352082cc96', 'SmallPairGraphClosure25Chunk11': 'd95d99c9c85da4bb63f77d87dc4c5b9917e6d5bfd8f60e6d7c5d7af76724ab8d', 'SmallPairGraphClosure25Coverage': '77a810005a03b4bc385ebccc885c63c7b573f20b72ade9df8c6bd3e3754a7530', 'SmallPairGraphClosure25': 'd76b5a372dcc2a0a86abd57001a94b86fd9580c549192fe65cf554ec752528d1', 'SmallPairGraphArithmetic25': 'adbd31c0b9ce182d87399cdbbe96f473c24aa8d054625ec7524511b6667c572d', 'SmallPairRawSelectedData25': '76ed86bf2dc6bf86b79bbaa574dff6d99fb70878ea6d86009fc7c483af4f7e54', 'SmallPairLightAssembly25': 'bd192e00e2176c523d859addb25c5bf30a7494b725c17168d6f36a58f7031fa6', 'SmallPairGraphTriangle25': 'fa05c5cdeefddbdb8b3935e9a00083ee1ceeed81cdd9aafc2366023452fb1c49', 'SmallPairGraphData25': 'cef7208eaaee99bc29dba01a22e8d816599dd69af1f34088426e5cafe74a600a'}
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
