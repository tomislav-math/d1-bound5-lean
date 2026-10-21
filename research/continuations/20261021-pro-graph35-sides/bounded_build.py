"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairLightAdaptiveLeft35_000': '070be753a48c164ef2c68d8480b40efeb6ce7f91e3b4ec19d0b4380c2946fe6b', 'SmallPairLightAdaptiveLeft35_000Part00': '50ef371a7ba1783a1149c88cae7ae8f7c0cfc163a981c40c6cbcd418808101c1', 'SmallPairLightAdaptiveLeft35_000Part01': '4228fa6a360e3f753885ac7d7fe73460bdb36a96eec003ba8d2bacda8aeec98f', 'SmallPairLightAdaptiveLeft35_000Part02': '314eb3be0e2b81b46faf3a73d91a077b0809b93045aabda01010187febdfd9e4', 'SmallPairLightAdaptiveLeft35_000Part03': '6379a7722245094340da3e61627976f361ab6373bb6ba2c260da7c4c2970519e', 'SmallPairLightAdaptiveLeft35_000Part04': '2a5dd73f6bbefe31fc1fc53a510e7e312a13c6e72d05fc6b36320e46b0d219b3', 'SmallPairLightAdaptiveLeft35_001': 'f51a0033a0b0fed6af92b99f8315b8dcc4411b7c996966b59b01d1a5724d1af7', 'SmallPairLightAdaptiveLeft35_001Part00': '9bb5be366d784f66ff21f5b6f86187dfb276e12ba315dfa3f84aa0744e765b9e', 'SmallPairLightAdaptiveLeft35_001Part01': '150a2adc34cfdf4753957a65fb67b167773e466b8dee512ab25afa1f06fd4d57', 'SmallPairLightAdaptiveLeft35_001Part02': 'f71e73c60f318ef68ad530f96bea026968cd22149da815fcba7a03adf2831404', 'SmallPairLightAdaptiveRight35_000': 'eee760c04602493fd196471a90c6a2be6b437d40013650cfde19dbdd67b142cd', 'SmallPairLightAdaptiveRight35_000Part00': '771361de7b17c0f20d9c190b5ae2568d90f83256fea1ce303e6fdc40e74650b0', 'SmallPairLightAdaptiveRight35_000Part01': '739526b82251bde9b51aa47ae919eb2dade3b9645123ef3dec966835c2d6bd97', 'SmallPairLightAdaptiveRight35_000Part02': '523bb5c43aa99adaa1a966246b741e67f784fc4562c02470dc6906c57501b7b4', 'SmallPairLightAdaptiveRight35_000Part03': 'c23a744e19653beb59560128cadd6bdcb4b01f40d79542c6d7fd205a2f958694', 'SmallPairLightAdaptiveRight35_000Part04': '25a03743d891dd8c7287d1580caf38085d51d045af2552acd6f371856830c5ca', 'SmallPairLightAdaptiveRight35_001': 'f7db5feb5d79f88dec3de941701c34110f4c068630c8928c08a24e474b538d67', 'SmallPairLightAdaptiveRight35_001Part00': 'fe92710571b4b6dbceef552fd5c22d434bbabd7443e1672bcbaf35c55147b1a5', 'SmallPairLightAdaptiveRight35_001Part01': 'b59780dd8c0ece0848b1010873549f4bb9326d590783784c976949c0b609e225', 'SmallPairLightAdaptiveRight35_001Part02': '633c719acbf0703637c84dce6aa8dc96110ec4c892b22c1edb88d78e7a0ec6c3', 'SmallPairLightLeft35': '67a6080749653df855950e734ee17a4cca99dd9eb39357c4d9abcaa36401ee33', 'SmallPairLightRight35': '5984b09d998e3cc2f7dc3db86231c086198bd7e01bf329f6cc31a2e6739da2bd'}
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
