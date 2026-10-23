import ast
import base64
import hashlib
import json
import lzma
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import types
import unittest
from unittest import mock

HERE = Path(__file__).parent
b = types.ModuleType('evidence_parts_fixture')
b.__file__ = str(HERE / 'evidence_parts.py')
exec(compile(Path(b.__file__).read_bytes(), b.__file__, 'exec'), b.__dict__)


def put(p, data):
    p.parent.mkdir(parents=True, exist_ok=True); p.write_bytes(data)


class Tests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='d1-evidence-fixture-', dir=str(Path(tempfile.gettempdir()).resolve()))
        self.root = Path(self.tmp.name); self.src = self.root / 'inputs'; self.src.mkdir()
        self.plan = {'schema':1, 'phase':2, 'label':'fixture', 'files':[], 'missing':[], 'inventories':[]}
        self.plan_path = self.root / 'plan.json'; self.out = self.root / 'package'; self.dest = self.root / 'reconstructed'
        self.add('small.json', b'{"original":true}\n')
    def tearDown(self): self.tmp.cleanup()
    def add(self, name, data, status='COMPLETE_ORIGINAL'):
        p = self.src / name; put(p, data)
        self.plan['files'].append({'source':str(p), 'logical':name, 'bytes':len(data), 'sha256':b.digest(data), 'status':status})
    def write_plan(self):
        self.plan_path.write_bytes(b.json_bytes(self.plan)); return b.digest(self.plan_path.read_bytes())
    def capture(self):
        result = b.capture(self.plan_path, self.write_plan(), self.out)
        self.m = json.loads((self.out / 'MANIFEST.json').read_bytes()); return result
    def verify(self): return b.verify(self.out, b.digest((self.out / 'MANIFEST.json').read_bytes()), self.dest)
    def rewrite(self): (self.out / 'MANIFEST.json').write_bytes(b.json_bytes(self.m))
    def reject_capture(self):
        with self.assertRaises((ValueError, OSError, UnicodeError, lzma.LZMAError)): self.capture()
    def reject_verify(self):
        with self.assertRaises((ValueError, OSError, UnicodeError, lzma.LZMAError)): self.verify()
    def raw(self):
        self.add('binary.bin', b'\xff' * 250); self.capture()
        return self.m['files'][1]
    def xz(self):
        self.add('large.json', b'abcde' * (b.GIT_LIMIT // 5 + 2)); self.capture()
        return self.m['files'][1]
    def replace_encoded(self, row, data):
        part = row['parts'][0]; stored = b.b64encode(data); (self.out / part['stored_path']).write_bytes(stored)
        part.update(decoded_bytes=len(data), decoded_sha256=b.digest(data), stored_bytes=len(stored), stored_sha256=b.digest(stored))
        row.update(encoded_bytes=len(data), encoded_sha256=b.digest(data)); self.rewrite()
    def test_direct_exact_and_independent_reconstruction(self):
        r = self.capture(); self.assertEqual(r['status'], b.STATUS)
        self.verify(); self.assertEqual((self.dest/'originals/small.json').read_bytes(), (self.src/'small.json').read_bytes())
        self.assertEqual(self.m['files'][0]['encoding'], 'direct-utf8')
    def test_partial_status_retained(self):
        self.plan['files'][0]['status'] = 'PARTIAL_NOT_TERMINAL'; self.capture(); self.verify()
        self.assertEqual(json.loads((self.dest/'RECONSTRUCTION.json').read_bytes())['originals'][0]['status'], 'PARTIAL_NOT_TERMINAL')
    def test_missing_explicit_no_fabrication(self):
        self.plan['missing'] = [{'source':str(self.src/'missing.log'), 'reason':'not generated after interruption'}]
        self.capture(); self.verify(); self.assertFalse((self.dest/'originals/missing.log').exists())
    def test_empty_original(self):
        self.add('empty.log', b''); self.capture(); self.verify(); self.assertEqual((self.dest/'originals/empty.log').stat().st_size, 0)
    def test_binary_raw_parts_and_tail(self):
        with mock.patch.object(b, 'CHUNK', 96):
            row = self.raw(); self.assertEqual([p['decoded_bytes'] for p in row['parts']], [96,96,58]); self.verify()
        self.assertEqual((self.dest/'originals/binary.bin').read_bytes(), b'\xff'*250)
    def test_large_xz_exact_roundtrip(self):
        row=self.xz();self.assertEqual(row['encoding'],'xz-single-stream-preset3-crc64');self.verify()
    def test_phase1_uses_original_raw_encoding(self):
        self.plan['phase']=1; row=self.xz();self.assertEqual(row['encoding'],'raw-parts');self.verify()
    def test_no_xz_without_measured_size_benefit(self):
        self.add('random.bin',os.urandom(b.GIT_LIMIT+1));self.capture();self.assertEqual(self.m['files'][1]['encoding'],'raw-parts');self.verify()
    def test_real_chunk_git_bound(self):
        data=b.b64encode(b'\x00'*b.CHUNK);self.assertLess(len(data),b.GIT_LIMIT);self.assertLessEqual(len(data),b.STORED_MAX)
        self.assertEqual(len(data),4249493)
    def test_bad_plan_hash(self):
        self.write_plan()
        with self.assertRaises(ValueError):b.capture(self.plan_path,'0'*64,self.out)
    def test_plan_source_hash_mismatch(self):self.plan['files'][0]['sha256']='0'*64;self.reject_capture()
    def test_plan_source_size_mismatch(self):self.plan['files'][0]['bytes']+=1;self.reject_capture()
    def test_duplicate_original(self):self.plan['files'].append(dict(self.plan['files'][0]));self.reject_capture()
    def test_source_symlink(self):
        p=self.src/'small.json';p.rename(self.src/'actual');p.symlink_to(self.src/'actual');self.reject_capture()
    def test_source_ancestor_symlink(self):
        p=self.root/'alias';p.symlink_to(self.src,target_is_directory=True);self.plan['files'][0]['source']=str(p/'small.json');self.reject_capture()
    def test_source_fifo(self):
        p=self.src/'small.json';p.unlink();os.mkfifo(p);self.reject_capture()
    def test_output_existing_unchanged(self):
        self.out.mkdir();p=self.out/'keep';p.write_bytes(b'keep');self.reject_capture();self.assertEqual(p.read_bytes(),b'keep')
    def test_output_symlink(self):self.out.symlink_to(self.src,target_is_directory=True);self.reject_capture()
    def test_logical_traversal(self):self.plan['files'][0]['logical']='../escape';self.reject_capture()
    def test_missing_source_exists(self):
        self.plan['missing']=[{'source':str(self.src/'small.json'),'reason':'false'}];self.reject_capture()
    def test_inventory_unexpected_member(self):
        self.plan['inventories']=[{'root':str(self.src),'entries':[]}];self.reject_capture()
    def test_inventory_includes_and_exclusions(self):
        put(self.src/'excluded.txt',b'outside selected gate')
        self.plan['inventories']=[{'root':str(self.src),'entries':[{'path':'small.json','disposition':'include','reason':'selected original'},{'path':'excluded.txt','disposition':'exclude','reason':'separately preserved'}]}]
        self.capture();self.verify()
    def test_mutating_original_before_commit(self):
        original=b.write_new
        def mutation(path,data,root):
            original(path,data,root)
            if path.name=='small.json':(self.src/'small.json').write_bytes(b'changed after read')
        with mock.patch.object(b,'write_new',side_effect=mutation):self.reject_capture()
    def test_inventory_new_member_during_capture(self):
        self.plan['inventories']=[{'root':str(self.src),'entries':[{'path':'small.json','disposition':'include','reason':'selected'}]}]
        original=b.write_new
        def mutation(path,data,root):
            original(path,data,root)
            if path.name=='small.json':put(self.src/'late.log',b'late')
        with mock.patch.object(b,'write_new',side_effect=mutation):self.reject_capture()
    def test_package_extra_member(self):self.capture();put(self.out/'unexpected',b'x');self.reject_verify()
    def test_package_symlink(self):
        self.capture();p=self.out/'files/small.json';p.unlink();p.symlink_to(self.src/'small.json');self.reject_verify()
    def test_package_symlink_directory(self):
        self.capture();(self.out/'alias').symlink_to(self.src,target_is_directory=True);self.reject_verify()
    def test_bad_manifest_pin(self):
        self.capture()
        with self.assertRaises(ValueError):b.verify(self.out,'0'*64,self.dest)
    def test_bad_stored_payload_hash(self):
        self.raw();(self.out/self.m['files'][1]['parts'][0]['stored_path']).write_bytes(b'AAAA\n');self.reject_verify()
    def test_changed_original_plan_binding(self):
        self.capture();self.m['files'][0]['sha256']='0'*64;self.rewrite();self.reject_verify()
    def test_poststat_change_refused(self):
        self.capture();self.m['files'][0]['original_post_stat']['st_ino']+=1;self.rewrite();self.reject_verify()
    def test_reordered_parts(self):
        with mock.patch.object(b,'CHUNK',96):
            row=self.raw();row['parts'].reverse();self.rewrite();self.reject_verify()
    def test_gapped_parts(self):
        row=self.raw();row['parts'][0]['raw_offset']=1;self.rewrite();self.reject_verify()
    def test_duplicate_package_path(self):
        row=self.raw();row['parts'][0]['stored_path']='files/small.json';self.rewrite();self.reject_verify()
    def test_noncanonical_base64(self):
        row=self.raw();part=row['parts'][0];data=(self.out/part['stored_path']).read_bytes().replace(b'\n',b' \n');(self.out/part['stored_path']).write_bytes(data)
        part['stored_bytes']=len(data);part['stored_sha256']=b.digest(data);self.rewrite();self.reject_verify()
    def test_xz_trailing_bytes(self):
        row=self.xz();part=row['parts'][0];data=base64.b64decode((self.out/part['stored_path']).read_bytes());self.replace_encoded(row,data+b'trailing');self.reject_verify()
    def test_xz_concatenated_streams(self):
        row=self.xz();part=row['parts'][0];data=base64.b64decode((self.out/part['stored_path']).read_bytes());self.replace_encoded(row,data+lzma.compress(b'extra',check=lzma.CHECK_CRC64,preset=3));self.reject_verify()
    def test_xz_truncated(self):
        row=self.xz();part=row['parts'][0];data=base64.b64decode((self.out/part['stored_path']).read_bytes());self.replace_encoded(row,data[:-3]);self.reject_verify()
    def test_xz_wrong_integrity_check(self):
        row=self.xz();data=lzma.compress((self.src/'large.json').read_bytes(),check=lzma.CHECK_CRC32,preset=3);self.replace_encoded(row,data);self.reject_verify()
    def test_xz_output_bound(self):
        row=self.xz();data=lzma.compress((self.src/'large.json').read_bytes()+b'oversized',check=lzma.CHECK_CRC64,preset=3);self.replace_encoded(row,data);self.reject_verify()
    def test_xz_memory_limit(self):
        row=self.xz();data=lzma.compress(b'abcde'*1000,format=lzma.FORMAT_XZ,check=lzma.CHECK_CRC64,filters=[{'id':lzma.FILTER_LZMA2,'dict_size':134217728}]);self.replace_encoded(row,data);self.reject_verify()
    def test_phase1_rejects_forged_xz(self):
        self.xz();self.m['phase']=1;self.rewrite();self.reject_verify()
    def test_destination_never_overwritten(self):
        self.capture();self.dest.mkdir();p=self.dest/'keep';p.write_bytes(b'keep');self.reject_verify();self.assertEqual(p.read_bytes(),b'keep')
    def test_destination_symlink_rejected(self):self.capture();self.dest.symlink_to(self.src,target_is_directory=True);self.reject_verify()
    def test_full_reconstruction_when_originals_no_longer_available(self):
        self.capture();(self.src/'small.json').unlink();self.verify();self.assertTrue((self.dest/'originals/small.json').exists())
    def test_destination_files_and_directories_fsynced(self):
        real=b.os.fsync;calls=[]
        def traced(fd):calls.append(os.fstat(fd).st_mode);real(fd)
        with mock.patch.object(b.os,'fsync',side_effect=traced):self.capture();self.verify()
        import stat
        self.assertTrue(any(stat.S_ISREG(m) for m in calls));self.assertTrue(any(stat.S_ISDIR(m) for m in calls))
    def test_capture_does_not_create_declared_missing_source(self):
        self.plan['missing']=[{'source':str(self.out),'reason':'missing original'}]
        self.reject_capture();self.assertFalse(self.out.exists())
    def test_reconstruction_does_not_create_declared_missing_source(self):
        self.plan['missing']=[{'source':str(self.dest),'reason':'missing original'}]
        self.capture();self.reject_verify();self.assertFalse(self.dest.exists())
    def test_reconstruction_does_not_replace_removed_original(self):
        self.capture();p=self.src/'small.json';p.unlink()
        with self.assertRaises(ValueError):b.verify(self.out,b.digest((self.out/'MANIFEST.json').read_bytes()),p)
        self.assertFalse(p.exists())
    def test_reconstruction_rejects_bad_plan_status(self):
        self.capture();self.plan['files'][0]['status']='PASS'
        data=b.json_bytes(self.plan);(self.out/'PLAN.json').write_bytes(data)
        self.m['plan_sha256']=b.digest(data);self.m['files'][0]['status']='PASS';self.rewrite();self.reject_verify()
    def test_reconstruction_rejects_duplicate_plan_original(self):
        self.capture();self.plan['files'].append(dict(self.plan['files'][0]));data=b.json_bytes(self.plan)
        (self.out/'PLAN.json').write_bytes(data);self.m['plan_sha256']=b.digest(data);self.m['files'].append(dict(self.m['files'][0]));self.rewrite();self.reject_verify()
    def test_reconstruction_rejects_wrong_recipe(self):
        self.capture();self.m['recipe_sha256']='0'*64;self.rewrite();self.reject_verify()
    def test_dot_logical_path_rejected(self):self.plan['files'][0]['logical']='.';self.reject_capture()
    def test_path_control_characters_rejected(self):
        for name in ['line\nbreak','tab\tname','nul\x00name','del\x7fname']:
            with self.subTest(name=name):
                with self.assertRaises(ValueError):b.relative(name)
                with self.assertRaises(ValueError):b.lexical_absolute('/tmp/'+name)
    def test_nul_utf8_uses_binary_parts(self):
        self.add('nul.bin',b'abc\x00def');self.capture();self.assertEqual(self.m['files'][1]['encoding'],'raw-parts');self.verify()
    def inventory_capture(self):
        self.plan['inventories']=[{'root':str(self.src),'entries':[{'path':'small.json','disposition':'include','reason':'selected'}]}]
        self.capture()
    def test_declared_missing_parent_can_be_absent(self):
        self.plan['missing']=[{'source':str(self.src/'never-created/RESULT.json'),'reason':'no supervisor output'}]
        self.capture();self.verify()
    def test_removed_inventory_map_rejected(self):
        self.inventory_capture();self.m['inventories_before']={};self.m['inventories_after']={};self.rewrite();self.reject_verify()
    def test_removed_inventory_member_rejected(self):
        self.inventory_capture();self.m['inventories_before'][str(self.src)]={};self.m['inventories_after'][str(self.src)]={};self.rewrite();self.reject_verify()
    def test_bad_inventory_stat_rejected(self):
        self.inventory_capture();self.m['inventories_before'][str(self.src)]['small.json']={};self.m['inventories_after'][str(self.src)]['small.json']={};self.rewrite();self.reject_verify()
    def test_disagreement_original_inventory_stat_rejected(self):
        self.inventory_capture();self.m['inventories_before'][str(self.src)]['small.json']['st_ino']+=1
        self.m['inventories_after']=json.loads(json.dumps(self.m['inventories_before']));self.rewrite();self.reject_verify()
    def test_false_compression_metadata_rejected(self):
        row=self.xz();row['compressor']['preset']=9;self.rewrite();self.reject_verify()
    def test_python38_syntax(self):ast.parse(Path(b.__file__).read_bytes(),feature_version=(3,8))

if __name__=='__main__':unittest.main(verbosity=2)
