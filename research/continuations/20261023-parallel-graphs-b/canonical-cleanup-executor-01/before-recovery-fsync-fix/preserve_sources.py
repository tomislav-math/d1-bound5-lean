#!/usr/bin/env python3
"""Explicit, journaled preservation of one reviewed untracked-source set.

Production CLI accepts only the pinned 353-file plan and original 4759-file
inventory. It performs no Git mutation and never unlinks or overwrites sources.
Prepare/review this tool first; production execution belongs to the coordinator
only after the separately required release gates.
"""
import argparse
import ctypes
import errno
import fcntl
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import sys

sys.dont_write_bytecode = True
PLAN_SHA = '8d8412630d8f8b724599b89bd3ebfc7d4446d99de432ba40001e4c9d5df85b40'
INVENTORY_MANIFEST_SHA = 'c68e3d02eea98c09a5b878a2fa64d5ff1ebade34551e72464742d1e15feb207f'
PRODUCTION_ROOT = Path('/Users/tp/Lean/D1Bound5')


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for b in iter(lambda: f.read(1024*1024), b''): h.update(b)
    return h.hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def stable_json(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'))


def stamp(path):
    s = Path(path).lstat()
    return {'size': s.st_size, 'mtime_ns': s.st_mtime_ns, 'inode': s.st_ino, 'mode': s.st_mode}


def relative(name):
    p = Path(name)
    require(not p.is_absolute() and str(p) == name and '..' not in p.parts and name not in ['', '.'], 'Unsafe relative path')
    return p


def source_name(name):
    return name == 'D1Bound5.lean' or (name.startswith('D1Bound5/') and name.endswith('.lean'))


def no_symlink_parents(path, root):
    require(root == path or root in path.parents, 'Path escapes repository')
    require(not root.is_symlink(), 'Symlink repository')
    current = root
    for part in path.relative_to(root).parts:
        current = current/part
        require(not current.is_symlink(), 'Symlink path component: ' + str(current))


def files_under(root):
    """Read-only exact inventory, never a source of mutation targets."""
    if not root.exists(): return set()
    require(root.is_dir() and not root.is_symlink(), 'Invalid inventory directory')
    found, pending = set(), [root]
    while pending:
        folder = pending.pop()
        with os.scandir(folder) as entries:
            for entry in entries:
                require(not entry.is_symlink(), 'Symlink in guarded tree')
                p = Path(entry.path)
                if entry.is_dir(follow_symlinks=False): pending.append(p)
                else:
                    require(entry.is_file(follow_symlinks=False), 'Nonregular file in guarded tree')
                    found.add(p.relative_to(root).as_posix())
    return found


def fsync_dir(path):
    fd = os.open(path, os.O_RDONLY)
    try: os.fsync(fd)
    finally: os.close(fd)


def durable_mkdir(path, root):
    """Create reviewed parent directories and flush every new directory entry."""
    no_symlink_parents(path, root)
    current = root
    for part in path.relative_to(root).parts:
        current = current/part
        require(not current.is_symlink(), 'Symlink directory path')
        if current.exists():
            require(current.is_dir(), 'Non-directory parent path')
        else:
            current.mkdir()
            fsync_dir(current)
            fsync_dir(current.parent)


def atomic_no_replace(source, destination):
    """Actual no-clobber rename on Darwin/Linux; deliberately no fallback."""
    source, destination = Path(source), Path(destination)
    require(source.stat().st_dev == destination.parent.stat().st_dev, 'Cross-filesystem relocation forbidden')
    lib = ctypes.CDLL(None, use_errno=True)
    if sys.platform == 'darwin':
        function = lib.renamex_np
        function.argtypes = [ctypes.c_char_p, ctypes.c_char_p, ctypes.c_uint]
        function.restype = ctypes.c_int
        result = function(os.fsencode(source), os.fsencode(destination), 0x4)  # RENAME_EXCL
    elif sys.platform.startswith('linux'):
        function = lib.renameat2
        function.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p, ctypes.c_uint]
        function.restype = ctypes.c_int
        result = function(-100, os.fsencode(source), -100, os.fsencode(destination), 1)  # RENAME_NOREPLACE
    else:
        raise RuntimeError('No reviewed no-replace backend on this platform')
    if result:
        code = ctypes.get_errno()
        raise OSError(code, os.strerror(code), str(source), str(destination))
    fsync_dir(source.parent)
    fsync_dir(destination.parent)


class Executor:
    """Small core accepts explicit fixtures; production CLI pins real inputs."""
    def __init__(self, root, plan, inventory, index_sources, head_sources,
                 expected_head, expected_index_sha256, session, bindings):
        self.root, self.session = Path(root).absolute(), Path(session).absolute()
        require(self.root.resolve() == self.root, 'Symlink repository root or parent')
        require(self.session.resolve() == self.session, 'Session path contains traversal or symlink')
        require(self.root/'research' in self.session.parents, 'Session must be under owned research')
        no_symlink_parents(self.session, self.root)
        self.plan, self.inventory = plan, inventory
        self.index_sources, self.head_sources = index_sources, head_sources
        self.expected_head, self.expected_index_sha256 = expected_head, expected_index_sha256
        snapshot = plan.get('inventory_snapshot', {})
        self.pins = dict(snapshot.get('pins', {}))
        if 'policy_sha256' in snapshot: self.pins['GIT_SYNC_POLICY.md'] = snapshot['policy_sha256']
        require(all(relative(name) for name in self.pins), 'Unsafe configuration pin path')
        self.archive = self.root/relative(plan['destination'])
        require(self.root/'research' in self.archive.parents, 'Archive must be outside production')
        require(self.archive != self.session and self.archive not in self.session.parents and self.session not in self.archive.parents,
                'Session and archive must be disjoint')
        no_symlink_parents(self.archive, self.root)
        self.rows = {}
        for row in plan['planned_operations']:
            name = row['from']; relative(name); relative(row['to'])
            require(name not in self.rows and source_name(name) and name != 'D1Bound5.lean', 'Duplicate or nonhelper source')
            require(row['to'] == plan['destination']+'/'+name, 'Unexpected preservation path')
            require(name in inventory and inventory[name]['sha256'] == row['sha256'] and inventory[name]['bytes'] == row['bytes'],
                    'Plan differs from inventoried source')
            require(name not in index_sources and name not in head_sources and not row['HEAD_tracked'] and not row['index_tracked'],
                    'Tracked source cannot be relocated')
            self.rows[name] = row
        require(self.rows and len(self.rows) == plan['preserved_extra_count'], 'Wrong exact operation count')
        require(sum(r['bytes'] for r in self.rows.values()) == plan['preserved_extra_bytes'], 'Wrong preservation byte total')
        require(all(source_name(n) and relative(n) for n in inventory), 'Unexpected source inventory scope')
        self.identity = {'schema': 1, 'root': str(self.root), 'session': str(self.session), 'archive': str(self.archive),
            'expected_head': expected_head, 'expected_index_sha256': expected_index_sha256,
            'bindings': bindings, 'executor_sha256': sha(__file__),
            'plan_sha256': hashlib.sha256(stable_json(plan).encode()).hexdigest(),
            'inventory_sha256': hashlib.sha256(stable_json(inventory).encode()).hexdigest(),
            'index_sources': index_sources, 'head_sources': head_sources}
        self.states = {name: False for name in self.rows}
        self.pending = None
        self.lock = None
        self.shared_lock = None
        self.next_id = 0
        self.move_order = []

    def git(self, *args):
        return subprocess.check_output(['git', '-C', str(self.root), *args], stderr=subprocess.PIPE,
            env={**os.environ, 'GIT_OPTIONAL_LOCKS': '0'})

    def guard_git(self):
        require(self.git('rev-parse', '--show-toplevel').decode().strip() == str(self.root), 'Wrong Git root')
        require(self.git('branch', '--show-current').decode().strip() == 'main', 'Wrong Git branch')
        lock = Path(self.git('rev-parse', '--git-path', 'index.lock').decode().strip())
        if not lock.is_absolute(): lock = self.root/lock
        require(not lock.exists(), 'Concurrent Git index writer')
        require(self.git('rev-parse', 'HEAD').decode().strip() == self.expected_head, 'Git HEAD changed')
        raw = self.git('ls-files', '--stage', '-z')
        require(hashlib.sha256(raw).hexdigest() == self.expected_index_sha256, 'Git index changed')
        index = {}
        for entry in raw.split(b'\0'):
            if not entry: continue
            meta, name = entry.split(b'\t', 1); mode, oid, stage = meta.decode().split(); name = name.decode()
            require(stage == '0', 'Unmerged Git index')
            if source_name(name): index[name] = {'mode': mode, 'oid': oid}
        head = {}
        for entry in self.git('ls-tree', '-r', '-z', 'HEAD').split(b'\0'):
            if not entry: continue
            meta, name = entry.split(b'\t', 1); mode, kind, oid = meta.decode().split(); name = name.decode()
            if source_name(name): head[name] = {'mode': mode, 'kind': kind, 'oid': oid}
        require(index == self.index_sources and head == self.head_sources, 'Tracked production source set changed')
        require(not lock.exists(), 'Concurrent Git writer appeared')

    def check_file(self, path, row, full):
        no_symlink_parents(path, self.root)
        require(path.is_file() and not path.is_symlink(), 'Missing/nonregular guarded source: '+str(path))
        require(stamp(path) == row['stat'] and stat.S_ISREG(path.lstat().st_mode), 'Source metadata changed: '+str(path))
        if full: require(sha(path) == row['sha256'], 'Source hash changed: '+str(path))

    def guard_state(self, full=False):
        self.guard_git()
        for name, expected in self.pins.items():
            path = self.root/name
            no_symlink_parents(path, self.root)
            require(path.is_file() and sha(path) == expected, 'Configuration/policy pin changed: '+name)
        moved = {n for n, yes in self.states.items() if yes}
        expected = set(self.inventory)-moved
        actual = {'D1Bound5.lean'} | {'D1Bound5/'+n for n in files_under(self.root/'D1Bound5')}
        require(actual == expected, 'Unexpected production file set')
        require(files_under(self.archive) == moved, 'Unexpected archive file set')
        for name, row in self.inventory.items():
            path = self.archive/name if name in moved else self.root/name
            self.check_file(path, row, full)
        require(sha(__file__) == self.identity['executor_sha256'], 'Executor source changed')
        self.guard_git()

    def session_file(self, name):
        path = self.session/relative(name)
        no_symlink_parents(path, self.root)
        require(not path.exists() or path.is_file(), 'Nonregular session file')
        return path

    def apply_state(self, name, moved):
        self.states[name] = moved
        if moved: self.move_order.append(name)
        else: self.move_order.remove(name)

    def append(self, event):
        body = (stable_json(event)+'\n').encode()
        fd = os.open(self.session_file('events.jsonl'), os.O_WRONLY | os.O_APPEND | os.O_CREAT | os.O_NOFOLLOW, 0o600)
        try:
            require(os.write(fd, body) == len(body), 'Short journal write')
            os.fsync(fd)
        finally: os.close(fd)
        fsync_dir(self.session)

    def load_journal(self):
        path = self.session_file('events.jsonl')
        if not path.exists(): return
        no_symlink_parents(path, self.root)
        for line in path.read_text().splitlines():
            event = json.loads(line)
            require(event['type'] in ['intent', 'done', 'recovered_done', 'not_applied'], 'Unexpected journal event')
            if event['type'] == 'intent':
                require(self.pending is None and event['id'] == self.next_id, 'Invalid intent sequence')
                name, direction = event['name'], event['direction']
                require(name in self.rows and direction in ['preserve', 'rollback'], 'Unexpected journal scope')
                require(self.states[name] == (direction == 'rollback'), 'Invalid journal transition')
                require(event['sha256'] == self.rows[name]['sha256'], 'Journal hash mismatch')
                self.pending = event; self.next_id += 1
            else:
                require(self.pending is not None and event['id'] == self.pending['id'], 'Receipt lacks matching intent')
                if event['type'] != 'not_applied': self.apply_state(self.pending['name'], self.pending['direction'] == 'preserve')
                self.pending = None

    def reconcile_pending(self):
        if self.pending is None: return
        self.guard_git()
        e = self.pending; row = self.rows[e['name']]
        canonical, archive = self.root/e['name'], self.root/row['to']
        before, after = (canonical, archive) if e['direction'] == 'preserve' else (archive, canonical)
        require(not (before.exists() and after.exists()), 'Both intent paths exist; no overwrite allowed')
        if before.exists() and not after.exists():
            self.check_file(before, self.inventory[e['name']], True)
            event_type = 'not_applied'
        elif after.exists() and not before.exists():
            self.check_file(after, self.inventory[e['name']], True)
            event_type = 'recovered_done'; self.apply_state(e['name'], e['direction'] == 'preserve')
        else: raise RuntimeError('Ambiguous interrupted intent; manual review required')
        self.append({'type': event_type, 'id': e['id']}); self.pending = None

    def open_session(self, resume=False):
        self.guard_git()
        if resume:
            require(self.session.is_dir() and not self.session.is_symlink(), 'Missing owned session')
        else:
            require(not self.session.exists() and not self.archive.exists(), 'Fresh session/archive must not exist')
            self.guard_state(full=True)
        shared_path = self.archive.parent/'preservation.lock'
        no_symlink_parents(shared_path, self.root)
        require(not shared_path.exists() or shared_path.is_file(), 'Nonregular shared lock')
        durable_mkdir(shared_path.parent, self.root)
        fd = os.open(shared_path, os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW, 0o600)
        self.shared_lock = os.fdopen(fd, 'a+')
        require(stat.S_ISREG(os.fstat(self.shared_lock.fileno()).st_mode), 'Nonregular shared lock')
        fcntl.flock(self.shared_lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        self.guard_git()
        if not resume:
            require(not self.session.exists() and not self.archive.exists(), 'Fresh session/archive must not exist')
            self.guard_state(full=True)
            durable_mkdir(self.session, self.root)
        fd = os.open(self.session_file('session.lock'), os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW, 0o600)
        self.lock = os.fdopen(fd, 'a+')
        fcntl.flock(self.lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        identity_path = self.session_file('SESSION.json')
        if resume:
            require(read(identity_path) == self.identity, 'Foreign/changed preservation session')
            self.states = {name: False for name in self.rows}
            self.pending = None; self.next_id = 0; self.move_order = []
            self.load_journal(); self.reconcile_pending()
        else:
            with identity_path.open('x') as f:
                f.write(stable_json(self.identity)+'\n'); f.flush(); os.fsync(f.fileno())
            fsync_dir(self.session)
        self.guard_state(full=True)

    def transition(self, name, direction):
        self.guard_state()
        require(name in self.rows and self.states[name] == (direction == 'rollback'), 'Invalid exact operation')
        row = self.rows[name]; canonical, archive = self.root/name, self.root/row['to']
        source, destination = (canonical, archive) if direction == 'preserve' else (archive, canonical)
        self.check_file(source, self.inventory[name], True)
        no_symlink_parents(destination, self.root)
        require(not destination.exists(), 'Destination exists; refusing overwrite')
        durable_mkdir(destination.parent, self.root)
        event = {'type': 'intent', 'id': self.next_id, 'name': name, 'direction': direction, 'sha256': row['sha256']}
        self.append(event); self.pending = event; self.next_id += 1
        self.guard_git()
        self.check_file(source, self.inventory[name], True)
        atomic_no_replace(source, destination)
        self.check_file(destination, self.inventory[name], True)
        require(not source.exists(), 'Relocation did not remove original name')
        self.apply_state(name, direction == 'preserve')
        self.append({'type': 'done', 'id': event['id']}); self.pending = None
        self.guard_state()

    def run(self, direction, resume=False):
        require(direction in ['preserve', 'rollback'], 'Unknown action')
        require(direction != 'rollback' or resume, 'Rollback requires the original session')
        try:
            self.open_session(resume)
            names = list(reversed(self.move_order)) if direction == 'rollback' else sorted(self.rows)
            for name in names:
                if self.states[name] == (direction == 'rollback'): self.transition(name, direction)
            self.guard_state(full=True)
            result = {'status': 'PRESERVATION_ONLY_PASS' if direction == 'preserve' else 'ROLLBACK_TO_DEVELOPMENT_LAYOUT_PASS',
                'moved_count': sum(self.states.values()), 'planned_count': len(self.rows), 'git_mutations': False,
                'proof_verification_claim': False, 'publication_claim': False, 'identity': self.identity}
            path = self.session_file('RESULT-'+str(self.next_id)+'-'+direction+'.json')
            if path.exists(): require(read(path) == result, 'Existing result receipt changed')
            else:
                with path.open('x') as f: f.write(stable_json(result)+'\n'); f.flush(); os.fsync(f.fileno())
            fsync_dir(self.session)
            return result
        finally:
            if self.lock is not None: self.lock.close()
            if self.shared_lock is not None: self.shared_lock.close()


def production_spec(plan_path, inventory_dir):
    plan_path, inventory_dir = Path(plan_path), Path(inventory_dir)
    require(sha(plan_path) == PLAN_SHA, 'Unreviewed preservation plan')
    manifest_path = inventory_dir/'FINAL_MANIFEST.json'
    require(sha(manifest_path) == INVENTORY_MANIFEST_SHA, 'Unreviewed inventory manifest')
    manifest = read(manifest_path)
    for name in ['CANONICAL_FILES.json', 'GIT_INDEX_PRODUCTION.json', 'GIT_HEAD_PRODUCTION.json', 'EXTRA_UNTRACKED_SOURCES.json']:
        require(sha(inventory_dir/name) == manifest['files'][name], 'Inventory input changed: '+name)
    plan = read(plan_path); inventory = read(inventory_dir/'CANONICAL_FILES.json')
    index = read(inventory_dir/'GIT_INDEX_PRODUCTION.json'); head = read(inventory_dir/'GIT_HEAD_PRODUCTION.json')
    require(Path(plan['root']) == PRODUCTION_ROOT and len(inventory) == 4759 and len(index) == len(head) == 107,
            'Unexpected production inventory scope')
    require(plan['preserved_extra_count'] == 353 and plan['selected_source_count'] == 4406,
            'Unexpected reviewed plan scope')
    require(set(read(inventory_dir/'EXTRA_UNTRACKED_SOURCES.json')) == {r['from'] for r in plan['planned_operations']},
            'Plan does not equal exact extra-source set')
    return plan, inventory, index, head


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('action', choices=['preflight', 'preserve', 'rollback'])
    for name in ['plan', 'inventory-dir', 'reviewed-head', 'reviewed-index-sha256', 'session']:
        ap.add_argument('--'+name, required=True)
    ap.add_argument('--resume', action='store_true')
    ap.add_argument('--execute', action='store_true', help='Coordinator-only after release gates and executor review')
    a = ap.parse_args()
    require(a.action == 'preflight' or a.execute, 'Preparation only; --execute absent')
    require(sys.platform == 'darwin', 'Production execution requires the reviewed Mac environment')
    plan, inventory, index, head = production_spec(a.plan, a.inventory_dir)
    executor = Executor(PRODUCTION_ROOT, plan, inventory, index, head, a.reviewed_head,
        a.reviewed_index_sha256, a.session, {'plan_sha256': PLAN_SHA, 'inventory_manifest_sha256': INVENTORY_MANIFEST_SHA})
    if a.action == 'preflight':
        require(not a.resume, 'Preflight expects the unchanged initial canonical layout')
        require(not executor.session.exists() and not executor.archive.exists(), 'Fresh session/archive must not exist')
        executor.guard_state(full=True)
        print(stable_json({'status': 'READ_ONLY_EXACT_PREFLIGHT_PASS_NO_MUTATION',
            'identity': executor.identity, 'source_count': len(inventory), 'planned_count': len(executor.rows),
            'git_mutations': False, 'canonical_mutations': False, 'proof_verification_claim': False}))
    else:
        print(stable_json(executor.run(a.action, a.resume)))


if __name__ == '__main__':
    try: main()
    except BaseException as error:
        print('PRESERVATION_FAILED_NO_ACCEPTANCE:', repr(error), file=sys.stderr)
        sys.exit(1)
