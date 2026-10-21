"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PINS = {'SmallPairGraphInputs48': 'b5a04c7b1aa5d377ec08e976ebcefd4f1729f0e3ae979bcb64fddd41b60c793a', 'SmallPairGraphArithmetic48': 'e6244101e338a3e2941a187afc7d87015a68a1d81020bdd3e34df785c575e237', 'SmallPairGraphWitnessData48': 'abe44b11257879f82ce8180c0b3eec5ec07fe33413020aa84ae0863a631ef53b', 'SmallPairGraphClosure48Chunk00': 'f41c6d549f33c08ff1a2828fad1012fa6593d8a662c9c193849058b8527b0009', 'SmallPairGraphClosure48Chunk01': '44f3e32e907573b9fbb393209ff42addddcb2b05ddad6df63652d9bda16314b8', 'SmallPairGraphClosure48Chunk02': '5084a60bcaf999047cd33c13e93259a3b8edb9625bdc01953dd00ed1f0ddeb3e', 'SmallPairGraphClosure48Chunk03': '9b15107a2ba5c0f7af11208d0c7a5d9f215b1fb45d58b8aa06b580517a0f5c01', 'SmallPairGraphClosure48Chunk04': 'b606fd1fed0841d24bacc6b591be03ce5996859fff66ef7d98fec58be6082626', 'SmallPairGraphClosure48Chunk05': 'af5331d00cb735bca4495a5fba307cf94687567216c0a047256b7a7fd9a3e197', 'SmallPairGraphClosure48Coverage': 'cf547bf730123feb39f681d5a24fa79be0441f9efa99e2fe1672ec6e23f4d1e6', 'SmallPairGraphClosure48': '198676a6be372a21196ef6cfa12f60b7daffa7cfb63ec70651488a558130e6f8', 'SmallPairRawSelectedData48': '2cfece920a14fa90dde0b1a7f4ea89944f0bc4f6069847e1d1dab698fa946be6', 'SmallPairLightAssembly48': 'cbece2e752376f1748b5f5e76f355572d81d9117b4233dcc85b4e0f49ce687fe', 'SmallPairGraphTriangle48': 'd0b8c096f827eae465c69849ba3a3f886f328b3e9cb72bc1d1658259d473cdaf', 'SmallPairGraphData48': '67117dadd435e7aefd827e1b26d6d38f784f8dbe813c3ee40ae5bd5d1f6da2eb'}
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
