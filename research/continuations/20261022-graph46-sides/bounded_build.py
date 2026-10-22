"""One bounded guarded target in the existing Mac tree; no Git or queue changes."""
from pathlib import Path
from contextlib import contextmanager
import fcntl, hashlib, importlib.util, json, os, signal, subprocess, sys, time

ROOT = Path('/Users/tp/Lean/D1Bound5')
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
DRIVER_SHA = 'df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
PREPARE_SHA = '3aa342d01909e40c9fccc576e59db5a836606aac4a1cf45ecac65e25ec39eb34'
PINS = {'SmallPairLightAdaptiveLeft46_000': '380c7dc6a60d9ae7dca3f4f36b4f51475b8794d300bf0a55c96a71cbdc5caf65', 'SmallPairLightAdaptiveLeft46_000Part00': '66ce7a36ac8f973813419cf810f374fe6775edaab370f382abd4a7a52984714c', 'SmallPairLightAdaptiveLeft46_000Part01': '2a933b2b9515ad79c0724ba0ecf0c0b5ddc132cc45e978471e85927e35a74f41', 'SmallPairLightAdaptiveLeft46_000Part02': 'cf0d7aa86854c4e1a45b2ce3968e8c94a3781bf6c0b7abe271b2ad6471aa2f85', 'SmallPairLightAdaptiveLeft46_000Part03': '8bd62df93ec2f296a1c94e835924714d03c2c94c8b100eabd377f5c153825122', 'SmallPairLightAdaptiveLeft46_000Part04': 'abfcb0567959f973ba953eeb54484a8a85f5b681cf355ba438ff90b1f13cc87f', 'SmallPairLightAdaptiveLeft46_000Part05': '51bebc004aec7a0f33677d28187845e45de0fb3ee718fdd100a57e6f2fde0d38', 'SmallPairLightAdaptiveLeft46_001': '53fcefbac060778d76cd3a0ec795a4b7706f12fac4304f4ad763959f7803865d', 'SmallPairLightAdaptiveLeft46_001Part00': '200ca375cd989ba41abb2519f27f82b3c7a233d58ddfee23fac007ad5a65b346', 'SmallPairLightAdaptiveLeft46_001Part01': 'ba1aeb42b1d3018bcbfaada8ac4db9b56970023423f5d08ba7d03b0b9fcbac77', 'SmallPairLightAdaptiveLeft46_001Part02': '216500c4c3ef200ce1c8f9ccb854ecddf96c55627eecca314b2e986e59d7291b', 'SmallPairLightAdaptiveLeft46_001Part03': '3eb0ca94942d8fcba0982e9decd43f8a82d85878edaafcc7bbb447066a761bc1', 'SmallPairLightAdaptiveRight46_000': '74b78f8a14dc34d5a45569f136bdf3bb72bc92de5438f047d527bdcfebd7583d', 'SmallPairLightAdaptiveRight46_000Part00': '436d4d23ebb96a2bd5949482fd9abda5d9932dec6ebb68c3293e1222b5a5bccc', 'SmallPairLightAdaptiveRight46_000Part01': '30dc3bb12ac31a5a923a46b19d10ff747e290a03bfa820aff74a60ecc5f6baa5', 'SmallPairLightAdaptiveRight46_000Part02': 'b9ae5d5a0c71acaf3d083e5d139f9f39c7cd9bd6f424c43c941895937f3b91ff', 'SmallPairLightAdaptiveRight46_000Part03': '3dc9103ec363097c2fe02cb5a1f85911d309e448a057265666d5cbdc25ce21d4', 'SmallPairLightAdaptiveRight46_000Part04': 'ffd81fd1c6283471e43116a9b37be4a6260bf8bc0c7620392c353c5e1b928442', 'SmallPairLightAdaptiveRight46_000Part05': '32665e265709b538f8a241a50267301ff628b8787513d2f08737b6f1df679922', 'SmallPairLightAdaptiveRight46_001': 'a868cddbc4770670c4125016886a5df3cf9fb2e3cab453def24500d0af800a52', 'SmallPairLightAdaptiveRight46_001Part00': 'b96fb556175990d5a50b7fd3d496b0b18e4fe7c11901293d6665456ad2588efe', 'SmallPairLightAdaptiveRight46_001Part01': '83b8b10226322d325cb2e6b68045490a70ea2519d5ac6ec7879e017413f85912', 'SmallPairLightAdaptiveRight46_001Part02': '9afec232e51c681a47cdbce80596ae42313d638523c9c79a8006b64d976e2438', 'SmallPairLightAdaptiveRight46_001Part03': '073bcfff0d6586d2670bdd159014e8792ba68cd3f2c3b263744c7f3a8ad0c136', 'SmallPairLightLeft46': '1f83b52da398d7859b2344f560660efce4764f16abde756d5407b114342d3f4f', 'SmallPairLightRight46': '739c702ff1f9840879a27681847c112e22b302f45be3cd1ea64e1144781104cd'}
if not __debug__:
 raise RuntimeError('Do not disable verification assertions')
os.environ['LEAN_NUM_THREADS'] = '1'
name = sys.argv[1]
assert name in PINS, 'Unreviewed target'
assert OUT == ROOT / 'research/continuations/20261022-graph46-sides'
foundation_binding_path = OUT / 'REVIEWED_FOUNDATION_BINDING.json'
foundation_binding_bytes = foundation_binding_path.read_bytes()
foundation_binding = json.loads(foundation_binding_bytes)
assert foundation_binding['status'] == 'REVIEWED_FOUNDATION_BINDING'
assert foundation_binding['graph'] == 46
install_plan = json.loads((OUT / 'PLAN.json').read_bytes())
installation = json.loads((OUT / 'INSTALL_RECEIPT.json').read_bytes())
assert install_plan['source_manifest'] == installation['source_manifest'] == PINS
assert install_plan['reviewed_foundation_binding_sha256'] == installation['reviewed_foundation_binding_sha256'] == hashlib.sha256(foundation_binding_bytes).hexdigest()
assert install_plan['base_commit'] == foundation_binding['base_commit']
checks_path = OUT / 'prepare_checks.py'
assert hashlib.sha256(checks_path.read_bytes()).hexdigest() == PREPARE_SHA
sys.dont_write_bytecode = True
checks_spec = importlib.util.spec_from_file_location('graph46_bounded_source_checks', checks_path)
checks = importlib.util.module_from_spec(checks_spec)
sys.modules[checks_spec.name] = checks
checks_spec.loader.exec_module(checks)
assert checks.O == OUT and checks.R == ROOT
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
 checks.no_live_project_compiler()

with (WORK / 'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner, fcntl.LOCK_EX | fcntl.LOCK_NB)
 try:
  with intake():
   assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip() == install_plan['base_commit']
   assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=ROOT)
   assert foundation_binding_path.read_bytes() == foundation_binding_bytes
   assert checks.verify_installation(driver) == (install_plan, installation)
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
   if name not in checks.SCOPES['sides-pilot']:
    checks.verify_pilots(driver, mod, latest)
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
