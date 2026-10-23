#!/usr/bin/env python3
"""Authorized exact source recovery only; never touches build/runtime/receipts."""
from pathlib import Path, PurePosixPath
import hashlib, json, os, shutil, subprocess, tarfile
R = Path('/tmp/d1bound5-second-loss-recovery-20261023')
M = R/'authoritative-workspace'
A = M/'recovery-20261023'
S = A/'source'
W = Path('/workspace/scratch/fed64f41ca78')
T = W/'recovery-20261023/source'
ARCHIVE = Path('/tmp/d1bound5-verification-20261023/source-transfer/sources.tar.xz')
ARCHIVE_SHA = 'af3dc790347c0a29ffeb10a902697e00e169002ea04f33203ae4446d709fe901'
COMMIT = 'b4c81242dd9c9cee6966a1e08bce0f94c66f1491'
TREE = 'ee490da49ba30447d92745140f48c1ae3c34f263'
def sha(data): return hashlib.sha256(data).hexdigest()
def require(condition, message):
    if not condition: raise RuntimeError(message)
def exclusive(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('xb') as f:
        f.write(data); f.flush(); os.fsync(f.fileno())
def git(root, *args, data=None):
    p = subprocess.run(['git', '-C', str(root), *args], input=data,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    require(p.returncode == 0, 'Git failed: ' + repr(args) + ': ' + p.stderr.decode())
    return p.stdout
lock_path = A/'restored-tools/original-identities/CLEAN_SOURCE_LOCK.json'
require(sha(lock_path.read_bytes()) == 'b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c', 'Source lock differs')
lock = json.loads(lock_path.read_text())
require(lock['module_count'] == 4406 and len(lock['sources']) == 4406, 'Source count differs')
expected = {row['relative_path']: {'bytes': row['bytes'], 'sha256': row['sha256']} for row in lock['sources'].values()}
for name, digest in lock['auxiliary'].items(): expected[name] = {'sha256': digest}
archive_expected = set(expected)
require(len(archive_expected) == 4409, 'Archive member count differs')
for name, digest in {
    'scripts/verification/FinalIntegrationAudit.lean': '005f05312ef81f9a961e1c8adefb00b98e514cca3794adcc438118e4edf5d1ac',
    'scripts/verification/FinalTargetAudit.lean': 'b21a0deae156faabd97ad38e87920a5f9f16700cad843c3e38e040c90aaa61d7',
}.items(): expected[name] = {'sha256': digest}
require(len(expected) == 4411, 'Candidate count differs')
require(not S.is_symlink() and not T.is_symlink(), 'Source root is symlink')
require(not (S/'.git').exists() and not (T/'.git').exists(), 'Refuse existing Git metadata')
before = ARCHIVE.stat()
require(before.st_size == 52152080 and sha(ARCHIVE.read_bytes()) == ARCHIVE_SHA, 'Archive differs')
with tarfile.open(ARCHIVE, 'r:xz') as tar:
    members = tar.getmembers()
    require(len(members) == 4409 and {m.name for m in members} == archive_expected, 'Archive member scope differs')
    for member in members:
        rel = PurePosixPath(member.name)
        require(member.isfile() and not rel.is_absolute() and '..' not in rel.parts, 'Invalid archive member')
        raw = tar.extractfile(member).read(); row = expected[member.name]
        require(sha(raw) == row['sha256'] and ('bytes' not in row or len(raw) == row['bytes']), 'Archive source differs: '+member.name)
        exclusive(S/member.name, raw)
after = ARCHIVE.stat()
require((before.st_dev,before.st_ino,before.st_size,before.st_mtime_ns,before.st_ctime_ns) == (after.st_dev,after.st_ino,after.st_size,after.st_mtime_ns,after.st_ctime_ns), 'Archive changed')
def verify_source(root):
    found = {}
    for p in root.rglob('*'):
        if '.git' in p.relative_to(root).parts: continue
        require(not p.is_symlink(), 'Symlink in source tree')
        if p.is_file():
            name = str(p.relative_to(root)); require(name in expected, 'Unexpected source file: '+name)
            raw = p.read_bytes(); row = expected[name]
            require(sha(raw) == row['sha256'] and ('bytes' not in row or len(raw) == row['bytes']), 'Source differs: '+name)
            found[name] = {'bytes':len(raw),'sha256':sha(raw)}
    require(set(found) == set(expected), 'Missing source files')
    return found
rows = verify_source(S)
git(S, 'init', '--quiet')
git(S, '-c', 'gc.auto=0', 'add', '--pathspec-from-file=-', '--pathspec-file-nul', data=b'\0'.join(n.encode('utf-8') for n in sorted(expected))+b'\0')
require(git(S, 'write-tree').decode().strip() == TREE, 'Git tree differs')
commit_bytes = (A/'RECOVERY_SOURCE_COMMIT_OBJECT.txt').read_bytes()
require(sha(commit_bytes) == 'dc70eaf6182cd34da08e67e02103271a90184b13ee2d699df7a242e568947078', 'Commit object bytes differ')
require(git(S, 'hash-object', '-t', 'commit', '-w', '--stdin', data=commit_bytes).decode().strip() == COMMIT, 'Commit hash differs')
git(S, 'update-ref', 'HEAD', COMMIT)
require(git(S, 'status', '--porcelain') == b'', 'Authoritative source Git not clean')
# Copy exact bytes only; pre-existing two harnesses must already match.
for name, row in rows.items():
    src = S/name; out = T/name; raw = src.read_bytes()
    if out.exists(): require(out.is_file() and not out.is_symlink() and out.read_bytes() == raw, 'Existing destination differs')
    else: exclusive(out, raw)
shutil.copytree(S/'.git', T/'.git')
require(verify_source(S) == rows and verify_source(T) == rows, 'Postcopy source equivalence failed')
for root in [S,T]:
    require(git(root, 'rev-parse', 'HEAD').decode().strip() == COMMIT, 'HEAD differs')
    require(git(root, 'rev-parse', 'HEAD^{tree}').decode().strip() == TREE, 'HEAD tree differs')
    require(git(root, 'status', '--porcelain') == b'', 'Git dirty')
    require(len(git(root, 'ls-files', '-z').split(b'\0'))-1 == 4411, 'Tracked count differs')
    require(git(root, 'cat-file', 'commit', COMMIT) == commit_bytes, 'Raw commit reconstruction differs')
inventory_bytes=(json.dumps(rows,sort_keys=True,indent=2)+'\n').encode()
exclusive(R/'RESTORED_SOURCE_INVENTORY.json',inventory_bytes)
record={'status':'EXACT_SOURCE_AND_SAME_GIT_CANDIDATE_RESTORED_NO_LEAN',
        'source_archive_sha256':ARCHIVE_SHA,'source_lock_sha256':sha(lock_path.read_bytes()),
        'original_source_root':str(T),'authoritative_duplicate_source_root':str(S),
        'source_inventory_sha256':sha(inventory_bytes),'project_modules':4406,'config_files':3,'committed_audit_harnesses':2,
        'tracked_files':4411,'commit':COMMIT,'tree':TREE,'git_clean_both':True,
        'all_source_bytes_equal_lock_and_both_copies':True,'git_metadata':'New repository metadata reconstructed from exact source bytes and original raw commit object; not claimed byte-identical original index/stat data.',
        'build_runtime_receipts_mutated':False,'lean_launched':False,'root_independent_review_required_before_resume':True}
exclusive(R/'SOURCE_RESTORATION.json',(json.dumps(record,sort_keys=True,indent=2)+'\n').encode())
print(json.dumps(record,sort_keys=True),flush=True)
