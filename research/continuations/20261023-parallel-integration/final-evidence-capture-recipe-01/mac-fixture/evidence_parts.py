#!/usr/bin/env python3
"""Explicit supplemental evidence capture and full reconstruction. No proof acceptance."""
import argparse
import base64
import codecs
import datetime
import hashlib
import json
import lzma
import os
from pathlib import Path
import re
import stat
import sys
import tempfile

CHUNK = 3145728
STORED_MAX = 4249493
GIT_LIMIT = 5242880
IO = 1048576
SCOPE_MANIFEST_SHA = '77740e6172afe193fa38bb5d0e2a7ab6a97d9665d5d9232f9f4c40edb506adda'
AMENDMENT_SHA = '292dc4550335a85387727ea27e87ee0ae110f1ed3fd231487a020559aa54cb66'
SELECTION_SHA = 'f8393412f527673c27501db061e20ea0952a3736ac823b73e2406fae4a31a3de'
STATUS = 'SUPPLEMENTAL_ORIGINAL_BYTES_CAPTURED_NOT_PROOF_ACCEPTANCE'


def require(condition, message):
    if not condition:
        raise ValueError(message)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def stamp(st):
    return {k: getattr(st, k) for k in ('st_dev', 'st_ino', 'st_mode', 'st_size', 'st_mtime_ns', 'st_ctime_ns')}


def lexical_absolute(value):
    require(isinstance(value, str) and all(ord(c) >= 32 and ord(c) != 127 for c in value), 'Path must be control-free text')
    p = Path(value)
    require(p.is_absolute() and str(p) == value and '..' not in p.parts and '.' not in p.parts, 'Noncanonical absolute path')
    return p


def absolute(value, exists=True, directory=False):
    p = lexical_absolute(value)
    for q in reversed([p] + list(p.parents)):
        try:
            s = q.lstat()
        except FileNotFoundError:
            require(not exists and q == p, 'Missing path or ancestor: ' + str(q))
            continue
        require(not stat.S_ISLNK(s.st_mode), 'Symlink forbidden: ' + str(q))
        require(stat.S_ISDIR(s.st_mode) if q != p or directory else stat.S_ISREG(s.st_mode), 'Wrong file kind: ' + str(q))
    return p


def relative(value):
    require(isinstance(value, str) and value and '\\' not in value and all(ord(c) >= 32 and ord(c) != 127 for c in value), 'Bad relative path')
    p = Path(value)
    require(bool(p.parts) and not p.is_absolute() and str(p) == value and not any(x in ('.', '..') for x in p.parts), 'Unsafe relative path')
    return p


def hashfile(path):
    p = absolute(str(path)); before = stamp(p.stat())
    h = hashlib.sha256(); count = 0
    fd = os.open(str(p), os.O_RDONLY | os.O_NOFOLLOW)
    with os.fdopen(fd, 'rb') as f:
        require(stamp(os.fstat(f.fileno())) == before, 'Input changed while opening')
        while True:
            data = f.read(IO)
            if not data:
                break
            h.update(data); count += len(data)
        require(stamp(os.fstat(f.fileno())) == before, 'Input changed while hashing')
    require(stamp(absolute(str(p)).stat()) == before, 'Input replaced while hashing')
    return count, h.hexdigest(), before


def read_pinned(path, expected):
    n, h, before = hashfile(path)
    require(h == expected, 'File hash mismatch: ' + str(path))
    require(n < GIT_LIMIT, 'Index exceeds strict Git limit; explicitly split index first')
    fd = os.open(str(path), os.O_RDONLY | os.O_NOFOLLOW)
    with os.fdopen(fd, 'rb') as f:
        require(stamp(os.fstat(f.fileno())) == before, 'Input changed before reading')
        data = f.read(GIT_LIMIT)
        require(stamp(os.fstat(f.fileno())) == before, 'Input changed during reading')
    require(len(data) == n and digest(data) == h and stamp(absolute(str(path)).stat()) == before, 'Input changed while reading')
    return data


def fsync_dir(path):
    fd = os.open(str(path), os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def new_dir(path):
    p = absolute(str(path), exists=False, directory=True)
    require(not p.exists(), 'Destination already exists')
    p.mkdir(); fsync_dir(p); fsync_dir(p.parent)
    return p


def parents(path, root):
    require(path == root or root in path.parents, 'Destination escaped package')
    q = root
    for part in path.relative_to(root).parts:
        q = q / part
        if not q.exists():
            q.mkdir(); fsync_dir(q); fsync_dir(q.parent)
        absolute(str(q), directory=True)


def write_new(path, data, root):
    require(len(data) < GIT_LIMIT, 'Semantic text exceeds strict Git limit')
    parents(path.parent, root)
    fd = os.open(str(path), os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
    with os.fdopen(fd, 'wb') as f:
        f.write(data); f.flush(); os.fsync(f.fileno())
    fsync_dir(path.parent)


def json_bytes(value):
    return (json.dumps(value, sort_keys=True, indent=2, ensure_ascii=True) + '\n').encode('ascii')


def regular_inventory(root):
    root = absolute(str(root), directory=True); result = {}
    for parent, dirs, files in os.walk(str(root), followlinks=False):
        for name in dirs:
            absolute(str(Path(parent) / name), directory=True)
        for name in files:
            p = absolute(str(Path(parent) / name))
            result[p.relative_to(root).as_posix()] = stamp(p.stat())
    return result


def missing_path(value):
    p = lexical_absolute(value)
    require(not os.path.lexists(str(p)), 'Declared missing original exists')
    for parent in p.parents:
        try: entry = parent.lstat()
        except FileNotFoundError: continue
        require(stat.S_ISDIR(entry.st_mode) and not stat.S_ISLNK(entry.st_mode), 'Unsafe missing-original ancestor')
    return p


def valid_stat(value):
    return isinstance(value, dict) and set(value) == {'st_dev','st_ino','st_mode','st_size','st_mtime_ns','st_ctime_ns'} and all(type(v) is int for v in value.values()) and value['st_size'] >= 0 and stat.S_ISREG(value['st_mode'])


def check_plan(plan, live=True):
    require(set(plan) == {'schema', 'phase', 'label', 'files', 'missing', 'inventories'}, 'Plan keys differ')
    require(plan['schema'] == 1 and type(plan['phase']) is int and plan['phase'] in (1, 2, 3), 'Bad plan version/phase')
    require(isinstance(plan['label'], str) and re.fullmatch(r'[A-Za-z0-9_-]+', plan['label']), 'Bad label')
    require(isinstance(plan['files'], list) and plan['files'], 'Explicit files required')
    sources = set(); logical = set()
    for row in plan['files']:
        require(set(row) == {'source', 'logical', 'bytes', 'sha256', 'status'}, 'File row keys differ')
        (absolute if live else lexical_absolute)(row['source']); relative(row['logical'])
        require(row['source'] not in sources and row['logical'] not in logical, 'Duplicate original or logical path')
        sources.add(row['source']); logical.add(row['logical'])
        require(type(row['bytes']) is int and row['bytes'] >= 0 and isinstance(row['sha256'], str) and re.fullmatch('[0-9a-f]{64}', row['sha256']), 'Bad source identity')
        require(row['status'] in ('COMPLETE_ORIGINAL', 'PARTIAL_NOT_TERMINAL'), 'Original status must be explicit')
    require(isinstance(plan['missing'], list) and isinstance(plan['inventories'], list), 'Bad inventory lists')
    missing = set()
    for row in plan['missing']:
        require(set(row) == {'source', 'reason'} and isinstance(row['reason'], str) and row['reason'].strip(), 'Missing original needs reason')
        p = lexical_absolute(row['source'])
        if live: missing_path(str(p))
        require((not live or not p.exists()) and row['source'] not in sources | missing, 'Missing source exists or duplicates')
        missing.add(row['source'])
    roots = set()
    for inv in plan['inventories']:
        require(set(inv) == {'root', 'entries'} and isinstance(inv['entries'], list), 'Bad explicit directory inventory')
        root = absolute(inv['root'], directory=True) if live else lexical_absolute(inv['root']); require(str(root) not in roots, 'Duplicate inventory root'); roots.add(str(root))
        names = set()
        for row in inv['entries']:
            require(set(row) == {'path', 'disposition', 'reason'}, 'Bad inventory entry')
            relative(row['path']); require(row['path'] not in names, 'Duplicate inventory entry'); names.add(row['path'])
            require(row['disposition'] in ('include', 'exclude') and isinstance(row['reason'], str) and row['reason'].strip(), 'Each inventory disposition needs a reason')
            require(row['disposition'] != 'include' or str(root / row['path']) in sources, 'Included inventory file absent from plan')
            require(row['disposition'] != 'exclude' or str(root / row['path']) not in sources, 'Excluded inventory file also captured')
        if live: require(set(regular_inventory(root)) == names, 'Unexpected/missing terminal directory member')


def inventories(plan):
    return {x['root']: regular_inventory(Path(x['root'])) for x in plan['inventories']}


def b64encode(data):
    raw = base64.b64encode(data)
    return b''.join(raw[i:i + 76] + b'\n' for i in range(0, len(raw), 76))


def stored_blob(package, row):
    path = package / relative(row['stored_path'])
    require(type(row['stored_bytes']) is int and row['stored_bytes'] < GIT_LIMIT, 'Stored file too large')
    data = read_pinned(path, row['stored_sha256'])
    require(len(data) == row['stored_bytes'], 'Stored file length mismatch')
    return data


def reconstruct(package, row, sink):
    original_hash = hashlib.sha256(); encoded_hash = hashlib.sha256(); original_n = 0; encoded_n = 0
    encoding = row['encoding']; require(encoding in ('direct-utf8', 'raw-parts', 'xz-single-stream-preset3-crc64'), 'Unknown encoding')
    decoder = lzma.LZMADecompressor(format=lzma.FORMAT_XZ, memlimit=67108864) if encoding.startswith('xz-') else None
    def output(data):
        nonlocal original_n
        original_n += len(data); require(original_n <= row['bytes'], 'Decoded output exceeds original length')
        original_hash.update(data); sink.write(data)
    if encoding == 'direct-utf8':
        data = stored_blob(package, row['direct']); data.decode('utf-8'); require(b'\x00' not in data, 'NUL bytes require encoded parts'); output(data); encoded_n = len(data); encoded_hash.update(data)
        require(not row['parts'], 'Direct original has unexpected parts')
    else:
        require(row['direct'] is None and isinstance(row['parts'], list), 'Malformed parts')
        offset_key = 'compressed_offset' if decoder else 'raw_offset'
        for index, part in enumerate(row['parts']):
            require(set(part) == {'index', offset_key, 'decoded_bytes', 'decoded_sha256', 'stored_path', 'stored_bytes', 'stored_sha256'}, 'Part keys differ')
            require(part['index'] == index and part[offset_key] == encoded_n, 'Parts are reordered, gapped or overlapping')
            require(type(part['decoded_bytes']) is int and 0 < part['decoded_bytes'] <= CHUNK and part['stored_bytes'] <= STORED_MAX, 'Part bounds violated')
            if index < len(row['parts']) - 1:
                require(part['decoded_bytes'] == CHUNK, 'Nonfinal part is short')
            data = stored_blob(package, part)
            require(re.fullmatch(rb'(?:[A-Za-z0-9+/=]{1,76}\n)+', data) is not None, 'Base64 line format differs')
            compressed = base64.b64decode(data.replace(b'\n', b''), validate=True)
            require(b64encode(compressed) == data and len(compressed) == part['decoded_bytes'] and digest(compressed) == part['decoded_sha256'], 'Part decoded identity mismatch')
            encoded_n += len(compressed); encoded_hash.update(compressed)
            if decoder:
                require(not decoder.eof, 'Trailing or concatenated XZ stream')
                data_in = compressed
                while True:
                    chunk = decoder.decompress(data_in, max_length=min(IO, row['bytes'] - original_n + 1)); data_in = b''; output(chunk)
                    if decoder.eof:
                        require(not decoder.unused_data, 'Trailing/concatenated XZ bytes'); break
                    if decoder.needs_input:
                        break
            else:
                output(compressed)
        if decoder:
            require(decoder.eof and not decoder.unused_data and decoder.check == lzma.CHECK_CRC64, 'Incomplete/non-CRC64/multiple XZ stream')
            require(encoded_n < row['bytes'], 'XZ selected without size benefit')
    require(encoded_n == row['encoded_bytes'] and encoded_hash.hexdigest() == row['encoded_sha256'], 'Encoded whole identity mismatch')
    require(original_n == row['bytes'] and original_hash.hexdigest() == row['sha256'], 'Original reconstruction mismatch')
    return {'bytes': original_n, 'sha256': original_hash.hexdigest()}


def protect_destination(target, plan, extra):
    protected = [lexical_absolute(str(x)) for x in extra]
    protected += [lexical_absolute(x['source']) for x in plan['files'] + plan['missing']]
    protected += [lexical_absolute(x['root']) for x in plan['inventories']]
    for original in protected:
        require(target != original and target not in original.parents and original not in target.parents,
                'Destination overlaps a protected input: ' + str(original))


def capture(plan_path, plan_sha, output):
    recipe_before = hashfile(Path(__file__))
    raw_plan = read_pinned(plan_path, plan_sha); plan = json.loads(raw_plan); check_plan(plan)
    before_inv = inventories(plan)
    output = absolute(str(output), exists=False, directory=True)
    protect_destination(output, plan, [plan_path, Path(__file__)])
    package = new_dir(output); write_new(package / 'PLAN.json', raw_plan, package)
    rows = []
    for index, source in enumerate(plan['files']):
        path = absolute(source['source']); pre = stamp(path.stat()); h = hashlib.sha256(); n = 0
        with tempfile.TemporaryFile(dir=str(package)) as raw, tempfile.TemporaryFile(dir=str(package)) as compressed:
            compressor = lzma.LZMACompressor(format=lzma.FORMAT_XZ, check=lzma.CHECK_CRC64, preset=3) if plan['phase'] in (2, 3) and source['bytes'] >= GIT_LIMIT else None
            fd = os.open(str(path), os.O_RDONLY | os.O_NOFOLLOW)
            with os.fdopen(fd, 'rb') as original:
                require(stamp(os.fstat(original.fileno())) == pre, 'Original changed while opening')
                while True:
                    data = original.read(IO)
                    if not data: break
                    h.update(data); n += len(data); raw.write(data)
                    if compressor: compressed.write(compressor.compress(data))
                require(stamp(os.fstat(original.fileno())) == pre, 'Original changed during capture')
            if compressor: compressed.write(compressor.flush())
            require(n == source['bytes'] and h.hexdigest() == source['sha256'], 'Original differs from explicit plan')
            post_n, post_hash, post = hashfile(path)
            require(pre == post and post_n == n and post_hash == h.hexdigest(), 'Original changed after capture')
            row = dict(source); row.update(original_pre_stat=pre, original_post_stat=post, capture_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), direct=None, parts=[], roundtrip_original_bytes_and_sha_verified=False)
            raw.seek(0); direct = raw.read(GIT_LIMIT) if n < GIT_LIMIT else None
            if direct is not None:
                try: direct.decode('utf-8')
                except UnicodeDecodeError: direct = None
                if direct is not None and b'\x00' in direct: direct = None
            if direct is not None:
                stored = 'files/' + source['logical']; write_new(package / stored, direct, package)
                row.update(encoding='direct-utf8', encoded_bytes=n, encoded_sha256=h.hexdigest(), direct={'stored_path':stored, 'stored_bytes':n, 'stored_sha256':h.hexdigest()})
            else:
                use_xz = compressor is not None and compressed.tell() < n
                stream = compressed if use_xz else raw; stream.seek(0); enc_hash = hashlib.sha256(); offset = 0
                row['encoding'] = 'xz-single-stream-preset3-crc64' if use_xz else 'raw-parts'
                if use_xz: row['compressor'] = {'implementation':'Python standard-library lzma', 'python_version':sys.version, 'preset':3, 'check':'CRC64'}
                while True:
                    data = stream.read(CHUNK)
                    if not data: break
                    encoded = b64encode(data); require(len(encoded) <= STORED_MAX, 'Encoded part too large')
                    stored = 'parts/%06d/part-%06d.b64' % (index, len(row['parts'])); write_new(package / stored, encoded, package)
                    part = {'index':len(row['parts']), 'compressed_offset' if use_xz else 'raw_offset':offset, 'decoded_bytes':len(data), 'decoded_sha256':digest(data), 'stored_path':stored, 'stored_bytes':len(encoded), 'stored_sha256':digest(encoded)}
                    row['parts'].append(part); offset += len(data); enc_hash.update(data)
                row.update(encoded_bytes=offset, encoded_sha256=enc_hash.hexdigest())
            with tempfile.TemporaryFile(dir=str(package)) as trial: reconstruct(package, row, trial)
            row['roundtrip_original_bytes_and_sha_verified'] = True; rows.append(row)
    check_plan(plan); after_inv = inventories(plan); require(before_inv == after_inv, 'Terminal directory inventory changed')
    for row in rows:
        n, h, st = hashfile(row['source']); require((n, h, st) == (row['bytes'], row['sha256'], row['original_pre_stat']), 'Original changed before capture committed')
    require(read_pinned(plan_path, plan_sha) == raw_plan, 'Plan changed')
    require(hashfile(Path(__file__)) == recipe_before, 'Recipe changed during capture')
    manifest = {'schema':1, 'status':STATUS, 'phase':plan['phase'], 'label':plan['label'], 'plan_sha256':plan_sha, 'recipe_sha256':recipe_before[1], 'scope_manifest_sha256':SCOPE_MANIFEST_SHA, 'amendment_sha256':AMENDMENT_SHA, 'selection_sha256':SELECTION_SHA, 'files':rows, 'missing':plan['missing'], 'inventories_before':before_inv, 'inventories_after':after_inv}
    manifest_raw = json_bytes(manifest); write_new(package / 'MANIFEST.json', manifest_raw, package)
    fsync_dir(package)
    return {'status':STATUS, 'manifest_sha256':digest(manifest_raw), 'files':len(rows), 'output':str(package)}


def verify(package, manifest_sha, output):
    recipe_before = hashfile(Path(__file__))
    package = absolute(str(package), directory=True); raw = read_pinned(package / 'MANIFEST.json', manifest_sha); manifest = json.loads(raw)
    require(set(manifest) == {'schema','status','phase','label','plan_sha256','recipe_sha256','scope_manifest_sha256','amendment_sha256','selection_sha256','files','missing','inventories_before','inventories_after'}, 'Manifest keys differ')
    require(manifest['recipe_sha256'] == recipe_before[1], 'Reconstructor is not the captured recipe')
    require(manifest['schema'] == 1 and manifest['status'] == STATUS, 'Not a supplemental bytes manifest')
    require(manifest['scope_manifest_sha256'] == SCOPE_MANIFEST_SHA and manifest['amendment_sha256'] == AMENDMENT_SHA and manifest['selection_sha256'] == SELECTION_SHA, 'Wrong selected archival format')
    plan_raw = read_pinned(package / 'PLAN.json', manifest['plan_sha256']); plan = json.loads(plan_raw); check_plan(plan, live=False)
    require(manifest['phase'] == plan['phase'] and manifest['label'] == plan['label'] and manifest['missing'] == plan['missing'], 'Manifest/plan scope mismatch')
    require(manifest['inventories_before'] == manifest['inventories_after'], 'Original inventory changed')
    inventory_map = manifest['inventories_before']
    require(isinstance(inventory_map, dict) and set(inventory_map) == {x['root'] for x in plan['inventories']}, 'Recorded inventory roots differ from explicit plan')
    for inv in plan['inventories']:
        members = inventory_map[inv['root']]
        require(isinstance(members, dict) and set(members) == {x['path'] for x in inv['entries']} and all(valid_stat(v) for v in members.values()), 'Recorded inventory members/stat differ from explicit plan')
    require(len(manifest['files']) == len(plan['files']), 'Original omitted or added')
    expected = {'PLAN.json', 'MANIFEST.json'}
    for original_index, (row, planned) in enumerate(zip(manifest['files'], plan['files'])):
        keys = {'source','logical','bytes','sha256','status','original_pre_stat','original_post_stat','capture_utc','direct','parts','roundtrip_original_bytes_and_sha_verified','encoding','encoded_bytes','encoded_sha256'}
        if row['encoding'] == 'xz-single-stream-preset3-crc64': keys.add('compressor')
        require(set(row) == keys, 'Original record keys differ')
        require({k:row[k] for k in planned} == planned and row['original_pre_stat'] == row['original_post_stat'] and row['roundtrip_original_bytes_and_sha_verified'] is True, 'Captured original identity/snapshot mismatch')
        relative(row['logical']); require(type(row['bytes']) is int and row['bytes'] >= 0, 'Bad original size')
        st = row['original_pre_stat']; require(valid_stat(st) and st['st_size'] == row['bytes'], 'Bad original capture stat')
        for inv in plan['inventories']:
            root = Path(inv['root']); src = Path(row['source'])
            if root in src.parents:
                require(inventory_map[str(root)][src.relative_to(root).as_posix()] == st, 'Included original stat differs from terminal inventory')
        if row['encoding'] == 'xz-single-stream-preset3-crc64':
            compressor = row['compressor']
            require(set(compressor) == {'implementation','python_version','preset','check'} and compressor['implementation'] == 'Python standard-library lzma' and isinstance(compressor['python_version'], str) and compressor['python_version'] and type(compressor['preset']) is int and compressor['preset'] == 3 and compressor['check'] == 'CRC64', 'Compressor metadata differs from selected encoding')
        require(type(row['encoded_bytes']) is int and row['encoded_bytes'] >= 0 and re.fullmatch('[0-9a-f]{64}', row['encoded_sha256']), 'Bad encoded identity')
        if row['direct']:
            require(set(row['direct']) == {'stored_path','stored_bytes','stored_sha256'} and row['direct']['stored_path'] == 'files/' + row['logical'], 'Direct path differs from logical original')
        else:
            for part_index, part in enumerate(row['parts']):
                require(part['stored_path'] == 'parts/%06d/part-%06d.b64' % (original_index, part_index), 'Part path differs from ordered original')
        require(row['encoding'] != 'xz-single-stream-preset3-crc64' or plan['phase'] in (2, 3), 'XZ is not selected for phase1')
        paths = [row['direct']['stored_path']] if row['direct'] else [x['stored_path'] for x in row['parts']]
        for path in paths:
            relative(path); require(path not in expected, 'Duplicate package payload'); expected.add(path)
    inv = regular_inventory(package); require(set(inv) == expected, 'Unexpected or missing package file')
    target = absolute(str(output), exists=False, directory=True)
    protect_destination(target, plan, [package, Path(__file__)])
    target = new_dir(target); originals = []
    for row in manifest['files']:
        dst = target / 'originals' / relative(row['logical']); parents(dst.parent, target)
        fd = os.open(str(dst), os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600)
        with os.fdopen(fd, 'wb') as sink:
            result = reconstruct(package, row, sink); sink.flush(); os.fsync(sink.fileno())
        fsync_dir(dst.parent); require(hashfile(dst)[:2] == (row['bytes'], row['sha256']), 'Reconstructed destination readback differs')
        originals.append({'logical':row['logical'], 'source':row['source'], 'status':row['status'], 'restored_path':str(dst), **result})
    require(inv == regular_inventory(package), 'Package changed during reconstruction')
    require(read_pinned(package / 'MANIFEST.json', manifest_sha) == raw and read_pinned(package / 'PLAN.json', manifest['plan_sha256']) == plan_raw, 'Index changed during reconstruction')
    require(hashfile(Path(__file__)) == recipe_before, 'Recipe changed during reconstruction')
    receipt = {'schema':1, 'status':'FULL_ORIGINAL_BYTES_RECONSTRUCTED_NOT_PROOF_ACCEPTANCE', 'manifest_sha256':manifest_sha, 'recipe_sha256':recipe_before[1], 'originals':originals, 'missing':manifest['missing'], 'utc':datetime.datetime.now(datetime.timezone.utc).isoformat()}
    receipt_raw = json_bytes(receipt); write_new(target / 'RECONSTRUCTION.json', receipt_raw, target); fsync_dir(target)
    return {'status':receipt['status'], 'receipt_sha256':digest(receipt_raw), 'output':str(target), 'files':len(originals)}


def main():
    parser = argparse.ArgumentParser(description=__doc__); sub = parser.add_subparsers(dest='action', required=True)
    a = sub.add_parser('capture'); a.add_argument('--plan', required=True); a.add_argument('--plan-sha256', required=True); a.add_argument('--out', required=True)
    a = sub.add_parser('verify'); a.add_argument('--package', required=True); a.add_argument('--manifest-sha256', required=True); a.add_argument('--out', required=True)
    args = parser.parse_args()
    result = capture(Path(args.plan), args.plan_sha256, Path(args.out)) if args.action == 'capture' else verify(Path(args.package), args.manifest_sha256, Path(args.out))
    print(json.dumps(result, sort_keys=True))

if __name__ == '__main__':
    main()
