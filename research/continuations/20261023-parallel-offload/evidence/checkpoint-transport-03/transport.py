#!/usr/bin/env python3
"""Byte transport only. Never declares a proof checkpoint durable."""
import argparse
import base64
import hashlib
import json
import os
from pathlib import Path
import re
import uuid

RAW_CHUNK = 600000
TEXT_PIECE = 100000
MAX_ARCHIVE = 128 * 1024 * 1024
REMOTE_BASE = Path('/Users/tp/Lean/D1Bound5ProofObjects')
FILES = ('batch.tar.xz', 'PREPARED.json')


def require(test, message):
    if not test:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def identity(path):
    s = path.stat()
    return [s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns]


def canonical(path):
    p = Path(path)
    require(p.is_absolute() and str(p) == str(p.resolve()), 'Noncanonical or symlink path')
    return p


def exclusive(path, data):
    with path.open('xb') as stream:
        stream.write(data)
        stream.flush()
        os.fsync(stream.fileno())


def save_new(path, value):
    exclusive(path, (json.dumps(value, sort_keys=True, indent=2) + '\n').encode())


def plan(source, build_id, batch, out):
    source = canonical(source)
    require(re.fullmatch(r'[a-zA-Z0-9_-]{1,80}', build_id), 'Invalid build identifier')
    require(1 <= batch <= 100, 'Batch outside authorized maximum')
    rows = {}
    for name in FILES:
        p = source / name
        require(p.is_file() and not p.is_symlink(), 'Missing or symlink source')
        before = identity(p)
        require(before[2] <= MAX_ARCHIVE, 'File exceeds bounded transfer size')
        parts = []
        whole = hashlib.sha256()
        with p.open('rb') as stream:
            while True:
                raw = stream.read(RAW_CHUNK)
                if not raw:
                    break
                whole.update(raw)
                parts.append({'raw_bytes': len(raw), 'raw_sha256': digest(raw),
                              'base64_bytes': len(base64.b64encode(raw))})
        require(before == identity(p), 'Source changed while planning')
        rows[name] = {'source': str(p), 'source_identity': before, 'bytes': before[2],
                      'sha256': whole.hexdigest(), 'chunks': parts}
    prepared = json.loads((source / 'PREPARED.json').read_bytes())
    require(prepared.get('schema') == 1 and prepared.get('status') == 'PREPARED_NOT_DURABLE', 'Unexpected exporter preparation status')
    require(prepared['archive_sha256'] == rows['batch.tar.xz']['sha256'], 'Exporter archive hash differs')
    require(prepared['archive_bytes'] == rows['batch.tar.xz']['bytes'], 'Exporter archive length differs')
    token = uuid.uuid4().hex
    base = REMOTE_BASE / ('recovery-' + build_id)
    value = {'schema': 1, 'status': 'TRANSPORT_PREPARED_NOT_DURABLE', 'raw_chunk_bytes': RAW_CHUNK,
             'text_piece_bytes': TEXT_PIECE, 'build_id': build_id, 'batch': batch,
             'incoming': str(base / ('incoming-' + token)),
             'destination': str(base / ('batch-%06d' % batch)), 'files': rows,
             'required_final_gate': 'Independent reviewed exporter verify-arrival with root-pinned hashes and prior durable chain.'}
    save_new(canonical(out), value)
    return {'plan': str(out), 'plan_sha256': digest(Path(out).read_bytes()),
            'archive_sha256': rows['batch.tar.xz']['sha256'], 'archive_bytes': rows['batch.tar.xz']['bytes'],
            'prepared_sha256': rows['PREPARED.json']['sha256'], 'destination': value['destination']}


def load_plan(path, expected):
    raw = Path(path).read_bytes()
    require(digest(raw) == expected, 'Transport plan hash differs')
    p = json.loads(raw)
    require(p['schema'] == 1 and p['raw_chunk_bytes'] == RAW_CHUNK and p['text_piece_bytes'] == TEXT_PIECE, 'Unsupported plan')
    require(set(p['files']) == set(FILES), 'Unexpected payload file')
    require(re.fullmatch(r'[a-zA-Z0-9_-]{1,80}', p['build_id']) and 1 <= p['batch'] <= 100, 'Invalid batch')
    base = REMOTE_BASE / ('recovery-' + p['build_id'])
    require(canonical(p['destination']) == base / ('batch-%06d' % p['batch']), 'Destination outside batch scope')
    incoming = canonical(p['incoming'])
    require(incoming.parent == base and re.fullmatch(r'incoming-[a-f0-9]{32}', incoming.name), 'Incoming outside batch scope')
    for name, row in p['files'].items():
        require(0 <= row['bytes'] <= MAX_ARCHIVE, 'Payload exceeds bounded size')
        require(sum(x['raw_bytes'] for x in row['chunks']) == row['bytes'], 'Inconsistent chunk lengths')
        require(all(0 < x['raw_bytes'] <= RAW_CHUNK and x['base64_bytes'] == 4*((x['raw_bytes']+2)//3) for x in row['chunks']), 'Bad chunk size')
        require(all(x['raw_bytes'] == RAW_CHUNK for x in row['chunks'][:-1]), 'Nonfinal short chunk')
    return p, raw


def emit(path, expected, name, chunk, piece):
    p, _ = load_plan(path, expected)
    require(name in FILES and chunk >= 0 and 0 <= piece < 8, 'Invalid chunk request')
    row = p['files'][name]
    require(chunk < len(row['chunks']), 'Chunk index out of range')
    source = canonical(row['source'])
    require(identity(source) == row['source_identity'], 'Source identity changed')
    with source.open('rb') as stream:
        stream.seek(chunk * RAW_CHUNK)
        data = stream.read(RAW_CHUNK)
    require(identity(source) == row['source_identity'], 'Source changed while reading')
    require(len(data) == row['chunks'][chunk]['raw_bytes'] and digest(data) == row['chunks'][chunk]['raw_sha256'], 'Source chunk differs')
    encoded = base64.b64encode(data).decode('ascii')
    return encoded[piece*TEXT_PIECE:(piece+1)*TEXT_PIECE]


def begin(path, expected):
    p, raw = load_plan(path, expected)
    incoming, destination = canonical(p['incoming']), canonical(p['destination'])
    require(not incoming.exists() and not destination.exists(), 'Transfer or batch already exists')
    incoming.parent.mkdir(parents=True, exist_ok=True)
    require(canonical(incoming.parent) == incoming.parent, 'Parent resolution changed')
    incoming.mkdir()
    destination.mkdir()
    exclusive(incoming / 'TRANSPORT_PLAN.json', raw)
    return {'status': 'EMPTY_TRANSFER_DIRECTORIES_CREATED_NOT_DURABLE', 'incoming': str(incoming), 'destination': str(destination)}


def chunk_path(incoming, file_index, index):
    return incoming / ('file-%d-chunk-%06d.b64' % (file_index, index))


def assemble(path, expected):
    p, raw = load_plan(path, expected)
    incoming, destination = canonical(p['incoming']), canonical(p['destination'])
    require((incoming/'TRANSPORT_PLAN.json').read_bytes() == raw, 'Incoming plan differs')
    require(destination.is_dir() and not list(destination.iterdir()), 'Destination not empty')
    expected_names = {'TRANSPORT_PLAN.json'}
    for file_index, name in enumerate(FILES):
        for i in range(len(p['files'][name]['chunks'])):
            expected_names.add(chunk_path(incoming, file_index, i).name)
    require({x.name for x in incoming.iterdir()} == expected_names, 'Missing or unexpected incoming chunks')
    for file_index, name in enumerate(FILES):
        row = p['files'][name]
        h = hashlib.sha256(); total = 0
        with (destination/name).open('xb') as stream:
            for i, part in enumerate(row['chunks']):
                source = chunk_path(incoming, file_index, i)
                require(not source.is_symlink() and source.is_file(), 'Invalid chunk file')
                require(source.stat().st_size == part['base64_bytes'], 'Encoded chunk size differs')
                data = base64.b64decode(source.read_bytes(), validate=True)
                require(len(data) == part['raw_bytes'] and digest(data) == part['raw_sha256'], 'Decoded chunk differs')
                stream.write(data); h.update(data); total += len(data)
            stream.flush(); os.fsync(stream.fileno())
        require(total == row['bytes'] and h.hexdigest() == row['sha256'], 'Assembled file differs')
    result = {'status': 'EXACT_BYTES_ARRIVED_NOT_VERIFIED_NOT_DURABLE', 'transport_plan_sha256': expected,
              'destination': str(destination), 'files': {n: {'bytes': r['bytes'], 'sha256': r['sha256']} for n, r in p['files'].items()},
              'required_next_step': p['required_final_gate']}
    save_new(incoming/'TRANSPORT_RESULT.json', result)
    return result


def main():
    ap = argparse.ArgumentParser(description=__doc__); sub = ap.add_subparsers(dest='command', required=True)
    x = sub.add_parser('plan'); x.add_argument('--source', required=True); x.add_argument('--build-id', required=True); x.add_argument('--batch', type=int, required=True); x.add_argument('--out', required=True)
    for command in ('emit', 'begin', 'assemble'):
        x = sub.add_parser(command); x.add_argument('--plan', required=True); x.add_argument('--plan-sha256', required=True)
        if command == 'emit':
            x.add_argument('--file', choices=FILES, required=True); x.add_argument('--chunk', type=int, required=True); x.add_argument('--piece', type=int, required=True)
    a = ap.parse_args()
    if a.command == 'plan': result = plan(a.source, a.build_id, a.batch, a.out)
    elif a.command == 'emit':
        print(emit(a.plan, a.plan_sha256, a.file, a.chunk, a.piece), end=''); return
    elif a.command == 'begin': result = begin(a.plan, a.plan_sha256)
    else: result = assemble(a.plan, a.plan_sha256)
    print(json.dumps(result, sort_keys=True))


if __name__ == '__main__':
    main()
