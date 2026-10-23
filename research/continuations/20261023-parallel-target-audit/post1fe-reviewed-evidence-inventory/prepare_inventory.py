#!/usr/bin/env python3
"""Read-only inventory of explicitly reviewed research packages; never stages Git."""
import argparse
import ast
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess

LIMIT = 5 * 1024 * 1024
TEXT_SUFFIXES = {'.json', '.jsonfrag', '.jsonl', '.md', '.txt', '.py', '.lean', '.log',
                 '.patch', '.diff', '.toml', '.yml', '.yaml', '.csv', '.sh', '.cpp', '.h'}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(test, message):
    if not test:
        raise RuntimeError(message)


def safe_relative(text):
    p = PurePosixPath(text)
    require(isinstance(text, str) and not p.is_absolute() and '..' not in p.parts
            and p.as_posix() == text and '\n' not in text and '\r' not in text,
            'Invalid relative path')
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
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--repo', type=Path, required=True)
    ap.add_argument('--scope', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    args = ap.parse_args()
    repo, out = args.repo.resolve(), args.out.resolve()
    out.relative_to(repo / 'research/continuations/20261023-parallel-target-audit')
    out.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, GIT_OPTIONAL_LOCKS='0')

    def git(*words):
        return subprocess.check_output(['git', '-C', str(repo)] + list(words),
                                       env=env, stderr=subprocess.PIPE)

    require(Path(git('rev-parse', '--show-toplevel').decode().strip()).resolve() == repo,
            'Wrong repository root')
    scope_raw = args.scope.read_bytes()
    scope = json.loads(scope_raw)
    base = git('rev-parse', scope['base_commit'] + '^{commit}').decode().strip()
    head = git('rev-parse', 'HEAD').decode().strip()
    require(head == base, 'HEAD differs from requested inventory base')
    fmt = git('rev-parse', '--show-object-format').decode().strip()
    require(fmt in {'sha1', 'sha256'}, 'Unsupported Git format')
    index = Path(git('rev-parse', '--git-path', 'index').decode().strip())
    if not index.is_absolute():
        index = repo / index
    index_hash = sha(index.read_bytes()) if index.exists() else None
    base_blobs = {}
    for row in git('ls-tree', '-r', '-z', base).split(b'\0'):
        if row:
            info, path = row.split(b'\t', 1)
            mode, kind, oid = info.decode().split()
            base_blobs[path.decode()] = {'mode': mode, 'kind': kind, 'oid': oid}

    policy = repo / 'scripts/git_sync_preflight.py'
    policy_raw = policy.read_bytes()
    nodes = [n.value for n in ast.parse(policy_raw).body if isinstance(n, ast.Assign)
             and any(isinstance(t, ast.Name) and t.id == 'TOKEN_PATTERNS' for t in n.targets)]
    require(len(nodes) == 1, 'Credential policy not uniquely found')
    patterns = [re.compile(x) for x in ast.literal_eval(nodes[0])]
    all_files, package_rows, unexpected = {}, [], []

    def read(path):
        rel = path.relative_to(repo).as_posix()
        require(rel.startswith('research/'), 'Selected file escaped research')
        require(not any(p.is_symlink() for p in [path] + list(path.parents)),
                'Selected symlink path: ' + rel)
        require(path.is_file(), 'Missing selected file: ' + rel)
        require(path.suffix.lower() in TEXT_SUFFIXES, 'Unreviewed selected extension: ' + rel)
        data = path.read_bytes()
        require(len(data) <= LIMIT, 'Selected text exceeds 5 MiB: ' + rel)
        text = data.decode('utf-8')
        require('\0' not in text, 'NUL in selected text: ' + rel)
        require(not any(p.search(text) for p in patterns),
                'Credential-shaped content; value withheld: ' + rel)
        return rel, data

    def capture(path, label, expected=None):
        rel, data = read(path)
        digest = sha(data)
        if expected is not None:
            require(digest == expected, 'Owner hash mismatch: ' + rel)
        blob = hashlib.new(fmt, b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()
        old = base_blobs.get(rel)
        change = ('UNCHANGED_AT_BASE' if old and old['kind'] == 'blob' and old['oid'] == blob
                  else 'MODIFIED_SINCE_BASE' if old else 'NEW_SINCE_BASE')
        row = {'sha256': digest, 'bytes': len(data), 'package': label, 'git_blob_oid': blob,
               'base_blob_oid': old['oid'] if old else None, 'change': change}
        require(rel not in all_files or all_files[rel] == row, 'Conflicting package overlap: ' + rel)
        all_files[rel] = row
        return rel, data

    for pkg in scope['packages']:
        root = repo / safe_relative(pkg['root'])
        require(root.is_dir() and not root.is_symlink(), 'Missing/symlink package root')
        allowed, checks = set(), []
        for receipt in pkg.get('receipts', []):
            path = root / safe_relative(receipt['name'])
            rel, raw = capture(path, pkg['label'], receipt.get('sha256'))
            allowed.add(rel)
            obj = json.loads(raw)
            table = obj[receipt['key']] if receipt.get('key') else obj
            require(isinstance(table, dict), 'Expected per-file owner hash table: ' + rel)
            for name, value in table.items():
                target = root / safe_relative(name)
                expected = value['sha256'] if isinstance(value, dict) else value
                require(isinstance(expected, str) and re.fullmatch('[0-9a-f]{64}', expected),
                        'Invalid owner hash value: ' + rel)
                target_rel, data = capture(target, pkg['label'], expected)
                if isinstance(value, dict) and 'bytes' in value:
                    require(len(data) == value['bytes'], 'Owner byte count mismatch: ' + target_rel)
                allowed.add(target_rel)
            checks.append({'path': rel, 'sha256': sha(raw), 'entries': len(table),
                           'declared_status': obj.get('status')})
        for item in pkg.get('explicit_files', []):
            rel, _ = capture(root / safe_relative(item['name']), pkg['label'], item.get('sha256'))
            allowed.add(rel)
        if pkg.get('stage_pathfile'):
            stage_path = root / safe_relative(pkg['stage_pathfile'])
            _, raw = read(stage_path)
            paths = raw.decode().splitlines()
            require(len(paths) == len(set(paths)), 'Duplicate owner stage path')
            for p in paths:
                safe_relative(p)
            require(set(paths) == allowed, 'Owner stage allowlist differs from receipt-selected set')
        for path in sorted(root.rglob('*')) if pkg.get('scan_unlisted', True) else []:
            if path.is_symlink():
                unexpected.append({'path': path.relative_to(repo).as_posix(), 'reason': 'SYMLINK_EXCLUDED'})
            elif path.is_file() and path.relative_to(repo).as_posix() not in allowed:
                unexpected.append({'path': path.relative_to(repo).as_posix(), 'reason': omitted_kind(path)})
        package_rows.append({'label': pkg['label'], 'root': pkg['root'], 'files': len(allowed),
                             'receipts': checks, 'stage_pathfile_verified': pkg.get('stage_pathfile'),
                             'scanned_package_for_unlisted_files': pkg.get('scan_unlisted', True),
                             'reviewed_semantics': pkg['semantics']})

    for rel, row in all_files.items():
        _, raw = read(repo / rel)
        require(sha(raw) == row['sha256'], 'Selected evidence changed during inventory: ' + rel)
    require(args.scope.read_bytes() == scope_raw, 'Owner scope changed')
    require(policy.read_bytes() == policy_raw, 'Canonical policy changed')
    require(git('rev-parse', 'HEAD').decode().strip() == head, 'HEAD changed')
    require((sha(index.read_bytes()) if index.exists() else None) == index_hash, 'Git index changed')
    new = {p: x for p, x in all_files.items() if x['change'] != 'UNCHANGED_AT_BASE'}
    old = {p: x for p, x in all_files.items() if x['change'] == 'UNCHANGED_AT_BASE'}
    manifest = {
        'schema': 1, 'status': 'REVIEWED_RESEARCH_INVENTORY_ONLY_NOT_STAGED_OR_FINAL_ACCEPTANCE',
        'utc': datetime.now(timezone.utc).isoformat(), 'base_commit': base, 'head_before_after': head,
        'git_index_sha256_before_after': index_hash, 'owner_scope_sha256': sha(scope_raw),
        'inventory_preparer_sha256': sha(Path(__file__).read_bytes()),
        'packages': package_rows, 'new_or_modified': new, 'already_at_base': old,
        'excluded_unlisted_files': unexpected,
        'counts': {'reviewed': len(all_files), 'new_or_modified': len(new), 'already_at_base': len(old),
                   'excluded_unlisted': len(unexpected), 'new_or_modified_bytes': sum(x['bytes'] for x in new.values())},
        'policy': {'path': 'scripts/git_sync_preflight.py', 'sha256': sha(policy_raw),
                   'max_file_bytes': LIMIT, 'strict_utf8': True, 'no_symlinks': True,
                   'credential_pattern_count': len(patterns)},
        'pending_status': {'clean_source_build': 'PENDING_FINAL_SUCCESS',
                           'clean_final_118_type_axiom_and_target_audits': 'PENDING',
                           'broad_compatibility_audit': 'PENDING',
                           'fresh_kernel_replay': 'PENDING',
                           'final_result_evidence_capture': 'LATER_SEPARATE_SCOPE',
                           'preservation_of_353_sources': 'LATER_SEPARATE_SCOPE_NOT_EXECUTED_HERE',
                           'global_proof_acceptance_claim': False},
        'pending_status_scope_note': 'These are the root-supplied request-time gate states (4341/4406 source modules). This preparation inventory does not inspect later final execution results or establish their completion.',
        'mutations': {'git_index_or_history': False, 'production_sources': False,
                      'candidate_runtime': False, 'lean_or_checker_execution': False,
                      'only_written_files': ['INVENTORY_MANIFEST.json', 'NEW_REVIEWED_PATHS.txt']},
        'pathfile_note': 'Only owner-reviewed new/modified payload files are listed. This is an inventory, not staging authorization or a complete final publication set. The inventory metadata itself is separate.'}
    manifest_path = out / 'INVENTORY_MANIFEST.json'
    paths_path = out / 'NEW_REVIEWED_PATHS.txt'
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n')
    paths_path.write_text(''.join(p + '\n' for p in sorted(new)))
    for p in [manifest_path, paths_path]:
        read(p)
    print(json.dumps({'status': manifest['status'], 'counts': manifest['counts'],
                      'manifest_sha256': sha(manifest_path.read_bytes()),
                      'pathfile_sha256': sha(paths_path.read_bytes()),
                      'excluded_unlisted': unexpected,
                      'package_counts': {x['label']: x['files'] for x in package_rows}}, indent=2))


if __name__ == '__main__':
    main()
