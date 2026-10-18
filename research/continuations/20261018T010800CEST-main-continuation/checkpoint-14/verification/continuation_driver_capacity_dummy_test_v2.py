"""Isolated dummy-process protocol and capacity tests; never run Lake or Lean."""
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
from continuation_driver_capacity import Driver, atomic_json, fingerprint, sha

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
            d.run_loop(execute=True,poll_seconds=.01,defer_busy_snapshot=True)

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
        times={(e['name'],e['event']):index for index,e in enumerate(events)}
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
        with patch('continuation_driver_capacity.sha',wraps=sha) as hashing:
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


    def capacity_run(self,d,after_reap=None,enabled=True,execute=True):
        snapshots=[]
        ticks=[]
        original_snapshot=d.snapshot
        original_reap=d.reap
        def counted_snapshot():
            active=tuple(sorted(d.jobs))
            result=original_snapshot()
            snapshots.append({'active':active,'unknown':tuple(result[4]),
                              'slots':min(2,max(1,int(result[0].get('max_parallel',2))))})
            return result
        def counted_reap():
            original_reap()
            ticks.append(tuple(sorted(d.jobs)))
            if after_reap is not None:
                after_reap(d)
        output=io.StringIO()
        with patch.object(d,'snapshot',side_effect=counted_snapshot), \
             patch.object(d,'reap',side_effect=counted_reap), redirect_stdout(output):
            d.run_loop(execute=execute,poll_seconds=.01,defer_busy_snapshot=enabled)
        return snapshots,ticks,output.getvalue()

    def event_names(self):
        path=self.root/'events.jsonl'
        return {json.loads(line)['name'] for line in path.read_text().splitlines()} if path.exists() else set()

    def test_capacity_skips_full_ticks_and_resnapshots_freed_capacity(self):
        self.add_module('A','Base')
        self.add_module('B','Base')
        d=self.driver(['A','B'],max_parallel=1)
        snapshots,ticks,_=self.capacity_run(d)
        self.assertEqual(len(snapshots),3)
        self.assertTrue(all(not x['active'] for x in snapshots))
        self.assertGreater(len(ticks),len(snapshots))
        self.assertEqual([row['name'] for row in d.rows],['A','B'])
        self.assertTrue(all(row['accepted_build'] for row in d.rows))

    def test_capacity_default_off_keeps_busy_snapshots(self):
        self.add_module('A','Base')
        d=self.driver(['A'],max_parallel=1)
        snapshots,_,_=self.capacity_run(d,enabled=False)
        self.assertTrue(any(x['active']==('A',) for x in snapshots))
        self.assertGreater(len(snapshots),2)
        self.assertTrue(d.rows[-1]['accepted_build'])

    def test_capacity_dry_run_always_takes_complete_snapshot(self):
        self.add_module('Unknown')
        self.add_module('A','Unknown')
        d=self.driver(['A'],max_parallel=1)
        snapshots,_,output=self.capacity_run(d,execute=False)
        self.assertEqual(len(snapshots),1)
        self.assertEqual(snapshots[0]['unknown'],('Unknown',))
        self.assertEqual(json.loads(output)['status'],'DRY_RUN')
        self.assertFalse(d.jobs)
        self.assertFalse(self.event_names())

    def test_capacity_slot_increase_triggers_fresh_snapshot_before_launch(self):
        self.add_module('A','Base')
        self.add_module('B','Base')
        d=self.driver(['A','B'],max_parallel=1)
        changed=[]
        def raise_capacity(current):
            if not changed and 'A' in current.jobs:
                q=json.loads(current.queue_path.read_text())
                q['max_parallel']=2
                atomic_json(current.queue_path,q)
                changed.append(True)
        snapshots,ticks,_=self.capacity_run(d,raise_capacity)
        self.assertEqual(changed,[True])
        self.assertTrue(any(x['active']==('A',) and x['slots']==2 for x in snapshots))
        self.assertTrue(any(set(x)=={'A','B'} for x in ticks))
        self.assertFalse(any(len(x['active'])>=x['slots'] for x in snapshots))
        self.assertEqual(self.event_names(),{'A','B'})
        self.assertTrue(all(row['accepted_build'] for row in d.rows))

    def test_capacity_new_unknown_blocks_all_launches_when_capacity_frees(self):
        self.add_module('A','Base')
        self.add_module('C','Base')
        self.add_module('Unknown')
        self.add_module('B','Unknown')
        d=self.driver(['A'],max_parallel=1)
        changed=[]
        def add_unknown(current):
            if not changed and 'A' in current.jobs:
                q=json.loads(current.queue_path.read_text())
                q['names']=['A','C','B']
                atomic_json(current.queue_path,q)
                changed.append(True)
        snapshots,_,output=self.capacity_run(d,add_unknown)
        self.assertEqual(changed,[True])
        self.assertEqual(len(snapshots),2)
        self.assertEqual(snapshots[-1]['unknown'],('Unknown',))
        self.assertEqual(self.event_names(),{'A'})
        self.assertEqual([row['name'] for row in d.rows],['A'])
        self.assertTrue(d.rows[0]['accepted_build'])
        self.assertIn('"untracked_nonqueued": ["Unknown"]',output)

    def test_capacity_pause_change_while_full_prevents_next_launch(self):
        self.add_module('A','Base')
        self.add_module('B','Base')
        d=self.driver(['A','B'],max_parallel=1)
        changed=[]
        def pause(current):
            if not changed and 'A' in current.jobs:
                q=json.loads(current.queue_path.read_text())
                q['pause_after_current']=True
                atomic_json(current.queue_path,q)
                changed.append(True)
        snapshots,_,output=self.capacity_run(d,pause)
        self.assertEqual(changed,[True])
        self.assertEqual(len(snapshots),2)
        self.assertTrue(all(not x['active'] for x in snapshots))
        self.assertEqual(self.event_names(),{'A'})
        self.assertEqual([row['name'] for row in d.rows],['A'])
        self.assertTrue(d.rows[0]['accepted_build'])
        self.assertIn('"status": "PAUSED"',output)

    def test_capacity_stop_while_full_reaps_owned_dummy_and_rejects(self):
        self.add_module('A','Base')
        self.add_module('B','Base')
        d=self.driver(['A','B'],max_parallel=1)
        changed=[]
        def stop(current):
            if not changed and 'A' in current.jobs:
                current.stop=True
                changed.append(True)
        snapshots,_,output=self.capacity_run(d,stop)
        self.assertEqual(changed,[True])
        self.assertEqual(len(snapshots),2)
        self.assertTrue(all(not x['active'] for x in snapshots))
        self.assertEqual([row['name'] for row in d.rows],['A'])
        self.assertTrue(d.rows[0]['interrupted'])
        self.assertFalse(d.rows[0]['accepted_build'])
        self.assertNotIn('B',self.event_names())
        self.assertFalse(d.jobs)
        self.assertIn('"status": "PAUSED"',output)

    def test_capacity_static_change_is_checked_while_full(self):
        (self.root/'lean-toolchain').write_text('dummy immutable toolchain')
        self.add_module('A','Base')
        self.add_module('B','Base')
        d=self.driver(['A','B'],max_parallel=1)
        changed=[]
        def alter_static(current):
            if not changed and 'A' in current.jobs:
                (self.root/'lean-toolchain').write_text('changed dummy toolchain')
                changed.append(True)
        snapshots,_,_=self.capacity_run(d,alter_static)
        self.assertEqual(changed,[True])
        self.assertEqual(len(snapshots),2)
        self.assertTrue(all(not x['active'] for x in snapshots))
        self.assertTrue(d.stop)
        self.assertEqual([row['name'] for row in d.rows],['A'])
        self.assertFalse(d.rows[0]['shared_artifacts_unchanged'])
        self.assertFalse(d.rows[0]['accepted_build'])
        self.assertTrue(d.rows[0]['interrupted'])
        self.assertNotIn('B',self.event_names())
        self.assertFalse(d.jobs)



if __name__=='__main__':
    unittest.main()
