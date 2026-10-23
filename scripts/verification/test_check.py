#!/usr/bin/env python3
"""Synthetic lifecycle tests for check.py; no Lean compiler or checker is run.

The repository validator and process/helper boundaries are mocked. The real
wrapper orchestration, source-policy binding, audit-freeze binding, replay-log
acceptance, failure retention, and outcome/status decisions are exercised.
"""
import argparse
import contextlib
import copy
import hashlib
import importlib.util
import io
import json
import os
from pathlib import Path
import py_compile
import sys
import tempfile
import types
import unittest
from unittest import mock

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
check = types.ModuleType('verification_check_under_test')
check.__file__ = str(HERE/'check.py')
exec(compile((HERE/'check.py').read_bytes(), str(HERE/'check.py'), 'exec'), check.__dict__)


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, sort_keys=True, indent=2) + '\n')


class Fixture:
    def __init__(self, root):
        self.root = root/'source'
        self.root.mkdir()
        self.build = root/'build'
        self.out = root/'evidence'
        self.checker = root/'toolchain/bin/leanchecker'
        self.checker.parent.mkdir(parents=True)
        self.checker.write_bytes(b'Synthetic checker identity; never executed.\n')
        self.source_lock = {
            'namespace': 'D1Bound5', 'roots': ['D1Bound5'], 'module_count': 1,
            'sources': {'D1Bound5': {
                'relative_path': 'D1Bound5.lean', 'bytes': 12,
                'sha256': hashlib.sha256(b'synthetic-source').hexdigest(), 'imports': []}}}
        self.source_lock_path = root/'source-lock.json'
        write_json(self.source_lock_path, self.source_lock)
        self.runtime_lock_path = root/'runtime-lock.json'
        write_json(self.runtime_lock_path, {
            'toolchain': str(self.checker.parents[1]),
            'files': {str(self.checker): check.sha(self.checker)}})
        self.frozen = {
            'environment': {'PATH': '/synthetic/bin', 'LEAN_PATH': str(self.build/'artifacts')},
            'source_lock_sha256': check.sha(self.source_lock_path),
            'origin': 'Synthetic fixture only; no build or replay claim.'}
        self.committed = {'commit': '1'*40, 'tree': '2'*40,
                          'selected_files': {'scripts/verification/clean_final_audits.py': '3'*64},
                          'selected_files_match_commit': True, 'production_scope': 1}
        self.args = argparse.Namespace(
            evidence_dir=str(self.out), build_dir=str(self.build),
            source_lock=str(self.source_lock_path), source_lock_sha256=check.sha(self.source_lock_path),
            runtime_lock=str(self.runtime_lock_path), runtime_lock_sha256=check.sha(self.runtime_lock_path),
            jobs=2, resume=False, hints=None, replay=False, build_timeout=1200,
            audit_timeout=60, replay_timeout=60)
        self.calls = []
        self.policy_status = 'SOURCE_POLICY_PASS_SOURCE_ONLY'
        self.change_policy_manifest = False
        self.audit_hash_mismatch = False
        self.current_freeze_mismatch = False
        self.kernel_after_freeze_mismatch = False
        self.kernel_ran = False
        self.build_exit = 0
        self.build_status = 'FRESH_PROJECT_SOURCE_BUILD_PASS'
        self.replay_exit = 0
        self.replay_log = 'replaying D1Bound5 with --fresh\n'
        self.failed_receipt = None
        self.helper = types.SimpleNamespace(load_builder=lambda path: object(), freeze=self.freeze)

    def freeze(self, args, builder):
        result = copy.deepcopy(self.frozen)
        if self.current_freeze_mismatch or (self.kernel_ran and self.kernel_after_freeze_mismatch):
            result['origin'] = 'Changed synthetic input'
        return result

    def command(self, command, log_path, cwd, env=None, timeout=None):
        self.calls.append(list(command))
        name = Path(command[1]).name if command[0] == sys.executable else Path(command[0]).name
        log_path = Path(log_path)
        log_path.write_text('synthetic subprocess output\n')
        code = 0
        if name == 'source_policy.py':
            write_json(self.out/'source-policy/SOURCE_POLICY_REPORT.json', {'status': self.policy_status})
            rows = {n: {k: row[k] for k in ['relative_path', 'bytes', 'sha256']}
                    for n, row in self.source_lock['sources'].items()}
            if self.change_policy_manifest:
                rows['D1Bound5']['sha256'] = 'f'*64
            write_json(self.out/'source-policy/SOURCE_MANIFEST.json', rows)
        elif name == 'fresh_project_build.py':
            self.build.mkdir(exist_ok=True)
            (self.build/'build.lock').touch()
            write_json(self.build/'SUMMARY.json', {'status': self.build_status})
            code = self.build_exit
            if code:
                self.failed_receipt = self.build/'attempts/synthetic-failure/receipt.json'
                write_json(self.failed_receipt, {'status': 'TIMEOUT', 'exit_code': code,
                                               'original_timeout': 240, 'immutable_marker': 'retain me'})
                self.failed_receipt_bytes = self.failed_receipt.read_bytes()
        elif name == 'clean_final_audits.py':
            freeze = self.out/'audits/INPUT_FREEZE.json'
            write_json(freeze, self.frozen)
            write_json(self.out/'audits/SUMMARY.json', {
                'status': 'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS',
                'input_freeze_sha256': '0'*64 if self.audit_hash_mismatch else check.sha(freeze)})
        elif name == 'leanchecker':
            self.kernel_ran = True
            log_path.write_text(self.replay_log)
            code = self.replay_exit
        else:
            raise AssertionError('Unexpected synthetic command: ' + repr(command))
        return {'command': command, 'exit_code': code, 'seconds': 0.0,
                'log_sha256': check.sha(log_path)}

    def run(self):
        with mock.patch.object(check, 'ROOT', self.root), \
             mock.patch.object(check, 'validate_repository', return_value=copy.deepcopy(self.committed)), \
             mock.patch.object(check, 'run_command', side_effect=self.command), \
             mock.patch.object(check, 'import_file', return_value=self.helper), \
             contextlib.redirect_stdout(io.StringIO()):
            return check.run(self.args)

    def summary(self):
        return json.loads((self.out/'SUMMARY.json').read_text())


class WrapperLifecycle(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='verification-wrapper-selfcheck-')
        self.f = Fixture(Path(self.temp.name))

    def tearDown(self):
        self.temp.cleanup()

    def assert_failed(self, message):
        with self.assertRaisesRegex(RuntimeError, message):
            self.f.run()
        row = self.f.summary()
        self.assertEqual(row['status'], 'FAILED_OR_INTERRUPTED_NO_COMPLETE_ACCEPTANCE')
        self.assertFalse(row['complete_verification'])
        self.assertEqual(row['official_fresh_kernel_replay'], 'PENDING')
        return row

    def test_source_policy_snapshot_mismatch_stops_before_build(self):
        self.f.change_policy_manifest = True
        self.assert_failed('different source snapshot')
        self.assertEqual(len(self.f.calls), 1)
        self.assertFalse(self.f.build.exists())

    def test_unaccepted_source_policy_report_stops_before_build(self):
        self.f.policy_status = 'UNREVIEWED_FINDINGS'
        self.assert_failed('did not accept exact reviewed findings')
        self.assertEqual(len(self.f.calls), 1)

    def test_audited_freeze_hash_is_binding(self):
        self.f.audit_hash_mismatch = True
        self.assert_failed('Audited input freeze hash changed')
        self.assertFalse(self.f.kernel_ran)

    def test_current_freeze_must_equal_audited_snapshot(self):
        self.f.current_freeze_mismatch = True
        self.assert_failed('differ from the exact type/axiom-audited snapshot')
        self.assertFalse(self.f.kernel_ran)

    def test_without_replay_exit_three_stays_pending(self):
        self.assertEqual(self.f.run(), 3)
        row = self.f.summary()
        self.assertEqual(row['status'], 'SOURCE_BUILD_AND_AUDITS_PASS_FRESH_REPLAY_PENDING')
        self.assertFalse(row['complete_verification'])
        self.assertEqual(row['official_fresh_kernel_replay'], 'PENDING')
        self.assertFalse(self.f.kernel_ran)
        audit = self.f.calls[-1]
        self.assertEqual(audit[audit.index('--expected-commit')+1], self.f.committed['commit'])
        self.assertEqual(audit[audit.index('--expected-tree')+1], self.f.committed['tree'])

    def test_explicit_fresh_canonical_marker_accepts_only_requested_scope(self):
        self.f.args.replay = True
        self.assertEqual(self.f.run(), 0)
        self.assertTrue(self.f.summary()['complete_verification'])
        self.assertEqual(self.f.calls[-1], [str(self.f.checker), '--verbose', '--fresh', 'D1Bound5'])

    def test_exit_zero_without_fresh_marker_is_not_acceptance(self):
        self.f.args.replay = True
        self.f.replay_log = 'synthetic checker exit zero without replay marker\n'
        self.assert_failed('Unexpected replay target/scope')

    def test_wrong_or_additional_replay_scope_is_not_acceptance(self):
        self.f.args.replay = True
        self.f.replay_log = 'replaying D1Bound5 with --fresh\nreplaying Mathlib with --fresh\n'
        self.assert_failed('Unexpected replay target/scope')

    def test_post_replay_freeze_change_is_rejected(self):
        self.f.args.replay = True
        self.f.kernel_after_freeze_mismatch = True
        self.assert_failed('Frozen replay inputs changed')

    def test_failed_build_retains_original_attempt_and_nonzero_evidence(self):
        self.f.build_exit = 7
        self.f.build_status = 'BUILD_FAILED'
        row = self.assert_failed('Fresh source build failed or remains incomplete')
        self.assertEqual(self.f.failed_receipt.read_bytes(), self.f.failed_receipt_bytes)
        self.assertEqual(row['steps'][-1]['exit_code'], 7)
        self.assertEqual(row['fresh_source_build'], 'PENDING')
        self.assertEqual(len(self.f.calls), 2)
        self.assertTrue((self.f.out/'build.log').is_file())

    def test_replay_nonzero_retains_log_and_never_accepts(self):
        self.f.args.replay = True
        self.f.replay_exit = 17
        row = self.assert_failed('Official fresh replay failed')
        self.assertEqual(row['steps'][-1]['exit_code'], 17)
        self.assertEqual((self.f.out/'fresh-kernel.log').read_text(), self.f.replay_log)

    def test_helper_loader_ignores_timestamp_and_size_valid_stale_pyc(self):
        path = Path(self.temp.name)/'synthetic_helper.py'
        path.write_text("VALUE = 'stale'\n")
        before = path.stat()
        cached = py_compile.compile(str(path), doraise=True,
                                    invalidation_mode=py_compile.PycInvalidationMode.TIMESTAMP)
        self.assertTrue(Path(cached).is_file())
        path.write_text("VALUE = 'fresh'\n")
        os.utime(path, ns=(before.st_atime_ns, before.st_mtime_ns))
        self.assertEqual(path.stat().st_size, before.st_size)
        self.assertEqual(path.stat().st_mtime_ns, before.st_mtime_ns)
        # Demonstrate that the fixture really would load stale bytecode through
        # the ordinary timestamp/size cache loader.
        stale_spec = importlib.util.spec_from_file_location('ordinary_cached_helper', path)
        stale_module = importlib.util.module_from_spec(stale_spec)
        stale_spec.loader.exec_module(stale_module)
        self.assertEqual(stale_module.VALUE, 'stale')
        loaded = check.import_file(path, 'reviewed_exact_helper', check.sha(path))
        self.assertEqual(loaded.VALUE, 'fresh')

    def test_helper_hash_mismatch_fails_before_execution(self):
        path = Path(self.temp.name)/'synthetic_helper.py'
        path.write_text("raise AssertionError('must not execute mismatched source')\n")
        with self.assertRaisesRegex(RuntimeError, 'differs from committed input'):
            check.import_file(path, 'mismatched_helper', '0'*64)

    def parsed_arguments(self, additional=()):
        argv = ['check.py']
        for name in ['source_lock', 'source_lock_sha256', 'runtime_lock', 'runtime_lock_sha256',
                     'build_dir', 'evidence_dir']:
            argv.extend(['--'+name.replace('_', '-'), getattr(self.f.args, name)])
        argv.extend(additional)
        with mock.patch.object(sys, 'argv', argv), mock.patch.object(check, 'run', return_value=3) as run:
            self.assertEqual(check.main(), 3)
        return run.call_args.args[0]

    def test_default_build_timeout_is_1200_and_forwarded(self):
        parsed = self.parsed_arguments()
        self.assertEqual(parsed.build_timeout, 1200)
        self.f.args.build_timeout = parsed.build_timeout
        self.assertEqual(self.f.run(), 3)
        build = self.f.calls[1]
        self.assertEqual(build[build.index('--timeout')+1], '1200')

    def test_explicit_build_timeout_override_is_forwarded(self):
        parsed = self.parsed_arguments(['--build-timeout', '1800'])
        self.assertEqual(parsed.build_timeout, 1800)
        self.f.args.build_timeout = parsed.build_timeout
        self.assertEqual(self.f.run(), 3)
        build = self.f.calls[1]
        self.assertEqual(build[build.index('--timeout')+1], '1800')

    def test_nonpositive_build_timeout_is_rejected_before_execution(self):
        with self.assertRaisesRegex(RuntimeError, 'Timeouts must be positive'):
            self.parsed_arguments(['--build-timeout', '0'])
        self.assertEqual(self.f.calls, [])


if __name__ == '__main__':
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(WrapperLifecycle)
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    print(json.dumps({'status': 'PASS_SYNTHETIC_WRAPPER_LIFECYCLE' if result.wasSuccessful() else 'FAIL',
                      'tests_run': result.testsRun, 'wrapper_sha256': check.sha(HERE/'check.py'),
                      'real_lean_or_checker_launched': False,
                      'scope': 'Synthetic boundary mocks exercise orchestration; no theorem/kernel verification claim.'},
                     sort_keys=True, indent=2))
    sys.exit(0 if result.wasSuccessful() else 1)
