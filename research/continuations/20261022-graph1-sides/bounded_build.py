"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairLightAdaptiveLeft1_000': 'a76978b4b387c3c46156fe93511d1db9cd3e463fddb79d1f0769c33d821ea278', 'SmallPairLightAdaptiveLeft1_000Part00': '9ccb3e0fb8156f6154cf2af6ee61041956fee1bc31ffd6dcbc99e440c6708a03', 'SmallPairLightAdaptiveLeft1_000Part01': 'b5df000b8e8480eb1324abb271b7edc7808716b7d39346c9f9ea1e8023dc8951', 'SmallPairLightAdaptiveLeft1_000Part02': '2e736e00bacab842f4522f583c93d5707a709b98e8259f339615a2b393566c1f', 'SmallPairLightAdaptiveLeft1_000Part03': '0c01e9c1f74087c936d853b237ece21210ca5b92e1a4e53fb20d9662d064fad1', 'SmallPairLightAdaptiveLeft1_000Part04': '7ec739479177d16e228c15eccb4270d3cb29a5a7c73aebde5675df5408f8cb9c', 'SmallPairLightAdaptiveLeft1_000Part05': '0308b73aa3d59a645676bd4b9c5228a93b9bb644d62538f5da0aca40d7480b17', 'SmallPairLightAdaptiveLeft1_001': '50c3928b565d571161184b715f8d55de9304d8a0a7044c0ac031268c6a2a5cf2', 'SmallPairLightAdaptiveLeft1_001Part00': 'cae40fe8c0ed95536f6c1a6ea057e2a8bdf6a5988c09252ee7f9fb7ec80bbe44', 'SmallPairLightAdaptiveLeft1_001Part01': '0ed78a5921718702beae5d92eca1e444cded2c750838569dc9fe3df2ee25977d', 'SmallPairLightAdaptiveLeft1_001Part02': 'a712f49bedc427688fdd3effce4d4262b287f031f3e49c8d33e13ed287fb0b59', 'SmallPairLightAdaptiveLeft1_001Part03': 'c13cbdbaf6250b057bb174db521f5a5c765a6ca0a3b3dc8a383a734b542ee302', 'SmallPairLightAdaptiveRight1_000': 'e07471ae2dea817bd73d0685703e39ccc211fc351f792ec9c674cccc9a5cf889', 'SmallPairLightAdaptiveRight1_000Part00': 'fef32360c682295caf3a5345e7d7ea89c7b28c649da1aa3c3ff6da3f8e81fdac', 'SmallPairLightAdaptiveRight1_000Part01': '8756425acc01df50ad5520fdf38b3024254eb87822cf7198c26bc5a755463fc3', 'SmallPairLightAdaptiveRight1_000Part02': '248246bc477e152b80dba93182230ab33c87a4de8c66e425798b6b545349d2a3', 'SmallPairLightAdaptiveRight1_000Part03': 'a169ffe2ab751b6674c00b3a99452af1a197c8476cf819193847b01733d5104a', 'SmallPairLightAdaptiveRight1_000Part04': 'fe8869f65433fd98c70dd7d7b3d16b6e76799e0e5b5d0d3fc7052821dd9da19a', 'SmallPairLightAdaptiveRight1_000Part05': 'a7b4c5d1e5539069cb33121bb6e5b1797586c144ba08f077a723d68eaa57b2d2', 'SmallPairLightAdaptiveRight1_001': 'cace90b0234d7ef056c660e56b5e0fa75fb976b35a6b88d2ebb7610168eb857f', 'SmallPairLightAdaptiveRight1_001Part00': '83c0961fbe73e281e5732b479f49c2104aa05bc48a41cfff3aae804a3e6101a3', 'SmallPairLightAdaptiveRight1_001Part01': '4236b8d4beba2294ecdf80c52d9591b2bc92456154281587361e1948ec8c36d1', 'SmallPairLightAdaptiveRight1_001Part02': '76b3962cf3df4ac56990aa02020ef7740d7fa63865b2409ccd7539b8b4da74d6', 'SmallPairLightAdaptiveRight1_001Part03': '52e5c2438a80e464e95efb90a1cc350ec9c96e756641ca9576dcf955ef6a9b43', 'SmallPairLightLeft1': '98445b90667c3455707dacf065e9fe2d342252bc990562f9163f40e28ce01e09', 'SmallPairLightRight1': '14a6e009deda71ce4e221f11d26eed1ef8c5b5705ccb1eae2c7f7cb9343d4a87'}
if not __debug__:
 raise RuntimeError('Do not disable verification assertions')
os.environ['LEAN_NUM_THREADS'] = '1'
name = sys.argv[1]
assert name in PINS, 'Unreviewed target'
assert OUT == ROOT / 'research/continuations/20261022-graph1-sides'
foundation_binding_path = OUT / 'REVIEWED_FOUNDATION_BINDING.json'
foundation_binding_bytes = foundation_binding_path.read_bytes()
foundation_binding = json.loads(foundation_binding_bytes)
assert foundation_binding['status'] == 'REVIEWED_FOUNDATION_BINDING'
install_plan = json.loads((OUT / 'PLAN.json').read_bytes())
installation = json.loads((OUT / 'INSTALL_RECEIPT.json').read_bytes())
assert install_plan['source_manifest'] == installation['source_manifest'] == PINS
assert install_plan['reviewed_foundation_binding_sha256'] == installation['reviewed_foundation_binding_sha256'] == hashlib.sha256(foundation_binding_bytes).hexdigest()
assert install_plan['base_commit'] == foundation_binding['base_commit']
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
   assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip() == install_plan['base_commit']
   assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=ROOT)
   assert foundation_binding_path.read_bytes() == foundation_binding_bytes
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
