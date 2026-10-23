#!/usr/bin/env python3
"""Synthetic byte fixtures only: no Lean, Git, actual build or network."""
import copy
import io
import json
from pathlib import Path
import shutil
import tarfile
import tempfile
from types import SimpleNamespace
import unittest
from unittest import mock
import checkpoint_export as e


class CheckpointTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='checkpoint-fixture-')
        self.root = Path(self.tmp.name).resolve()
        self.src = self.root / 'source'; self.src.mkdir()
        self.build = self.root / 'build'; self.build.mkdir()
        self.spec_path = self.root / 'SPEC.json'
        self.sl = {'schema': 1, 'namespace': 'D1Bound5', 'roots': ['D1Bound5.B'],
                   'sources': {}, 'auxiliary': {}, 'topological_order': ['D1Bound5.A', 'D1Bound5.B'], 'module_count': 2}
        for n, deps in [('D1Bound5.A', []), ('D1Bound5.B', ['D1Bound5.A'])]:
            rel = e.mpath(n, '.lean'); data = ('-- synthetic fixture ' + n + '\n').encode()
            self.put(self.src / rel, data)
            self.sl['sources'][n] = {'relative_path': rel, 'sha256': e.data_sha(data), 'bytes': len(data), 'imports': deps}
        self.put(self.src / 'lean-toolchain', b'fixture-not-an-executable\n')
        self.sl['auxiliary']['lean-toolchain'] = e.file_sha(self.src / 'lean-toolchain')
        self.put(self.root / 'source-lock.json', e.encoded(self.sl))
        self.put(self.root / 'runtime-lock.json', e.encoded({'schema': 1, 'files': {}, 'lean': '/synthetic/never-executed/lean', 'scope': 'SYNTHETIC_ONLY'}))
        self.put(self.root / 'runner.py', b'# synthetic runner identity, never executed\n')
        self.spec = {'schema': 1, 'build_id': 'a' * 32, 'source_root': str(self.src), 'build_dir': str(self.build)}
        for role, filename in [('source_lock', 'source-lock.json'), ('runtime_lock', 'runtime-lock.json'), ('runner', 'runner.py')]:
            self.spec[role] = {'path': str(self.root / filename), 'sha256': e.file_sha(self.root / filename)}
        identity = {'schema': 1, 'source_root': str(self.src), 'build_dir': str(self.build),
                    'source_lock_sha256': self.spec['source_lock']['sha256'],
                    'runtime_lock_sha256': self.spec['runtime_lock']['sha256'],
                    'runner_sha256': self.spec['runner']['sha256'], 'environment': {'SYNTHETIC_ONLY': '1'}}
        self.spec['identity_hash'] = e.digest(identity)
        self.origin = {'build_id': self.spec['build_id'], 'identity_hash': self.spec['identity_hash'],
                       'identity': identity, 'initial_artifact_inventory': []}
        self.put(self.build / 'ORIGIN.json', e.encoded(self.origin))
        self.spec['origin_sha256'] = e.file_sha(self.build / 'ORIGIN.json')
        self.save_spec()
        self.rows = {}
        self.accept('D1Bound5.A', '1' * 32)
        self.accept('D1Bound5.B', '2' * 32)

    def tearDown(self):
        self.tmp.cleanup()

    def put(self, path, data):
        path.parent.mkdir(parents=True, exist_ok=True); path.write_bytes(data)

    def save_spec(self):
        self.put(self.spec_path, e.encoded(self.spec))

    def accept(self, n, aid):
        bundle = {}
        for suffix in ['.olean', '.olean.private', '.olean.server', '.ir', '.ir.sig']:
            rel = e.mpath(n, suffix); data = ('artifact fixture ' + rel).encode()
            self.put(self.build / 'artifacts' / rel, data); bundle[rel] = e.data_sha(data)
        receipt_path = 'attempts/' + n + '/' + aid + '/receipt.json'
        log = b'original synthetic compiler log\n'
        self.put((self.build / receipt_path).parent / 'compiler.log', log)
        deps = {d: {'receipt_sha256': self.rows[d]['receipt_sha256'], 'artifact_bundle': self.rows[d]['row']['artifact_bundle']}
                for d in self.sl['sources'][n]['imports']}
        row = {'schema': 1, 'module': n, 'build_id': self.spec['build_id'], 'identity_hash': self.spec['identity_hash'],
               'source_sha256': self.sl['sources'][n]['sha256'], 'status': 'COMPILE_PASS', 'exit_code': 0,
               'dependencies': deps, 'artifact_bundle': bundle, 'log_sha256': e.data_sha(log), 'invocation': '3' * 32,
               'command': ['/synthetic/never-executed/lean', '-j1', '-DautoImplicit=false', '-R', str(self.src),
                           '-o', str(self.build / 'attempts' / n / aid / 'stage' / e.mpath(n, '.olean')),
                           str(self.src / e.mpath(n, '.lean'))]}
        self.put(self.build / 'invocations' / ('3' * 32) / 'START.json', e.encoded({'identity_hash': self.spec['identity_hash']}))
        self.put(self.build / receipt_path, e.encoded(row))
        pointer = {'receipt_path': receipt_path, 'receipt_sha256': e.file_sha(self.build / receipt_path)}
        self.put(self.build / 'accepted' / e.mpath(n, '.json'), e.encoded(pointer))
        self.rows[n] = dict(pointer, row=row)

    def rewrite_receipt(self, n, change):
        p = self.build / self.rows[n]['receipt_path']; row = json.loads(p.read_text()); change(row)
        self.put(p, e.encoded(row))
        pointer = {'receipt_path': self.rows[n]['receipt_path'], 'receipt_sha256': e.file_sha(p)}
        self.put(self.build / 'accepted' / e.mpath(n, '.json'), e.encoded(pointer))

    def prepare(self, number=1, previous=None, max_modules=50, max_bytes=512 * e.MIB):
        return e.prepare(SimpleNamespace(spec=str(self.spec_path), spec_sha256=e.file_sha(self.spec_path),
            out=str(self.root / ('prepared-' + str(number))), previous=str(previous) if previous else None,
            previous_sha256=e.file_sha(previous) if previous else None, max_modules=max_modules, max_bytes=max_bytes))

    def arrival(self, prepared, number=1, previous=None, alter=None):
        dest = self.root / ('durable-' + str(number)); dest.mkdir()
        for name in ['batch.tar.gz', 'PREPARED.json']:
            shutil.copyfile(Path(prepared['archive']).parent / name, dest / name)
        if alter: alter(dest)
        args = SimpleNamespace(archive=str(dest / 'batch.tar.gz'), archive_sha256=prepared['archive_sha256'],
            prepared=str(dest / 'PREPARED.json'), prepared_sha256=prepared['prepared_sha256'], destination=str(dest),
            previous=str(previous) if previous else None, previous_sha256=e.file_sha(previous) if previous else None)
        result = e.verify_arrival(args)
        return Path(result['path'])

    def test_full_bundles_original_bytes_and_no_acceptance_claim(self):
        p = self.prepare(); durable = self.arrival(p); row = json.loads(durable.read_text())
        self.assertEqual(len(row['cumulative']), 2); self.assertFalse(row['proof_acceptance_claim'])
        with tarfile.open(p['archive']) as tar:
            names = tar.getnames()
            self.assertIn('build/artifacts/D1Bound5/A.olean.private', names)
            self.assertIn('build/artifacts/D1Bound5/A.ir.sig', names)
            for module in self.rows:
                path = self.rows[module]['receipt_path']
                self.assertEqual(tar.extractfile('build/' + path).read(), (self.build / path).read_bytes())

    def test_two_batches_dependency_chain_and_metadata_every_batch(self):
        first = self.arrival(self.prepare(max_modules=1)); second = self.prepare(2, first)
        durable = self.arrival(second, 2, first)
        row = json.loads(durable.read_text()); self.assertEqual(row['batch_number'], 2)
        self.assertEqual(row['modules'], ['D1Bound5.B']); self.assertEqual(len(row['cumulative']), 2)
        with tarfile.open(second['archive']) as tar:
            self.assertIn('metadata/runtime_lock.json', tar.getnames())
            self.assertIn('chain/PREVIOUS_DURABLE.json', tar.getnames())

    def test_active_unaccepted_and_failed_attempts_are_ignored(self):
        (self.build / 'accepted' / 'D1Bound5/B.json').unlink()
        self.put(self.build / 'attempts/D1Bound5.B/active/receipt.json', b'{"status":"RUNNING"}')
        p = self.prepare(); self.assertEqual(p['new_modules'], 1)
        with tarfile.open(p['archive']) as tar:
            self.assertFalse(any('D1Bound5.B' in x or '/B.' in x for x in tar.getnames()))

    def test_source_changed_rejected(self):
        self.put(self.src / 'D1Bound5/A.lean', b'changed')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_artifact_corruption_rejected(self):
        self.put(self.build / 'artifacts/D1Bound5/A.olean.private', b'changed')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_missing_sidecar_rejected(self):
        (self.build / 'artifacts/D1Bound5/A.ir.sig').unlink()
        with self.assertRaises(RuntimeError): self.prepare()

    def test_extra_sidecar_rejected(self):
        self.put(self.build / 'artifacts/D1Bound5/A.olean.evil', b'extra')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_artifact_symlink_rejected(self):
        p = self.build / 'artifacts/D1Bound5/A.olean'; p.unlink(); p.symlink_to(self.src / 'D1Bound5/A.lean')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_log_corruption_rejected(self):
        self.put((self.build / self.rows['D1Bound5.A']['receipt_path']).parent / 'compiler.log', b'changed')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_receipt_hash_mismatch_rejected(self):
        self.put(self.build / self.rows['D1Bound5.A']['receipt_path'], b'{}')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_foreign_build_rejected(self):
        self.rewrite_receipt('D1Bound5.A', lambda x: x.update(build_id='b' * 32))
        with self.assertRaises(RuntimeError): self.prepare()

    def test_not_pass_rejected(self):
        self.rewrite_receipt('D1Bound5.A', lambda x: x.update(status='RUNNING'))
        with self.assertRaises(RuntimeError): self.prepare()

    def test_nonzero_exit_rejected(self):
        self.rewrite_receipt('D1Bound5.A', lambda x: x.update(exit_code=1))
        with self.assertRaises(RuntimeError): self.prepare()

    def test_dependency_chain_changed_rejected(self):
        self.rewrite_receipt('D1Bound5.B', lambda x: x['dependencies']['D1Bound5.A'].update(receipt_sha256='0' * 64))
        with self.assertRaises(RuntimeError): self.prepare()

    def test_escaping_receipt_rejected(self):
        p = self.build / 'accepted/D1Bound5/A.json'; row = json.loads(p.read_text()); row['receipt_path'] = '../runner.py'
        self.put(p, e.encoded(row))
        with self.assertRaises(RuntimeError): self.prepare()

    def test_foreign_origin_rejected(self):
        self.origin['build_id'] = 'c' * 32; self.put(self.build / 'ORIGIN.json', e.encoded(self.origin))
        with self.assertRaises(RuntimeError): self.prepare()

    def test_runtime_lock_change_rejected(self):
        self.put(self.root / 'runtime-lock.json', b'{}')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_runner_change_rejected(self):
        self.put(self.root / 'runner.py', b'changed')
        with self.assertRaises(RuntimeError): self.prepare()

    def test_prepared_receipt_cannot_advance_chain(self):
        p = self.prepare(max_modules=1)
        with self.assertRaises(RuntimeError): self.prepare(2, Path(p['prepared']))

    def test_new_identity_cannot_use_previous_chain(self):
        first = self.arrival(self.prepare(max_modules=1)); self.spec['extra_metadata'] = {}; self.save_spec()
        with self.assertRaises(RuntimeError): self.prepare(2, first)

    def test_changed_previous_pointer_rejected(self):
        first = self.arrival(self.prepare(max_modules=1))
        p = self.build / 'accepted/D1Bound5/A.json'; p.write_bytes(p.read_bytes() + b' ')
        with self.assertRaises(RuntimeError): self.prepare(2, first)

    def test_archive_transport_corruption_rejected(self):
        p = self.prepare()
        with self.assertRaises(RuntimeError): self.arrival(p, alter=lambda d: (d / 'batch.tar.gz').write_bytes(b'corrupt'))

    def test_prepared_transport_corruption_rejected(self):
        p = self.prepare()
        with self.assertRaises(RuntimeError): self.arrival(p, alter=lambda d: (d / 'PREPARED.json').write_bytes(b'{}'))

    def test_snapshot_cannot_overwrite_existing_output(self):
        self.prepare()
        with self.assertRaises(RuntimeError): self.prepare()

    def test_durable_confirmation_cannot_be_overwritten(self):
        p = self.prepare(); self.arrival(p); d = self.root / 'durable-1'
        args = SimpleNamespace(archive=str(d / 'batch.tar.gz'), archive_sha256=p['archive_sha256'],
            prepared=str(d / 'PREPARED.json'), prepared_sha256=p['prepared_sha256'], destination=str(d),
            previous=None, previous_sha256=None)
        with self.assertRaises(RuntimeError): e.verify_arrival(args)

    def test_compression_time_source_mutation_rejected(self):
        original = tarfile.TarFile.addfile; changed = [False]
        def mutate(tar, info, fileobj=None):
            result = original(tar, info, fileobj)
            if not changed[0]:
                changed[0] = True; self.put(self.src / 'D1Bound5/A.lean', b'changed while compression')
            return result
        with mock.patch.object(tarfile.TarFile, 'addfile', mutate):
            with self.assertRaises(RuntimeError): self.prepare()
        self.assertFalse((self.root / 'prepared-1/PREPARED.json').exists())

    def test_batch_limits_enforced(self):
        with self.assertRaises(RuntimeError): self.prepare(max_modules=101)
        with self.assertRaises(RuntimeError): self.prepare(max_bytes=1)

    def test_no_new_modules_creates_no_batch(self):
        first = self.arrival(self.prepare())
        with self.assertRaises(RuntimeError): self.prepare(2, first)
        self.assertFalse((self.root / 'prepared-2').exists())

    def test_archive_member_traversal_rejected(self):
        p = self.prepare(); d = Path(p['archive']).parent
        with tarfile.open(p['archive']) as tar:
            old = [(x.name, tar.extractfile(x).read()) for x in tar]
        with tarfile.open(p['archive'], 'w:gz') as tar:
            for name, data in old + [('../escape', b'bad')]:
                info = tarfile.TarInfo(name); info.size = len(data); tar.addfile(info, io.BytesIO(data))
        side = json.loads((d / 'PREPARED.json').read_text()); side['archive_sha256'] = e.file_sha(d / 'batch.tar.gz')
        side['archive_bytes'] = (d / 'batch.tar.gz').stat().st_size; self.put(d / 'PREPARED.json', e.encoded(side))
        p.update(archive_sha256=side['archive_sha256'], prepared_sha256=e.file_sha(d / 'PREPARED.json'))
        with self.assertRaises(RuntimeError): self.arrival(p)


if __name__ == '__main__':
    unittest.main(verbosity=2)
