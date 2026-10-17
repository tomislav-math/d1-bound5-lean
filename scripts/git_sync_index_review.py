#!/usr/bin/env python3
"""Read-only review of the exact Git index for the private D1Bound5 project.

No staging, commits, pushes, hash refresh, permission changes or background work.
A PASS is neither a Lean verification nor permission to override a tool refusal.
"""
from __future__ import annotations

import hashlib
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path, PurePosixPath

ROOT = Path('/Users/tp/Lean/D1Bound5')
REPOSITORY = 'tomislav-math/d1-bound5-lean'
MANIFESTS = ('records/proof-source-sha256.txt', 'records/verification-tools-sha256.txt')
MAX_BYTES = 5 * 1024 * 1024
TOKEN_PATTERNS = (
    r'gh[pousr]_[A-Za-z0-9]{20,}', r'github_pat_[A-Za-z0-9_]{30,}',
    r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----',
    r'sk-(?:proj-)?[A-Za-z0-9_-]{28,}', r'(?i)Bearer\s+[A-Za-z0-9_.-]{30,}',
    r'(?i)https?://[^\s/:]+:[^\s/@]+@',
)


class ReviewError(RuntimeError):
    """An exact snapshot cannot be accepted for further human/model review."""


def check(condition: bool, message: str) -> None:
    if not condition:
        raise ReviewError(message)


def safe_path(name: str) -> None:
    p = PurePosixPath(name)
    check(bool(name) and not p.is_absolute() and str(p) == name and
          not any(part in ('.', '..', '.git', '.lake', '__pycache__') for part in p.parts)
          and not any(ord(c) < 32 for c in name), 'Unsafe or non-project path')


class IndexReview:
    def __init__(self, root: Path):
        self.root = root.resolve()
        self.cache: dict[str, bytes] = {}

    def git(self, *args: str) -> bytes:
        # All internal call sites below are fixed read-only invocations.
        result = subprocess.run(['git', *args], cwd=self.root, capture_output=True,
                                timeout=30, env={**os.environ, 'GIT_OPTIONAL_LOCKS': '0'})
        if result.returncode:
            raise ReviewError(f'Read-only git {args[0]} failed: exit {result.returncode}')
        return result.stdout

    @staticmethod
    def parse_index(raw: bytes) -> dict[str, tuple[str, str]]:
        entries = {}
        for record in raw.split(b'\0'):
            if not record:
                continue
            meta, name_bytes = record.split(b'\t', 1)
            mode, oid, stage = meta.decode('ascii').split()
            name = name_bytes.decode('utf-8')
            safe_path(name)
            check(stage == '0', 'Unmerged index entry; manual reconciliation required')
            check(name not in entries, 'Duplicate index entry')
            entries[name] = (mode, oid)
        return entries

    def blob(self, entries: dict[str, tuple[str, str]], name: str) -> bytes:
        check(name in entries, f'Absent from Git index: {name}')
        mode, oid = entries[name]
        check(mode in ('100644', '100755'), f'Non-regular indexed file: {name}')
        if oid not in self.cache:
            size = int(self.git('cat-file', '-s', oid))
            check(size <= MAX_BYTES, f'Large file requires separate review: {name}')
            self.cache[oid] = self.git('cat-file', 'blob', oid)
        return self.cache[oid]

    @staticmethod
    def manifest_rows(data: bytes) -> dict[str, str]:
        rows = {}
        for line in data.decode('utf-8').splitlines():
            if not line.strip():
                continue
            match = re.fullmatch(r'([0-9a-f]{64})[ \t]+\*?(.+)', line)
            check(match is not None, 'Malformed SHA-256 manifest row')
            digest, name = match.groups()
            safe_path(name)
            check(name not in rows, f'Duplicate manifest path: {name}')
            rows[name] = digest
        check(bool(rows), 'Empty SHA-256 manifest')
        return rows

    def inspect(self) -> dict:
        check(self.git('rev-parse', '--show-toplevel').decode().strip() == str(self.root),
              'Wrong project root')
        lock = Path(self.git('rev-parse', '--git-path', 'index.lock').decode().strip())
        if not lock.is_absolute():
            lock = self.root / lock
        check(not lock.exists(), 'Git index is locked; leave the owner undisturbed')
        head = self.git('rev-parse', 'HEAD').decode().strip()
        before = self.git('ls-files', '--stage', '-z')
        entries = self.parse_index(before)
        changed = [p.decode('utf-8') for p in self.git(
            'diff', '--no-ext-diff', '--cached', '--no-renames', '--name-only', '-z', '--'
        ).split(b'\0') if p]
        for name in changed:
            safe_path(name)
            check(name in {'D1Bound5.lean', 'STATUS.md', 'README.md', 'GIT_SYNC_POLICY.md'} or
                  name.startswith(('D1Bound5/', 'records/', 'scripts/', 'research/')),
                  f'Unreviewed staged scope: {name}')
            check(name in entries, f'Deletion requires separate explicit review: {name}')
            text = self.blob(entries, name).decode('utf-8')
            check(not any(re.search(pattern, text) for pattern in TOKEN_PATTERNS),
                  f'Credential-shaped content needs review: {name}; value withheld')
        manifests = {}
        for manifest in MANIFESTS:
            rows = self.manifest_rows(self.blob(entries, manifest))
            for name, expected in rows.items():
                actual = hashlib.sha256(self.blob(entries, name)).hexdigest()
                check(actual == expected, f'INDEX_FINGERPRINT_MISMATCH: {name}')
            manifests[manifest] = rows
        proof_paths = {name for name in entries if name == 'D1Bound5.lean' or
                       (name.startswith('D1Bound5/') and name.endswith('.lean'))}
        check(proof_paths <= set(manifests[MANIFESTS[0]]),
              'A staged-tree proof source lacks a source fingerprint')
        audit_paths = {name for name in entries if name.startswith('scripts/') and
                       name.endswith('Audit.lean')}
        check(audit_paths <= set(manifests[MANIFESTS[1]]),
              'A staged-tree Lean audit lacks a tool fingerprint')
        worktree_diff = []
        for name in sorted(set().union(*(set(rows) for rows in manifests.values()))):
            path = self.root / name
            if path.is_symlink() or not path.is_file():
                worktree_diff.append(name)
            elif hashlib.sha256(path.read_bytes()).hexdigest() != hashlib.sha256(
                    self.blob(entries, name)).hexdigest():
                worktree_diff.append(name)
        after = self.git('ls-files', '--stage', '-z')
        check(before == after and self.git('rev-parse', 'HEAD').decode().strip() == head,
              'Snapshot changed during review; do not touch concurrent work')
        check(not lock.exists(), 'Index writer appeared during review')
        return {
            'status': 'INDEX_REVIEW_PASS' if changed else 'NO_STAGED_CHANGES',
            'read_only': True, 'head': head, 'staged_paths': changed,
            'index_fingerprint': hashlib.sha256(before).hexdigest(),
            'manifest_counts': {name: len(rows) for name, rows in manifests.items()},
            'working_tree_differs_from_index': worktree_diff,
            'scope': 'INDEX CONTENT ONLY; NOT A BUILD, SOURCE-TYPE AUDIT, OR PUSH RECEIPT',
            'next_step': 'Inspect exact diff and matching verification receipts. Respect live writers and tool refusals.',
        }


def main() -> None:
    review = IndexReview(ROOT)
    check(review.git('branch', '--show-current').decode().strip() == 'main', 'Unexpected branch')
    origin = review.git('remote', 'get-url', 'origin').decode().strip()
    check(origin in (f'https://github.com/{REPOSITORY}.git', f'https://github.com/{REPOSITORY}',
                     f'git@github.com:{REPOSITORY}.git'), 'Unexpected Git destination')
    gh = Path('/Users/tp/.local/bin/gh')
    result = subprocess.run([str(gh), 'repo', 'view', REPOSITORY, '--json',
                             'nameWithOwner,visibility,viewerPermission'],
                            cwd=ROOT, capture_output=True, timeout=30)
    check(result.returncode == 0, 'Provider read-only access check failed; details withheld')
    info = json.loads(result.stdout)
    check(info.get('nameWithOwner') == REPOSITORY and info.get('visibility') == 'PRIVATE',
          'Private destination not confirmed')
    check(info.get('viewerPermission') in ('ADMIN', 'MAINTAIN', 'WRITE'), 'No provider write access')
    report = review.inspect()
    report.update(utc=datetime.now(timezone.utc).isoformat(), repository=REPOSITORY,
                  visibility=info['visibility'], permission=info['viewerPermission'])
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ReviewError, OSError, ValueError, UnicodeError, subprocess.TimeoutExpired) as error:
        print(json.dumps({'status': 'INDEX_REVIEW_FAILED_NO_MUTATION', 'detail': str(error)}))
        sys.exit(1)
