#!/usr/bin/env python3
"""Temporary Linux Git fixtures only; never touches the canonical project.

These tests exercise preservation safety and crash recovery, not Lean proof
acceptance. Production CLI pins and its Darwin backend receive static review;
the filesystem mutation tests use Linux renameat2(RENAME_NOREPLACE).
"""
import copy
import contextlib
import errno
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import types
import unittest
from unittest import mock

sys.dont_write_bytecode = True
SOURCE = Path(__file__).with_name('preserve_sources.py').resolve()
SOURCE_BYTES = SOURCE.read_bytes()
EXECUTOR_SHA256 = hashlib.sha256(SOURCE_BYTES).hexdigest()
executor = types.ModuleType('tested_preserve_sources')
executor.__file__ = str(SOURCE)
exec(compile(SOURCE_BYTES, str(SOURCE), 'exec'), executor.__dict__)


class InterruptedForFixture(RuntimeError):
    pass


class PreservationFixtures(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='preservation-fixture-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)/'repository'
        self.root.mkdir()
        self.git('init', '-b', 'main')
        self.git('config', 'user.email', 'fixture@example.invalid')
        self.git('config', 'user.name', 'Preservation Fixture')
        self.original = {
            'D1Bound5.lean': b'import D1Bound5.Retained\n',
            'D1Bound5/Retained.lean': b'def retained : Nat := 1\n',
            'D1Bound5/ExtraA.lean': b'def extraA : Nat := 2\n',
            'D1Bound5/ExtraB.lean': b'def extraB : Nat := 3\n',
            'D1Bound5/subdir/ExtraC.lean': b'def extraC : Nat := 4\n',
        }
        for name, data in self.original.items():
            p = self.root/name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_bytes(data)
        self.git('add', 'D1Bound5.lean', 'D1Bound5/Retained.lean')
        self.git('commit', '-qm', 'Fixture retained sources')
        self.expected_head = self.git('rev-parse', 'HEAD').decode().strip()
        self.index_raw = self.git('ls-files', '--stage', '-z')
        self.index_sha = hashlib.sha256(self.index_raw).hexdigest()
        self.raw_index = (self.root/'.git/index').read_bytes()
        self.index_sources = {}
        for entry in self.index_raw.split(b'\0'):
            if entry:
                meta, name = entry.split(b'\t', 1)
                mode, oid, stage = meta.decode().split()
                self.index_sources[name.decode()] = {'mode': mode, 'oid': oid}
        self.head_sources = {}
        for entry in self.git('ls-tree', '-r', '-z', 'HEAD').split(b'\0'):
            if entry:
                meta, name = entry.split(b'\t', 1)
                mode, kind, oid = meta.decode().split()
                self.head_sources[name.decode()] = {'mode': mode, 'kind': kind, 'oid': oid}
        self.inventory = {
            name: {'sha256': executor.sha(self.root/name), 'bytes': len(data),
                   'stat': executor.stamp(self.root/name)}
            for name, data in self.original.items()
        }
        self.extra_names = sorted(set(self.inventory)-set(self.index_sources))
        destination = 'research/preserved/helpers'
        self.plan = {
            'root': str(self.root), 'destination': destination,
            'preserved_extra_count': len(self.extra_names),
            'preserved_extra_bytes': sum(len(self.original[n]) for n in self.extra_names),
            'planned_operations': [
                {'from': n, 'to': destination+'/'+n,
                 'sha256': self.inventory[n]['sha256'], 'bytes': self.inventory[n]['bytes'],
                 'HEAD_tracked': False, 'index_tracked': False}
                for n in self.extra_names],
        }
        self.session = self.root/'research/session'
        self.archive = self.root/destination

    def git(self, *args):
        return subprocess.check_output(['git', '-C', str(self.root), *args],
                                       stderr=subprocess.PIPE,
                                       env={**os.environ, 'GIT_OPTIONAL_LOCKS': '0'})

    def new(self, **overrides):
        spec = dict(root=self.root, plan=self.plan, inventory=self.inventory,
                    index_sources=self.index_sources, head_sources=self.head_sources,
                    expected_head=self.expected_head, expected_index_sha256=self.index_sha,
                    session=self.session, bindings={'fixture_only': True})
        spec.update(overrides)
        return executor.Executor(**spec)

    def events(self):
        path = self.session/'events.jsonl'
        return [json.loads(s) for s in path.read_text().splitlines()] if path.exists() else []

    def assert_git_unchanged(self):
        self.assertEqual(self.git('rev-parse', 'HEAD').decode().strip(), self.expected_head)
        self.assertEqual(self.git('ls-files', '--stage', '-z'), self.index_raw)
        self.assertEqual((self.root/'.git/index').read_bytes(), self.raw_index)

    def assert_original_layout(self):
        for name, data in self.original.items():
            self.assertEqual((self.root/name).read_bytes(), data)
            self.assertEqual(executor.stamp(self.root/name), self.inventory[name]['stat'])

    def interrupt_before_first_move(self):
        obj = self.new()
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=InterruptedForFixture('before rename')):
            with self.assertRaises(InterruptedForFixture): obj.run('preserve')
        self.assertEqual([e['type'] for e in self.events()], ['intent'])
        return obj

    def test_exact_preservation_retains_all_bytes_and_git(self):
        result = self.new().run('preserve')
        self.assertEqual(result['status'], 'PRESERVATION_ONLY_PASS')
        self.assertEqual(result['moved_count'], 3)
        self.assertFalse(result['proof_verification_claim'])
        self.assertFalse(result['publication_claim'])
        self.assertFalse(result['git_mutations'])
        self.assertEqual(executor.files_under(self.archive), set(self.extra_names))
        for name, data in self.original.items():
            path = (self.archive if name in self.extra_names else self.root)/name
            self.assertEqual(path.read_bytes(), data)
            self.assertEqual(executor.stamp(path), self.inventory[name]['stat'])
        self.assertEqual([e['name'] for e in self.events() if e['type'] == 'intent'], self.extra_names)
        self.assertEqual([e['type'] for e in self.events()], ['intent', 'done']*3)
        self.assert_git_unchanged()

    def test_rollback_is_reverse_exact_inverse(self):
        self.new().run('preserve')
        result = self.new().run('rollback', resume=True)
        self.assertEqual(result['status'], 'ROLLBACK_TO_DEVELOPMENT_LAYOUT_PASS')
        self.assertEqual(result['moved_count'], 0)
        reverse = [e['name'] for e in self.events() if e['type'] == 'intent' and e['direction'] == 'rollback']
        self.assertEqual(reverse, list(reversed(self.extra_names)))
        self.assertEqual(executor.files_under(self.archive), set())
        self.assert_original_layout()
        self.assert_git_unchanged()

    def test_completed_resume_idempotent_and_same_instance_safe(self):
        obj = self.new()
        first = obj.run('preserve')
        original_journal = (self.session/'events.jsonl').read_bytes()
        self.assertEqual(obj.run('preserve', resume=True), first)
        self.assertEqual(self.new().run('preserve', resume=True), first)
        self.assertEqual((self.session/'events.jsonl').read_bytes(), original_journal)
        obj.run('rollback', resume=True)
        obj.run('rollback', resume=True)
        self.assert_original_layout()

    def test_preserve_rollback_preserve_cycle_keeps_every_byte(self):
        obj = self.new()
        obj.run('preserve')
        obj.run('rollback', resume=True)
        obj.run('preserve', resume=True)
        self.assertEqual(sum(obj.states.values()), 3)
        for name in self.extra_names: self.assertEqual((self.archive/name).read_bytes(), self.original[name])
        self.assert_git_unchanged()

    def test_plan_rejects_tracked_root_duplicate_and_escape(self):
        changes = [
            lambda p: p['planned_operations'].__setitem__(0, {**p['planned_operations'][0], 'from': 'D1Bound5.lean'}),
            lambda p: p['planned_operations'].__setitem__(0, {**p['planned_operations'][0], 'from': 'D1Bound5/Retained.lean'}),
            lambda p: p['planned_operations'].__setitem__(1, p['planned_operations'][0]),
            lambda p: p.__setitem__('destination', '../outside'),
            lambda p: p['planned_operations'][0].__setitem__('to', 'research/elsewhere.lean'),
            lambda p: p['planned_operations'][0].__setitem__('HEAD_tracked', True),
            lambda p: p['planned_operations'][0].__setitem__('index_tracked', True),
            lambda p: p.__setitem__('preserved_extra_count', 2),
            lambda p: p.__setitem__('preserved_extra_bytes', 0),
            lambda p: p['planned_operations'][0].__setitem__('sha256', '0'*64),
        ]
        for change in changes:
            with self.subTest(change=changes.index(change)):
                plan = copy.deepcopy(self.plan); change(plan)
                with self.assertRaises(RuntimeError): self.new(plan=plan)
        self.assert_original_layout()

    def test_session_and_archive_disjoint_and_research_only(self):
        for session in [self.root/'outside', self.archive, self.archive/'session', self.root/'research']:
            with self.subTest(session=session):
                with self.assertRaises(RuntimeError): self.new(session=session)
        plan = copy.deepcopy(self.plan)
        plan['destination'] = 'D1Bound5/archive'
        with self.assertRaises(RuntimeError): self.new(plan=plan)

    def test_wrong_branch_rejected_before_moves(self):
        self.git('checkout', '-qb', 'wrong-branch')
        with self.assertRaisesRegex(RuntimeError, 'branch'): self.new().run('preserve')
        self.assert_original_layout()

    def test_changed_head_rejected_before_moves(self):
        self.git('commit', '--allow-empty', '-qm', 'Concurrent commit')
        with self.assertRaisesRegex(RuntimeError, 'HEAD'): self.new().run('preserve')
        self.assert_original_layout()

    def test_changed_index_rejected_before_moves(self):
        (self.root/'unrelated.txt').write_text('concurrent addition')
        self.git('add', 'unrelated.txt')
        with self.assertRaisesRegex(RuntimeError, 'index'): self.new().run('preserve')
        self.assert_original_layout()

    def test_git_lock_rejected_before_moves(self):
        (self.root/'.git/index.lock').write_text('writer')
        with self.assertRaisesRegex(RuntimeError, 'writer'): self.new().run('preserve')
        self.assert_original_layout()

    def test_added_source_rejected_before_moves(self):
        (self.root/'D1Bound5/New.lean').write_text('def unexpected := 1')
        with self.assertRaisesRegex(RuntimeError, 'file set'): self.new().run('preserve')
        for name in self.extra_names: self.assertTrue((self.root/name).exists())

    def configuration_plan(self):
        pins = {'lean-toolchain': b'leanprover/lean4:v4.33.1\n',
                'lakefile.lean': b'import Lake\n',
                'lake-manifest.json': b'{"fixture": true}\n',
                'GIT_SYNC_POLICY.md': b'Fixture-only source preservation policy.\n'}
        for name, data in pins.items(): (self.root/name).write_bytes(data)
        plan = copy.deepcopy(self.plan)
        plan['inventory_snapshot'] = {
            'pins': {n: executor.sha(self.root/n) for n in pins if n != 'GIT_SYNC_POLICY.md'},
            'policy_sha256': executor.sha(self.root/'GIT_SYNC_POLICY.md'),
        }
        return plan, pins

    def test_changed_configuration_or_policy_pin_rejected_before_moves(self):
        plan, pins = self.configuration_plan()
        for name, data in pins.items():
            with self.subTest(pin=name):
                path = self.root/name; path.write_bytes(data+b'changed')
                with self.assertRaisesRegex(RuntimeError, 'Configuration/policy pin changed'):
                    self.new(plan=plan).run('preserve')
                self.assert_original_layout()
                path.write_bytes(data)
        self.assert_git_unchanged()

    def test_preserve_and_rollback_keep_valid_configuration_pins(self):
        plan, pins = self.configuration_plan()
        self.new(plan=plan).run('preserve')
        self.new(plan=plan).run('rollback', resume=True)
        for name, data in pins.items(): self.assertEqual((self.root/name).read_bytes(), data)
        self.assert_original_layout()
        self.assert_git_unchanged()

    def test_changed_configuration_pin_blocks_resumed_rollback(self):
        plan, pins = self.configuration_plan()
        self.new(plan=plan).run('preserve')
        (self.root/'GIT_SYNC_POLICY.md').write_bytes(b'changed policy')
        with self.assertRaisesRegex(RuntimeError, 'Configuration/policy pin changed'):
            self.new(plan=plan).run('rollback', resume=True)
        for name in self.extra_names: self.assertEqual((self.archive/name).read_bytes(), self.original[name])
        (self.root/'GIT_SYNC_POLICY.md').write_bytes(pins['GIT_SYNC_POLICY.md'])
        self.new(plan=plan).run('rollback', resume=True)
        self.assert_original_layout()

    def test_missing_source_rejected_before_moves(self):
        (self.root/self.extra_names[1]).rename(self.root/'saved-outside-scope')
        with self.assertRaisesRegex(RuntimeError, 'file set'): self.new().run('preserve')
        self.assertEqual((self.root/'saved-outside-scope').read_bytes(), self.original[self.extra_names[1]])

    def test_changed_metadata_rejected(self):
        path = self.root/self.extra_names[0]
        path.chmod(0o600 if path.stat().st_mode & 0o777 != 0o600 else 0o644)
        with self.assertRaisesRegex(RuntimeError, 'metadata'): self.new().run('preserve')
        self.assertTrue(path.exists())

    def test_same_size_same_mtime_changed_hash_rejected(self):
        path = self.root/self.extra_names[0]
        old = path.stat()
        path.write_bytes(b'X'*len(self.original[self.extra_names[0]]))
        os.utime(path, ns=(old.st_atime_ns, old.st_mtime_ns))
        with self.assertRaisesRegex(RuntimeError, 'hash'): self.new().run('preserve')
        self.assertTrue(path.exists())

    def test_static_source_symlink_rejected(self):
        path = self.root/self.extra_names[0]
        saved = self.root/'outside-saved.lean'
        path.rename(saved); path.symlink_to(saved)
        with self.assertRaisesRegex(RuntimeError, 'Symlink'): self.new().run('preserve')
        self.assertEqual(saved.read_bytes(), self.original[self.extra_names[0]])

    def test_symlink_repository_and_session_parent_rejected(self):
        link = Path(self.temp.name)/'linked-repository'; link.symlink_to(self.root, target_is_directory=True)
        with self.assertRaisesRegex(RuntimeError, 'Symlink'): self.new(root=link, session=link/'research/session')
        (self.root/'research').mkdir()
        (self.root/'research/link').symlink_to(self.root, target_is_directory=True)
        with self.assertRaisesRegex(RuntimeError, '[Ss]ymlink'): self.new(session=self.root/'research/link/session')

    def test_lexical_session_and_retained_inventory_traversal_rejected(self):
        with self.assertRaisesRegex(RuntimeError, 'traversal'):
            self.new(session=self.root/'research/../research/session')
        inventory = copy.deepcopy(self.inventory)
        inventory['D1Bound5/../retained-escape.lean'] = self.inventory['D1Bound5/Retained.lean']
        with self.assertRaisesRegex(RuntimeError, 'relative path'): self.new(inventory=inventory)

    def test_preexisting_archive_or_session_rejected(self):
        self.archive.mkdir(parents=True)
        preserved = self.archive/'foreign.txt'; preserved.write_text('never overwrite')
        with self.assertRaisesRegex(RuntimeError, 'Fresh'): self.new().run('preserve')
        self.assertEqual(preserved.read_text(), 'never overwrite')
        self.assert_original_layout()

    def test_atomic_no_replace_rejects_actual_existing_destination(self):
        source, destination = self.root/'atomic-source', self.root/'atomic-destination'
        source.write_bytes(b'source bytes'); destination.write_bytes(b'destination bytes')
        with self.assertRaises(OSError) as error: executor.atomic_no_replace(source, destination)
        self.assertEqual(error.exception.errno, errno.EEXIST)
        self.assertEqual(source.read_bytes(), b'source bytes')
        self.assertEqual(destination.read_bytes(), b'destination bytes')

    def test_atomic_no_replace_rejects_dangling_destination_symlink(self):
        source, destination = self.root/'atomic-source', self.root/'atomic-destination'
        source.write_bytes(b'source bytes')
        destination.symlink_to(self.root/'missing-target')
        with self.assertRaises(OSError) as error: executor.atomic_no_replace(source, destination)
        self.assertEqual(error.exception.errno, errno.EEXIST)
        self.assertEqual(source.read_bytes(), b'source bytes')
        self.assertTrue(destination.is_symlink())
        self.assertFalse((self.root/'missing-target').exists())

    def test_destination_appearing_at_rename_is_not_overwritten(self):
        real = executor.atomic_no_replace
        def race(source, destination):
            destination.write_bytes(b'concurrent destination')
            real(source, destination)
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=race):
            with self.assertRaises(OSError): self.new().run('preserve')
        self.assertEqual((self.archive/self.extra_names[0]).read_bytes(), b'concurrent destination')
        self.assert_original_layout()
        self.assertEqual([e['type'] for e in self.events()], ['intent'])

    def test_source_changed_after_intent_aborts_before_rename(self):
        obj = self.new(); original_append = obj.append
        def change_after_intent(event):
            original_append(event)
            if event['type'] == 'intent':
                path = self.root/event['name']; old = path.stat()
                path.write_bytes(b'X'*path.stat().st_size)
                os.utime(path, ns=(old.st_atime_ns, old.st_mtime_ns))
        with mock.patch.object(obj, 'append', side_effect=change_after_intent):
            with self.assertRaisesRegex(RuntimeError, 'hash'): obj.run('preserve')
        self.assertFalse((self.archive/self.extra_names[0]).exists())
        self.assertTrue((self.root/self.extra_names[0]).exists())

    def test_index_lock_appearing_after_intent_aborts_before_rename(self):
        obj = self.new(); original_append = obj.append
        def lock_after_intent(event):
            original_append(event)
            if event['type'] == 'intent': (self.root/'.git/index.lock').write_text('new writer')
        with mock.patch.object(obj, 'append', side_effect=lock_after_intent):
            with self.assertRaisesRegex(RuntimeError, 'writer'): obj.run('preserve')
        self.assert_original_layout()

    def test_head_appearing_after_intent_aborts_before_rename(self):
        obj = self.new(); original_append = obj.append
        def commit_after_intent(event):
            original_append(event)
            if event['type'] == 'intent': self.git('commit', '--allow-empty', '-qm', 'Concurrent writer')
        with mock.patch.object(obj, 'append', side_effect=commit_after_intent):
            with self.assertRaisesRegex(RuntimeError, 'HEAD'): obj.run('preserve')
        self.assert_original_layout()

    def test_durable_intent_exists_before_actual_rename(self):
        real = executor.atomic_no_replace
        def inspect_then_rename(source, destination):
            event = self.events()[-1]
            self.assertEqual(event['type'], 'intent')
            self.assertEqual(source, self.root/event['name'])
            self.assertTrue((self.session/'SESSION.json').is_file())
            real(source, destination)
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=inspect_then_rename):
            self.new().run('preserve')

    def test_durable_mkdir_flushes_each_created_directory_and_parent(self):
        target = self.root/'research/new/nested'
        flushed = []
        real = executor.fsync_dir
        def record(path):
            self.assertTrue(path.is_dir())
            flushed.append(path)
            real(path)
        with mock.patch.object(executor, 'fsync_dir', side_effect=record):
            executor.durable_mkdir(target, self.root)
            expected = [self.root/'research', self.root,
                        self.root/'research/new', self.root/'research',
                        target, self.root/'research/new']
            self.assertEqual(flushed, expected)
            executor.durable_mkdir(target, self.root)
            self.assertEqual(flushed, expected)
        self.assert_original_layout()

    def test_durable_mkdir_rejects_symlink_nondirectory_and_escape(self):
        link = self.root/'linked'; link.symlink_to(Path(self.temp.name), target_is_directory=True)
        plain = self.root/'plain-file'; plain.write_bytes(b'untouched')
        for target in [link/'child', plain/'child', Path(self.temp.name)/'outside']:
            with self.subTest(target=target):
                with self.assertRaises(RuntimeError): executor.durable_mkdir(target, self.root)
        self.assertEqual(plain.read_bytes(), b'untouched')
        self.assertFalse((Path(self.temp.name)/'outside').exists())

    def test_resume_intent_before_rename_records_not_applied_then_completes(self):
        self.interrupt_before_first_move()
        result = self.new().run('preserve', resume=True)
        self.assertEqual(result['moved_count'], 3)
        self.assertEqual([e['type'] for e in self.events()][:3], ['intent', 'not_applied', 'intent'])
        self.assert_git_unchanged()

    def test_resume_after_actual_rename_records_recovered_done(self):
        real = executor.atomic_no_replace
        def rename_then_interrupt(source, destination):
            real(source, destination)
            raise InterruptedForFixture('after durable rename')
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=rename_then_interrupt):
            with self.assertRaises(InterruptedForFixture): self.new().run('preserve')
        self.assertFalse((self.root/self.extra_names[0]).exists())
        result = self.new().run('preserve', resume=True)
        self.assertEqual(result['moved_count'], 3)
        self.assertEqual([e['type'] for e in self.events()][:2], ['intent', 'recovered_done'])
        self.assert_git_unchanged()

    def test_same_instance_resume_after_done_journal_write_failure(self):
        obj = self.new(); append = obj.append
        def fail_done(event):
            if event['type'] == 'done': raise InterruptedForFixture('before done append')
            append(event)
        with mock.patch.object(obj, 'append', side_effect=fail_done):
            with self.assertRaises(InterruptedForFixture): obj.run('preserve')
        self.assertEqual(sum(obj.states.values()), 1)
        result = obj.run('preserve', resume=True)
        self.assertEqual(result['moved_count'], 3)
        self.assertEqual(len(obj.move_order), 3)

    def test_partial_rollback_after_rename_recovers_then_reverses_remainder(self):
        self.new().run('preserve')
        real = executor.atomic_no_replace
        def rename_then_interrupt(source, destination):
            real(source, destination); raise InterruptedForFixture('rollback after rename')
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=rename_then_interrupt):
            with self.assertRaises(InterruptedForFixture): self.new().run('rollback', resume=True)
        self.assertTrue((self.root/self.extra_names[-1]).exists())
        self.new().run('rollback', resume=True)
        self.assert_original_layout()
        self.assert_git_unchanged()

    def test_partial_rollback_before_rename_retries_without_loss(self):
        self.new().run('preserve')
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=InterruptedForFixture('rollback before rename')):
            with self.assertRaises(InterruptedForFixture): self.new().run('rollback', resume=True)
        self.new().run('rollback', resume=True)
        self.assert_original_layout()
        self.assertEqual(self.events()[7]['type'], 'not_applied')
        self.assert_git_unchanged()

    def test_rollback_from_pending_preserve_returns_original_layout(self):
        real = executor.atomic_no_replace
        def rename_then_interrupt(source, destination):
            real(source, destination); raise InterruptedForFixture('preserve after rename')
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=rename_then_interrupt):
            with self.assertRaises(InterruptedForFixture): self.new().run('preserve')
        self.new().run('rollback', resume=True)
        self.assert_original_layout()

    def test_pending_both_paths_exist_is_rejected_without_overwrite(self):
        self.interrupt_before_first_move()
        destination = self.archive/self.extra_names[0]
        destination.write_bytes(b'foreign destination')
        with self.assertRaisesRegex(RuntimeError, 'Both intent paths'): self.new().run('preserve', resume=True)
        self.assertEqual(destination.read_bytes(), b'foreign destination')
        self.assert_original_layout()

    def test_pending_neither_path_exists_requires_manual_review(self):
        self.interrupt_before_first_move()
        source = self.root/self.extra_names[0]; saved = self.root/'saved-missing-intent'
        source.rename(saved)
        with self.assertRaisesRegex(RuntimeError, 'Ambiguous'): self.new().run('preserve', resume=True)
        self.assertEqual(saved.read_bytes(), self.original[self.extra_names[0]])

    def test_pending_changed_destination_hash_is_rejected(self):
        real = executor.atomic_no_replace
        def rename_then_interrupt(source, destination):
            real(source, destination); raise InterruptedForFixture('after rename')
        with mock.patch.object(executor, 'atomic_no_replace', side_effect=rename_then_interrupt):
            with self.assertRaises(InterruptedForFixture): self.new().run('preserve')
        path = self.archive/self.extra_names[0]; old = path.stat()
        path.write_bytes(b'X'*old.st_size); os.utime(path, ns=(old.st_atime_ns, old.st_mtime_ns))
        with self.assertRaisesRegex(RuntimeError, 'hash'): self.new().run('preserve', resume=True)

    def test_foreign_identity_rejected(self):
        self.interrupt_before_first_move()
        identity = json.loads((self.session/'SESSION.json').read_text())
        identity['expected_head'] = '0'*40
        (self.session/'SESSION.json').write_text(json.dumps(identity))
        with self.assertRaisesRegex(RuntimeError, 'Foreign/changed'): self.new().run('preserve', resume=True)
        self.assert_original_layout()

    def test_journal_out_of_scope_or_mismatched_sequence_rejected(self):
        self.interrupt_before_first_move()
        original = self.events()[0]
        variants = [{**original, 'name': 'D1Bound5/Retained.lean'},
                    {**original, 'id': 7}, {**original, 'sha256': '0'*64},
                    {**original, 'direction': 'delete'},
                    {'type': 'done', 'id': 0}]
        for event in variants:
            with self.subTest(event=event):
                (self.session/'events.jsonl').write_text(json.dumps(event)+'\n')
                with self.assertRaises(RuntimeError): self.new().run('preserve', resume=True)
                self.assert_original_layout()

    def test_torn_journal_fails_closed(self):
        self.interrupt_before_first_move()
        with (self.session/'events.jsonl').open('a') as stream: stream.write('{"type":')
        with self.assertRaises(json.JSONDecodeError): self.new().run('preserve', resume=True)
        self.assert_original_layout()

    def test_session_lock_prevents_competing_executor(self):
        first = self.new(); first.open_session()
        try:
            with self.assertRaises(BlockingIOError): self.new().run('preserve', resume=True)
            self.assert_original_layout()
        finally:
            first.lock.close()
            first.shared_lock.close()

    def test_shared_archive_lock_prevents_different_session_executor(self):
        first = self.new(); first.open_session()
        second_session = self.root/'research/second-session'
        try:
            with self.assertRaises(BlockingIOError): self.new(session=second_session).run('preserve')
            self.assertFalse(second_session.exists())
            self.assert_original_layout()
        finally:
            first.lock.close()
            first.shared_lock.close()
        self.new().run('preserve', resume=True)
        self.assert_git_unchanged()

    def test_symlink_shared_archive_lock_rejected(self):
        self.archive.parent.mkdir(parents=True)
        foreign = self.root/'foreign-lock'; foreign.write_bytes(b'untouched lock target')
        (self.archive.parent/'preservation.lock').symlink_to(foreign)
        with self.assertRaisesRegex(RuntimeError, 'Symlink'): self.new().run('preserve')
        self.assertEqual(foreign.read_bytes(), b'untouched lock target')
        self.assert_original_layout()

    def test_symlink_journal_identity_lock_and_result_rejected(self):
        self.new().run('preserve')
        names = ['events.jsonl', 'SESSION.json', 'session.lock', 'RESULT-3-preserve.json']
        for name in names:
            with self.subTest(name=name):
                path = self.session/name; saved = self.session/(name+'.saved')
                path.rename(saved); path.symlink_to(saved)
                with self.assertRaisesRegex(RuntimeError, 'Symlink'): self.new().run('preserve', resume=True)
                path.unlink(); saved.rename(path)
        for name in self.extra_names: self.assertEqual((self.archive/name).read_bytes(), self.original[name])

    def test_changed_existing_result_receipt_rejected(self):
        self.new().run('preserve')
        path = self.session/'RESULT-3-preserve.json'
        result = json.loads(path.read_text()); result['publication_claim'] = True
        path.write_text(json.dumps(result))
        with self.assertRaisesRegex(RuntimeError, 'result receipt changed'): self.new().run('preserve', resume=True)

    def test_rollback_without_original_session_rejected(self):
        with self.assertRaisesRegex(RuntimeError, 'original session'): self.new().run('rollback')
        self.assert_original_layout()

    def test_preflight_core_creates_no_session_archive_or_git_changes(self):
        obj = self.new()
        before = {p.relative_to(self.root).as_posix(): executor.sha(p)
                  for p in self.root.rglob('*') if p.is_file()}
        obj.guard_state(full=True)
        after = {p.relative_to(self.root).as_posix(): executor.sha(p)
                 for p in self.root.rglob('*') if p.is_file()}
        self.assertEqual(before, after)
        self.assertFalse(self.session.exists())
        self.assertFalse(self.archive.exists())
        self.assert_git_unchanged()

    def test_preflight_cli_branch_is_read_only_on_mocked_production_fixture(self):
        # Only input acquisition/platform/root are mocked. The actual preflight
        # branch and every Git/source guard execute against this temporary repo.
        args = ['preserve_sources.py', 'preflight', '--plan', '/fixture-plan',
                '--inventory-dir', '/fixture-inventory', '--reviewed-head', self.expected_head,
                '--reviewed-index-sha256', self.index_sha, '--session', str(self.session)]
        output = io.StringIO()
        with mock.patch.object(sys, 'argv', args), mock.patch.object(sys, 'platform', 'darwin'), \
             mock.patch.object(executor, 'PRODUCTION_ROOT', self.root), \
             mock.patch.object(executor, 'production_spec', return_value=(self.plan, self.inventory, self.index_sources, self.head_sources)), \
             contextlib.redirect_stdout(output):
            executor.main()
        result = json.loads(output.getvalue())
        self.assertEqual(result['status'], 'READ_ONLY_EXACT_PREFLIGHT_PASS_NO_MUTATION')
        self.assertFalse(result['canonical_mutations'])
        self.assertFalse(self.session.exists())
        self.assertFalse(self.archive.exists())
        self.assert_original_layout()
        self.assert_git_unchanged()

    def test_preflight_cli_rejects_occupied_session_or_archive_without_changes(self):
        args = ['preserve_sources.py', 'preflight', '--plan', '/fixture-plan',
                '--inventory-dir', '/fixture-inventory', '--reviewed-head', self.expected_head,
                '--reviewed-index-sha256', self.index_sha, '--session', str(self.session)]
        for occupied in [self.session, self.archive]:
            with self.subTest(occupied=occupied):
                occupied.mkdir(parents=True)
                with mock.patch.object(sys, 'argv', args), mock.patch.object(sys, 'platform', 'darwin'), \
                     mock.patch.object(executor, 'PRODUCTION_ROOT', self.root), \
                     mock.patch.object(executor, 'production_spec', return_value=(self.plan, self.inventory, self.index_sources, self.head_sources)):
                    with self.assertRaisesRegex(RuntimeError, 'Fresh session/archive'): executor.main()
                self.assertEqual(list(occupied.iterdir()), [])
                occupied.rmdir()
        self.assert_original_layout()
        self.assert_git_unchanged()

    def test_production_cli_cannot_execute_without_explicit_switch(self):
        args = [sys.executable, str(SOURCE), 'preserve', '--plan', '/missing-plan',
                '--inventory-dir', '/missing-inventory', '--reviewed-head', '0'*40,
                '--reviewed-index-sha256', '0'*64, '--session', '/missing-session']
        result = subprocess.run(args, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1)
        self.assertIn('Preparation only; --execute absent', result.stderr)
        self.assert_original_layout()

    def test_executor_source_frozen_for_this_suite(self):
        self.assertEqual(hashlib.sha256(SOURCE.read_bytes()).hexdigest(), EXECUTOR_SHA256)


if __name__ == '__main__':
    print('Fixture executor SHA256:', EXECUTOR_SHA256, flush=True)
    unittest.main(verbosity=2)
