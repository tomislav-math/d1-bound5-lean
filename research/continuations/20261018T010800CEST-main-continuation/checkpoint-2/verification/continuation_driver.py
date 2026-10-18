"""Serial Lean continuation builder, with source/dependency fingerprints.

Run only after all other owned compiler jobs have finished. The editable queue
is reloaded between builds; a failed fingerprint is not retried unchanged.
This is verification tooling, never imported by the mathematical development.
"""
from pathlib import Path
import datetime
import hashlib
import json
import re
import subprocess
import time

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
QUEUE = RUN / 'continuation-queue.json'
STATE = RUN / 'continuation-builds.json'
ACTIVE = RUN / 'continuation-active.json'
LOGS = RUN / 'continuation-builds'
LOGS.mkdir(exist_ok=True)


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def read_source(name):
    p = ROOT / 'D1Bound5' / (name + '.lean')
    return p.read_bytes()


def source_closure(name, seen=None):
    seen = {} if seen is None else seen
    if name in seen:
        return seen
    data = read_source(name)
    seen[name] = hashlib.sha256(data).hexdigest()
    for dep in re.findall(rb'^import D1Bound5\.([A-Za-z0-9_]+)\s*$', data, re.M):
        source_closure(dep.decode(), seen)
    return seen


def fingerprint(closure):
    return hashlib.sha256(json.dumps(closure, sort_keys=True).encode()).hexdigest()


rows = json.loads(STATE.read_text()) if STATE.exists() else []
while True:
    queue = json.loads(QUEUE.read_text())
    names = queue['names']
    if queue.get('pause_after_current', False):
        print(json.dumps({'status': 'PAUSED', 'utc': now()}), flush=True)
        break
    closures = {n: source_closure(n) for n in names}
    keys = {n: fingerprint(closures[n]) for n in names}
    latest = {(r['name'], r['fingerprint']): r for r in rows}
    eligible = []
    for n in names:
        if (n, keys[n]) in latest:
            continue
        deps = (set(closures[n]) - {n}) & set(names)
        if all(latest.get((d, keys[d]), {}).get('accepted_build', False) for d in deps):
            eligible.append(n)
    if not eligible:
        unresolved = [n for n in names if not latest.get((n, keys[n]), {}).get('accepted_build', False)]
        print(json.dumps({'status': 'NO_ELIGIBLE_TARGET', 'unresolved': unresolved,
                          'utc': now()}), flush=True)
        break
    name = eligible[0]
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    stem = name + '-' + stamp
    closure = closures[name]
    (LOGS / (stem + '.sources.json')).write_text(json.dumps(closure, indent=2, sort_keys=True))
    (LOGS / (stem + '.lean')).write_bytes(read_source(name))
    active = {'name': name, 'started_utc': now(), 'closure': closure,
              'fingerprint': keys[name], 'log': str(LOGS / (stem + '.log'))}
    ACTIVE.write_text(json.dumps(active, indent=2))
    print(json.dumps({'status': 'BUILDING', **active}), flush=True)
    started = time.monotonic()
    with (LOGS / (stem + '.log')).open('w') as log:
        result = subprocess.run(['/Users/tp/.elan/bin/lake', 'build', 'D1Bound5.' + name],
                                cwd=ROOT, stdout=log, stderr=subprocess.STDOUT)
    unchanged = source_closure(name) == closure
    row = {'name': name, 'fingerprint': keys[name], 'source_sha256': closure[name],
           'exit': result.returncode, 'closure_unchanged': unchanged,
           'accepted_build': result.returncode == 0 and unchanged,
           'seconds': time.monotonic() - started, 'utc': now(), 'log': active['log']}
    rows.append(row)
    STATE.write_text(json.dumps(rows, indent=2))
    ACTIVE.write_text(json.dumps({'status': 'BETWEEN_BUILDS', 'utc': now()}))
    print(json.dumps(row), flush=True)
    if result.returncode:
        lines = (LOGS / (stem + '.log')).read_text().splitlines()
        errors = [i for i, s in enumerate(lines) if s.startswith('error:')]
        keep = set()
        for i in errors:
            keep.update(range(i, min(i + 22, len(lines))))
        print('\n'.join(lines[i] for i in sorted(keep))[-24000:], flush=True)
