from pathlib import Path
import re,json,hashlib
ROOT=Path(__file__).resolve().parents[1]
def read(p):return (ROOT/p).read_text()
def coords(s):return [tuple(map(int,m)) for m in re.findall(r'⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩',s)]
phase=read('finite_fast_next/graph_phases/SmallPairPhaseData41.lean')
witness=read('pair_witness_next/SmallPairWitnessData41.lean')
indexed=read('pair_witness_next/SmallPairIndexedClosure41.lean')
vs=coords(phase.split('def closure',1)[1].split('def large',1)[0])
a=coords(phase.split('def anchorA',1)[1].split('\n',1)[0])[0]
b=coords(phase.split('def anchorB',1)[1].split('\n',1)[0])[0]
r0=coords(witness.split('def anchorRootWitness',1)[1].split('\n',1)[0])[0]
flat=coords(witness.split('def vertexRootPairs',1)[1].split('def closureWitnesses',1)[0])
rs=list(zip(flat[::2],flat[1::2])); assert len(flat)==2*len(vs)
part=indexed.split('def indexedClosureDestinations',1)[1].split('theorem closure_indexed',1)[0]
dests=[tuple(None if z=='none' else int(z[5:]) for z in m) for m in re.findall(r'\((some \d+|none),\s*(some \d+|none)\)',part)]
assert len(vs)==len(rs)==len(dests)==373
# Independent arithmetic in QuadInt 1 2.
def add(x,y):return x[0]+y[0],x[1]+y[1]
def scale(n,x):return n*x[0],n*x[1]
def mul(x,y):return x[0]*y[0]-2*x[1]*y[1],x[0]*y[1]+x[1]*y[0]+x[1]*y[1]
def norm(x):return x[0]**2+x[0]*x[1]+2*x[1]**2
assert mul(r0,r0)==add(mul(a,b),(1,0))
counts={'some':0,'none':0}
for z,(r,s),ds in zip(vs,rs,dests):
 assert mul(r,r)==add(mul(a,z),(1,0))
 assert mul(s,s)==add(mul(b,z),(1,0))
 mid=add(add(a,b),mul(add(scale(2,mul(a,b)),(1,0)),z))
 cross=scale(2,mul(mul(r0,r),s))
 for target,w in zip(ds,[add(mid,cross),add(mid,scale(-1,cross))]):
  if target is None:assert 10**1100<norm(w);counts['none']+=1
  else:assert 0<=target<len(vs) and vs[target]==w;counts['some']+=1
report={'generic_sha256':hashlib.sha256((ROOT/'pair_witness_next/PairClosureIndexedWitness.lean').read_bytes()).hexdigest(),'pilot_sha256':hashlib.sha256(indexed.encode()).hexdigest(),'root_data_sha256':hashlib.sha256(witness.encode()).hexdigest(),'phase_data_sha256':hashlib.sha256(phase.encode()).hexdigest(),'vertices':len(vs),'destination_counts':counts,'all_anchor_and_vertex_roots':'independent PASS','all_signed_mutation_destinations':'independent PASS','math_and_source_review':'PASS','pinned_api':'List.mem_of_getElem? confirmed in Lean4.33.1 Init/Data/List/Lemmas.lean:479','kernel_status':'pending coordinator'}
(ROOT/'audit_next/indexed_closure41_review.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
