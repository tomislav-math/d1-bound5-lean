"""Prepare exactly covered row26 blocks001 and002. No compiler or Git operation.
All project writes require both existing locks. Data and parent proofs stay fixed.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
prior=root/'research/continuations/20261019T175309CEST-graph-continuation'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):
    with p.open('x') as f: f.write(json.dumps(v,indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('row26_partition_driver',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    d=mod.Driver(root,work)
    active=json.loads(d.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
    q,names,closures,accepted,unknown,eligible=d.snapshot()
    assert unknown==[] and q['max_parallel']==1 and q['pause_after_current'] is True
    assert {'PairLightArithmeticPrefixConcat','SmallPairLightAdaptiveData26','SmallPairLightData26'}<=accepted
    assert sha(root/'D1Bound5/SmallPairLightData26.lean')=='5846a48684f6c85575a6bcb6b11c73f695438e75f50a0505e9d333ffa48b497d'
    assert sha(root/'D1Bound5/SmallPairLightAdaptiveData26.lean')=='8fcbf5018c5c1dbac57bbba6f0cec8a92e2243d8ef255c12bbada752b611c969'
    generated={};parents={};plan=[]
    for block,count,start in [('001',59,54),('002',65,113)]:
        for side in ['Left','Right']:
            lower=side.lower();parent=f'SmallPairLightAdaptive{side}26_{block}'
            source=root/'D1Bound5'/(parent+'.lean');text=source.read_text()
            assert parent not in accepted, 'Do not repeat a newer compiled parent'
            expected=(f'import D1Bound5.SmallPairLightAdaptiveData26\n\nnamespace D1Bound5.PairLightAdaptivePrepared26\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n/-- Heads {start} through {start+count-1}; every head retains its entire tail. -/\ntheorem {lower}_prefix_{block}_checked :\n    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve {count}\n      {lower}Cached{block} {lower}Rows{block} = true := by\n  decide +kernel\n\nend D1Bound5.PairLightAdaptivePrepared26\n')
            assert text==expected, 'Parent changed since direct source review'
            parents[parent]={'sha256':sha(source),'source':text,'header':text.split('theorem ',1)[1].split(' := by',1)[0]}
            parts=[]
            for index,offset in enumerate(range(0,count,3)):
                length=min(3,count-offset);name=parent+f'Part{index:02d}'
                assert not (root/'D1Bound5'/(name+'.lean')).exists(), 'Never overwrite a proof leaf'
                code=(f'import D1Bound5.SmallPairLightAdaptiveData26\n\nnamespace D1Bound5.PairLightAdaptivePrepared26\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n/-- Original heads {start+offset} through {start+offset+length-1}; all later vertices retained. -/\ntheorem {lower}_prefix_{block}_part{index:02d}_checked :\n    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve {length}\n      ({lower}Cached{block}.drop {offset}) ({lower}Rows{block}.drop {offset}) = true := by\n  decide +kernel\n\nend D1Bound5.PairLightAdaptivePrepared26\n')
                generated[name]=code;parts.append({'name':name,'offset':offset,'length':length})
            assert [i for p in parts for i in range(p['offset'],p['offset']+p['length'])]==list(range(count))
            plan.append({'parent':parent,'side':lower,'block':block,'head_start':start,'heads':count,'parts':parts})
    folder=out/'parts';folder.mkdir();(out/'before').mkdir()
    for n,p in parents.items(): (out/'before'/(n+'.lean')).write_text(p['source'])
    save(out/'ORIGINAL_PARENTS.json',parents);save(out/'PARTITION_PLAN.json',plan);save(out/'QUEUE_BEFORE.json',q)
    review={}
    for n,code in generated.items():
        p=root/'D1Bound5'/(n+'.lean')
        with p.open('x') as f:f.write(code)
        review[n]={'sha256':sha(p),'imports':['D1Bound5.SmallPairLightAdaptiveData26'],'review':'Three full head rows (two in final leaf), exact original vertex and witness drops, no truncated tail.'}
    targets=list(generated)
    save(folder/'TARGETS.json',targets);save(folder/'PRE_BUILD_SOURCE_REVIEW.json',review)
    (folder/'batch_run.py').write_bytes((prior/'parts/batch_run.py').read_bytes())
    q['names']+= [n for n in targets if n not in q['names']]
    (work/'continuation-queue.json').write_text(json.dumps(q,indent=2)+'\n');save(out/'QUEUE_AFTER.json',q)
    now=datetime.now().astimezone().isoformat()
    save(out/'INTAKE_RECORD.json',{'time':now,'prepared_parts':len(targets),'original_parents':list(parents),'unknown':unknown,'single_writer_locks_held':True,'data_unchanged':True,'parent_sources_unchanged':True,'max_parallel':1,'compiler_started':False,'git_mutated':False})
    print('PREPARED_EXACT_PARTITION',len(targets),'leaves; four unchanged original parent statements;',now)
