#!/usr/bin/env python3
"""Prepare a curated research-only archive proposal without changing Git/index.

Only owned archive metadata is written. Git inspection uses read-only commands
with optional locks disabled. Staging, commits, push, candidate execution and
proof acceptance are explicitly outside this tool.
"""
import argparse
import ast
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

LIMIT = 5 * 1024 * 1024
TEXT_SUFFIXES = {'.json', '.jsonfrag', '.jsonl', '.md', '.txt', '.py', '.lean', '.log',
                 '.patch', '.diff', '.toml', '.yml', '.yaml', '.csv', '.sh', '.cpp', '.h'}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def save(path, obj):
    path.write_text(json.dumps(obj, indent=2, sort_keys=True) + '\n')


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def essential_runtime_lock_part(path):
    return (path.parts[-4:-1] == ('fresh-build-runner', 'durable-clean-build-identities',
                                'runtime-lock-parts')
            and re.fullmatch(r'FRESH_RUNTIME_LOCK\.part-[0-9]{3}\.jsonfrag', path.name) is not None)


def excluded(path):
    name = path.name.lower()
    if essential_runtime_lock_part(path):
        return None
    if name.endswith('.b64') or re.search(r'\.part(?:[.0-9_-].*)?$', name):
        return 'transport'
    if any(name.endswith(s) for s in ['.tar', '.gz', '.zip', '.xz', '.zst', '.bz2', '.7z']):
        return 'binary archive'
    if re.search(r'\.(?:olean|ilean|ir)(?:\..*)?$', name):
        return 'proof artifact'
    if path.suffix.lower() in {'.o', '.so', '.dylib', '.a', '.dll', '.exe', '.pyc'} or name == '.ds_store':
        return 'binary/runtime artifact'
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--repo', type=Path, required=True)
    ap.add_argument('--scope', type=Path, required=True)
    ap.add_argument('--out', type=Path, required=True)
    ap.add_argument('--base', default='9b418')
    args = ap.parse_args()
    repo, output = args.repo.resolve(), args.out.resolve()
    output.relative_to(repo / 'research/continuations/20261023-parallel-target-audit')
    output.mkdir(parents=True, exist_ok=True)
    environment = dict(os.environ, GIT_OPTIONAL_LOCKS='0')

    def git(*words):
        return subprocess.check_output(['git', '-C', str(repo)] + list(words), env=environment,
                                       stderr=subprocess.PIPE)

    require(Path(git('rev-parse', '--show-toplevel').decode().strip()).resolve() == repo,
            'Wrong canonical repository root')
    base = git('rev-parse', args.base + '^{commit}').decode().strip()
    head = git('rev-parse', 'HEAD').decode().strip()
    require(head == base, 'Canonical HEAD changed; root must choose an updated archive base')
    git_format = git('rev-parse', '--show-object-format').decode().strip()
    require(git_format in {'sha1', 'sha256'}, 'Unsupported Git object format')
    index = Path(git('rev-parse', '--git-path', 'index').decode().strip())
    if not index.is_absolute():
        index = repo / index
    index_sha = sha(index.read_bytes()) if index.exists() else None
    old = {}
    for row in git('ls-tree', '-r', '-z', base).split(b'\0'):
        if row:
            metadata, name = row.split(b'\t', 1)
            mode, kind, oid = metadata.decode().split()
            old[name.decode()] = (mode, kind, oid)

    scanner = repo / 'scripts/git_sync_preflight.py'
    scanner_raw = scanner.read_bytes()
    tree = ast.parse(scanner_raw)
    values = [node.value for node in tree.body if isinstance(node, ast.Assign)
              and any(isinstance(t, ast.Name) and t.id == 'TOKEN_PATTERNS' for t in node.targets)]
    require(len(values) == 1, 'Could not locate canonical credential policy')
    token_patterns = [re.compile(p) for p in ast.literal_eval(values[0])]
    scope_raw = args.scope.read_bytes()
    scope = json.loads(scope_raw)
    require(scope.get('all_owner_scopes_final') is True, 'Owner archive scopes are not finalized')
    selected, excluded_rows, unchanged, scope_counts, essential_parts = {}, [], [], {}, []

    def safe_file(path):
        relative = path.relative_to(repo)
        require(str(relative).startswith('research/'), 'Archive source escaped research scope')
        require(not any(parent.is_symlink() for parent in [path] + list(path.parents)),
                'Symlink in archive path: ' + str(relative))
        require(path.is_file(), 'Missing selected archive file: ' + str(relative))
        require(path.suffix.lower() in TEXT_SUFFIXES, 'Unreviewed file type: ' + str(relative))
        data = path.read_bytes()
        require(len(data) <= LIMIT, 'Archive file exceeds 5 MiB: ' + str(relative))
        text = data.decode('utf-8')
        require('\0' not in text, 'NUL/binary content in archive text: ' + str(relative))
        require(not any(pattern.search(text) for pattern in token_patterns),
                'Credential-shaped content; value withheld: ' + str(relative))
        return relative.as_posix(), data

    for item in scope['scopes']:
        root = repo / item['path']
        require(root.exists(), 'Missing owner scope: ' + item['path'])
        require(not root.is_symlink(), 'Symlink owner scope: ' + item['path'])
        require(item['kind'] in {'directory', 'file'}, 'Invalid owner scope kind')
        paths = sorted(root.rglob('*')) if item['kind'] == 'directory' else [root]
        count = 0
        for path in paths:
            require(not path.is_symlink(), 'Symlink in owner scope: ' + str(path.relative_to(repo)))
            if path.is_dir():
                continue
            reason = excluded(path)
            if reason:
                excluded_rows.append({'path': path.relative_to(repo).as_posix(), 'reason': reason})
                continue
            relative, data = safe_file(path)
            digest = sha(data)
            blob = hashlib.new(git_format, b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()
            at_base = relative in old and old[relative][1] == 'blob' and old[relative][2] == blob
            if essential_runtime_lock_part(path):
                essential_parts.append({'path': relative, 'sha256': digest, 'bytes': len(data),
                                        'git_blob_oid': blob, 'already_byte_identical_at_base': at_base,
                                        'classification': 'ESSENTIAL_PINNED_RUNTIME_LOCK_TEXT_NOT_TRANSPORT'})
            if at_base:
                unchanged.append({'path': relative, 'sha256': digest, 'scope': item['label'],
                                  'classification': 'ESSENTIAL_PINNED_RUNTIME_LOCK_TEXT_ALREADY_AT_BASE'
                                  if essential_runtime_lock_part(path) else 'UNCHANGED_AT_BASE'})
                continue
            row = {'sha256': digest, 'bytes': len(data), 'scope': item['label'],
                   'change': 'modified' if relative in old else 'new'}
            require(relative not in selected or selected[relative]['sha256'] == digest,
                    'Conflicting owner scope contents: ' + relative)
            selected.setdefault(relative, row)
            count += 1
        scope_counts[item['label']] = count

    # Verify every owner's exact immutable hash receipt named in the curated scope.
    receipt_checks = []
    for item in scope.get('owner_receipts', []):
        receipt = repo / item['path']
        obj = json.loads(receipt.read_text())
        table = obj[item['key']] if item.get('key') else obj
        require(isinstance(table, dict), 'Invalid owner hash receipt: ' + item['path'])
        for name, expected in table.items():
            require(isinstance(expected, str) and re.fullmatch('[0-9a-f]{64}', expected),
                    'Unexpected owner receipt schema: ' + item['path'])
            target = receipt.parent / name
            target.resolve().relative_to(receipt.parent.resolve())
            relative, data = safe_file(target)
            require(sha(data) == expected, 'Owner receipt mismatch: ' + relative)
        receipt_checks.append({'path': item['path'], 'sha256': sha(receipt.read_bytes()),
                               'verified_entries': len(table)})
    for relative, expected in scope.get('expected_file_hashes', {}).items():
        name, data = safe_file(repo / relative)
        require(sha(data) == expected, 'Final owner version changed: ' + name)

    progress_relative, progress_raw = safe_file(repo / scope['current_progress'])
    require(progress_relative in selected, 'Current progress is not in selected archive')
    require(sha(progress_raw) == selected[progress_relative]['sha256'], 'Current progress changed')

    # Confirm captured files, canonical policy, scope and Git/index have not changed.
    for relative, row in selected.items():
        require(sha((repo / relative).read_bytes()) == row['sha256'], 'Archive file changed: ' + relative)
    require(args.scope.read_bytes() == scope_raw, 'Curated owner scope changed')
    require(scanner.read_bytes() == scanner_raw, 'Canonical scanner policy changed')
    require(git('rev-parse', 'HEAD').decode().strip() == head, 'Canonical HEAD changed')
    require((sha(index.read_bytes()) if index.exists() else None) == index_sha, 'Git index changed')
    pending = {
        'status': 'RESEARCH_ARCHIVE_PROPOSAL_ONLY',
        'fresh_project_source_build': 'RUNNING_OR_PENDING_FINAL_SUCCESS',
        'clean_final_mathematical_and_axiom_audits': 'NOT_YET_RUN_ON_COMPLETED_CLEAN_BUILD',
        'broad_compatibility_audit': 'PENDING',
        'fresh_installed_kernel_replay': 'NOT_STARTED_PENDING_PRIOR_GATES',
        'global_main_theorem_acceptance': False,
        'canonical_production_cleanup_or_tool_activation': 'NOT_PERFORMED_BY_THIS_ARCHIVE',
    }
    manifest = {'schema': 1, 'status': 'CURATED_RESEARCH_ARCHIVE_READY_FOR_ROOT_REVIEW',
                'utc': datetime.now(timezone.utc).isoformat(), 'base_commit': base,
                'files': selected, 'file_count': len(selected),
                'bytes': sum(x['bytes'] for x in selected.values()), 'scope_counts': scope_counts,
                'owner_receipts_revalidated': receipt_checks, 'unchanged_at_base': unchanged,
                'essential_runtime_lock_parts': essential_parts,
                'excluded_files': excluded_rows, 'pending_status': pending,
                'curated_scope_sha256': sha(scope_raw),
                'current_progress_snapshot': json.loads(progress_raw),
                'policy': {'source': 'scripts/git_sync_preflight.py', 'sha256': sha(scanner_raw),
                           'max_file_bytes': LIMIT, 'strict_utf8': True, 'no_symlinks': True,
                           'credential_pattern_count': len(token_patterns), 'no_transport_or_proof_artifacts': True},
                'git_index_sha256_before_after': index_sha, 'git_mutations': [],
                'candidate_runtime_mutations': [], 'compiler_or_kernel_commands': [],
                'derived_files': ['ARCHIVE_MANIFEST.json', 'STAGE_PATHS.txt'],
                'derived_file_note': 'These two metadata files are also in the explicit stage pathfile; they are not self-hashed in the payload manifest. Root must revalidate all hashes and run canonical staged preflight before any commit.'}
    manifest_path = output / 'ARCHIVE_MANIFEST.json'
    pathfile = output / 'STAGE_PATHS.txt'
    save(manifest_path, manifest)
    stage = sorted(set(selected) | {manifest_path.relative_to(repo).as_posix(), pathfile.relative_to(repo).as_posix()})
    pathfile.write_text(''.join(name + '\n' for name in stage))
    for path in [manifest_path, pathfile]:
        safe_file(path)
    print(json.dumps({'status': manifest['status'], 'manifest_sha256': sha(manifest_path.read_bytes()),
                      'stage_pathfile_sha256': sha(pathfile.read_bytes()), 'payload_files': len(selected),
                      'payload_bytes': manifest['bytes'], 'stage_files': len(stage),
                      'stage_bytes': sum((repo / name).stat().st_size for name in stage),
                      'excluded_files': len(excluded_rows), 'unchanged_at_base': len(unchanged),
                      'scope_counts': scope_counts, 'pending_status': pending}, indent=2))


if __name__ == '__main__':
    main()
