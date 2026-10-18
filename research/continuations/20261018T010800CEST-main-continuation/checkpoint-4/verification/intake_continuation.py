"""Copy an explicitly named draft intake and record its exact source hashes.

This is serial orchestration tooling, not part of the mathematical proof.
The running compiler's dependency closure is protected against modification.
"""
from pathlib import Path
import base64
import gzip
import fcntl
import os
import datetime
import hashlib
import json
import re
import sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
name = sys.argv[1]
assert re.fullmatch(r'wave[0-9]+', name)
sources = json.loads((RUN / (name + '-intake.json')).read_text())
if isinstance(sources, dict) and sources.get('encoding') == 'gzip-base64':
    assert set(sources) == {'encoding', 'data'}
    sources = json.loads(gzip.decompress(base64.b64decode(sources['data'], validate=True)))
assert all(re.fullmatch(r'[A-Za-z0-9_]+\.lean', n) for n in sources)
with (RUN / 'continuation-intake.lock').open('a+') as lock:
    fcntl.flock(lock, fcntl.LOCK_EX)
    active = json.loads((RUN / 'continuation-active.json').read_text()).get('closure', {})
    changed = {n: s for n, s in sources.items()
               if not (ROOT / 'D1Bound5' / n).exists()
               or (ROOT / 'D1Bound5' / n).read_text() != s}
    assert not set(active) & {Path(n).stem for n in changed}, 'Active dependency would change'
    missing = {x for s in sources.values()
               for x in re.findall(r'^import D1Bound5\.([A-Za-z0-9_]+)\s*$', s, re.M)
               if x + '.lean' not in sources and not (ROOT / 'D1Bound5' / (x + '.lean')).exists()}
    assert not missing, missing
    for n, s in changed.items():
        (ROOT / 'D1Bound5' / n).write_text(s)
    queue_path = RUN / 'continuation-queue.json'
    queue = json.loads(queue_path.read_text())
    held = set(sys.argv[2:])
    for n in sources:
        stem = Path(n).stem
        if stem not in queue['names'] and stem not in held:
            queue['names'].append(stem)
    queue_temp = queue_path.with_name(queue_path.name+'.intake.'+str(os.getpid()))
    queue_temp.write_text(json.dumps(queue, indent=2))
    os.replace(queue_temp, queue_path)
    receipt = {'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
               'source_sha256': {n: hashlib.sha256(s.encode()).hexdigest() for n, s in sources.items()},
               'changed': list(changed), 'held': sorted(held), 'queue_count': len(queue['names'])}
    (RUN / (name + '-receipt.json')).write_text(json.dumps(receipt, indent=2))
    print(json.dumps({'changed': list(changed), 'held': sorted(held), 'queue_count': len(queue['names'])}))
