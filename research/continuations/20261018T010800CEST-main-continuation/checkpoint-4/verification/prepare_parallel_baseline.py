"""Capture existing accepted source/artifact provenance after the serial stop."""
from pathlib import Path
import hashlib
import importlib.util
import json
import subprocess
import sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT/'research/continuations/20261018T010800CEST-main-continuation'
sys.path.insert(0, str(RUN))
from continuation_driver_parallel import Driver, atomic_json, fingerprint, utc

def git(*args):
    return subprocess.run(['git', *args], cwd=ROOT, check=True,
                          text=True, capture_output=True).stdout.strip()

assert git('rev-parse', 'HEAD') == 'b69d073ef5fb99dc9a4d62d47efc12e92e9c66da'
assert not git('diff', '--name-only')
assert not git('diff', '--cached', '--name-only')
assert json.loads((RUN/'continuation-active.json').read_text()).get('status') == 'BETWEEN_BUILDS'
driver = Driver(ROOT, RUN)
tracked = {Path(p).stem for p in git('ls-files', 'D1Bound5').splitlines() if p.endswith('.lean')}
latest = driver.latest()
names = tracked | {row['name'] for row in driver.rows}
accepted = {}
for name in sorted(names):
    closure = driver.closure(name)
    key = fingerprint(closure)
    row = latest.get((name, key))
    if row is not None and not row.get('accepted_build', False):
        continue
    if name not in tracked and not (row and row.get('accepted_build', False)):
        continue
    artifacts = driver.artifacts(name)
    assert '.lake/build/lib/lean/D1Bound5/'+name+'.olean' in artifacts, name
    accepted[name] = {'fingerprint': key, 'artifacts': artifacts,
        'provenance': 'accepted-root unchanged at '+git('rev-parse','HEAD') if name in tracked
                      else 'successful exact-source serial build '+row['log']}
baseline = {'utc': utc(), 'scope': 'Scheduling trust only; no new main-theorem acceptance',
            'accepted': accepted}
atomic_json(RUN/'continuation-trusted-baseline.json', baseline)
print(json.dumps({'trusted_modules': len(accepted), 'tracked_baseline':len(tracked),
                  'artifact_bytes':sum((ROOT/p).stat().st_size for a in accepted.values() for p in a['artifacts'])}))
