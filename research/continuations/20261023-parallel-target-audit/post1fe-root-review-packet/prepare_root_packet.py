#!/usr/bin/env python3
"""Revalidate an immutable research inventory and prepare its exact 90-path packet.

This writes only its own review manifest and pathlist. No staging, commit, push,
canonical source change, inventory refresh or Lean/checker command is performed.
"""
import ast
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess

REPO = Path('/Users/tp/Lean/D1Bound5')
BASE = '1fe0adf1028af0e41ea578660c8d48875cde6588'
OWNED = 'research/continuations/20261023-parallel-target-audit/'
INVENTORY = OWNED + 'post1fe-reviewed-evidence-inventory/'
OUT = REPO / (OWNED + 'post1fe-root-review-packet')
PINS = {
    'INVENTORY_MANIFEST.json': 'e2da8041182693111cb08f110aea87e3cba3ea27ac2829384c3e06e9f4cf9687',
    'NEW_REVIEWED_PATHS.txt': '6f0509d8a55746244c2628bd68fc36e3df17387509f73580cf6f32a6804dbc97',
    'OWNER_SCOPES.json': '1e0343453575c4b6f1a7e4bad6708905d09d7939b797e689aaf2fe91d82ca333',
    'prepare_inventory.py': '964851fd405f049d49454887bf24682175ba3ad17d4a1e43d7d057f032aa354d',
}
LIMIT = 5 * 1024 * 1024
SUFFIXES = {'.json', '.jsonfrag', '.jsonl', '.md', '.txt', '.py', '.lean', '.log',
            '.patch', '.diff', '.toml', '.yml', '.yaml', '.csv', '.sh', '.cpp', '.h'}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(test, message):
    if not test:
        raise RuntimeError(message)


def relative(text):
    require(isinstance(text, str), 'Non-string path')
    p = PurePosixPath(text)
    require(not p.is_absolute() and '..' not in p.parts and p.as_posix() == text
            and '\n' not in text and '\r' not in text, 'Unsafe relative path')
    return p


def omitted_kind(path):
    n = path.name.lower()
    if n.endswith('.b64') or re.search(r'\.part(?:[.0-9_-].*)?$', n):
        return 'TRANSPORT_EXCLUDED'
    if any(n.endswith(x) for x in ['.tar', '.gz', '.zip', '.xz', '.zst', '.bz2', '.7z']):
        return 'ARCHIVE_EXCLUDED'
    if '__pycache__' in path.parts or n.endswith('.pyc') or n == '.ds_store':
        return 'CACHE_EXCLUDED'
    if re.search(r'\.(?:olean|ilean|ir)(?:\..*)?$', n):
        return 'PROOF_ARTIFACT_EXCLUDED'
    return 'UNEXPECTED_NOT_OWNER_ALLOWLISTED'


def main():
    env = dict(os.environ, GIT_OPTIONAL_LOCKS='0')

    def git(*words):
        return subprocess.check_output(['git', '-C', str(REPO)] + list(words),
                                       env=env, stderr=subprocess.PIPE)

    require(git('rev-parse', '--show-toplevel').decode().strip() == str(REPO), 'Wrong Git root')
    require(git('rev-parse', 'HEAD').decode().strip() == BASE, 'HEAD differs from reviewed base')
    require(git('diff-index', '--cached', '--name-only', '-z', BASE, '--') == b'', 'Index is not empty')
    index = Path(git('rev-parse', '--git-path', 'index').decode().strip())
    if not index.is_absolute():
        index = REPO / index
    index_hash = sha(index.read_bytes()) if index.exists() else None
    fmt = git('rev-parse', '--show-object-format').decode().strip()
    require(fmt in {'sha1', 'sha256'}, 'Unknown Git object format')
    blobs = {}
    for row in git('ls-tree', '-r', '-z', BASE).split(b'\0'):
        if row:
            meta, name = row.split(b'\t', 1)
            mode, kind, oid = meta.decode().split()
            blobs[name.decode()] = (mode, kind, oid)
    policy = REPO / 'scripts/git_sync_preflight.py'
    policy_raw = policy.read_bytes()
    nodes = [n.value for n in ast.parse(policy_raw).body if isinstance(n, ast.Assign)
             and any(isinstance(t, ast.Name) and t.id == 'TOKEN_PATTERNS' for t in n.targets)]
    require(len(nodes) == 1, 'Canonical credential policy missing or ambiguous')
    patterns = [re.compile(x) for x in ast.literal_eval(nodes[0])]
    captured = {}

    def read(name, expected=None, size=None):
        path = REPO / relative(name)
        require(name.startswith('research/'), 'Selected path outside research')
        require(not any(p.is_symlink() for p in [path] + list(path.parents)), 'Symlink path: ' + name)
        require(path.is_file() and path.suffix.lower() in SUFFIXES, 'Missing or non-text file: ' + name)
        data = path.read_bytes()
        require(len(data) <= LIMIT, 'File exceeds 5 MiB: ' + name)
        text = data.decode('utf-8')
        require('\0' not in text, 'NUL in text: ' + name)
        require(not any(p.search(text) for p in patterns), 'Credential-shaped match; value withheld: ' + name)
        digest = sha(data)
        require(expected is None or digest == expected, 'Hash mismatch: ' + name)
        require(size is None or len(data) == size, 'Size mismatch: ' + name)
        row = {'sha256': digest, 'bytes': len(data)}
        require(name not in captured or captured[name] == row, 'File changed during validation: ' + name)
        captured[name] = row
        return data

    metadata = {INVENTORY + n: read(INVENTORY + n, expected) for n, expected in PINS.items()}
    manifest = json.loads(metadata[INVENTORY + 'INVENTORY_MANIFEST.json'])
    scope = json.loads(metadata[INVENTORY + 'OWNER_SCOPES.json'])
    require(manifest['base_commit'] == scope['base_commit'] == BASE, 'Inventory base mismatch')
    require(manifest['owner_scope_sha256'] == PINS['OWNER_SCOPES.json'], 'Scope provenance mismatch')
    require(manifest['inventory_preparer_sha256'] == PINS['prepare_inventory.py'], 'Preparer provenance mismatch')
    require(manifest['policy']['sha256'] == sha(policy_raw), 'Credential policy changed since inventory')
    new = manifest['new_or_modified']
    old = manifest['already_at_base']
    require(len(new) == 86 and len(old) == 40 and not set(new).intersection(old), 'Unexpected inventory counts')
    inventory_paths = metadata[INVENTORY + 'NEW_REVIEWED_PATHS.txt'].decode().splitlines()
    require(len(inventory_paths) == len(set(inventory_paths)) == 86 and set(inventory_paths) == set(new),
            'Inventory pathlist mismatch')
    all_files = dict(old, **new)
    for name, row in all_files.items():
        raw = read(name, row['sha256'], row['bytes'])
        blob = hashlib.new(fmt, b'blob ' + str(len(raw)).encode() + b'\0' + raw).hexdigest()
        prior = blobs.get(name)
        at_base = bool(prior and prior[1] == 'blob' and prior[2] == blob)
        require(blob == row['git_blob_oid'] and at_base == (name in old), 'Git blob classification mismatch: ' + name)
    receipts, current_excluded = [], []
    for package in scope['packages']:
        root = package['root']
        allowed = set()
        for receipt in package.get('receipts', []):
            name = root + '/' + str(relative(receipt['name']))
            raw = read(name, receipt.get('sha256'))
            allowed.add(name)
            obj = json.loads(raw)
            table = obj[receipt['key']] if receipt.get('key') else obj
            require(isinstance(table, dict), 'Invalid owner receipt table: ' + name)
            for child, value in table.items():
                child_name = root + '/' + str(relative(child))
                expected = value['sha256'] if isinstance(value, dict) else value
                size = value.get('bytes') if isinstance(value, dict) else None
                require(isinstance(expected, str) and re.fullmatch('[0-9a-f]{64}', expected), 'Invalid owner hash')
                read(child_name, expected, size)
                allowed.add(child_name)
            receipts.append({'path': name, 'sha256': sha(raw), 'verified_entries': len(table)})
        for explicit in package.get('explicit_files', []):
            name = root + '/' + str(relative(explicit['name']))
            read(name, explicit.get('sha256'))
            allowed.add(name)
        require(allowed == {n for n, row in all_files.items() if row['package'] == package['label']},
                'Package inventory allowlist mismatch: ' + package['label'])
        if package.get('stage_pathfile'):
            name = root + '/' + str(relative(package['stage_pathfile']))
            listed = read(name).decode().splitlines()
            require(len(listed) == len(set(listed)) and set(listed) == allowed, 'Owner stage allowlist mismatch')
        for path in sorted((REPO / relative(root)).rglob('*')) if package.get('scan_unlisted', True) else []:
            name = path.relative_to(REPO).as_posix()
            if path.is_symlink():
                current_excluded.append({'path': name, 'reason': 'SYMLINK_EXCLUDED'})
            elif path.is_file() and name not in allowed:
                current_excluded.append({'path': name, 'reason': omitted_kind(path)})
    require(current_excluded == manifest['excluded_unlisted_files'], 'Package has new or changed unlisted files')
    require(len(current_excluded) == 7 and all(x['reason'] == 'TRANSPORT_EXCLUDED' for x in current_excluded),
            'Unexpected excluded package content')
    selected = {name: captured[name] for name in sorted(set(new) | set(metadata))}
    require(len(selected) == 90, 'Root packet is not exactly 90 paths')
    for name, row in captured.items():
        require(sha((REPO / name).read_bytes()) == row['sha256'], 'Input changed before completion: ' + name)
    require(policy.read_bytes() == policy_raw, 'Canonical policy changed')
    require(git('rev-parse', 'HEAD').decode().strip() == BASE, 'HEAD changed')
    require(git('diff-index', '--cached', '--name-only', '-z', BASE, '--') == b'', 'Index no longer empty')
    require((sha(index.read_bytes()) if index.exists() else None) == index_hash, 'Raw index changed')
    report = {
        'schema': 1, 'status': 'EXACT_90_PATH_RESEARCH_CHECKPOINT_READY_FOR_ROOT_REVIEW_ONLY',
        'utc': datetime.now(timezone.utc).isoformat(), 'expected_head': BASE,
        'index_empty_before_after': True, 'raw_index_sha256_before_after': index_hash,
        'payload_count': 86, 'inventory_metadata_count': 4, 'path_count': 90,
        'total_bytes': sum(x['bytes'] for x in selected.values()), 'files': selected,
        'four_inventory_metadata_paths': sorted(metadata), 'owner_receipts_revalidated': receipts,
        'already_at_base_revalidated_count': 40, 'unchanged_historical_inventory_sha256': PINS['INVENTORY_MANIFEST.json'],
        'policy': {'path': 'scripts/git_sync_preflight.py', 'sha256': sha(policy_raw), 'strict_utf8': True,
                   'max_file_bytes': LIMIT, 'credential_pattern_count': len(patterns), 'no_symlinks': True},
        'excluded_known_transports': current_excluded,
        'optional_prior_push_receipt_included': False, 'mutable_current_progress_included': False,
        'final_proof_gate_status': 'PENDING_NOT_CLAIMED_BY_THIS_RESEARCH_CHECKPOINT',
        'historical_preparation_statuses_preserved_unchanged': True,
        'not_in_scope': ['final build/audit/kernel result capture', 'actual preservation of 353 sources',
                         'canonical installation', 'handoff updates', 'Git mutation'],
        'mutations': {'git': False, 'canonical_sources': False, 'inventory': False, 'runtime': False,
                      'Lean_or_checker_execution': False},
        'packet_metadata_not_in_stage_list': ['prepare_root_packet.py', 'ROOT_REVIEW_MANIFEST.json', 'STAGE_PATHS.txt'],
        'root_action_required': 'Review exact file hashes, stage only the 90 listed paths, recheck staged hashes and run canonical private Git preflight before any commit or push.'}
    OUT.mkdir(parents=True, exist_ok=True)
    report_path = OUT / 'ROOT_REVIEW_MANIFEST.json'
    pathfile = OUT / 'STAGE_PATHS.txt'
    report_path.write_text(json.dumps(report, indent=2, sort_keys=True) + '\n')
    pathfile.write_text(''.join(name + '\n' for name in selected))
    for p in [report_path, pathfile]:
        read(p.relative_to(REPO).as_posix())
    print(json.dumps({'status': report['status'], 'paths': 90, 'bytes': report['total_bytes'],
                      'manifest_sha256': sha(report_path.read_bytes()),
                      'pathfile_sha256': sha(pathfile.read_bytes()),
                      'inventory_metadata_paths': sorted(metadata), 'owner_receipts': len(receipts),
                      'owner_entries_checked': sum(x['verified_entries'] for x in receipts),
                      'head': BASE, 'index_empty': True}, indent=2))


if __name__ == '__main__':
    main()
