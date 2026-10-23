#!/usr/bin/env python3
"""Install only absent, source-matched historically accepted Mac Lean artifacts.
No Lean invocation. Does not claim fresh replay or mutate mathematical sources.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import sys
import tarfile
import time

R = Path(__file__).resolve().parent.parent
BUNDLE = R / 'historical-transfer'
sys.path.insert(0, str(R))
import guarded_general as g
_SHA_CACHE = {}


def sha(p):
    p = Path(p)
    before = p.stat()
    key = (before.st_dev, before.st_ino, before.st_size, before.st_mtime_ns, before.st_ctime_ns)
    prior = _SHA_CACHE.get(str(p))
    if prior is not None and prior[0] == key:
        return prior[1]
    h = hashlib.sha256()
    with p.open('rb') as f:
        for data in iter(lambda: f.read(1024 * 1024), b''):
            h.update(data)
    after = p.stat()
    assert key == (after.st_dev, after.st_ino, after.st_size, after.st_mtime_ns, after.st_ctime_ns), ('File changed while hashing', str(p))
    digest = h.hexdigest()
    _SHA_CACHE[str(p)] = (key, digest)
    return digest


# This process-local Python hashing optimization changes no shared runner file.
# g.closure/external use the same SHA256, refreshed on any metadata change.
g.sha = sha


def parts(n):
    base = g.artifact(n)
    return {str(p): sha(p) for p in [base, Path(str(base) + '.server'), Path(str(base) + '.private')]
            if p.is_file()}


def stage(archive, summary):
    expected = json.loads(summary.read_text())
    assert sha(archive) == expected['archive_sha256'], 'Archive checksum mismatch'
    destination = BUNDLE / 'staged'
    destination.mkdir(exist_ok=True)
    manifest = None
    allowed = {}
    seen = set()
    with tarfile.open(archive, 'r|xz') as tar:
        for member in tar:
            assert member.isfile(), ('Non-regular archive member', member.name)
            stream = tar.extractfile(member)
            if member.name == 'EXPORT_MANIFEST.json':
                assert manifest is None and not seen
                raw = stream.read()
                assert hashlib.sha256(raw).hexdigest() == expected['manifest_sha256']
                manifest = json.loads(raw)
                for row in manifest['accepted']:
                    allowed.update(row['exported_artifacts'])
                (destination / member.name).write_bytes(raw)
                continue
            assert manifest is not None
            assert member.name in allowed and member.name not in seen, member.name
            relative = Path(member.name)
            assert not relative.is_absolute() and '..' not in relative.parts
            assert relative.parts[:5] == ('.lake', 'build', 'lib', 'lean', 'D1Bound5')
            target = destination / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            h = hashlib.sha256()
            with target.open('wb') as out:
                while data := stream.read(1024 * 1024):
                    h.update(data)
                    out.write(data)
            assert h.hexdigest() == allowed[member.name], member.name
            seen.add(member.name)
    assert seen == set(allowed)
    g.save(destination / 'STAGED.json', {'status': 'STAGED_ONLY_NOT_ACCEPTED_LOCALLY',
           'archive_sha256': expected['archive_sha256'], 'manifest_sha256': expected['manifest_sha256'],
           'files': len(seen), 'modules': len(manifest['accepted'])})
    print('STAGED', len(seen), 'artifact parts', flush=True)


def install(ignore_reservations):
    destination = BUNDLE / 'staged'
    stage_record = json.loads((destination / 'STAGED.json').read_text())
    manifest_path = destination / 'EXPORT_MANIFEST.json'
    assert sha(manifest_path) == stage_record['manifest_sha256']
    manifest = json.loads(manifest_path.read_text())
    assert manifest['toolchain_file'].strip() == 'leanprover/lean4:v4.33.1'
    assert manifest['mathlib_manifest_sha256'] == json.loads((R / 'RUNTIME_SETUP.json').read_text())['mathlib_manifest_sha256']
    blocked = set()
    reservations = {}
    for f in (R / 'reservations').glob('*.json'):
        if f.name in ignore_reservations:
            continue
        d = json.loads(f.read_text())
        names = d.get('reserved_modules', [])
        blocked.update(names)
        reservations[f.name] = sorted(names)
    imported, rejected = [], {}
    # Each module's base olean is installed last; never replace existing bytes.
    for row in manifest['accepted']:
        n = row['name']
        if n in blocked:
            rejected[n] = 'ACTIVE_RESERVATION'
            continue
        if g.artifact(n).exists():
            rejected[n] = 'ALREADY_PRESENT_NOT_OVERWRITTEN'
            continue
        if g.closure(n) != row['source_closure']:
            rejected[n] = 'SOURCE_CLOSURE_CHANGED'
            continue
        key = hashlib.sha256(json.dumps(row['source_closure'], sort_keys=True).encode()).hexdigest()
        assert key == row['fingerprint']
        historical = row.get('acceptance_row') or row.get('baseline_row')
        assert historical and historical['fingerprint'] == key
        if row.get('acceptance_row'):
            assert historical.get('accepted_build') is True
        assert historical['artifacts'] == row['historical_all_artifacts']
        assert set(row['source_closure']) <= set(manifest['dependency_acceptance'])
        for dep in row['source_closure']:
            accepted = manifest['dependency_acceptance'][dep]
            assert all(row['source_closure'].get(k) == h for k, h in accepted['source_closure'].items())
        paths = sorted(row['exported_artifacts'], key=lambda p: p.endswith('.olean'))
        if any((g.P / p).exists() for p in paths):
            rejected[n] = 'EXISTING_PART_NOT_OVERWRITTEN'
            continue
        linked = []
        try:
            for relative in paths:
                source, target = destination / relative, g.P / relative
                assert sha(source) == row['exported_artifacts'][relative]
                target.parent.mkdir(parents=True, exist_ok=True)
                os.link(source, target)  # atomic refusal if a concurrent writer won
                linked.append(target)
            assert g.closure(n) == row['source_closure'], 'Source changed during import'
        except Exception:
            for p in linked:
                # Remove only our just-created hardlinks, never another writer's inode.
                source = destination / p.relative_to(g.P)
                if p.exists() and p.stat().st_ino == source.stat().st_ino:
                    p.unlink()
            raise
        imported.append(n)
    g.save(BUNDLE / 'INSTALLATION.json', {
        'status': 'INSTALLED_PENDING_RECEIPT_FINALIZATION', 'installed': imported,
        'skipped': rejected, 'ignored_inactive_reservations': sorted(ignore_reservations),
        'active_reservations': reservations, 'manifest_sha256': stage_record['manifest_sha256'],
        'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())})
    print('INSTALLED', len(imported), 'SKIPPED', len(rejected), flush=True)


def finalize():
    installation = json.loads((BUNDLE / 'INSTALLATION.json').read_text())
    destination = BUNDLE / 'staged'
    manifest_path = destination / 'EXPORT_MANIFEST.json'
    assert sha(manifest_path) == installation['manifest_sha256']
    manifest = json.loads(manifest_path.read_text())
    rows = {r['name']: r for r in manifest['accepted']}
    output = R / 'results-historical-import'
    output.mkdir(exist_ok=True)
    accepted, pending = [], {}
    for n in installation['installed']:
        row = rows[n]
        sc = g.closure(n)
        if sc != row['source_closure']:
            pending[n] = 'SOURCE_CLOSURE_CHANGED'
            continue
        if any(not g.artifact(x).exists() for x in sc):
            pending[n] = 'DEPENDENCY_ARTIFACT_MISSING'
            continue
        expected_parts = {str(g.P / p): h for p, h in row['exported_artifacts'].items()}
        if parts(n) != expected_parts:
            pending[n] = 'IMPORTED_ARTIFACT_CHANGED'
            continue
        receipt = {'name': n, 'proof_status': 'IMPORTED_HISTORICAL_ACCEPTANCE',
                   'origin': 'Mac historical accepted build; not Linux recompilation',
                   'source_closure': sc, 'artifact_sha256': sha(g.artifact(n)),
                   'artifact_parts': expected_parts,
                   'dependency_artifacts': {x: sha(g.artifact(x)) for x in sc if x != n},
                   'dependency_artifact_parts': {x: parts(x) for x in sc if x != n},
                   'external_import_artifacts': g.external(sc), 'toolchain': '4.33.1',
                   'mathlib_commit': '0df444a360eaa60ab8c11dca51a86af692955474',
                   'historical_acceptance': row,
                   'historical_dependency_acceptance': {x: manifest['dependency_acceptance'][x] for x in sc},
                   'export_manifest_path': str(manifest_path),
                   'export_manifest_sha256': installation['manifest_sha256'],
                   'remote_configuration': manifest['configuration'],
                   'source_artifact_binding': 'Exact original Mac acceptance fingerprint and artifact bytes',
                   'hash_cache_policy': 'Process-local dev/ino/size/mtime_ns/ctime_ns cache; full SHA256 refresh on change',
                   'dependency_acceptance_gate': 'Every local dependency still requires its own valid receipt',
                   'fresh_replay': 'PENDING', 'exit_code': 0,
                   'utc_import': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}
        # Refuse a source/part/dependency race during capture.
        assert g.closure(n) == sc and parts(n) == expected_parts
        assert all(sha(g.artifact(x)) == h for x, h in receipt['dependency_artifacts'].items())
        g.save(output / (n + '-receipt.json'), receipt)
        accepted.append(n)
    g.save(output / ('SUMMARY-' + BUNDLE.name + '.json'), {'status': 'IMPORTED_RECEIPTS_NOT_FINAL_PROOF',
           'accepted': accepted, 'pending': pending, 'fresh_replay': 'PENDING'})
    print('RECEIPTS', len(accepted), 'PENDING', len(pending), flush=True)


if __name__ == '__main__':
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('action', choices=['stage', 'install', 'finalize'])
    p.add_argument('--bundle-dir', type=Path, default=BUNDLE)
    p.add_argument('--archive', type=Path)
    p.add_argument('--summary', type=Path)
    p.add_argument('--ignore-inactive-reservation', action='append', default=[])
    a = p.parse_args()
    BUNDLE = a.bundle_dir.resolve()
    a.archive = a.archive or BUNDLE / 'accepted-artifacts.tar.xz'
    a.summary = a.summary or BUNDLE / 'PACKAGE_SUMMARY.json'
    if a.action == 'stage':
        stage(a.archive, a.summary)
    elif a.action == 'install':
        install(set(a.ignore_inactive_reservation))
    else:
        finalize()
