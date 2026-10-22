"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairGraphInputs11': 'b499ddc749baceb1300d759c8918a3d970ddfbde887995663c13d3e413715a69', 'SmallPairGraphWitnessData11': 'c142d7a8063d6c09c6a5c9423cd9f992bfdbdc5c3052c136f7da5f3d5974ac0f', 'SmallPairGraphClosure11Chunk00': 'd763ce1f0bdd52ae8b40e2dcdff5112d8cebb2ce31a9deaaae27610387dab483', 'SmallPairGraphClosure11Chunk01': '8eed0f2f2f46694f0da5bb5d8d0070f21f8c360e1bf7ac005988843421095e15', 'SmallPairGraphClosure11Chunk02': 'e9970f1cc66c9d299ab3004a0fea281cf5529b0869cff589c7e0346d04a04e9b', 'SmallPairGraphClosure11Chunk03': '362906f9faa4c2417a78e5b759ba2b2f9bf0858f1e939712b97d0ac693562aec', 'SmallPairGraphClosure11Chunk04': '8047cbe28d668f43afe9c91cf0002e6d7eda1cfe75a89f8166e8530fcda36667', 'SmallPairGraphClosure11Chunk05': '6f931a2228495b9ad9f436f9a2cd1da7b548806c606dc7ed9c052811f343db12', 'SmallPairGraphClosure11Chunk06': '8472768d682109ddb1d4d23313c75b962b3bd6856d4cc1bae1e8181bbbbc84fa', 'SmallPairGraphClosure11Chunk07': '0e0ad0a215885541bf04cf72954c038dc3e32ab859334573c8ecac2a44085993', 'SmallPairGraphClosure11Chunk08': 'b21265f83622bd69f55d4e89ad0b11a07f4aba13d61a4ab051259c820172187b', 'SmallPairGraphClosure11Chunk09': '926d455ff00022c2ccaa0788d2848efcd84d9cc1556c9ae1e43f6d578602ff6f', 'SmallPairGraphClosure11Chunk10': '6fe4d2a52c439cf29ab2b0f27bb542f800ef4ece32d53d6c48b1afcd4749fa81', 'SmallPairGraphClosure11Chunk11': '0fc3e7090a5b5572a94f77056d4048c82bfcebc246c22cd54121602a35dc8015', 'SmallPairGraphClosure11Coverage': '7bc47e349845f51fdca070a1ae349e8e36f2d260b39a84fea6ee96127ffc5170', 'SmallPairGraphClosure11': '07e7bbd6da02ee4d9003fa0926ed74dead2a79cca9a0031f674b2e1ed3ba933a', 'SmallPairGraphArithmetic11': '364875a34ed5bd9637ca968a549dadc1fb5a5e775dc46c04000fe048f6339b2e', 'SmallPairRawSelectedData11LeftCached': '6e24b4aa220f152aa999d7365bddc3c6ebedc48a89c222d8aae40bbcec2c8593', 'SmallPairRawSelectedData11LeftRows': '2343003b838df3fa3b9888784c6b1f48037bff5feb9f4929a683977111e612c6', 'SmallPairRawSelectedData11RightCached': '8906413018ed33a8f80fdc964f28db7a1efa878ea797abf65f28cc9eac099ed3', 'SmallPairRawSelectedData11RightRows': '81524b06d6949fa0bdaad7bdbfaf8fe3b9d6f111069ef8244e63add0351ab764', 'SmallPairRawSelectedData11': '360b65e8fa8704f8d2184f3c0ce49163dd7b020a0dd5401def3cb7d601b0c02e', 'SmallPairLightAssembly11': 'e7005de29879d0c1f756e05b4ab6bb8008ac22743be8e6172cf5d11c233a7754', 'SmallPairGraphTriangle11': 'a31c3280b282b485f572eb3570e8e7f8b8a1e4d6551127d6471c702d3a0ea251', 'SmallPairGraphData11': 'b863c7932bb1f5edd3af3df7a1a006b06aaea8d7b007c52b475ad99185e99797'}
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
