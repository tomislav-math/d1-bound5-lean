"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairLightAdaptiveLeft48_000': 'a1e2884f0ef52fd0a986a3675bc15f50c66e2cfce48aa2a5bacaffdbe68c396a', 'SmallPairLightAdaptiveLeft48_000Part00': '5ae02e7e3e5495ea53f0a25561c5911bbf65319375a17dd09a21676477d60dc2', 'SmallPairLightAdaptiveLeft48_000Part01': '374f392580ff4ff5b38b2c1eb3422ad338c732469b282129a02022d430e0c815', 'SmallPairLightAdaptiveLeft48_000Part02': 'dc0fd940c39861e16811fa590a814cb298c2bafd242da290fcc0ae5874180cdb', 'SmallPairLightAdaptiveLeft48_000Part03': '3b252163dcb8252c4ba9b56fe7af400c604140dac7dbd84e9138a4580799c415', 'SmallPairLightAdaptiveLeft48_000Part04': '4bb39bbe8ce3daa1eeebe32e5c280610c3f655e6df6af6377cb232d8898e3e1a', 'SmallPairLightAdaptiveLeft48_001': 'd94e1fc6fed7c6afecc4385707b3b993408f41f522b7e2b82bb071e5c37982a6', 'SmallPairLightAdaptiveLeft48_001Part00': '2d10512315c9c600aee8fc4ceeed44e71b6f2c4389cd27be6a166a7c86d7043b', 'SmallPairLightAdaptiveLeft48_001Part01': '0b36bce479fbd7c1b91d08f884d919938b7f11cd1bfda7537b62d0edc601f7b9', 'SmallPairLightAdaptiveLeft48_001Part02': 'a26008113195f9633c1700352b32b0593c37c977442aaafc280ea3ce4c160d29', 'SmallPairLightAdaptiveRight48_000': '7995390531691efd46a8af8536671fa0111ed2eb703026437a9de7fc6af1bff0', 'SmallPairLightAdaptiveRight48_000Part00': '4e10e472df5a1ce3accd98aeecc601924d2bb7aaea0d3c0f226c49c9fe90b590', 'SmallPairLightAdaptiveRight48_000Part01': '520235ba3e0676a79463a7504970c992ef8a26fc22f73f75cfd8517dfd0d028b', 'SmallPairLightAdaptiveRight48_000Part02': '9a4fa6266eb2010b26261449c9be4a4676f12992e2610123d9d6c1cfc71dd1f3', 'SmallPairLightAdaptiveRight48_000Part03': '4b61b99568e7e29da63a9526125c0c1829cadf39d0b0ec3e6127446079ada4b8', 'SmallPairLightAdaptiveRight48_000Part04': '1231ea630caabc7361a76bc14e774896bb92a11956b52c7d532178dee814d986', 'SmallPairLightAdaptiveRight48_001': '054c48908842c9715cae96fa5d3347891ccd3eb17883310a3efc9dab831608bd', 'SmallPairLightAdaptiveRight48_001Part00': 'e126280dcb6d6d6cdfae1cd4aa30b58d4dad1a3d9a73d85bad9dbf4e93f469a7', 'SmallPairLightAdaptiveRight48_001Part01': 'c9b99c2d483fd3e8555e79781638af3c0564f662647ebc84b758ca9c7b1111fc', 'SmallPairLightAdaptiveRight48_001Part02': 'fd1d4b849666a2a0fe56af6c743317f40a073c296730238bd8b57bff49b24365', 'SmallPairLightLeft48': 'f771599f3c85f0150c884a42fb0fc14b2b6fe24d74719fc258a92db2eb769be5', 'SmallPairLightRight48': '56565e4beae9f0a378dcfb2ed3f4d9c8fb39097b816de06062e21fa72b9ae986'}
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
