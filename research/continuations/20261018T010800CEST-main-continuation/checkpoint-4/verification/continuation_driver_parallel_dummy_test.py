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
from continuation_driver_parallel import Driver, atomic_json, fingerprint

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


if __name__=='__main__':
    unittest.main()
