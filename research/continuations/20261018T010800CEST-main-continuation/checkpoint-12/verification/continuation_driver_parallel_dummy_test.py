"""Local dummy-process checks only: no Lake, Lean, network or remote writes."""
from contextlib import redirect_stdout
from pathlib import Path
import io
import json
import tempfile
import threading
import time
import sys
import unittest
from unittest.mock import patch
from continuation_driver_parallel import Driver, atomic_json, fingerprint, sha

FAKE = r'''
from pathlib import Path
import json, os, subprocess, sys, time
name=sys.argv[1]
root=Path.cwd()
def event(kind):
    with (root/'events.jsonl').open('a') as stream:
        stream.write(json.dumps({'name':name,'event':kind,'time':time.monotonic()})+'\n')
event('start')
if name=='Timeout':
    subprocess.Popen([sys.executable,'-c',"import time; from pathlib import Path; time.sleep(.5); Path('leaked-child').write_text('bad')"])
    time.sleep(5)
if name=='Mutate':
    (root/'.lake/build/lib/lean/D1Bound5/Base.olean').write_text('mutated')
if name=='MutateSource':
    (root/'D1Bound5/Base.lean').write_text('-- changed during child execution\n')
time.sleep(.18)
if name=='Fail':
    event('end')
    sys.exit(1)
p=root/'.lake/build/lib/lean/D1Bound5'/f'{name}.olean'
p.parent.mkdir(parents=True,exist_ok=True)
p.write_text('accepted dummy '+name)
event('end')
'''


class Checks(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory()
        self.root=Path(self.tmp.name)
        self.run=self.root/'run'
        self.run.mkdir()
        (self.root/'D1Bound5').mkdir()
        (self.root/'fake.py').write_text(FAKE)
        self.add_module('Base')
        art=self.root/'.lake/build/lib/lean/D1Bound5/Base.olean'
        art.parent.mkdir(parents=True)
        art.write_text('accepted immutable base')
        d=Driver(self.root,self.run)
        atomic_json(self.run/'continuation-trusted-baseline.json', {'accepted':{'Base':{
            'fingerprint':fingerprint(d.closure('Base')),'artifacts':d.artifacts('Base')}}})

    def tearDown(self):
        self.tmp.cleanup()

    def add_module(self,name,dep=None):
        (self.root/'D1Bound5'/f'{name}.lean').write_text((f'import D1Bound5.{dep}\n' if dep else '')+'-- dummy\n')

    def driver(self,names,**queue):
        atomic_json(self.run/'continuation-queue.json', {'names':names, **queue})
        return Driver(self.root,self.run,[sys.executable,str(self.root/'fake.py'),'{name}'])

    def execute(self,d):
        with redirect_stdout(io.StringIO()):
            d.run_loop(execute=True,poll_seconds=.01)

    def test_two_slots_dependency_order_and_active_union(self):
        for name,dep in [('A','Base'),('B','Base'),('C','A'),('Held','Base'),('Blocked','Held')]:
            self.add_module(name,dep)
        d=self.driver(['A','B','C','Held','Blocked'],blocked_modules=['Held'])
        seen=[]
        t=threading.Thread(target=self.execute,args=(d,))
        t.start()
        while t.is_alive():
            p=self.run/'continuation-active.json'
            if p.exists():
                seen.append(json.loads(p.read_text()))
            time.sleep(.005)
        t.join()
        events=[json.loads(x) for x in (self.root/'events.jsonl').read_text().splitlines()]
        times={(e['name'],e['event']):e['time'] for e in events}
        self.assertLess(times['B','start'],times['A','end'])
        self.assertGreaterEqual(times['C','start'],times['A','end'])
        self.assertEqual({e['name'] for e in events},{'A','B','C'})
        self.assertTrue(any(set(s['protected_closure'])=={'A','B','Base'} and len(s['active'])==2 for s in seen))
        self.assertTrue(all(len(s['active'])<=2 for s in seen))
        self.assertTrue(all(r['accepted_build'] for r in d.rows))

    def test_untracked_dependency_blocks_without_launch(self):
        self.add_module('Unknown')
        self.add_module('A','Unknown')
        d=self.driver(['A'])
        self.execute(d)
        self.assertFalse((self.root/'events.jsonl').exists())

    def test_failed_fingerprint_not_retried_even_with_larger_timeout(self):
        self.add_module('Fail','Base')
        d=self.driver(['Fail'])
        self.execute(d)
        self.assertFalse(d.rows[-1]['accepted_build'])
        before=(self.root/'events.jsonl').read_text()
        d=self.driver(['Fail'],default_timeout_seconds=9999)
        self.execute(d)
        self.assertEqual(before,(self.root/'events.jsonl').read_text())

    def test_timeout_kills_owned_process_group(self):
        self.add_module('Timeout','Base')
        d=self.driver(['Timeout'],default_timeout_seconds=.06)
        self.execute(d)
        self.assertTrue(d.rows[-1]['timed_out'])
        self.assertFalse(d.rows[-1]['accepted_build'])
        time.sleep(.6)
        self.assertFalse((self.root/'leaked-child').exists())

    def test_shared_artifact_change_rejects_and_stops(self):
        self.add_module('Mutate','Base')
        d=self.driver(['Mutate'])
        self.execute(d)
        self.assertFalse(d.rows[-1]['shared_artifacts_unchanged'])
        self.assertFalse(d.rows[-1]['accepted_build'])
        self.assertTrue(d.stop)

    def test_cache_skips_only_metadata_unchanged_scheduling_reads(self):
        d=self.driver([])
        manifest=d.baseline['accepted']['Base']['artifacts']
        with patch('continuation_driver_parallel.sha',wraps=sha) as hashing:
            self.assertTrue(d.manifest_matches(manifest,cached=True))
            self.assertEqual(hashing.call_count,1)
            self.assertTrue(d.manifest_matches(manifest,cached=True))
            self.assertEqual(hashing.call_count,1)
            self.assertTrue(d.manifest_matches(manifest))
            self.assertEqual(hashing.call_count,2)

    def test_cache_invalidation_even_when_size_and_mtime_restored(self):
        import os
        d=self.driver([])
        manifest=d.baseline['accepted']['Base']['artifacts']
        self.assertTrue(d.manifest_matches(manifest,cached=True))
        path=self.root/next(iter(manifest))
        old=path.stat()
        time.sleep(.002)
        path.write_bytes(b'x'*old.st_size)
        os.utime(path,ns=(old.st_atime_ns,old.st_mtime_ns))
        self.assertFalse(d.manifest_matches(manifest,cached=True))

    def test_launch_rejects_dependency_changed_after_scheduling(self):
        self.add_module('A','Base')
        d=self.driver(['A'])
        with d.locked():
            _,_,closures,accepted,unknown,eligible=d.snapshot()
            self.assertIn('Base',accepted)
            self.assertEqual(eligible,['A'])
            (self.root/'.lake/build/lib/lean/D1Bound5/Base.olean').write_text('changed after snapshot')
            with redirect_stdout(io.StringIO()):
                self.assertFalse(d.launch('A',closures['A'],10))
        self.assertTrue(d.stop)
        self.assertFalse(d.jobs)
        self.assertFalse((self.root/'events.jsonl').exists())

    def test_launch_rejects_new_unaccepted_dependency_artifact(self):
        self.add_module('A','Base')
        d=self.driver(['A'])
        with d.locked():
            _,_,closures,_,_,eligible=d.snapshot()
            self.assertEqual(eligible,['A'])
            (self.root/'.lake/build/lib/lean/D1Bound5/Base.ilean').write_text('unaccepted extra artifact')
            with redirect_stdout(io.StringIO()):
                self.assertFalse(d.launch('A',closures['A'],10))
        self.assertTrue(d.stop)
        self.assertFalse(d.jobs)
        self.assertFalse((self.root/'events.jsonl').exists())

    def test_snapshot_reads_each_source_once_and_refreshes_next_snapshot(self):
        for name,dep in [('A','Base'),('B','Base'),('C','A')]:
            self.add_module(name,dep)
        d=self.driver(['A','B','C'])
        reads={}
        original=Path.read_bytes
        def counted(path):
            if path.parent == self.root/'D1Bound5':
                reads[path.stem]=reads.get(path.stem,0)+1
            return original(path)
        with patch.object(Path,'read_bytes',new=counted):
            with d.locked():
                first=d.snapshot()
                self.assertEqual(reads,{'A':1,'Base':1,'B':1,'C':1})
                (self.root/'D1Bound5/Base.lean').write_text('-- changed between snapshots\n')
                second=d.snapshot()
                self.assertEqual(reads,{'A':2,'Base':2,'B':2,'C':2})
                self.assertNotEqual(first[2]['Base'],second[2]['Base'])
                self.assertNotIn('Base',second[3])
                self.assertEqual(second[5],[])

    def test_launch_source_checks_do_not_reuse_snapshot_cache(self):
        self.add_module('A','Base')
        d=self.driver(['A'])
        with d.locked():
            _,_,closures,_,_,eligible=d.snapshot()
            self.assertEqual(eligible,['A'])
            (self.root/'D1Bound5/Base.lean').write_text('-- changed after scheduling\n')
            with redirect_stdout(io.StringIO()):
                self.assertFalse(d.launch('A',closures['A'],10))
        self.assertTrue(d.stop)
        self.assertFalse(d.jobs)
        self.assertFalse((self.root/'events.jsonl').exists())

    def test_completion_source_checks_do_not_reuse_snapshot_cache(self):
        self.add_module('MutateSource','Base')
        d=self.driver(['MutateSource'])
        self.execute(d)
        self.assertFalse(d.rows[-1]['closure_unchanged'])
        self.assertFalse(d.rows[-1]['accepted_build'])


if __name__=='__main__':
    unittest.main()
