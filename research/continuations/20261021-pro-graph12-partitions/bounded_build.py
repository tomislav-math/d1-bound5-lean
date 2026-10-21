"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairLightAdaptiveLeft12_000Part00': 'e0d473db134653a332dcf03d93fb17a68ad5e04729ab7623729f0a98fc5e9369', 'SmallPairLightAdaptiveLeft12_000Part01': '7784693cbdeeddf6ebc854d21c5e7bfc83ca97a6afb0a33bfb780f02fa42baab', 'SmallPairLightAdaptiveLeft12_000Part02': 'fcb71753e58b5d8e468a9bf1826a5097b6a161e8d933defaa68040b0c73ef3a1', 'SmallPairLightAdaptiveLeft12_000Part03': '774efc7fab224054c12194fbd0287bc726150cf1c64ce671bd14392b67b7db61', 'SmallPairLightAdaptiveLeft12_000Part04': '2d0324871c52c884a604583c44c089877355c02c62ce4cf53f9c3f66765cb88a', 'SmallPairLightAdaptiveLeft12_000': 'e14c1ab88077cd9f572dd6a02da476762fb54a3e71a5b5eb98b6f3bd7e7bd8ef', 'SmallPairLightAdaptiveLeft12_001Part00': 'f76a6077b233d36bf0c1a409641fcbe2762e667af3956176086521c1f7f7bd81', 'SmallPairLightAdaptiveLeft12_001Part01': '3070f20bc146fa75793007fd98e2d21f27d672a382b9715d17b53302f4ac5f71', 'SmallPairLightAdaptiveLeft12_001Part02': '935636b361098ea8862298af87255caefdb0bf0512a87fefb903ebca17aab579', 'SmallPairLightAdaptiveLeft12_001': '695b77eff85bbb00fae304cd7603f14c1e278d372f8e1f2fc93c31c9e974befa', 'SmallPairLightLeft12': 'e3689d767b8df39c808a0b38cb0215411821c77ab4eb96e105aca835bdef82b2', 'SmallPairLightAdaptiveRight12_000Part00': '9b5508ca2182c11238e830c28659465e35d280298430fa0dd137b07004b0b244', 'SmallPairLightAdaptiveRight12_000Part01': '2bd994aafc2985a8c65739f8cbec6ff1715918a25c85195d0fc33a3aeacffb94', 'SmallPairLightAdaptiveRight12_000Part02': 'ad12003dca4b9ed698d309b80baccf5bb551e7f7e3990f502212cce5580b73be', 'SmallPairLightAdaptiveRight12_000Part03': '92a1675e28060bffed0c0ac1d066419f3f200d0408ab056683d80e4c4a971b26', 'SmallPairLightAdaptiveRight12_000Part04': '736f5724350e46870f4093e7141f6a3e1bfd26382761b46a7c78b1a88394365e', 'SmallPairLightAdaptiveRight12_000': 'a92c6db7bdb6502ecd261da04e876820fc45eb931d43f03cdac142ff6b25d989', 'SmallPairLightAdaptiveRight12_001Part00': '49380a6d7ad1fa8f3b2e37cfb911c396e1b6a7eb3605ebb9274d4f8bbe6cc19e', 'SmallPairLightAdaptiveRight12_001Part01': 'f264766836e996ff35ed862eaa19be3835cbede5e26fcc2ff1bad4b2206bd4f1', 'SmallPairLightAdaptiveRight12_001Part02': '878426ee53f013c31060b802bbfbef7aff1fd0f7e52f8676ac5e8b289582cc25', 'SmallPairLightAdaptiveRight12_001': 'c63e2a41eb30a3fe43d057aaadb19b3baf70cf73e744a85513fd1c79f59af18a', 'SmallPairLightRight12': '9481d050dc603cfe16089466e0ecaf987df9ca463c022a0d0668a301b723cb7c'}
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
