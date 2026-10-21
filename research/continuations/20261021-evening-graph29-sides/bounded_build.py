"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairLightAdaptiveLeft29_000': '28b8c0013b9775daa25423e1211309390ebbb0ab1a0cf96a64199701ddc1646d', 'SmallPairLightAdaptiveLeft29_000Part00': 'd7fc0d9b85816372b19bd89ed13eebb179fa0b960d85e87e7705665eebc38ac4', 'SmallPairLightAdaptiveLeft29_000Part01': '2159f0a829e8b668da5b7290d865a87a18466598aa94cdc23c552937097c2ea1', 'SmallPairLightAdaptiveLeft29_000Part02': '22cc411f787699e2a9df20ff288591a036148510f63077a279141791c07483af', 'SmallPairLightAdaptiveLeft29_000Part03': '7f84ae1f458ac9a506f77712a20ff418a6ca4c9b62030327aa8f17e935d0f5db', 'SmallPairLightAdaptiveLeft29_000Part04': '65a78a4d73dafdf0104031b75e54d20e204c94c9d9b830039cd4d1be7797da41', 'SmallPairLightAdaptiveLeft29_001': '7edef042d12b59268973db34a17fa32118aa2f7df125440232b47a32ee16d28b', 'SmallPairLightAdaptiveLeft29_001Part00': 'a5040bc9c71e445f1c38e6371444eb7647706c9e9a605659944860b11a252000', 'SmallPairLightAdaptiveLeft29_001Part01': '22a82d94ac6382c8227edcb8a401f1999a850ea504ce9f60d6552040a5db5380', 'SmallPairLightAdaptiveLeft29_001Part02': '81fdf582af2fe802b98ba68ce05e9346c86cdbbde95372cc0f0f66173fac9630', 'SmallPairLightAdaptiveLeft29_001Part03': '1461b6b07f04731fe09312929f14421be71d74a32f1fa998ad7e9ce0a2d97c2b', 'SmallPairLightLeft29': '169b1ff2732b190d2a7e911d59c47a1732a144bb42fbb9291b58bfef1f8288d6', 'SmallPairLightAdaptiveRight29_000Part00': '19843421e930120230e10a0f417a1ad5ad0c19b6ecfaedb83f8c067a07bf0c4a', 'SmallPairLightAdaptiveRight29_000Part01': 'c80c59614eff655b9183ace6304529c37bdf17ee77eebe3d29533285264302ec', 'SmallPairLightAdaptiveRight29_000Part02': 'cefd3a18e386cf9a9a15e81eaa3c2f3b9f6371b6d9fe61106dff30e8e9b2cfbc', 'SmallPairLightAdaptiveRight29_000Part03': '95543086c881e54b41dd8e00d984e9853e40842f5151180665a3fc6bdcc694eb', 'SmallPairLightAdaptiveRight29_000Part04': '9b723bb5ca31a6a36a182a1357f05d3f1483878881f86e16a33adfaa299c352b', 'SmallPairLightAdaptiveRight29_000': '552f87a6b0ad0ef9116051ccafea59319ffabc507f4d3fab88f4eb722fea0c61', 'SmallPairLightAdaptiveRight29_001Part00': 'ea2f50c4700fa28a1de59d672657a7f9edf6187657576dd8945c7408d3945876', 'SmallPairLightAdaptiveRight29_001Part01': 'ec43994d52ebf70d3d5ea91f0fdda2e50c5e2394419b8d678bf2bd0316842b6f', 'SmallPairLightAdaptiveRight29_001Part02': '0ee711a0da53ff9b2779f0b3acb4fc416ff7986211bcfd03b4988f2599b47fa5', 'SmallPairLightAdaptiveRight29_001Part03': 'ee5bfc6148856cf5a9d75741422fdef2742168257d4248cf4f2416d6f8af4966', 'SmallPairLightAdaptiveRight29_001': '1d3df2442e2bd576af29dea59588b7d20ca959ee8057df6b9e03d2948fcca02e', 'SmallPairLightRight29': '80c7ed9a3fdaf1f16f1f6fbad169c6a434e215d92c6e4aeb615d65eb3d227578'}
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
