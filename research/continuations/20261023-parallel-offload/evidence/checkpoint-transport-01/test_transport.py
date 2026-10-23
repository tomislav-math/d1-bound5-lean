import base64
import hashlib
import json
from pathlib import Path
import tempfile
import types
import unittest

SOURCE = Path(__file__).with_name('transport.py')
t = types.ModuleType('reviewed_transport_fixture')
exec(compile(SOURCE.read_bytes(), str(SOURCE), 'exec'), t.__dict__)


class TransportTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name).resolve()
        t.REMOTE_BASE = self.root / 'remote'
        self.source = self.root/'source'; self.source.mkdir()
        self.data = bytes(range(256)) * 1300
        (self.source/'batch.tar.gz').write_bytes(self.data)
        (self.source/'PREPARED.json').write_text(json.dumps({'schema': 1, 'status': 'PREPARED_NOT_DURABLE', 'archive_bytes': len(self.data), 'archive_sha256': t.digest(self.data)})+'\n')
        self.plan = self.root/'plan.json'
        self.summary = t.plan(str(self.source), 'synthetic_build', 1, str(self.plan))
        self.pin = self.summary['plan_sha256']
        self.value = json.loads(self.plan.read_bytes())

    def tearDown(self):
        self.temp.cleanup()

    def upload(self):
        t.begin(str(self.plan), self.pin)
        for j, name in enumerate(t.FILES):
            for i, part in enumerate(self.value['files'][name]['chunks']):
                encoded = ''.join(t.emit(str(self.plan), self.pin, name, i, k) for k in range(8))
                self.assertEqual(len(encoded), part['base64_bytes'])
                t.chunk_path(Path(self.value['incoming']), j, i).write_text(encoded)

    def test_exact_bounded_roundtrip_not_durable(self):
        self.upload(); result = t.assemble(str(self.plan), self.pin)
        self.assertEqual(result['status'], 'EXACT_BYTES_ARRIVED_NOT_VERIFIED_NOT_DURABLE')
        self.assertEqual((Path(self.value['destination'])/'batch.tar.gz').read_bytes(), self.data)
        self.assertFalse((Path(self.value['destination'])/'DURABLE_BATCH.json').exists())
        with self.assertRaises(ValueError): t.assemble(str(self.plan), self.pin)
        with self.assertRaises(ValueError): t.begin(str(self.plan), self.pin)

    def test_bad_chunk_refuses_acceptance(self):
        self.upload(); p=t.chunk_path(Path(self.value['incoming']),0,0)
        prior=p.read_text();p.write_text(('B' if prior[0]=='A' else 'A')+prior[1:])
        with self.assertRaises(ValueError): t.assemble(str(self.plan),self.pin)
        self.assertFalse((Path(self.value['incoming'])/'TRANSPORT_RESULT.json').exists())

    def test_duplicate_append_refused(self):
        self.upload(); p=t.chunk_path(Path(self.value['incoming']),0,0)
        with p.open('a') as f:f.write('AAAA')
        with self.assertRaises(ValueError): t.assemble(str(self.plan),self.pin)

    def test_plan_and_source_changes_refused(self):
        with self.assertRaises(ValueError):t.load_plan(self.plan,'0'*64)
        p=self.source/'batch.tar.gz';p.write_bytes(self.data+b'x')
        with self.assertRaises(ValueError):t.emit(str(self.plan),self.pin,'batch.tar.gz',0,0)

    def test_unexpected_and_symlink_paths_refused(self):
        self.upload(); incoming=Path(self.value['incoming']);(incoming/'unexpected').write_text('x')
        with self.assertRaises(ValueError):t.assemble(str(self.plan),self.pin)
        (incoming/'unexpected').unlink(); p=t.chunk_path(incoming,0,0);copy=incoming.parent/'copy';p.rename(copy);p.symlink_to(copy)
        with self.assertRaises(ValueError):t.assemble(str(self.plan),self.pin)

    def test_existing_plan_not_overwritten(self):
        before=self.plan.read_bytes()
        with self.assertRaises(FileExistsError):t.plan(str(self.source),'synthetic_build',1,str(self.plan))
        self.assertEqual(self.plan.read_bytes(),before)


if __name__=='__main__':
    unittest.main()
