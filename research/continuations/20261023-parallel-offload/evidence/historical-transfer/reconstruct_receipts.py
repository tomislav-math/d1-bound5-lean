#!/usr/bin/env python3
"""Losslessly recover original import-receipt JSON bytes from shared text tables.
This reconstructs evidence only; it does not accept a build or check a proof.
"""
import argparse
import hashlib
import json
from pathlib import Path


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def read_manifest(path):
    if path.is_dir():
        index = json.loads((path / 'INDEX.json').read_text())
        pieces = []
        for row in index['parts']:
            raw = (path / row['file']).read_bytes()
            assert len(raw) == row['bytes'] and digest(raw) == row['sha256']
            pieces.append(raw)
        raw = b''.join(pieces)
        assert len(raw) == index['original_bytes'] and digest(raw) == index['original_sha256']
    else:
        raw = path.read_bytes()
    return digest(raw), json.loads(raw)


def reconstruct(archive, manifest_paths, out=None):
    index = json.loads((archive / 'INDEX.json').read_text())
    for relative, expected in index['files'].items():
        assert digest((archive / relative).read_bytes()) == expected, relative
    manifests = dict(read_manifest(p) for p in manifest_paths)
    rows = {h: {r['name']: r for r in d['accepted']} for h, d in manifests.items()}
    parts = json.loads((archive / 'DEPENDENCY_PARTS.json').read_text())
    external = json.loads((archive / 'EXTERNAL_IMPORTS.json').read_text())
    count = 0
    for filename, expected in index['original_receipts'].items():
        packed = json.loads((archive / 'records' / filename).read_text())
        record = packed['record']
        n, h = record['name'], record['export_manifest_sha256']
        manifest, original = manifests[h], rows[h][n]
        source = original['source_closure']
        record['source_closure'] = source
        record['historical_acceptance'] = original
        record['remote_configuration'] = manifest['configuration']
        record['historical_dependency_acceptance'] = {
            x: manifest['dependency_acceptance'][x] for x in source}
        dependencies = set(source) - {n}
        record['dependency_artifact_parts'] = {x: parts[x] for x in dependencies}
        record['dependency_artifacts'] = {}
        for x in dependencies:
            matches = [v for p, v in parts[x].items() if p.endswith('/' + x + '.olean')]
            assert len(matches) == 1, x
            record['dependency_artifacts'][x] = matches[0]
        record['external_import_artifacts'] = {x: external[x] for x in packed['external_names']}
        raw = (json.dumps(record, indent=2, sort_keys=True) + '\n').encode()
        assert digest(raw) == expected == packed['original_sha256'], filename
        if out is not None:
            out.mkdir(parents=True, exist_ok=True)
            (out / filename).write_bytes(raw)
        count += 1
    return count


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--archive', type=Path, required=True)
    ap.add_argument('--manifest', type=Path, action='append', required=True)
    ap.add_argument('--out', type=Path)
    args = ap.parse_args()
    print('EXACT_RECEIPT_RECONSTRUCTION_PASS', reconstruct(args.archive, args.manifest, args.out))
