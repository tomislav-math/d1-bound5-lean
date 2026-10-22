"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairLightAdaptiveLeft11_000': '4610218ee4a4b3399efe5a24dfa30a415449855924e74d7660acf8d95fc395f1', 'SmallPairLightAdaptiveLeft11_000Part00': '257b7053a7a0d46287f71695527a68c94d136150f4601ba810d06515f60bd432', 'SmallPairLightAdaptiveLeft11_000Part01': 'dd39b7d0db605d76b28faab6156e2e9064ad7098c6f09a4c30d2fa1b677b7308', 'SmallPairLightAdaptiveLeft11_000Part02': '575780f98d37c6253ca0f11245b0430f8c71c5998b8eea2d0bc41bcb5fd4112f', 'SmallPairLightAdaptiveLeft11_000Part03': '293a71d484f5859d305c3004fcf794c68ffd046e5ded927d181f49b0b5323657', 'SmallPairLightAdaptiveLeft11_000Part04': 'fc5ae1df8b4aa1928e7c0c19aca0aec3aaef20eeb9e22777c64eb159dfdcd7ba', 'SmallPairLightAdaptiveLeft11_000Part05': '5fb5accb9251489b2949b13d842fd7b1ae4f0fc3cbf4df04a0ae6af5ec5072db', 'SmallPairLightAdaptiveLeft11_001': '3acfe0eb501b239643b6bdd27a47a27f1bb653607e9dbb6109ef431c3a3e99af', 'SmallPairLightAdaptiveLeft11_001Part00': '44601b9ade9fb7d33e6bc94eae5fe308ba707dbe0b5f91fd4a5b13fd5a8bae10', 'SmallPairLightAdaptiveLeft11_001Part01': 'ce04a30f5f46c4332e5b3db0d449b61f4bb1d61fa67dcfa92b44ea44c64fc871', 'SmallPairLightAdaptiveLeft11_001Part02': 'b04e9d9e7b8eb374b46812ff3811ab637c8f9ef2320214c5bb93ff36b3aa6c3a', 'SmallPairLightAdaptiveLeft11_001Part03': '9b48b0f37933876e34461fca92ef8cfda59a4e1fee5911b0766abc83b46f1910', 'SmallPairLightAdaptiveRight11_000': '345b655110266d84174a44019519df7181f139a815a8ba45e146b77eba65a313', 'SmallPairLightAdaptiveRight11_000Part00': '8facdd924e0aa2ab88bb9e8535873ab3a1025ff73ef9d8ff40257889796be97c', 'SmallPairLightAdaptiveRight11_000Part01': '81084b253b5cf5c6fa1fca1b407ee92a0e2212218b84621131575db6f4848f18', 'SmallPairLightAdaptiveRight11_000Part02': 'a8b296a5abab11995398c02cc33e94445399ad0bf18ddbf793cc76405f42d90d', 'SmallPairLightAdaptiveRight11_000Part03': '30d21eebdba73d18935613bacd2a5d96446d94c9099198c394d7a0412e2aabb8', 'SmallPairLightAdaptiveRight11_000Part04': 'e0e49188a9cfcd81905b4bd45c800e8a9f45ff0047225ce23fd9baffdcdfda63', 'SmallPairLightAdaptiveRight11_000Part05': '4e1a9bded087196aff74c1c42342f1f15ca99c99e6d65a6dd8e5eb95859baa43', 'SmallPairLightAdaptiveRight11_001': '8c88ce90d8eb4e15cd3ac29c497f37412528186fa4c16c475226157893511a86', 'SmallPairLightAdaptiveRight11_001Part00': '4d8668162c61d57e74b08e2482a65de8b650d98c9128c831f3ca74d4abdd21c8', 'SmallPairLightAdaptiveRight11_001Part01': '375f9a9c122f31bce2153f3980ee91cba3f6d9ff947c209a04891f385c20e440', 'SmallPairLightAdaptiveRight11_001Part02': '72b231644a4d301512bc5c1ea9342dd057452e9cdcfa58951368eb7d28116582', 'SmallPairLightAdaptiveRight11_001Part03': '5df613aa1174ccf3776a5702b8c77b585b6576312931bdf66dcdb538e9888ae9', 'SmallPairLightLeft11': '489527f7b8484c8f8728064ca717191d6b89face009aaf1df34cbfc9e6cbe814', 'SmallPairLightRight11': 'df0aa3ffd451b6c69d6a0e6fa43c3aa3da6cc1230bb0bc3d8ebde46d49ba607b'}
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
