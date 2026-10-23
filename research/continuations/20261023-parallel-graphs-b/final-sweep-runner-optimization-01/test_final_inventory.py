#!/usr/bin/env python3
"""Synthetic filesystem/final-gate tests; no Lean, project cache, or Git writes."""
import hashlib
import os
from pathlib import Path
import stat
import tempfile
import threading
import types
import unittest
from unittest import mock


RUNNER = Path(__file__).with_name('fresh_project_build.py')
EXPECTED_RUNNER_SHA256 = '349a4e81d9ae80f66e505f3fa927cbde3a0a287cdb1e9971f1d6295d2b797da0'
runner_bytes = RUNNER.read_bytes()
assert hashlib.sha256(runner_bytes).hexdigest() == EXPECTED_RUNNER_SHA256
r = types.ModuleType('inventory_test_subject')
r.__file__ = str(RUNNER)
exec(compile(runner_bytes, str(RUNNER), 'exec'), r.__dict__)
assert hashlib.sha256(RUNNER.read_bytes()).hexdigest() == EXPECTED_RUNNER_SHA256


class Fixture(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='final-inventory-fixture-')
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.art = self.root/'artifacts'
        self.art.mkdir()
        self.base = self.put('Fixture/A.olean', b'original')

    def put(self, relative, data=b'artifact'):
        path = self.art/relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        return path

    def snapshot(self):
        return r.FinalArtifactInventory(self.art)

    def rejects_mutation(self, mutation):
        snapshot = self.snapshot()
        mutation()
        with self.assertRaises((RuntimeError, OSError)):
            snapshot.verify_unchanged()

    def make_build(self):
        b = r.Build.__new__(r.Build)
        b.art = self.art
        b.src = self.root/'source'
        b.src.mkdir()
        b.out = self.root/'build-records'
        b.out.mkdir()
        b.names = ['Fixture.A', 'Fixture.B']
        b.deps = {'Fixture.A': [], 'Fixture.B': ['Fixture.A']}
        b.ancestor_cache = {'Fixture.A': set(), 'Fixture.B': {'Fixture.A'}}
        b.modules = {}
        b.accepted = {}
        b.pins = r.Pins()
        b.sl = {'auxiliary': {}}
        b.a = types.SimpleNamespace(jobs=1, resume=False)
        b.failed = []
        b.interrupted = threading.Event()
        b.runtime_calls = []
        b.guard_runtime = lambda **kwargs: b.runtime_calls.append(kwargs)
        b.statuses = []
        b.summary = lambda status, waiting, active: b.statuses.append(status)
        for n in b.names:
            source = b.src/r.module_path(n)
            source.parent.mkdir(exist_ok=True)
            source.write_text('synthetic source ' + n)
            b.modules[n] = {'relative_path': str(r.module_path(n)),
                            'sha256': r.sha(source), 'imports': b.deps[n]}
            artifact = self.put(str(r.module_path(n, '.olean')), n.encode())
            attempt = b.out/n
            attempt.mkdir()
            receipt = attempt/'receipt.json'
            receipt.write_text('{"synthetic": true, "module": "' + n + '"}\n')
            log = attempt/'compiler.log'
            log.write_text('synthetic compiler log; no compiler was invoked\n')
            b.accepted[n] = {'path': receipt, 'receipt_sha256': r.sha(receipt),
                             'row': {'artifact_bundle': {
                                 str(artifact.relative_to(self.art)): r.sha(artifact)},
                                 'log_sha256': r.sha(log)}}
        config = b.src/'lean-toolchain'
        config.write_text('synthetic pinned configuration\n')
        b.sl['auxiliary']['lean-toolchain'] = r.sha(config)
        return b

    def assert_gate_failure(self, b):
        self.assertEqual(b.run(), 2)
        self.assertEqual(b.statuses, ['GUARD_FAILED'])
        self.assertEqual(b.failed[-1]['status'], 'FINAL_OR_SCHEDULER_GUARD_FAILED')
        self.assertFalse(any('PASS' in x or 'COMPLETE' in x for x in b.statuses))


class InventoryTests(Fixture):
    def test_unchanged_inventory_and_lookup_match_globs(self):
        for name in ['A.olean.private', 'A.olean.server', 'A.oleanX', 'A.ir',
                     'A.ir.sig', 'A.ir.unexpected', 'A.irrelevant', 'A.ole',
                     'AB.olean', 'A1.olean', 'Other.olean', "A'B.olean"]:
            self.put('Fixture/' + name)
        self.put('Fixture/A.olean.directory/nested.olean')
        self.put('Elsewhere/A.olean')
        snapshot = self.snapshot()
        for base in [self.base, self.art/'Fixture/AB.olean',
                     self.art/'Fixture/Missing.olean', self.art/'Missing/A.olean',
                     self.art/'Elsewhere/A.olean', self.art/"Fixture/A'B.olean"]:
            self.assertEqual(snapshot.files(base), r.artifact_files(base))
        snapshot.verify_unchanged()
        self.assertIn(self.art/'Fixture/A.irrelevant', snapshot.files(self.base))
        self.assertNotIn(self.art/'Fixture/A.olean.directory', snapshot.files(self.base))

    def test_empty_inventory(self):
        empty = self.root/'empty'
        empty.mkdir()
        snapshot = r.FinalArtifactInventory(empty)
        self.assertEqual(snapshot.files(empty/'No.olean'), [])
        snapshot.verify_unchanged()

    def test_added_sidecar(self):
        self.rejects_mutation(lambda: self.put('Fixture/A.olean.new'))

    def test_added_unrelated_regular_file(self):
        self.rejects_mutation(lambda: self.put('unrelated.txt'))

    def test_deleted_artifact(self):
        self.rejects_mutation(self.base.unlink)

    def test_renamed_artifact(self):
        self.rejects_mutation(lambda: self.base.rename(self.base.with_name('Moved.olean')))

    def test_same_size_rewrite_even_with_mtime_restored(self):
        def mutate():
            before = self.base.stat()
            self.base.write_bytes(b'modified')
            os.utime(self.base, ns=(before.st_atime_ns, before.st_mtime_ns))
        self.rejects_mutation(mutate)

    def test_same_content_inode_replacement(self):
        replacement = self.root/'replacement'
        replacement.write_bytes(self.base.read_bytes())
        before = self.base.stat()
        os.utime(replacement, ns=(before.st_atime_ns, before.st_mtime_ns))
        self.rejects_mutation(lambda: os.replace(replacement, self.base))

    def test_metadata_only_chmod(self):
        self.rejects_mutation(lambda: self.base.chmod(stat.S_IMODE(self.base.stat().st_mode) ^ stat.S_IXUSR))

    def test_nested_directory_addition(self):
        self.rejects_mutation(lambda: (self.art/'Fixture/new-dir').mkdir())

    def test_nested_directory_removal(self):
        directory = self.art/'Fixture/empty-dir'
        directory.mkdir()
        self.rejects_mutation(directory.rmdir)

    def test_transient_member_restored_names_still_detected(self):
        def mutate():
            transient = self.put('Fixture/transient.tmp')
            transient.unlink()
        self.rejects_mutation(mutate)

    def test_preexisting_hardlink_allowed_but_alias_rewrite_detected(self):
        alias = self.art/'Fixture/A.olean.alias'
        os.link(self.base, alias)
        snapshot = self.snapshot()
        self.assertEqual(snapshot.files(self.base), r.artifact_files(self.base))
        snapshot.verify_unchanged()
        alias.write_bytes(b'modified')
        with self.assertRaises(RuntimeError):
            snapshot.verify_unchanged()

    def test_hardlink_added_after_snapshot(self):
        self.rejects_mutation(lambda: os.link(self.base, self.art/'alias'))

    def test_file_symlink_rejected(self):
        (self.art/'linked.olean').symlink_to(self.base)
        with self.assertRaisesRegex(RuntimeError, 'Symlink'):
            self.snapshot()

    def test_directory_symlink_alias_rejected(self):
        (self.art/'alias-directory').symlink_to(self.base.parent, target_is_directory=True)
        with self.assertRaisesRegex(RuntimeError, 'Symlink'):
            self.snapshot()

    def test_root_symlink_rejected(self):
        alias = self.root/'root-alias'
        alias.symlink_to(self.art, target_is_directory=True)
        with self.assertRaisesRegex(RuntimeError, 'Symlink'):
            r.FinalArtifactInventory(alias)

    @unittest.skipUnless(hasattr(os, 'mkfifo'), 'requires POSIX FIFO')
    def test_special_file_rejected_without_opening(self):
        os.mkfifo(self.art/'pipe')
        with self.assertRaisesRegex(RuntimeError, 'Nonregular'):
            self.snapshot()

    def test_insertion_during_initial_snapshot(self):
        original = r.FinalArtifactInventory.metadata_of
        inserted = []
        def metadata(path):
            value = original(path)
            if path == self.base and not inserted:
                inserted.append(self.put('Fixture/late.olean'))
            return value
        with mock.patch.object(r.FinalArtifactInventory, 'metadata_of', staticmethod(metadata)):
            with self.assertRaisesRegex(RuntimeError, 'changed during inventory'):
                self.snapshot()
        self.assertEqual(len(inserted), 1)

    def test_rewrite_of_earlier_subtree_during_capture(self):
        earlier = self.put('A-subtree/First.olean', b'original')
        later = self.put('Z-subtree/Last.olean')
        original = r.FinalArtifactInventory.metadata_of
        changed = []
        def metadata(path):
            value = original(path)
            if path == later and not changed:
                changed.append(True)
                earlier.write_bytes(b'modified')
            return value
        with mock.patch.object(r.FinalArtifactInventory, 'metadata_of', staticmethod(metadata)):
            with self.assertRaisesRegex(RuntimeError, 'Artifact entry changed during inventory'):
                self.snapshot()

    def test_mutation_during_final_snapshot(self):
        snapshot = self.snapshot()
        original = r.FinalArtifactInventory.metadata_of
        changed = []
        def metadata(path):
            value = original(path)
            if path == self.base and not changed:
                changed.append(True)
                self.base.write_bytes(b'modified')
            return value
        with mock.patch.object(r.FinalArtifactInventory, 'metadata_of', staticmethod(metadata)):
            with self.assertRaisesRegex(RuntimeError, 'Artifact entry changed during inventory'):
                snapshot.verify_unchanged()


class GateTests(Fixture):
    def test_valid_final_sweep_retains_runtime_source_and_content_gates(self):
        b = self.make_build()
        with mock.patch.object(b.pins, 'verify', wraps=b.pins.verify) as verify:
            self.assertEqual(b.run(), 0)
        self.assertEqual(b.statuses, ['FRESH_PROJECT_SOURCE_BUILD_PASS'])
        self.assertEqual(b.runtime_calls, [{'full': True}])
        checked = {str(call.args[0]) for call in verify.call_args_list}
        for n in b.names:
            self.assertIn(str(b.src/r.module_path(n)), checked)
            self.assertIn(str(b.art/r.module_path(n, '.olean')), checked)
            self.assertIn(str(b.accepted[n]['path']), checked)
            self.assertIn(str(b.accepted[n]['path'].parent/'compiler.log'), checked)
        self.assertIn(str(b.src/'lean-toolchain'), checked)

    def test_valid_resumed_sweep_reports_resumed_not_fresh(self):
        b = self.make_build()
        b.a.resume = True
        self.assertEqual(b.run(), 0)
        self.assertEqual(b.statuses, ['PROJECT_SOURCE_BUILD_COMPLETE_RESUMED'])

    def test_wrong_artifact_hash_not_replaced_by_inventory(self):
        b = self.make_build()
        bundle = b.accepted['Fixture.A']['row']['artifact_bundle']
        bundle[next(iter(bundle))] = '0' * 64
        self.assert_gate_failure(b)
        self.assertIn('SHA256 mismatch', b.failed[-1]['error'])

    def test_cached_hash_invalidated_on_rewrite(self):
        b = self.make_build()
        b.guard_bundle('Fixture.A', b.accepted['Fixture.A']['row']['artifact_bundle'])
        self.base.write_bytes(b'Changed.A')
        self.assert_gate_failure(b)
        self.assertIn('SHA256 mismatch', b.failed[-1]['error'])

    def test_unexpected_exotic_sidecar_rejected(self):
        b = self.make_build()
        self.put('Fixture/A.irrelevant')
        self.assert_gate_failure(b)
        self.assertIn('sidecar inventory changed', b.failed[-1]['error'])

    def test_dependency_receipt_hash_preserved(self):
        b = self.make_build()
        b.accepted['Fixture.A']['path'].write_text('changed receipt')
        with self.assertRaisesRegex(RuntimeError, 'SHA256 mismatch'):
            b.guard_dependencies('Fixture.B', self.snapshot())
        self.assert_gate_failure(b)

    def test_leaf_receipt_hash_preserved(self):
        b = self.make_build()
        b.accepted['Fixture.B']['path'].write_text('changed leaf receipt')
        self.assert_gate_failure(b)

    def test_log_hash_preserved(self):
        b = self.make_build()
        (b.accepted['Fixture.B']['path'].parent/'compiler.log').write_text('changed log')
        self.assert_gate_failure(b)

    def test_source_hash_preserved(self):
        b = self.make_build()
        (b.src/r.module_path('Fixture.B')).write_text('changed source')
        self.assert_gate_failure(b)

    def test_configuration_hash_preserved(self):
        b = self.make_build()
        (b.src/'lean-toolchain').write_text('changed configuration')
        self.assert_gate_failure(b)

    def test_runtime_guard_failure_never_passes(self):
        b = self.make_build()
        b.guard_runtime = mock.Mock(side_effect=RuntimeError('synthetic runtime pin failure'))
        self.assert_gate_failure(b)

    def test_rewrite_after_last_artifact_hash_rejected_by_final_snapshot(self):
        b = self.make_build()
        original = b.guard_bundle
        def guard(n, expected, final_inventory=None):
            original(n, expected, final_inventory)
            if n == 'Fixture.B':
                (b.art/r.module_path(n, '.olean')).write_bytes(b'Changed.B')
        b.guard_bundle = guard
        self.assert_gate_failure(b)
        self.assertIn('Artifact tree changed during final verification sweep', b.failed[-1]['error'])

    def test_added_sidecar_after_last_bundle_lookup_never_passes(self):
        b = self.make_build()
        original = b.guard_bundle
        def guard(n, expected, final_inventory=None):
            original(n, expected, final_inventory)
            if n == 'Fixture.B':
                self.put('Fixture/B.olean.late')
        b.guard_bundle = guard
        self.assert_gate_failure(b)

    def test_snapshot_constructed_only_after_worker_pool_shutdown(self):
        b = self.make_build()
        events = []
        executor = r.concurrent.futures.ThreadPoolExecutor
        inventory = r.FinalArtifactInventory
        class TrackedExecutor(executor):
            def shutdown(self, *args, **kwargs):
                result = super().shutdown(*args, **kwargs)
                events.append('workers_drained')
                return result
        def capture(root):
            self.assertEqual(events, ['workers_drained'])
            events.append('snapshot')
            return inventory(root)
        with mock.patch.object(r.concurrent.futures, 'ThreadPoolExecutor', TrackedExecutor), \
                mock.patch.object(r, 'FinalArtifactInventory', side_effect=capture):
            self.assertEqual(b.run(), 0)
        self.assertEqual(events, ['workers_drained', 'snapshot'])


if __name__ == '__main__':
    unittest.main(verbosity=2)
