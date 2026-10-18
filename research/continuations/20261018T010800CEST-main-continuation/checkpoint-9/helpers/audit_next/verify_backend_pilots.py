"""Independent replay of the emitted optional16/34 sources; no Lean compiler."""
from pathlib import Path
import ast
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'pair_backend_next/staged_pilots'
sha = lambda b: hashlib.sha256(b).hexdigest()
coord_pat = r'⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩'
def coords(s):
    return [tuple(map(int, v)) for v in re.findall(coord_pat, s)]
def list_body(s, name):
    return re.search(rf'def {name}\b.*? := \[(.*?)\n\]', s, re.S).group(1)
def int_pairs(s):
    return [tuple(map(int, v)) for v in re.findall(r'\((\d+),\s*(\d+)\)', s)]
def theorem(s, name):
    return re.search(rf'theorem {name}\b.*?(?=\n\ntheorem |\n\nend D1Bound5)', s, re.S).group()
def public_type(s, name):
    return re.search(rf'theorem {name}\b(.*?) :=', s, re.S).group(1)
def add(x,y): return x[0]+y[0], x[1]+y[1]
def scale(k,x): return k*x[0], k*x[1]

manifest = json.loads((BASE/'manifest.json').read_text())
results = []
for r in manifest['results']:
    k,t,n = r['row'],r['tau'],r['nu']
    emitted = {p:(BASE/p).read_text() for p in r['files']}
    for p, meta in r['files'].items():
        data=(BASE/p).read_bytes()
        assert sha(data)==meta['sha256'] and len(data)==meta['bytes']
    original=(ROOT/f'finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean').read_text()
    assert sha(original.encode())==r['original_source_sha256']
    declarations=original[original.index(f'def smallPairA_{k} '):original.index(f'theorem smallPairSeeds_{k}_checked')]
    assert sum(s.count(declarations) for s in emitted.values())==1
    joined='\n'.join(emitted.values())
    for name in [f'smallPairSeeds_{k}_checked',f'smallPairFilter_{k}_checked',f'smallPairLarge_{k}_count']:
        assert theorem(original,name) in joined
    for name in [f'smallPairSeeds_{k}_checked',f'smallPairFilter_{k}_checked',f'smallPairLarge_{k}_count',f'smallPairClosure_{k}_checked',f'smallPairNoTriangle_{k}_checked']:
        assert public_type(original,name)==public_type(joined,name)
    inp=emitted[f'D1Bound5/SmallPairGraphInputs{k}.lean']
    witness=emitted[f'D1Bound5/SmallPairGraphWitnessData{k}.lean']
    a=coords(re.search(rf'def smallPairA_{k} .*',inp).group())[0]
    b=coords(re.search(rf'def smallPairB_{k} .*',inp).group())[0]
    closure=coords(list_body(inp,f'smallPairClosure_{k}'))
    large=coords(list_body(inp,f'smallPairLarge_{k}'))
    flat=coords(list_body(witness,'rootPairs'))
    pairs=list(zip(flat[::2],flat[1::2]))
    dests=[tuple(None if x=='none' else int(x[5:]) for x in v) for v in
           re.findall(r'\((none|some \d+),\s*(none|some \d+)\)',list_body(witness,'destinations'))]
    assert len(flat)==2*len(closure) and len(dests)==len(closure)
    root=coords(re.search(r'def anchorRoot .*',witness).group())[0]
    def mul(x,y): return x[0]*y[0]-n*x[1]*y[1],x[0]*y[1]+x[1]*y[0]+t*x[1]*y[1]
    def norm(x): return x[0]**2+t*x[0]*x[1]+n*x[1]**2
    assert mul(root,root)==add(mul(a,b),(1,0))
    outside=0
    for z,(u,v),ds in zip(closure,pairs,dests):
        assert mul(u,u)==add(mul(a,z),(1,0)) and mul(v,v)==add(mul(b,z),(1,0))
        mid=add(add(a,b),mul(add(scale(2,mul(a,b)),(1,0)),z))
        cross=scale(2,mul(mul(root,u),v))
        for i,w in zip(ds,[add(mid,cross),add(mid,scale(-1,cross))]):
            if i is None:
                assert norm(w)>10**1100
                outside+=1
            else: assert 0<=i<len(closure) and closure[i]==w
    row_result=dict(row=k,backend=r['backend'],original_declarations_preserved=True,
        five_public_types_preserved=True,three_arithmetic_proofs_preserved=True,
        exact_roots=len(closure),indexed_destinations=2*len(closure)-outside,outside=outside)
    if r['backend']=='structural':
        assert (t==0 and n>1) or (t==1 and 4*n-1>1)
        assert all(2*x+t*y==0 for x,y in large)
        row_result['trace_checks']=len(large)
    else:
        sigsrc=emitted[f'D1Bound5/SmallPairGraphCachedData{k}.lean']
        raw=list_body(sigsrc,'cachedSignatures')
        signatures=[int_pairs(line) for line in raw.splitlines() if line.strip()]
        sieve_src=(ROOT/f'finite_fast_next/sieves/SmallPairSieve_{t}_{n}.lean').read_text()
        masks={name:int(value) for name,value in re.findall(r'def (smallPairMask_\d+_\d+_\d+) : ℕ := (\d+)',sieve_src)}
        sieve=[(int(p)+1,masks[name]) for p,name in re.findall(r'\((\d+),\s*(smallPairMask_\d+_\d+_\d+)\)',list_body(sieve_src,f'smallPairSieve_{t}_{n}'))]
        assert signatures==[[(x%p,y%p) for p,_ in sieve] for x,y in large]
        colors=int(re.search(r'def colors : ℕ := (\d+)',inp).group(1))
        floor_src=emitted[f'D1Bound5/SmallPairFloorWitnessData{k}.lean']
        seen={'pairs':0,'cached_survivors':0,'cheap_guard':0,'positive':0,'negative':0,'norm':0}
        for color,label in [(0,'left'),(1,'right')]:
            inds=[i for i in range(len(large)) if ((colors>>i)&1)==color]
            rows=ast.literal_eval('['+list_body(floor_src,label+'Rows')+']')
            assert len(rows)==len(inds)
            for ii,i in enumerate(inds):
                ks=iter(rows[ii]); used=0
                for j in inds[ii+1:]:
                    seen['pairs']+=1
                    if large[i]==large[j]: continue
                    possible=True
                    for (p,mask),(u,v),(w,q) in zip(sieve,signatures[i],signatures[j]):
                        idx=((u*w-n*v*q+1)%p)*p+(u*q+v*w+t*v*q)%p
                        if ((mask>>idx)&1)==0:
                            possible=False
                            break
                    if not possible: continue
                    seen['cached_survivors']+=1
                    z=add(mul(large[i],large[j]),(1,0))
                    d=n if t==0 else 4*n-1
                    if z[1]==0 and z[0]<0 and z[0]%d!=0:
                        seen['cheap_guard']+=1
                        continue
                    floor=next(ks); used+=1
                    assert isinstance(floor,int) and floor>=0
                    if z[1]!=0: low,high,value=floor**2,(floor+1)**2,norm(z); key='norm'
                    elif z[0]>0: low,high,value=floor**2,(floor+1)**2,z[0]; key='positive'
                    else: low,high,value=d*floor**2,d*(floor+1)**2,-z[0]; key='negative'
                    assert low<value<high
                    seen[key]+=1
                assert used==len(rows[ii])
            imports=re.findall(r'^import D1Bound5\.(\w+)',emitted[f'D1Bound5/SmallPairGraph{label.title()}{k}.lean'],re.M)
            assert all('Closure' not in x and 'Arithmetic' not in x and 'GraphWitnessData' not in x for x in imports)
        row_result['independent_sparse_replay']=seen
        row_result['signature_pairs']=len(large)*len(sieve)
    results.append(row_result)

repairs={}
repair_root=ROOT/'analytic_repairs_20261018'
for name,pins in json.loads((repair_root/'SOURCE_MANIFEST.json').read_text()).items():
    before=(repair_root/f'{name}.before.txt').read_bytes()
    after=(repair_root/f'{name}.lean').read_bytes()
    assert sha(before)==pins['pre_sha256'] and sha(after)==pins['post_sha256']
    assert after.replace(b'noncomputable section\n\n',b'',1)==before
    repairs[name]=dict(pins,review='PASS: exactly one noncomputable section inserted')

report=dict(status='Independent source/data replay PASS; no Lean compilation',
    generator_sha256=sha((ROOT/'pair_backend_next/stage_pair_backends.py').read_bytes()),
    manifest_sha256=sha((BASE/'manifest.json').read_bytes()),
    results=results,analytic_repairs=repairs)
out=ROOT/'audit_next/backend_pilots_review.json'
out.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
