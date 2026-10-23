#!/usr/bin/env python3
"""Review explicitly owner-pinned research text; no Git mutation or proof claim."""
import ast
from collections import Counter
import datetime
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess

ROOT = Path('/Users/tp/Lean/D1Bound5')
OUT = ROOT/'research/continuations/20261023-parallel-graphs-a/research-publication-candidate-03'
MAX_BYTES = 5 * 1024 * 1024


def check(ok, message):
    if not ok:
        raise RuntimeError(message)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def git(*args):
    p = subprocess.run(['git', '-C', str(ROOT), *args], capture_output=True, timeout=60)
    check(p.returncode == 0, 'Read-only Git command failed; diagnostics withheld')
    return p.stdout


def checkpoint():
    check(not (ROOT/'.git/index.lock').exists(), 'Index lock exists')
    return {'head': git('rev-parse', 'HEAD').decode().strip(),
            'branch': git('branch', '--show-current').decode().strip(),
            'index_listing_sha256': sha(git('ls-files', '--stage', '-z')),
            'raw_index_sha256': sha((ROOT/'.git/index').read_bytes()),
            'staged_diff_empty': not git('diff', '--cached', '--name-only', '-z'),
            'policy_sha256': sha((ROOT/'GIT_SYNC_POLICY.md').read_bytes()),
            'preflight_sha256': sha((ROOT/'scripts/git_sync_preflight.py').read_bytes())}


def checked_path(relative):
    p = PurePosixPath(relative)
    check(relative.startswith('research/') and not p.is_absolute(), 'Nonresearch path selected')
    check(str(p) == relative, 'Noncanonical path spelling')
    check(all(x not in ('', '.', '..') for x in p.parts) and '\\' not in relative and
          not any(c in relative for c in '\r\n\t\0'), 'Unsafe path')
    if p.name == 'CURRENT_PROGRESS.json':
        check(relative == 'research/continuations/20261023-parallel-resume/CURRENT_PROGRESS.json'
              and spec.get('root_frozen_current_progress_sha256'),
              'Mutable progress excluded without explicit root freeze')
    check(not any(x in ('transport', '__pycache__', '.lake') for x in p.parts), 'Excluded path component')
    check(not relative.endswith(('.b64', '.part', '.ilean', '.olean', '.olean.private', '.olean.server',
                                 '.ir', '.ir.sig', '.tar', '.xz', '.gz', '.zip', '.pyc')),
          'Binary/cache/transport selected')
    q = ROOT
    for part in p.parts:
        q = q/part
        check(not q.is_symlink(), 'Symlink in selected path')
    check(q.is_file() and stat.S_ISREG(q.stat().st_mode), 'Selected path is not a regular file')
    return q


def fingerprint(path):
    s = path.stat()
    return (s.st_dev, s.st_ino, s.st_mode, s.st_size, s.st_mtime_ns, s.st_ctime_ns)


spec_bytes = (OUT/'OWNER_INPUTS.json').read_bytes()
spec = json.loads(spec_bytes)
before = checkpoint()
check(before == spec['expected_checkpoint'], 'HEAD/index/policy differs from pinned checkpoint')
check(before['staged_diff_empty'] and before['branch'] == 'main', 'Nonempty index or unexpected branch')
for name in ('CANDIDATE_MANIFEST.json', 'MERGED_STAGE_PATHS.txt', 'NEW_OR_CHANGED_STAGE_PATHS.txt'):
    check(not (OUT/name).exists(), 'Candidate already exists; no overwrite')

preflight = (ROOT/'scripts/git_sync_preflight.py').read_bytes()
patterns = None
for node in ast.parse(preflight.decode()).body:
    if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == 'TOKEN_PATTERNS'
                                          for t in node.targets):
        patterns = ast.literal_eval(node.value)
check(isinstance(patterns, list) and len(patterns) == 6 and all(isinstance(p, str) for p in patterns),
      'Unexpected canonical credential patterns')
patterns = [re.compile(p) for p in patterns]
selected, inputs, groups = {}, {}, {}


def read_pinned(path, expected):
    data = checked_path(path).read_bytes()
    check(sha(data) == expected, 'Owner-pinned file changed: ' + path)
    inputs[path] = expected
    return data


def add(path, expected, group):
    check(not path.startswith(str(OUT.relative_to(ROOT))+'/'),
          'Candidate own metadata cannot be included as owner-reviewed payload')
    if path.endswith('/CURRENT_PROGRESS.json'):
        check(expected == spec.get('root_frozen_current_progress_sha256'),
              'Progress hash differs from explicit root freeze')
    if path in selected:
        check(selected[path]['sha256'] == expected, 'Conflicting owner hashes: ' + path)
        selected[path]['groups'].append(group)
    else:
        selected[path] = {'sha256': expected, 'groups': [group]}


for group in spec['groups']:
    name, prefix = group['name'], group['prefix']
    check(name not in groups, 'Duplicate owner group name')
    added = set()
    if 'manifest' in group:
        m = group['manifest']
        obj = json.loads(read_pinned(prefix+m['name'], m['sha256']))
        entries = obj[m.get('rows_key', 'files')]
        if isinstance(entries, list):
            check(len({row['path'] for row in entries}) == len(entries),
                  'Duplicate list-manifest path')
            entries = {row['path']: row['sha256'] for row in entries}
        else:
            entries = {p: row['sha256'] if isinstance(row, dict) else row for p, row in entries.items()}
        check(len(entries) == m['payload_count'], 'Owner payload count differs: ' + name)
        for relative, expected in entries.items():
            check(not relative.startswith('research/'), 'Expected package-relative owner path')
            path = prefix+relative
            add(path, expected, name); added.add(path)
        add(prefix+m['name'], m['sha256'], name); added.add(prefix+m['name'])
    for relative, expected in group.get('extra_files', {}).items():
        read_pinned(prefix+relative, expected)
        add(prefix+relative, expected, name); added.add(prefix+relative)
    check(len(added) == group['expected_count'], 'Unexpected owner group count: ' + name)
    groups[name] = len(added)

paths = sorted(selected)
base_rows = {}
for row in git('ls-tree', '-r', '-z', '--full-tree', before['head'], '--', *paths).split(b'\0'):
    if not row:
        continue
    meta, path = row.split(b'\t', 1)
    mode, kind, oid = meta.decode().split()
    check(kind == 'blob' and mode in ('100644', '100755'), 'Unexpected base tree type')
    base_rows[path.decode()] = oid

rows, snapshots = {}, {}
for path in paths:
    p = checked_path(path); fp = fingerprint(p); data = p.read_bytes()
    check(fp == fingerprint(p), 'Changed during read: ' + path)
    check(len(data) <= MAX_BYTES, 'File exceeds 5 MiB: ' + path)
    content = data.decode('utf-8')
    check('\0' not in content and not any(pattern.search(content) for pattern in patterns),
          'Selected text failed credential/NUL scan; sensitive value withheld: ' + path)
    h = sha(data)
    check(h == selected[path]['sha256'], 'Owner bytes changed: ' + path)
    oid = base_rows.get(path)
    old_sha = sha(git('cat-file', 'blob', oid)) if oid else None
    classification = 'BASE_IDENTICAL' if old_sha == h else ('CHANGED' if oid else 'NEW')
    rows[path] = {'sha256': h, 'bytes': len(data), 'classification_vs_base': classification,
                  'base_git_blob': oid, 'base_sha256': old_sha,
                  'owner_groups': selected[path]['groups']}
    snapshots[path] = fp

for path, expected in inputs.items():
    check(sha(checked_path(path).read_bytes()) == expected, 'Owner input changed after scan')
for path in paths:
    p = checked_path(path)
    check(fingerprint(p) == snapshots[path] and sha(p.read_bytes()) == rows[path]['sha256'],
          'Selected file changed after scan: ' + path)
check((OUT/'OWNER_INPUTS.json').read_bytes() == spec_bytes, 'Owner specification changed')
after = checkpoint()
check(after == before, 'HEAD/index/policy changed during review')
changed = [p for p in paths if rows[p]['classification_vs_base'] != 'BASE_IDENTICAL']
manifest = {'schema': 1, 'status': 'RESEARCH_CHECKPOINT_CANDIDATE_FOR_ROOT_REVIEW_ONLY',
            'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'base_commit': before['head'], 'checkpoint_before': before, 'checkpoint_after': after,
            'owner_specification_sha256': sha(spec_bytes), 'owner_inputs_sha256': inputs,
            'groups': groups, 'selected_path_count': len(paths), 'new_or_changed_path_count': len(changed),
            'classification_counts': dict(Counter(r['classification_vs_base'] for r in rows.values())),
            'total_bytes': sum(r['bytes'] for r in rows.values()), 'files': rows,
            'policy_checks': {'strict_utf8': True, 'maximum_file_bytes': MAX_BYTES,
                              'credential_pattern_count': 6, 'credential_matches': 0,
                              'regular_files_no_symlink_components': True,
                              'all_owner_hashes_match': True, 'pre_post_selected_hashes_equal': True},
            'pending_or_excluded': spec['pending_or_excluded'],
            'proof_gate_acceptance_claim': False, 'git_mutations': False,
            'canonical_source_or_tool_installation': False, 'lean_or_checker_launch': False,
            'historical_and_current_statuses': 'Preserve exact owner labels; preparation/pilot/checkpoint transport is not full build/audit/fresh replay acceptance.',
            'new_files_created_only_in': str(OUT.relative_to(ROOT)),
            'candidate_own_metadata_not_in_selected_paths': ['aggregate_review.py', 'OWNER_INPUTS.json',
                'CANDIDATE_MANIFEST.json', 'MERGED_STAGE_PATHS.txt', 'NEW_OR_CHANGED_STAGE_PATHS.txt'],
            'root_action_required': 'Review explicit paths and current guards, run canonical policy helpers, stage only approved paths, review exact index, then separate private commit/push.'}
outputs = {'CANDIDATE_MANIFEST.json': json.dumps(manifest, indent=2, sort_keys=True)+'\n',
           'MERGED_STAGE_PATHS.txt': '\n'.join(paths)+'\n',
           'NEW_OR_CHANGED_STAGE_PATHS.txt': '\n'.join(changed)+'\n'}
for name, content in outputs.items():
    check(len(content.encode()) <= MAX_BYTES and not any(p.search(content) for p in patterns),
          'Generated metadata fails text policy')
    with (OUT/name).open('xb') as f:
        f.write(content.encode()); f.flush(); os.fsync(f.fileno())
check(checkpoint() == before, 'HEAD/index/policy changed while saving research metadata')
print(json.dumps({'status': manifest['status'], 'count': len(paths), 'new_or_changed': len(changed),
                  'classifications': manifest['classification_counts'], 'total_bytes': manifest['total_bytes'],
                  'outputs': {name: sha((OUT/name).read_bytes()) for name in
                              ['aggregate_review.py', 'OWNER_INPUTS.json', *outputs]},
                  'git_and_policy_guards_unchanged': True}, indent=2))
