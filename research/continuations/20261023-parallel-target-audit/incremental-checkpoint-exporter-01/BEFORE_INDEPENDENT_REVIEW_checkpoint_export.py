#!/usr/bin/env python3
"""Stable accepted-module snapshots, then independent durable-arrival verification.

No compiler, Git, network, extraction, source writes or build writes. Python 3.8+.
An accepted snapshot is recovery evidence, never whole-build/proof acceptance.
"""
import argparse
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import sys
import tarfile
import tempfile
import uuid

SCHEMA = 1
HEX = re.compile(r'[0-9a-f]{64}\Z')
MODULE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*\Z")
UUID = re.compile(r'[0-9a-f]{32}\Z')
MIB = 1024 * 1024


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def encoded(value):
    return (json.dumps(value, sort_keys=True, indent=2) + '\n').encode()


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()


def data_sha(value):
    return hashlib.sha256(value).hexdigest()


def file_sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(MIB), b''):
            h.update(block)
    return h.hexdigest()


def safe_relative(name):
    require(isinstance(name, str) and name and '\\' not in name and '\x00' not in name,
            'Invalid relative path')
    p = PurePosixPath(name)
    require(not p.is_absolute() and all(x not in ('', '.', '..') for x in name.split('/')),
            'Unsafe relative path: ' + name)
    return name


def regular(path):
    p = Path(path).absolute()
    for parent in [p] + list(p.parents):
        require(not parent.is_symlink(), 'Symlink forbidden: ' + str(parent))
    s = p.stat()
    require(stat.S_ISREG(s.st_mode), 'Not regular: ' + str(p))
    return (s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns)


def stable_bytes(path, expected=None):
    before = regular(path)
    data = Path(path).read_bytes()
    require(regular(path) == before, 'Input changed while reading: ' + str(path))
    if expected is not None:
        require(bool(HEX.fullmatch(expected)) and data_sha(data) == expected,
                'Input hash mismatch: ' + str(path))
    return data


def exclusive(path, data):
    with Path(path).open('xb') as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())


def sync_directory(path):
    fd = os.open(str(path), os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def mpath(name, suffix):
    require(bool(MODULE.fullmatch(name)), 'Invalid module')
    return name.replace('.', '/') + suffix


def bundle_names(root, module):
    base = Path(root) / mpath(module, '.olean')
    paths = set(base.parent.glob(base.name + '*')) | set(base.parent.glob(base.with_suffix('.ir').name + '*'))
    for path in paths:
        regular(path)
    return sorted(str(p.relative_to(root)) for p in paths)


def previous_record(path, expected):
    if path is None:
        require(expected is None, 'Previous hash without previous receipt')
        return None, None
    require(expected is not None, 'Previous durable receipt needs an explicit hash')
    raw = stable_bytes(path, expected)
    row = json.loads(raw)
    require(row['schema'] == SCHEMA and row['status'] == 'DURABLE_ACCEPTED_SNAPSHOT',
            'Previous batch is not independently confirmed durable')
    require(row['proof_acceptance_claim'] is False, 'Unexpected previous acceptance claim')
    require(isinstance(row['cumulative'], dict), 'Invalid previous cumulative state')
    return row, raw


def load_spec(path, expected):
    raw = stable_bytes(path, expected)
    spec = json.loads(raw)
    require(spec['schema'] == SCHEMA, 'Unsupported specification')
    require(bool(UUID.fullmatch(spec['build_id'])), 'Invalid build identity')
    require(bool(HEX.fullmatch(spec['identity_hash'])), 'Invalid identity hash')
    require(bool(HEX.fullmatch(spec['origin_sha256'])), 'Invalid origin pin')
    for key in ('source_lock', 'runtime_lock', 'runner'):
        require(bool(HEX.fullmatch(spec[key]['sha256'])), 'Invalid metadata pin')
    for key in ('source_root', 'build_dir'):
        require(Path(spec[key]).is_absolute(), 'Explicit absolute root required')
        require(not Path(spec[key]).is_symlink(), 'Symlink root forbidden')
    return spec, raw


def identity_check(spec, origin, source_lock, runtime_lock, runner_sha):
    identity = origin['identity']
    require(origin['initial_artifact_inventory'] == [], 'Build did not start empty')
    require(origin['build_id'] == spec['build_id'], 'Foreign build ID')
    require(origin['identity_hash'] == digest(identity) == spec['identity_hash'], 'Foreign identity')
    require(identity['runner_sha256'] == runner_sha == spec['runner']['sha256'], 'Runner mismatch')
    require(identity['source_lock_sha256'] == spec['source_lock']['sha256'], 'Source-lock mismatch')
    require(identity['runtime_lock_sha256'] == spec['runtime_lock']['sha256'], 'Runtime-lock mismatch')
    require(identity['source_root'] == spec['source_root'] and identity['build_dir'] == spec['build_dir'],
            'Origin path mismatch')
    require(source_lock['schema'] == runtime_lock['schema'] == 1, 'Builder lock schema mismatch')
    order = source_lock['topological_order']
    require(len(order) == len(set(order)) == source_lock['module_count'] == len(source_lock['sources']),
            'Invalid source inventory')
    require(set(order) == set(source_lock['sources']), 'Invalid source order')
    seen = set()
    for n in order:
        require(source_lock['sources'][n]['relative_path'] == mpath(n, '.lean'), 'Source path mismatch')
        deps = {d for d in source_lock['sources'][n]['imports'] if d in source_lock['sources']}
        require(deps <= seen, 'Non-topological source lock')
        seen.add(n)


def receipt_check(n, pointer, receipt, source_lock, spec, cumulative, runtime):
    require(set(pointer) == {'receipt_path', 'receipt_sha256'}, 'Unexpected pointer fields')
    relative = safe_relative(pointer['receipt_path'])
    parts = relative.split('/')
    require(len(parts) == 4 and parts[0] == 'attempts' and parts[1] == n
            and UUID.fullmatch(parts[2]) and parts[3] == 'receipt.json', 'Non-UUID receipt path')
    require(receipt['schema'] == 1 and receipt['status'] == 'COMPILE_PASS' and receipt['exit_code'] == 0,
            'Receipt is not a compiler PASS')
    require(receipt['module'] == n and receipt['build_id'] == spec['build_id']
            and receipt['identity_hash'] == spec['identity_hash'], 'Foreign receipt')
    require(receipt['source_sha256'] == source_lock['sources'][n]['sha256'], 'Foreign source')
    require(bool(UUID.fullmatch(receipt['invocation'])), 'Missing invocation identity')
    expected_command = [runtime['lean'], '-j1', '-DautoImplicit=false', '-R', spec['source_root'],
                        '-o', str(Path(spec['build_dir']) / 'attempts' / n / parts[2] / 'stage' / mpath(n, '.olean')),
                        str(Path(spec['source_root']) / mpath(n, '.lean'))]
    require(receipt['command'] == expected_command, 'Unexpected compiler command')
    require(bool(HEX.fullmatch(receipt['log_sha256'])), 'Missing original compiler log hash')
    deps = [d for d in source_lock['sources'][n]['imports'] if d in source_lock['sources']]
    require(set(receipt['dependencies']) == set(deps), 'Dependency set mismatch')
    for d in deps:
        require(d in cumulative, 'Dependency not in durable predecessor or this snapshot: ' + d)
        require(receipt['dependencies'][d] == {
            'receipt_sha256': cumulative[d]['receipt_sha256'],
            'artifact_bundle': cumulative[d]['artifact_bundle']}, 'Dependency identity mismatch')
    bundle = receipt['artifact_bundle']
    require(isinstance(bundle, dict) and mpath(n, '.olean') in bundle, 'Missing primary artifact')
    base = mpath(n, '.olean')
    ir = mpath(n, '.ir')
    for p, h in bundle.items():
        safe_relative(p)
        require((p.startswith(base) or p.startswith(ir)) and '/' not in p[len(base if p.startswith(base) else ir):],
                'Foreign artifact path')
        require(bool(HEX.fullmatch(h)), 'Invalid artifact hash')


def prepare(args):
    spec, spec_raw = load_spec(args.spec, args.spec_sha256)
    prev, prev_raw = previous_record(args.previous, args.previous_sha256)
    require(1 <= args.max_modules <= 100, 'Batch module limit must be 1..100')
    require(args.max_bytes > 0, 'Positive batch byte cap required')
    out = Path(args.out).absolute()
    require(not out.exists(), 'Snapshot output must be new; never overwrite a batch')
    build, source = Path(spec['build_dir']), Path(spec['source_root'])
    for protected in (build, source):
        require(out != protected and protected not in out.parents and out not in protected.parents,
                'Output must be disjoint from source and build roots')
    origin_raw = stable_bytes(build / 'ORIGIN.json', spec['origin_sha256'])
    origin = json.loads(origin_raw)
    metadata = {'SPEC.json': (Path(args.spec), args.spec_sha256),
                'ORIGIN.json': (build / 'ORIGIN.json', spec['origin_sha256'])}
    for role in ('source_lock', 'runtime_lock', 'runner'):
        metadata[role + ('.py' if role == 'runner' else '.json')] = (
            Path(spec[role]['path']), spec[role]['sha256'])
    sl = json.loads(stable_bytes(metadata['source_lock.json'][0], spec['source_lock']['sha256']))
    rt = json.loads(stable_bytes(metadata['runtime_lock.json'][0], spec['runtime_lock']['sha256']))
    identity_check(spec, origin, sl, rt, spec['runner']['sha256'])
    if prev:
        require(prev['spec_sha256'] == args.spec_sha256 and prev['build_id'] == spec['build_id']
                and prev['identity_hash'] == spec['identity_hash'], 'Cannot mix checkpoint identities')
    cumulative = dict(prev['cumulative']) if prev else {}
    require(set(cumulative) <= set(sl['sources']), 'Unknown predecessor module')
    number = prev['batch_number'] + 1 if prev else 1
    inputs = {}
    def add(name, path, sha):
        safe_relative(name)
        require(name not in inputs, 'Duplicate archive name')
        regular(path)
        inputs[name] = (Path(path), sha)
    for name, (path, h) in metadata.items():
        add('metadata/' + name, path, h)
    for name, row in spec.get('extra_metadata', {}).items():
        require('/' not in safe_relative(name), 'Extra metadata name must be a basename')
        add('metadata/extra/' + name, Path(row['path']), row['sha256'])
    for name, h in sl['auxiliary'].items():
        add('source/' + safe_relative(name), source / name, h)
    if prev:
        add('chain/PREVIOUS_DURABLE.json', Path(args.previous), args.previous_sha256)
    # A fixed pointer-name snapshot intentionally ignores active/unaccepted work and later arrivals.
    known = {n for n in sl['topological_order'] if (build / 'accepted' / mpath(n, '.json')).is_file()}
    for n in cumulative:
        require(n in known, 'Previously durable module no longer accepted in this build')
        p = build / 'accepted' / mpath(n, '.json')
        stable_bytes(p, cumulative[n]['pointer_sha256'])
    selected = []
    total = sum(regular(p)[2] for p, _ in inputs.values())
    require(total <= args.max_bytes, 'Metadata exceeds batch byte limit')
    for n in sl['topological_order']:
        if n in cumulative or n not in known:
            continue
        pointer_path = build / 'accepted' / mpath(n, '.json')
        pointer_raw = stable_bytes(pointer_path)
        pointer = json.loads(pointer_raw)
        receipt_path = build / safe_relative(pointer['receipt_path'])
        receipt_raw = stable_bytes(receipt_path, pointer['receipt_sha256'])
        receipt = json.loads(receipt_raw)
        receipt_check(n, pointer, receipt, sl, spec, cumulative, rt)
        require(bundle_names(build / 'artifacts', n) == sorted(receipt['artifact_bundle']),
                'Artifact bundle inventory mismatch: ' + n)
        module_inputs = {
            'build/accepted/' + mpath(n, '.json'): (pointer_path, data_sha(pointer_raw)),
            'build/' + pointer['receipt_path']: (receipt_path, pointer['receipt_sha256']),
            'build/' + str(PurePosixPath(pointer['receipt_path']).parent / 'compiler.log'):
                (receipt_path.parent / 'compiler.log', receipt['log_sha256']),
            'source/' + sl['sources'][n]['relative_path']:
                (source / sl['sources'][n]['relative_path'], receipt['source_sha256'])}
        for rel, h in receipt['artifact_bundle'].items():
            module_inputs['build/artifacts/' + rel] = (build / 'artifacts' / rel, h)
        start_rel = 'invocations/' + receipt['invocation'] + '/START.json'
        start_raw = stable_bytes(build / start_rel)
        require(json.loads(start_raw)['identity_hash'] == spec['identity_hash'], 'Foreign invocation START')
        module_inputs['build/' + start_rel] = (build / start_rel, data_sha(start_raw))
        for name in set(module_inputs) & set(inputs):
            require(inputs[name] == module_inputs[name], 'Conflicting repeated immutable input')
        module_inputs = {name: value for name, value in module_inputs.items() if name not in inputs}
        amount = sum(regular(p)[2] for p, _ in module_inputs.values())
        if total + amount > args.max_bytes:
            require(selected, 'One accepted module exceeds batch byte cap; choose an explicit larger cap')
            break
        for name, (path, h) in module_inputs.items():
            add(name, path, h)
        cumulative[n] = {'pointer_sha256': data_sha(pointer_raw), 'receipt_path': pointer['receipt_path'],
                         'receipt_sha256': pointer['receipt_sha256'], 'source_sha256': receipt['source_sha256'],
                         'artifact_bundle': receipt['artifact_bundle'], 'batch_number': number}
        selected.append(n)
        total += amount
        if len(selected) >= args.max_modules:
            break
    require(selected, 'No newly accepted modules: no batch created')
    out.mkdir(parents=True)
    # Staging is disposable. Only the verified tar and its explicit sidecar are transport candidates.
    with tempfile.TemporaryDirectory(prefix='copy-', dir=str(out)) as temp:
        temp = Path(temp)
        files = {}
        captured = {}
        for name, (path, h) in inputs.items():
            before = regular(path)
            target = temp / name
            target.parent.mkdir(parents=True, exist_ok=True)
            actual = hashlib.sha256()
            with path.open('rb') as inp, target.open('xb') as dest:
                for block in iter(lambda: inp.read(MIB), b''):
                    dest.write(block)
                    actual.update(block)
            require(regular(path) == before and actual.hexdigest() == h, 'Unstable/mismatched copy: ' + name)
            files[name] = {'sha256': h, 'bytes': before[2]}
            captured[name] = before
        # Rehash originals after all copies, including all selected pointers, receipts and sidecars.
        for name, (path, h) in inputs.items():
            require(regular(path) == captured[name] and file_sha(path) == h
                    and regular(path) == captured[name], 'Input changed after capture: ' + name)
        for n in selected:
            require(bundle_names(build / 'artifacts', n) == sorted(cumulative[n]['artifact_bundle']),
                    'Bundle membership changed after capture')
        for n in set(cumulative) - set(selected):
            stable_bytes(build / 'accepted' / mpath(n, '.json'), cumulative[n]['pointer_sha256'])
        snapshot = {'schema': SCHEMA, 'status': 'PREPARED_STABLE_ACCEPTED_SNAPSHOT',
                    'proof_acceptance_claim': False, 'build_id': spec['build_id'],
                    'identity_hash': spec['identity_hash'], 'spec_sha256': args.spec_sha256,
                    'batch_number': number, 'previous_durable_sha256': args.previous_sha256,
                    'modules': selected, 'cumulative': cumulative, 'files': files,
                    'payload_bytes': sum(x['bytes'] for x in files.values()),
                    'scope': 'Only listed stable COMPILE_PASS modules; unaccepted/active work excluded; no whole-build or kernel PASS claim.'}
        snapshot_raw = encoded(snapshot)
        (temp / 'SNAPSHOT.json').write_bytes(snapshot_raw)
        archive = out / 'batch.tar.gz'
        with tarfile.open(str(archive), 'w:gz', compresslevel=3) as tar:
            for name in sorted(list(files) + ['SNAPSHOT.json']):
                data = temp / name
                info = tarfile.TarInfo(name)
                info.size = data.stat().st_size
                info.mode = 0o600
                with data.open('rb') as f:
                    tar.addfile(info, f)
        for name, (path, h) in inputs.items():
            require(regular(path) == captured[name] and file_sha(path) == h
                    and regular(path) == captured[name], 'Input changed during compression: ' + name)
        for n in selected:
            require(bundle_names(build / 'artifacts', n) == sorted(cumulative[n]['artifact_bundle']),
                    'Bundle membership changed during compression')
        with archive.open('rb') as f:
            os.fsync(f.fileno())
        sidecar = {'schema': SCHEMA, 'status': 'PREPARED_NOT_DURABLE',
                   'archive_sha256': file_sha(archive), 'archive_bytes': archive.stat().st_size,
                   'snapshot_sha256': data_sha(snapshot_raw), 'snapshot': snapshot}
        exclusive(out / 'PREPARED.json', encoded(sidecar))
        sync_directory(out)
    return {'status': 'PREPARED_NOT_DURABLE', 'archive': str(archive),
            'archive_sha256': sidecar['archive_sha256'], 'prepared': str(out / 'PREPARED.json'),
            'prepared_sha256': file_sha(out / 'PREPARED.json'), 'new_modules': len(selected),
            'cumulative_modules': len(cumulative)}


def verify_arrival(args):
    previous, previous_raw = previous_record(args.previous, args.previous_sha256)
    prepared_raw = stable_bytes(args.prepared, args.prepared_sha256)
    prepared = json.loads(prepared_raw)
    require(prepared['schema'] == SCHEMA and prepared['status'] == 'PREPARED_NOT_DURABLE', 'Invalid prepared record')
    require(prepared['archive_sha256'] == args.archive_sha256, 'Transport archive pin mismatch')
    archive = Path(args.archive).absolute()
    destination = Path(args.destination).absolute()
    require(archive.parent == destination and Path(args.prepared).absolute().parent == destination,
            'Archive and prepared sidecar must already be stored in durable destination')
    require(not (destination / 'DURABLE_BATCH.json').exists(), 'Never overwrite durable confirmation')
    before = regular(archive)
    require(before[2] == prepared['archive_bytes'] and file_sha(archive) == args.archive_sha256,
            'Transported archive corrupted')
    snapshot = prepared['snapshot']
    require(data_sha(encoded(snapshot)) == prepared['snapshot_sha256'], 'Snapshot identity mismatch')
    require(snapshot['status'] == 'PREPARED_STABLE_ACCEPTED_SNAPSHOT' and snapshot['proof_acceptance_claim'] is False,
            'Unexpected acceptance claim')
    expected = dict(snapshot['files'])
    expected['SNAPSHOT.json'] = {'sha256': prepared['snapshot_sha256'], 'bytes': len(encoded(snapshot))}
    small = {}
    seen = set()
    with tarfile.open(str(archive), 'r:gz') as tar:
        for member in tar:
            name = safe_relative(member.name)
            require(member.isfile() and name not in seen and name in expected,
                    'Unexpected/duplicate/nonregular archive member')
            require(member.size == expected[name]['bytes'], 'Archive member length mismatch')
            h = hashlib.sha256()
            # Keep only original metadata, pointers and receipts needed for independent semantic checking.
            collect = name.startswith(('metadata/', 'chain/', 'build/accepted/', 'build/invocations/')) or name.endswith('/receipt.json')
            chunks = []
            stream = tar.extractfile(member)
            for block in iter(lambda: stream.read(MIB), b''):
                h.update(block)
                if collect:
                    chunks.append(block)
            require(h.hexdigest() == expected[name]['sha256'], 'Archive member content mismatch')
            if collect:
                small[name] = b''.join(chunks)
            seen.add(name)
    require(seen == set(expected), 'Missing archive members')
    require(regular(archive) == before and file_sha(archive) == args.archive_sha256
            and regular(archive) == before, 'Archive changed during independent verification')
    require(stable_bytes(args.prepared, args.prepared_sha256) == prepared_raw, 'Prepared sidecar changed')
    spec_raw = small['metadata/SPEC.json']
    spec = json.loads(spec_raw)
    require(data_sha(spec_raw) == snapshot['spec_sha256'], 'Specification mismatch')
    sl_raw, rt_raw = small['metadata/source_lock.json'], small['metadata/runtime_lock.json']
    require(data_sha(sl_raw) == spec['source_lock']['sha256'] and data_sha(rt_raw) == spec['runtime_lock']['sha256'],
            'Archived lock pin mismatch')
    require(data_sha(small['metadata/ORIGIN.json']) == spec['origin_sha256'], 'Archived origin mismatch')
    sl, rt = json.loads(sl_raw), json.loads(rt_raw)
    identity_check(spec, json.loads(small['metadata/ORIGIN.json']), sl, rt, data_sha(small['metadata/runner.py']))
    require(snapshot['build_id'] == spec['build_id'] and snapshot['identity_hash'] == spec['identity_hash'],
            'Snapshot identity mismatch')
    cumulative = dict(previous['cumulative']) if previous else {}
    required_files = {'metadata/SPEC.json', 'metadata/ORIGIN.json', 'metadata/source_lock.json',
                      'metadata/runtime_lock.json', 'metadata/runner.py'}
    for name, row in spec.get('extra_metadata', {}).items():
        require('/' not in safe_relative(name), 'Invalid extra metadata name')
        require(expected['metadata/extra/' + name]['sha256'] == row['sha256'], 'Extra metadata pin mismatch')
        required_files.add('metadata/extra/' + name)
    for name, h in sl['auxiliary'].items():
        require(expected['source/' + safe_relative(name)]['sha256'] == h, 'Auxiliary source mismatch')
        required_files.add('source/' + name)
    require(snapshot['previous_durable_sha256'] == args.previous_sha256, 'Predecessor pin mismatch')
    require(snapshot['batch_number'] == (previous['batch_number'] + 1 if previous else 1), 'Batch number mismatch')
    if previous:
        required_files.add('chain/PREVIOUS_DURABLE.json')
        require(small['chain/PREVIOUS_DURABLE.json'] == previous_raw, 'Archived predecessor mismatch')
        require(previous['spec_sha256'] == snapshot['spec_sha256'] and previous['build_id'] == spec['build_id']
                and previous['identity_hash'] == spec['identity_hash'], 'Foreign predecessor identity')
    else:
        require('chain/PREVIOUS_DURABLE.json' not in seen, 'Unexpected predecessor')
    modules = snapshot['modules']
    require(0 < len(modules) <= 100 and len(modules) == len(set(modules)), 'Invalid selected modules')
    require([n for n in sl['topological_order'] if n in modules] == modules, 'Module ordering mismatch')
    for n in modules:
        require(n not in cumulative, 'Already durable module duplicated')
        pointer_name = 'build/accepted/' + mpath(n, '.json')
        pointer_raw = small[pointer_name]
        pointer = json.loads(pointer_raw)
        receipt_name = 'build/' + safe_relative(pointer['receipt_path'])
        receipt_raw = small[receipt_name]
        require(data_sha(receipt_raw) == pointer['receipt_sha256'], 'Archived receipt identity mismatch')
        receipt = json.loads(receipt_raw)
        receipt_check(n, pointer, receipt, sl, spec, cumulative, rt)
        start_name = 'build/invocations/' + receipt['invocation'] + '/START.json'
        require(json.loads(small[start_name])['identity_hash'] == spec['identity_hash'], 'Archived invocation mismatch')
        required_files.add(start_name)
        log_name = 'build/' + str(PurePosixPath(pointer['receipt_path']).parent / 'compiler.log')
        required_files.update({pointer_name, receipt_name, log_name, 'source/' + sl['sources'][n]['relative_path']})
        require(expected['build/' + str(PurePosixPath(pointer['receipt_path']).parent / 'compiler.log')]['sha256']
                == receipt['log_sha256'], 'Archived log mismatch')
        require(expected['source/' + sl['sources'][n]['relative_path']]['sha256'] == receipt['source_sha256'],
                'Archived source mismatch')
        for rel, h in receipt['artifact_bundle'].items():
            required_files.add('build/artifacts/' + rel)
            require(expected['build/artifacts/' + rel]['sha256'] == h, 'Archived artifact mismatch')
        cumulative[n] = {'pointer_sha256': data_sha(pointer_raw), 'receipt_path': pointer['receipt_path'],
                         'receipt_sha256': pointer['receipt_sha256'], 'source_sha256': receipt['source_sha256'],
                         'artifact_bundle': receipt['artifact_bundle'], 'batch_number': snapshot['batch_number']}
    require(cumulative == snapshot['cumulative'], 'Cumulative chain mismatch')
    require(required_files == set(snapshot['files']), 'Snapshot contains unselected or missing file paths')
    require(snapshot['payload_bytes'] == sum(x['bytes'] for x in snapshot['files'].values()), 'Payload byte count mismatch')
    # Output exists only after complete archive and semantic validation, and cannot overwrite an earlier receipt.
    result = {'schema': SCHEMA, 'status': 'DURABLE_ACCEPTED_SNAPSHOT', 'proof_acceptance_claim': False,
              'build_id': snapshot['build_id'], 'identity_hash': snapshot['identity_hash'],
              'spec_sha256': snapshot['spec_sha256'], 'batch_number': snapshot['batch_number'],
              'previous_durable_sha256': args.previous_sha256, 'modules': modules,
              'cumulative': cumulative, 'archive_name': archive.name, 'archive_sha256': args.archive_sha256,
              'archive_bytes': before[2], 'prepared_name': Path(args.prepared).name,
              'prepared_sha256': args.prepared_sha256, 'snapshot_sha256': prepared['snapshot_sha256'],
              'file_count': len(expected), 'payload_bytes': snapshot['payload_bytes'],
              'verifier_sha256': file_sha(__file__),
              'scope': 'Exact original bytes independently checked at this storage destination; no proof/final-build acceptance.'}
    for path in (archive, Path(args.prepared)):
        with path.open('rb') as f:
            os.fsync(f.fileno())
    exclusive(destination / 'DURABLE_BATCH.json', encoded(result))
    sync_directory(destination)
    return {'status': result['status'], 'path': str(destination / 'DURABLE_BATCH.json'),
            'sha256': file_sha(destination / 'DURABLE_BATCH.json'), 'new_modules': len(modules),
            'cumulative_modules': len(cumulative)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    p = commands.add_parser('prepare')
    for name in ('spec', 'spec-sha256', 'out'):
        p.add_argument('--' + name, required=True)
    p.add_argument('--previous'); p.add_argument('--previous-sha256')
    p.add_argument('--max-modules', type=int, default=50)
    p.add_argument('--max-bytes', type=int, default=512 * MIB)
    v = commands.add_parser('verify-arrival')
    for name in ('archive', 'archive-sha256', 'prepared', 'prepared-sha256', 'destination'):
        v.add_argument('--' + name, required=True)
    v.add_argument('--previous'); v.add_argument('--previous-sha256')
    args = parser.parse_args()
    try:
        result = prepare(args) if args.command == 'prepare' else verify_arrival(args)
        print(json.dumps(result, sort_keys=True))
        return 0
    except Exception as error:
        print(json.dumps({'status': 'FAILED_NO_DURABLE_ACCEPTANCE', 'error': str(error)}), file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
