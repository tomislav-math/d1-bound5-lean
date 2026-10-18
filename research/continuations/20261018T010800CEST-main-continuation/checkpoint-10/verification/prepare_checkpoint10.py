"""Prepare the tenth unaccepted research delta; never commit or push.

The coordinator must review this script before running it on the authorized
Mac. Runtime state and source bytes are captured under the intake lock. The
lock is released before writing the snapshot. Later compiler progress does
not change this explicitly dated view. Only terminal ledger logs are copied.
"""
from pathlib import Path, PurePosixPath
import ast
import base64
import datetime
import fcntl
import gzip
import hashlib
import json
import os
import re
import subprocess

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
DEST = RUN / 'checkpoint-10'
WORK = RUN / ('checkpoint-10-preparing-' + str(os.getpid()))
HEAD = '0d107611364a193651e5e895d2675d31766eee3a'
RECORD = ROOT / 'records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-10.md'
REVIEWED = RUN / 'checkpoint-10-reviewed-paths.json'
FROZEN_PAPER = Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex')
PAPER_SHA = '776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def git(*args):
    return subprocess.run(['git', *args], cwd=ROOT, check=True,
                          capture_output=True, text=True).stdout.strip()


def relative_name(name):
    assert isinstance(name, str) and name, repr(name)
    p = PurePosixPath(name)
    assert not p.is_absolute() and '..' not in p.parts and str(p) == name, name
    assert not any(ord(c) < 32 for c in name), repr(name)
    return Path(name)


def stable_read(path):
    """Reject a file that changes during this individual read."""
    assert path.is_file() and not path.is_symlink(), str(path)
    before = path.stat()
    data = path.read_bytes()
    after = path.stat()
    signature = lambda s: (s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns)
    assert signature(before) == signature(after) and len(data) == after.st_size, str(path)
    return data


assert not DEST.exists() and not WORK.exists() and not RECORD.exists() and not REVIEWED.exists()
assert git('rev-parse', 'HEAD') == HEAD
assert not git('diff', '--name-only') and not git('diff', '--cached', '--name-only')
assert sha(stable_read(FROZEN_PAPER)) == PAPER_SHA

required_runtime = [
    'continuation_driver_parallel.py', 'continuation_driver_parallel_REVIEW.md',
    'continuation_driver_parallel_dummy_test.py', 'continuation-builds.json',
    'continuation-active.json', 'continuation-queue.json',
    'continuation-trusted-baseline.json', 'prepare_checkpoint10.py', 'stage_checkpoint10.py',
    'checkpoint-9-push-receipt.json', 'checkpoint-9-index-review.json',
    'analytic-pell-priority.json', 'analytic-repairs-wave72.json', 'analytic-repairs-wave73.json',
    'literal34-preparation.json', 'literal34-review.json',
    'literal34-pilot-priority.json', 'literal34-pilot-intake-priority.json',
    'prepared-literal34/manifest.json', 'prepared-literal34-integration/manifest.json',
    'prepared-compact43-dry/manifest.json', 'lean-process-inventory.json',
    'import-repairs-wave76.json', 'selected34-preparation.json',
    'selected34-pilot-priority.json', 'prepared-selected34/manifest.json',
]

# The lock already belongs to the continuation protocol. Do not alter its bytes.
with (RUN / 'continuation-intake.lock').open('r+b') as lock:
    fcntl.flock(lock, fcntl.LOCK_EX)
    try:
        assert git('rev-parse', 'HEAD') == HEAD
        assert not git('diff', '--name-only') and not git('diff', '--cached', '--name-only')
        source_names = sorted(name for name in
            git('ls-files', '--others', '--exclude-standard', 'D1Bound5').splitlines()
            if name.endswith('.lean'))
        assert source_names
        for name in source_names:
            p = relative_name(name)
            assert p.parent == Path('D1Bound5'), name
        # Capture all local Lean modules for exact closure fingerprints, including
        # tracked accepted prerequisites; only untracked drafts enter SOURCE_MAP.
        source_bytes = {p.stem: stable_read(p) for p in sorted((ROOT / 'D1Bound5').glob('*.lean'))}
        old_map_bytes = stable_read(RUN / 'checkpoint-9/SOURCE_MAP.json')
        helpers_packet = stable_read(RUN / 'checkpoint10-helpers.json')
        waves = sorted(p.name for p in RUN.glob('wave*.json')
                       if re.fullmatch(r'wave\d+-(?:intake|receipt)\.json', p.name)
                       and int(re.search(r'\d+', p.name)[0]) >= 72)
        for number in range(72, 78):
            for kind in ('intake', 'receipt'):
                assert f'wave{number}-{kind}.json' in waves
        runtime_names = sorted(set(required_runtime + waves))
        runtime_bytes = {name: stable_read(RUN / relative_name(name)) for name in runtime_names}
        stamp = datetime.datetime.now(datetime.timezone.utc).isoformat()
    finally:
        fcntl.flock(lock, fcntl.LOCK_UN)

ledger = json.loads(runtime_bytes['continuation-builds.json'])
active_state = json.loads(runtime_bytes['continuation-active.json'])
queue = json.loads(runtime_bytes['continuation-queue.json'])
assert isinstance(ledger, list) and isinstance(active_state, dict) and isinstance(queue, dict)
assert all(isinstance(row, dict) and 'name' in row and 'fingerprint' in row for row in ledger)
old_rows = json.loads(old_map_bytes)['sources']
old = {row['source']: row for row in old_rows}
assert len(old) == len(old_rows)

# Match the coordinator's closure fingerprint algorithm without importing or
# executing its driver. This reports receipt status, not a fresh kernel replay.
IMPORT_LINE = re.compile(rb'^\s*import\s+([^\n]+)', re.M)
IMPORT_NAME = re.compile(rb'\bD1Bound5\.([A-Za-z0-9_.]+)')
VALID_NAME = re.compile(r'^[A-Za-z0-9_]+$')


def closure(name, seen=None):
    assert VALID_NAME.fullmatch(name), name
    seen = {} if seen is None else seen
    if name in seen:
        return seen
    data = source_bytes[name]
    seen[name] = sha(data)
    for line in IMPORT_LINE.findall(data):
        line = line.split(b'--', 1)[0]
        deps = IMPORT_NAME.findall(line)
        assert b'D1Bound5' not in line or deps, name
        for dep in deps:
            closure(dep.decode(), seen)
    return seen


current_receipts = {(row['name'], row['fingerprint']): row for row in ledger}
latest_receipts = {row['name']: row for row in ledger}
active_jobs = active_state.get('active', [])
assert isinstance(active_jobs, list)
active_by_name = {row['name']: row for row in active_jobs}
active_logs = {row['log'] for row in active_jobs if row.get('log')}


def status(name):
    latest = latest_receipts.get(name)
    if name not in source_bytes:
        return {'module': name, 'status': 'source not present in this snapshot',
                'latest_terminal_receipt': latest}
    deps = closure(name)
    key = sha(json.dumps(deps, sort_keys=True).encode())
    receipt = current_receipts.get((name, key))
    active = active_by_name.get(name)
    if active and active.get('fingerprint') == key:
        state = 'RUNNING at snapshot; no completion claim'
    elif receipt and receipt.get('accepted_build') is True:
        assert receipt.get('exit') == 0 and receipt.get('closure_unchanged') is True
        assert receipt.get('source_sha256') == deps[name]
        assert not receipt.get('timed_out', False) and not receipt.get('interrupted', False)
        state = 'PASS in terminal ledger at current closure fingerprint'
    elif receipt:
        state = ('TIMEOUT' if receipt.get('timed_out') else
                 'INTERRUPTED' if receipt.get('interrupted') else 'FAILED')
    else:
        state = ('PENDING; no terminal receipt for current closure fingerprint'
                 if name in queue.get('names', []) else
                 'UNVERIFIED; no terminal receipt for current closure fingerprint')
    return {'module': name, 'status': state, 'source_sha256': deps[name],
            'closure_fingerprint': key, 'closure_modules': len(deps),
            'current_terminal_receipt': receipt, 'latest_terminal_receipt': latest,
            'active_at_snapshot': active is not None}


targets = [
    'MainTheorem', 'SmallPairGraphData16', 'SmallPairGraphData22', 'SmallPairGraphData41',
    'SmallPairGraphClosure34', 'SmallPairGraphLeft34', 'SmallPairGraphData34',
    'SmallPairLiteralCachedData34', 'SmallPairLiteralLeft34', 'SmallPairLiteralRight34',
    'PairSelectedCachedMask', 'PairSelectedFloorWitnesses', 'PairCachedFloorChunks',
    'PairSelectedFloorChunks', 'SmallPairSelectedData34',
    'SmallPairSelectedLeft34', 'SmallPairSelectedRight34',
    'QuadSquareFloorObstruction', 'PairCachedFloorWitnesses',
    'UnitPairAxes', 'UnitPairSymmetric', 'EisensteinPellDescent',
    'FiniteClosedWindow', 'FrontierScalarReduction',
]
statuses = [status(name) for name in targets]
assert not statuses[0]['status'].startswith('PASS'), 'Main acceptance changed: review checkpoint wording'
status_report = {'utc': stamp, 'meaning': 'Frozen terminal-ledger/source/queue snapshot; no fresh replay',
                 'modules': statuses}

WORK.mkdir()


def put(name, data):
    rel = relative_name(name)
    target = WORK / rel
    assert not target.exists(), str(target)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)


rows = []
for name in source_names:
    data = source_bytes[Path(name).stem]
    previous = old.get(name)
    if previous and previous['sha256'] == sha(data):
        prior = ROOT / relative_name(previous['stored_at'])
        assert prior.resolve().is_relative_to(RUN.resolve())
        assert stable_read(prior) == data
        stored = previous['stored_at']
    else:
        rel = 'draft-delta/' + Path(name).name
        put(rel, data)
        stored = str((DEST / rel).relative_to(ROOT))
    rows.append({'source': name, 'stored_at': stored, 'bytes': len(data), 'sha256': sha(data)})
put('SOURCE_MAP.json', (json.dumps({'utc': stamp, 'sources': rows}, indent=2) + '\n').encode())

packet = json.loads(helpers_packet)
helpers = json.loads(gzip.decompress(base64.b64decode(packet['data'], validate=True)))
assert isinstance(helpers, dict)
for name, content in helpers.items():
    relative_name(name)
    assert isinstance(content, str), name
    put('helpers/' + name, content.encode())
for name, data in runtime_bytes.items():
    put('verification/' + name, data)
put('verification/CHECKPOINT_STATUS.json', (json.dumps(status_report, indent=2) + '\n').encode())

# Every log copied below belongs to a terminal ledger row captured above. Never
# copy a live compiler stream merely because it is present in the log directory.
parents = [RUN / f'checkpoint-{n}/verification/continuation-builds' for n in (9, 8, 7, 6, 5)]
parents += [RUN / 'checkpoint-4/addendum/verification/continuation-builds',
            RUN / 'checkpoint-4/verification/continuation-builds',
            RUN / 'checkpoint-3/verification/continuation-builds']
log_snapshots = []
for name in sorted({row['log'] for row in ledger if row.get('log') and row.get('exit') is not None}):
    assert name not in active_logs, 'Terminal log is also active: ' + name
    source = Path(name)
    assert source.parent == RUN / 'continuation-builds', str(source)
    data = stable_read(source)
    log_snapshots.append({'log': name, 'sha256': sha(data), 'bytes': len(data)})
    if any(p.is_file() and stable_read(p) == data for p in (base / source.name for base in parents)):
        continue
    put('verification/continuation-builds/' + source.name, data)
put('verification/TERMINAL_LOG_MAP.json', (json.dumps(log_snapshots, indent=2) + '\n').encode())

tree = ast.parse(stable_read(ROOT / 'scripts/source_audit.py').decode())
node = next(n for n in tree.body if isinstance(n, ast.FunctionDef) and n.name == 'remove_comments')
scope = {}
exec(compile(ast.Module(body=[node], type_ignores=[]), 'unchanged-stripper', 'exec'), scope)
forbidden = re.compile(r'\b(sorry|admit|sorryAx|axiom|unsafe|native_decide|implemented_by|extern)\b|\+native\b|debug\.skipKernelTC|Lean\.ofReduce|\brun_(tac|cmd|elab)\b')
for row in rows:
    assert not forbidden.search(scope['remove_comments'](source_bytes[Path(row['source']).stem].decode())), row['source']

table = '\n'.join('| ' + row['module'] + ' | ' + row['status'] + ' |' for row in statuses)
record_bytes = f'''# Main-theorem continuation: tenth research checkpoint

Captured {stamp}. **MainStatement remains UNPROVED.** The complete assembly is a research source artifact; its full dependency closure has not passed the required acceptance gates. The accepted root/configuration and historical 107-module verification baseline remain unchanged. This is a private research backup, with the manuscript hash pinned to the same frozen source.

The following status is derived from the captured terminal ledger, active-job receipt, queue and exact current source-closure fingerprints. A recorded PASS is not a fresh replay. A previous failed or timed-out hash is never promoted to acceptance of a replacement. Runtime files are a single dated view: a compiler job may complete after this capture without changing the statements below.

| Module | Status at capture |
| --- | --- |
{table}

The successful full consumer milestones for rows 16 and 41, the row 34 closure milestone, the old row 34 left-side timeout, and later row-22/literal/selected-backend progress can be checked individually in CHECKPOINT_STATUS.json and continuation-builds.json. No generated replacement or independently reviewed source is described as compiled without its matching terminal receipt. The earlier selected-backend wave-75 priority had no separate receipt; current priorities and any held literal-only jobs are represented by the captured queue and subsequent selected-row-34 priority record.

The exact source delta preserves the analytic repairs from waves 72 and 73, the literal-row-34 preparation, independent review and intake priority, selected-backend and import-repair sources through wave 77, the combined literal/selected-row-34 preparation, and the prepared compact-43 manifest. All later intake/receipt pairs present at capture are included too. The helper packet supplies reproducible local preparation and audit material. These generation and review artifacts do not prove Lean certificates.

The source map references unchanged exact drafts already stored in checkpoint 9 or earlier. Only terminal-ledger logs are considered, and byte-identical logs already stored in checkpoints 9, 8, 7, 6, 5, 4/addendum, 4 and 3 are not duplicated. Active compiler logs are excluded. Queue and active receipts are point-in-time snapshots, not completion receipts.

Every required concrete certificate, branch endpoint, full main closure, axiom audit and final same-kernel replay must still pass the coordinator's gates. No root integration or whole-root replay claim is made. Both scheduled tasks remain paused. This record is not a push receipt.
'''.encode()

files = []
for p in sorted(WORK.rglob('*')):
    if p.is_file():
        data = p.read_bytes()
        files.append({'path': str((DEST / p.relative_to(WORK)).relative_to(ROOT)),
                      'bytes': len(data), 'sha256': sha(data)})
files.append({'path': str(RECORD.relative_to(ROOT)), 'bytes': len(record_bytes), 'sha256': sha(record_bytes)})
manifest = {'utc': stamp, 'scope': 'UNACCEPTED RESEARCH DELTA',
            'previous_checkpoint_head': HEAD, 'files': files}
manifest_bytes = (json.dumps(manifest, indent=2) + '\n').encode()
put('MANIFEST.json', manifest_bytes)
files.append({'path': str((DEST / 'MANIFEST.json').relative_to(ROOT)),
              'bytes': len(manifest_bytes), 'sha256': sha(manifest_bytes)})
secret = re.compile(rb'gh[pousr]_[A-Za-z0-9_]{30,}|github_pat_[A-Za-z0-9_]{30,}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----')
assert not secret.search(record_bytes)
for p in WORK.rglob('*'):
    if p.is_file():
        assert not secret.search(p.read_bytes()), str(p)
assert git('rev-parse', 'HEAD') == HEAD
assert not git('diff', '--name-only') and not git('diff', '--cached', '--name-only')
assert sha(stable_read(FROZEN_PAPER)) == PAPER_SHA
assert not DEST.exists() and not RECORD.exists() and not REVIEWED.exists()

# Publish reviewed paths last. A crash before that point cannot produce a
# staging authorization for a partial snapshot.
WORK.rename(DEST)
RECORD.write_bytes(record_bytes)
REVIEWED.write_text(json.dumps([{'path': row['path'], 'sha256': row['sha256']} for row in files], indent=2) + '\n')
print(json.dumps({'utc': stamp, 'reviewed_files': len(files), 'bytes': sum(row['bytes'] for row in files),
                  'research_sources': len(rows), 'terminal_logs_considered': len(log_snapshots),
                  'scope': 'UNACCEPTED RESEARCH DELTA'}))
