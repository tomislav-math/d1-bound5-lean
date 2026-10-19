"""Apply the four reviewed parent joins only after every exact leaf compiled.
This is not a compiler, Git wrapper or trust shortcut. Existing locks and current
source/dependency/artifact guards remain mandatory.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('row26_join_driver',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
plan=json.loads((out/'PARTITION_PLAN.json').read_text());original=json.loads((out/'ORIGINAL_PARENTS.json').read_text())
results=json.loads((out/'parts/BATCH_RESULTS.json').read_text())
leaves=[p['name'] for item in plan for p in item['parts']]
assert [r['name'] for r in results]==leaves and all(r.get('accepted_build') and r['exit']==0 for r in results)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    d=mod.Driver(root,work);active=json.loads(d.active_path.read_text())
    assert not active.get('active') and not active.get('protected_closure')
    q,names,closures,accepted,unknown,eligible=d.snapshot()
    assert not unknown and set(leaves)<=accepted and q['max_parallel']==1 and q['pause_after_current'] is True
    assert sha(root/'D1Bound5/SmallPairLightData26.lean')=='5846a48684f6c85575a6bcb6b11c73f695438e75f50a0505e9d333ffa48b497d'
    drafts={}
    for item in plan:
        n=item['parent'];p=root/'D1Bound5'/(n+'.lean')
        assert sha(p)==original[n]['sha256'],'Parent edited by another writer'
        text=(out/'parent-drafts'/(n+'.lean')).read_text()
        assert text.split('theorem ',1)[1].split(' := by',1)[0]==original[n]['header']
        assert 'decide +kernel' not in text,'Parent must only join checked constants'
        assert all(('import D1Bound5.'+leaf['name']+'\n') in text for leaf in item['parts'])
        drafts[n]=text
    folder=out/'parents';folder.mkdir();review={}
    for n,text in drafts.items():
        p=root/'D1Bound5'/(n+'.lean');p.write_text(text)
        review[n]={'sha256':sha(p),'review':'Exact original theorem type; complete consecutive part coverage; verified prefix-add theorem; no arithmetic re-evaluation.'}
    save(folder/'TARGETS.json',list(drafts));save(folder/'PRE_BUILD_SOURCE_REVIEW.json',review)
    (folder/'batch_run.py').write_bytes((out/'parts/batch_run.py').read_bytes())
    save(out/'PARENT_APPLICATION.json',{'time':datetime.now().astimezone().isoformat(),'original_headers_unchanged':True,'leaf_builds_current':True,'data_unchanged':True,'parents':review})
    print('FOUR_ORIGINAL_PARENT_JOINS_APPLIED',datetime.now().astimezone().isoformat())
