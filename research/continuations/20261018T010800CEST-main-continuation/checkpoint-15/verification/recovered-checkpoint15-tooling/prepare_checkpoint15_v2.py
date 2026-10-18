"""Prepare the fifteenth unaccepted research delta; never commit or push.

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
import sys

assert sys.flags.optimize == 0 and sys.flags.dont_write_bytecode, "Use Python -B without optimization"

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
DEST = RUN / 'checkpoint-15'
WORK = RUN / ('checkpoint-15-preparing-' + str(os.getpid()))
HEAD = '323ce078b4626ba5165aef17364ac1755e29daf8'
FIRST_WAVE = 110
MINIMUM_LATEST_WAVE = 112
RECORD = ROOT / 'records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-15.md'
REVIEWED = RUN / 'checkpoint-15-reviewed-paths.json'
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
    assert path == FROZEN_PAPER or path.resolve().is_relative_to(ROOT.resolve()), str(path)
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
    'continuation_driver_parallel_dummy_test.py', 'intake_continuation.py',
    'continuation-builds.json', 'continuation-active.json', 'continuation-queue.json',
    'continuation-trusted-baseline.json', 'recovered-checkpoint15-tooling/prepare_checkpoint15.py',
    'recovered-checkpoint15-tooling/stage_checkpoint15.py',
    'recovered-checkpoint15-tooling/prepare_checkpoint15_v2.py',
    'recovered-checkpoint15-tooling/prepare_checkpoint15_v2.diff',
    'recovered-checkpoint15-tooling/prepare_checkpoint15_v2-authoring.json',
    'recovered-checkpoint15-tooling/prepare_checkpoint15_v2-review.json',
    'checkpoint-14-push-receipt.json', 'checkpoint-14-index-review.json',
    'prepare_light_rows_recovered.py', 'prepare_light47_bootstrap.py',
    'helper14-manifest.json', 'checkpoint-14-commit-receipt.json',
    'continuation_driver_capacity.py', 'continuation_driver_capacity_dummy_test.py',
    'continuation_driver_capacity_dummy_test_v2.py',
    'continuation-driver-capacity-review.json', 'continuation-driver-capacity-review-v2.json',
    'continuation-driver-capacity-python312-review.json',
    'driver-capacity-restart-receipt.json', 'capacity-pause-request.json',
    'adaptive-light45-preparation-receipt.json', 'adaptive-remaining38-40k-preparation.json',
]



def discover_runtime_names():
    """Capture current runtime metadata and prepared artifact manifests.

    Top-level runtime JSON (including later preparation/priority/review records)
    and prepared*/manifest JSON are in scope. Historical checkpoints, helper
    packets and old waves have their own frozen storage and are excluded here.
    New paired waves are added separately below with fail-closed completeness.
    """
    names = set(required_runtime)
    for path in RUN.glob('*.json'):
        name = path.name
        if name.startswith(('checkpoint', 'wave')):
            continue
        names.add(name)
    for path in RUN.glob('prepared*/*.json'):
        # Only manifests describe staged artifacts; payload Lean source is
        # captured separately from the actual project and helper packet.
        if path.name in {'manifest.json', 'source_manifest.before.json'}:
            names.add(str(path.relative_to(RUN)))
    # A successful final receipt establishes that both preparation logs are terminal.
    # Without it, do not snapshot possibly live preparation streams.
    if (RUN / 'light47-preparation-receipt.json').is_file():
        names.update({
            'light47-preparation-receipt.json',
            'light47-preflight.log', 'light47-emission.log',
            'light-scale-inputs138/materialization_manifest.json',
            'light47-manifest-preflight/manifest.json',
            'prepared-light47/manifest.json',
        })
    # Successful receipts establish terminal preparation logs. Their unaccepted
    # source packages are preserved separately in the exact archive, not helper JSON.
    names.update({
        'adaptive-remaining38-40k-dry.log', 'adaptive-remaining38-40k-emit.log',
        'prepared-adaptive-remaining38-40k-dry/manifest.json',
    })
    return names


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
        old_map_bytes = stable_read(RUN / 'checkpoint-14/SOURCE_MAP.json')
        helpers_packet = stable_read(RUN / 'checkpoint15-helpers.json')
        wave_files = {}
        for path in RUN.glob('wave*.json'):
            match = re.fullmatch(r'wave(\d+)-(intake|receipt)\.json', path.name)
            if match and int(match[1]) >= FIRST_WAVE:
                number = int(match[1])
                assert path.name == f'wave{number}-{match[2]}.json', path.name
                wave_files.setdefault(number, {})[match[2]] = path.name
        assert wave_files, 'No new intake waves are present'
        latest_wave = max(wave_files)
        assert latest_wave >= MINIMUM_LATEST_WAVE, (latest_wave, MINIMUM_LATEST_WAVE)
        assert set(wave_files) == set(range(FIRST_WAVE, latest_wave + 1)), 'Wave gap'
        for number, kinds in wave_files.items():
            assert set(kinds) == {'intake', 'receipt'}, ('Unpaired wave', number)
        waves = [wave_files[n][kind] for n in sorted(wave_files)
                 for kind in ('intake', 'receipt')]
        runtime_names = sorted(discover_runtime_names() | set(waves))
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


base_targets = [
    'MainTheorem', 'SmallPairGraphData16', 'SmallPairGraphData22', 'SmallPairGraphData41',
    'SmallPairGraphInputs22', 'SmallPairGraphWitnessData22',
    'SmallPairGraphArithmetic22', 'SmallPairGraphClosure22', 'SmallPairGraphTriangle22',
    'SmallPairGraphClosure34', 'SmallPairGraphLeft34', 'SmallPairGraphData34',
    'SmallPairLiteralCachedData34', 'SmallPairLiteralLeft34', 'SmallPairLiteralRight34',
    'PairSelectedCachedMask', 'PairSelectedFloorWitnesses', 'PairCachedFloorChunks',
    'PairSelectedFloorChunks', 'SmallPairSelectedData34',
    'SmallPairSelectedLeft34', 'SmallPairSelectedRight34', 'SmallPairGraphTriangle34',
    'PairResidueMaskNat', 'PairRawSelectedFloorWitnesses', 'SmallPairRawSelectedLeft34',
    'PairLightArithmetic', 'PairLightArithmeticBridge',
    'SmallPairLightData34', 'SmallPairLightLeft34', 'SmallPairLightAssembly34',
    'QuadSquareFloorObstruction', 'PairCachedFloorWitnesses',
    'UnitPairAxes', 'UnitPairSymmetric', 'EisensteinPellDescent',
    'FiniteClosedWindow', 'FrontierScalarReduction', 'PellMatchingData10',
    'SmallPairLightRightData34',
    'SmallPairLightRight34',
    'SmallPairLightRightAssembly34',
    'PellLightCF',
    'PellLightCFBridge',
    'PellLightFiniteAdapter',
    'PellLightFinitePilot',
    'PellLightFinitePilotAdapter',
    'UnitPairArithmeticModel',
    'UnitPairRealReduction',
    'CoherentNearOne',
    'CoherentPolynomialWeights',
    'CoherentTwoVanishing',
    'CoherentTwoGap',
    'CoherentTwoMainGap',
    'CoherentThreeGeneral',
    'CoherentThreeSimultaneous',
    'CoherentThreeNonvanishing',
    'CoherentThreeParameters',
    'CoherentParameterForms',
    'CoherentVandermondeFourNorm',
    'CoherentFourParameters',
    'CoherentDirectFour',
    'CoherentThreeZeroBootstrap',
    'SmallPairGraphData47', 'SmallPairLightAssembly47',
    'PairLightArithmeticChunks', 'PairLightArithmeticChunkProofs',
    'SmallPairGraphData45', 'SmallPairLightAssembly45',
    'PellLightMatching', 'PellLightMatchingBridge',
    'PellLightMatchingField7', 'PellLightMatchingField7Adapter',
    'PellLightAllMatchingCertificates', 'PellLightAllFiniteCertificates',
]
wave_targets = set()
wave_summary = []
for number in sorted(wave_files):
    intake = json.loads(runtime_bytes[wave_files[number]['intake']])
    # Decode the existing intake protocol; preserve the original runtime bytes.
    if isinstance(intake, dict) and intake.get('encoding') == 'gzip-base64':
        assert set(intake) == {'encoding', 'data'}, number
        intake = json.loads(gzip.decompress(base64.b64decode(intake['data'], validate=True)))
    receipt = json.loads(runtime_bytes[wave_files[number]['receipt']])
    assert isinstance(intake, dict) and isinstance(receipt, dict), number
    pins = receipt['source_sha256']
    assert isinstance(pins, dict) and set(pins) == set(intake), number
    for filename, source in intake.items():
        assert isinstance(filename, str) and re.fullmatch(r'[A-Za-z0-9_]+\.lean', filename)
        assert isinstance(source, str) and pins[filename] == sha(source.encode()), (number, filename)
        wave_targets.add(filename[:-5])
    wave_summary.append({'wave': number, 'intake_file': wave_files[number]['intake'],
                         'receipt_file': wave_files[number]['receipt'],
                         'source_sha256': pins})
targets = base_targets + sorted(wave_targets - set(base_targets))
statuses = [status(name) for name in targets]
assert not statuses[0]['status'].startswith('PASS'), 'Main acceptance changed: review checkpoint wording'
status_report = {'utc': stamp, 'meaning': 'Frozen terminal-ledger/source/queue snapshot; no fresh replay',
                 'first_intake_wave': FIRST_WAVE, 'latest_intake_wave': latest_wave,
                 'modules': statuses}
intake_report = {'utc': stamp, 'first_wave': FIRST_WAVE, 'latest_wave': latest_wave,
                'all_waves_paired_and_contiguous': True, 'waves': wave_summary,
                'runtime_artifacts': [{'path': name, 'bytes': len(data), 'sha256': sha(data)}
                                      for name, data in runtime_bytes.items()],
                'helper_packet_sha256': sha(helpers_packet)}

# Reference the already committed cp14 source packages; do not recreate or copy archives.
helper_meta = json.loads(runtime_bytes['helper15-manifest.json'])
assert helper_meta['format'] == 'checkpoint15-helper-manifest-v1'
assert helper_meta['expected_head'] == HEAD
assert helper_meta['packet_sha256'] == sha(helpers_packet)
archive_index_path = RUN / 'checkpoint-14/archives/ARCHIVE_INDEX.json'
archive_index_bytes = stable_read(archive_index_path)
assert sha(archive_index_bytes) == 'a357b1195d445246087b16882710b5c771536e39a07f0c84069eca47c4df8d4c'
archive_index = json.loads(archive_index_bytes)
archive_refs = helper_meta['archive_references']
expected_archive_refs = {
    str(archive_index_path.relative_to(ROOT)): {
        'sha256': sha(archive_index_bytes), 'bytes': len(archive_index_bytes)}
}
for row in archive_index['shards']:
    path = archive_index_path.parent / relative_name(row['path'])
    assert path.parent == archive_index_path.parent
    expected_archive_refs[str(path.relative_to(ROOT))] = {
        'sha256': row['sha256'], 'bytes': row['bytes']}
assert len(archive_refs) == len(expected_archive_refs) == 5
assert {row['path']: {'sha256': row['sha256'], 'bytes': row['bytes']} for row in archive_refs} == expected_archive_refs
tracked_paths = set(git('ls-files').splitlines())
for row in archive_refs:
    assert row['path'] in tracked_paths
    data = stable_read(ROOT / relative_name(row['path']))
    assert len(data) == row['bytes'] and sha(data) == row['sha256']
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
# Reuse exact tracked helpers and duplicate packet contents by explicit references.
packet_members = set()
assert len({row['path'] for row in helper_meta['helper_files']}) == len(helper_meta['helper_files'])
for row in helper_meta['helper_files']:
    relative_name(row['path'])
    kinds = [key for key in ('packet_member', 'stored_at') if key in row]
    assert len(kinds) == 1, row['path']
    if 'packet_member' in row:
        member = row['packet_member']
        relative_name(member)
        packet_members.add(member)
        data = helpers[member].encode()
    else:
        assert row['stored_at'] in tracked_paths
        data = stable_read(ROOT / relative_name(row['stored_at']))
    assert len(data) == row['bytes'] and sha(data) == row['sha256']
assert packet_members == set(helpers)
put('verification/ARCHIVE_REFERENCES.json', (json.dumps({
    'source_checkpoint': 14, 'archive_files_copied': 0, 'files': archive_refs}, indent=2) + '\n').encode())
runtime_map = []
for name, data in runtime_bytes.items():
    prior = RUN / 'checkpoint-14/verification' / relative_name(name)
    prior_name = str(prior.relative_to(ROOT))
    if prior_name in tracked_paths and prior.is_file() and stable_read(prior) == data:
        stored = prior_name
    else:
        put('verification/' + name, data)
        stored = str((DEST / 'verification' / name).relative_to(ROOT))
    runtime_map.append({'runtime_path': name, 'stored_at': stored,
                        'bytes': len(data), 'sha256': sha(data)})
put('verification/RUNTIME_MAP.json', (json.dumps(runtime_map, indent=2) + '\n').encode())
put('verification/CHECKPOINT_STATUS.json', (json.dumps(status_report, indent=2) + '\n').encode())
put('verification/INTAKE_CAPTURE.json', (json.dumps(intake_report, indent=2) + '\n').encode())

# Every log copied below belongs to a terminal ledger row captured above. Never
# copy a live compiler stream merely because it is present in the log directory.
parents = [RUN / f'checkpoint-{n}/verification/continuation-builds' for n in (14, 13, 12, 11, 10, 9, 8, 7, 6, 5)]
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
record_bytes = f'''# Main-theorem continuation: fifteenth research checkpoint

Captured {stamp}. **MainStatement remains UNPROVED.** The complete assembly is an unaccepted research artifact. Its full dependency closure has not passed the required acceptance gates. The accepted root/configuration and historical 107/484/922 verification baseline remain unchanged. This private research backup retains the same pinned manuscript.

The following status comes from the captured terminal ledger, active-job receipt, queue and exact current source-closure fingerprints. PASS means a matching terminal receipt, not a fresh replay. A previous failure or timeout is never promoted to acceptance of changed source. Later compiler progress does not alter this dated snapshot.

| Module | Status at capture |
| --- | --- |
{table}

Every intake/receipt pair from wave {FIRST_WAVE} through observed wave {latest_wave} is present, paired and hash-checked. These are source-intake receipts, not compilation receipts. Status targets include every module in these waves and earlier right-class, Pell-light and analytic milestones. A successful isolated checker does not establish its assembly, triangle, branch or MainStatement.

The reviewed production and merge helpers and their provenance are preserved through checkpoint15-helpers.json and the captured runtime records. Equal helper contents are stored once or referenced from tracked earlier checkpoints. RUNTIME_MAP records unchanged runtime metadata reused from checkpoint14. Prepared Light47 sources, a Python reproduction, or a source review do not constitute source intake or Lean acceptance. The successful Light47 preparation receipt, when present, permits capture of its terminal preparation logs and exact manifests. These checkpoint scripts install no prepared source.

The earlier analytic readiness report checked direct parents. The scheduler's stronger full-closure gate also requires individual acceptance records for CoherentNearOne, CoherentPolynomialWeights and CoherentTwoVanishing. Priority records and current terminal statuses document their actual progress; no artifact or acceptance gate is weakened.

The checkpoint-14 push and index receipts record the previous private research backup. Current runtime JSON, new paired intakes, preparation/review/priority records and prepared manifests are listed with exact hashes in INTAKE_CAPTURE.json. The mandatory helper packet is decoded without executing its contents. Snapshotting a helper does not execute its preparation, Git or compiler actions.

The source map reuses unchanged exact drafts stored in checkpoint 14 or earlier. Only captured terminal-ledger logs are considered. Byte-identical logs already stored in checkpoints 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4/addendum, 4 and 3 are not duplicated. Active compiler logs are excluded. Queue and active receipts remain point-in-time records.

The checkpoint references the five already committed checkpoint14 archive files through exact hashes and tracked paths. No archive bytes are recreated, decompressed, copied or staged again. Their807 source members remain available in the previous private checkpoint. New409-field matching production sources are captured by paired intake112 and the current source map. The small helper packet preserves generator/provenance manifests and exact merge45 preimages; these records do not constitute compiler acceptance.

Helper provenance includes the failed initial capacity test report, corrected reports, Python3.12 tests and the actual opt-in single-worker restart receipt. Earlier failed evidence is preserved honestly. Pell matching generation uses its frozen original bridge as provenance; later proof-only bridge repairs and their failures/reviews are separate history. The actual source and wave cut above determines current status.

All required concrete certificates, branch endpoints, full main closure, axiom audit and final same-kernel replay must still pass. No root integration or whole-root replay is claimed. Both scheduled tasks remain paused. This record is not a push receipt.
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
