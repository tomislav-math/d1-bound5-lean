#!/usr/bin/env python3
"""Lifecycle/guard tests with a deliberately fake compiler; no Lean theorem claim."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import time

HERE = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location('fresh', HERE/'fresh_project_build.py')
F = importlib.util.module_from_spec(SPEC); SPEC.loader.exec_module(F)

FAKE = r'''#!/usr/bin/env python3
import hashlib,os,pathlib,subprocess,sys,time
if '--version' in sys.argv:
 print('Lean fake fixture 4.33.1');sys.exit(0)
src=pathlib.Path(sys.argv[-1]); text=src.read_text()
out=pathlib.Path(sys.argv[sys.argv.index('-o')+1]);out.parent.mkdir(parents=True,exist_ok=True)
if '-- FAIL' in text:
 print('intentional fixture compiler failure');sys.exit(7)
if '-- SLEEP' in text:
 out.write_text('unaccepted partial output')
 child=subprocess.Popen([sys.executable,'-c','import time;time.sleep(30)'])
 print('FIXTURE_CHILDREN',os.getpid(),child.pid,flush=True)
 time.sleep(30)
data=hashlib.sha256(src.read_bytes()).hexdigest()
for suffix in ['', '.private', '.server']:
 pathlib.Path(str(out)+suffix).write_text(data+suffix)
out.with_suffix('.ir').write_text(data+'.ir')
pathlib.Path(str(out.with_suffix('.ir'))+'.sig').write_text(data+'.ir.sig')
print('fixture compiled',src.name)
'''


def fixture(root, leaf_extra=''):
    src=root/'src';tc=root/'tc';cache=root/'external';src.mkdir(parents=True)
    (src/'D1Test').mkdir();(tc/'bin').mkdir(parents=True);(tc/'lib/lean').mkdir(parents=True);cache.mkdir()
    (tc/'bin/lean').write_text(FAKE);(tc/'bin/lean').chmod(0o755)
    (tc/'lib/lean/Init.olean').write_text('pinned fake Init')
    (src/'D1Test/Leaf.lean').write_text('def leaf : Nat := 1\n'+leaf_extra)
    (src/'D1Test/Mid.lean').write_text('import D1Test.Leaf\ndef mid : Nat := leaf\n')
    (src/'D1Test/Spare.lean').write_text('def spare : Nat := 0\n')
    (src/'D1Test.lean').write_text('import D1Test.Mid\nimport D1Test.Spare\n')
    (src/'lean-toolchain').write_text('fixture-only\n')
    sl=F.source_lock(src,['D1Test'],'D1Test');F.save(root/'source.json',sl)
    files,_=F.inventory([str(tc/'bin'),str(tc/'lib'),str(cache)])
    rt={'schema':1,'toolchain':str(tc),'lean':str(tc/'bin/lean'),
        'external_paths':[str(cache),str(tc/'lib/lean')],
        'inventory_roots':[str(tc/'bin'),str(tc/'lib'),str(cache)],'files':files,
        'extra_files':[],'environment':{},'version_output':'fake fixture, not a Lean proof'}
    F.save(root/'runtime.json',rt)
    return src,tc,cache


def command(root, resume=False, extra=None):
    args=[sys.executable,str(HERE/'fresh_project_build.py'),'run',
          '--source-root',str(root/'src'),'--build-dir',str(root/'build'),
          '--source-lock',str(root/'source.json'),'--source-lock-sha256',F.sha(root/'source.json'),
          '--runtime-lock',str(root/'runtime.json'),'--runtime-lock-sha256',F.sha(root/'runtime.json'),
          '--expected-modules','4','--jobs','2','--timeout','5',
          '--memory-budget-mib','768','--memory-reserve-mib','0','--resource-wait','2']
    if resume:args.append('--resume')
    return args+(extra or [])


def execute(root, code, resume=False, extra=None):
    p=subprocess.run(command(root,resume,extra),text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=30)
    assert p.returncode==code,(p.returncode,code,p.stdout)
    return p


def summary(root):return F.read(root/'build/SUMMARY.json')


def receipts(root):return [F.read(p) for p in (root/'build/attempts').glob('*/*/receipt.json')]


def assert_children_terminated(ids):
    def terminated(pid):
        try:os.kill(pid,0)
        except ProcessLookupError:return True
        if sys.platform.startswith('linux'):
            namespace=os.stat('/proc/self/ns/pid').st_ino
            for proc in Path('/proc').iterdir():
                if not proc.name.isdigit():continue
                try:
                    if os.stat(proc/'ns/pid').st_ino!=namespace:continue
                    fields=dict(line.split(':',1) for line in (proc/'status').read_text().splitlines() if ':' in line)
                    if int(fields.get('NSpid','-1').split()[-1])==pid and fields['State'].strip().startswith('Z'):return True
                except (OSError,KeyError,ValueError):continue
        return False
    deadline=time.monotonic()+5
    while time.monotonic()<deadline:
        if all(terminated(pid) for pid in ids):return
        time.sleep(.05)
    assert all(terminated(pid) for pid in ids),('owned child survived',ids)


def main():
    results=[]
    with tempfile.TemporaryDirectory(prefix='fresh-build-selfcheck-') as tmp:
        base=Path(tmp)
        root=base/'success';fixture(root);execute(root,0)
        s=summary(root);assert s['status']=='FRESH_PROJECT_SOURCE_BUILD_PASS' and len(s['compiled_this_invocation'])==4
        assert len(list((root/'build/artifacts').rglob('*.olean*')))==12
        assert len(list((root/'build/artifacts').rglob('*.ir')))==4
        results.append('fresh source build publishes four modules with all sidecars')
        execute(root,0,resume=True);s=summary(root)
        assert s['status']=='PROJECT_SOURCE_BUILD_COMPLETE_RESUMED' and s['compiled_this_invocation']==[] and len(s['validated_passes_from_prior_invocations'])==4
        results.append('unchanged resume recursively validates all four receipts')
        (root/'build/artifacts/D1Test/Leaf.olean.private').write_text('tampered ancestor')
        execute(root,0,resume=True);s=summary(root)
        assert set(s['compiled_this_invocation'])=={'D1Test.Leaf','D1Test.Mid','D1Test'}
        assert s['validated_passes_from_prior_invocations']==['D1Test.Spare']
        results.append('corrupted ancestor sidecar invalidates the whole dependent receipt chain')
        (root/'build/artifacts/D1Test/Leaf.ir.sig').write_text('tampered IR signature')
        execute(root,0,resume=True);assert set(summary(root)['compiled_this_invocation'])=={'D1Test.Leaf','D1Test.Mid','D1Test'}
        results.append('IR and IR signature artifacts are included in recursive guards')
        pointer=F.read(root/'build/accepted/D1Test.json');receipt=root/'build'/pointer['receipt_path']
        receipt.write_text(receipt.read_text()+' ')
        execute(root,0,resume=True);assert summary(root)['compiled_this_invocation']==['D1Test']
        results.append('root receipt hash is checked even without a dependent module')
        leaf=root/'src/D1Test/Leaf.lean';original=leaf.read_text();leaf.write_text(original+'-- source mutation\n')
        execute(root,2,resume=True);leaf.write_text(original)
        results.append('source lock mismatch fails closed before compiling')
        execute(root,2)
        results.append('fresh mode refuses any pre-existing build directory')
        root=base/'failed';fixture(root,'-- FAIL\n');execute(root,1)
        assert any(r['status']=='COMPILER_FAILED' and r['exit_code']==7 for r in receipts(root))
        assert not (root/'build/artifacts/D1Test/Leaf.olean').exists()
        results.append('compiler nonzero exit survives in immutable failed attempt receipt')
        root=base/'timeout';fixture(root,'-- SLEEP\n');execute(root,1,extra=['--timeout','.15'])
        assert any(r['status']=='TIMEOUT' for r in receipts(root))
        assert not (root/'build/artifacts/D1Test/Leaf.olean').exists()
        ids=[]
        for log in (root/'build/attempts').glob('*/*/compiler.log'):
            text=log.read_text()
            if 'FIXTURE_CHILDREN' in text:ids=[int(x) for x in text.split('FIXTURE_CHILDREN ')[1].splitlines()[0].split()]
        assert ids;assert_children_terminated(ids)
        results.append('timeout terminates owned compiler group and never publishes partial output')
        root=base/'runtime';fixture(root);(root/'tc/lib/lean/Init.olean').write_text('changed runtime')
        execute(root,2);results.append('external runtime content change fails pinned inventory validation')
        root=base/'shadow';fixture(root);(root/'external/D1Test').mkdir()
        execute(root,2);results.append('external cache cannot supply the project namespace')
        first=base/'owner1';second=base/'owner2';(first/'Pkg').mkdir(parents=True);(second/'Pkg').mkdir(parents=True)
        (second/'Pkg/Sub.olean').write_text('must not bypass earlier package owner')
        assert F.resolve_module([first,second],'Pkg.Sub')==first/'Pkg/Sub.olean'
        results.append('module lookup follows first package owner even when its child artifact is missing')
        root=base/'sourceartifact';fixture(root);(root/'src/D1Test/Leaf.olean').write_text('copied old artifact')
        execute(root,2);results.append('source checkout containing any oleans is rejected')
        root=base/'stop';fixture(root);F.save(root/'control.json',{'stop':True})
        execute(root,3,extra=['--control',str(root/'control.json')]);assert summary(root)['completed_modules']==0
        F.save(root/'control.json',{'stop':False,'jobs':1})
        execute(root,0,resume=True,extra=['--control',str(root/'control.json')])
        results.append('cooperative stop is incomplete/nonzero and exact resume can finish')
        root=base/'interrupt';fixture(root,'-- SLEEP\n')
        p=subprocess.Popen(command(root,extra=['--timeout','60']),stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
        deadline=time.monotonic()+10;child_ids=[]
        while time.monotonic()<deadline:
            logs=list((root/'build/attempts').glob('*/*/compiler.log'))
            for log in logs:
                text=log.read_text()
                if 'FIXTURE_CHILDREN' in text: child_ids=[int(x) for x in text.split('FIXTURE_CHILDREN ')[1].splitlines()[0].split()]
            if child_ids:break
            time.sleep(.05)
        assert child_ids,'fixture compiler did not start'
        p.send_signal(signal.SIGINT);output=p.communicate(timeout=10)[0]
        assert p.returncode!=0,(p.returncode,output)
        assert any(r['status']=='INTERRUPTED_NO_PASS' for r in receipts(root))
        assert not (root/'build/artifacts/D1Test/Leaf.olean').exists()
        assert_children_terminated(child_ids)
        results.append('SIGINT marks active attempt interrupted and terminates its owned process group')
    report={'status':'PASS_FAKE_COMPILER_LIFECYCLE_SELFCHECK','test_count':len(results),'checks':results,
            'real_lean_project_build_launched':False,'runner_sha256':F.sha(HERE/'fresh_project_build.py')}
    F.save(HERE/'FRESH_RUNNER_SELFCHECK.json',report)
    print(json.dumps(report,indent=2))


if __name__=='__main__':main()
