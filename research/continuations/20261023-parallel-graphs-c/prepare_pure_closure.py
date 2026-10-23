"""Coordinate-only closure certificates, with explicit Lean-checked mapping to original data.
Source preparation only; generated statements remain unverified until kernel compilation/replay.
"""
from pathlib import Path
import re,json,hashlib,sys
R=Path('/Users/tp/Lean/D1Bound5');O=Path(__file__).resolve().parent
G=int(sys.argv[1]);assert G in [23,30]
D=R/'D1Bound5';P=O/('graph'+str(G));P.mkdir(exist_ok=True);C=P/'pure-closure-sources';C.mkdir(exist_ok=True)
A=R/'research/continuations/20261018T010800CEST-main-continuation/prepared-light-remaining39/D1Bound5'
I=(A/f'SmallPairGraphInputs{G}.lean').read_text();W=(A/f'SmallPairGraphWitnessData{G}.lean').read_text()
ns=f'D1Bound5.PairLightClosurePrepared{G}';base=f'SmallPairPureClosureData{G}';targets=[];leaves=[];counts={};body_evidence={}
def h(s):return hashlib.sha256(s.encode()).hexdigest()
def imp(xs):return ''.join('import D1Bound5.'+n+'\n' for n in xs)
def env():return '\nnamespace '+ns+'\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n'
def end():return '\nend '+ns+'\n'
def put(n,s):
 assert not (D/(n+'.lean')).exists(),n
 (D/(n+'.lean')).write_text(s);(C/(n+'.lean')).write_text(s);targets.append(n)
def literal(s,name):
 m=re.search(r'^def '+re.escape(name)+r'\s*:[^\n]+:= \[\n(.*?)\n\]',s,re.M|re.S);assert m,name
 lines=m.group(1).splitlines();assert lines and all(x.startswith('  ') for x in lines);return lines
def coord(x):
 assert re.fullmatch(r'[0-9 \t\n,\-⟨⟩()]+',x),x[:50]
 return x.replace('⟨','(').replace('⟩',')')
m=re.search(r'def smallPairA_'+str(G)+r' : QuadInt (\d+) (\d+) := (⟨[^\n]+⟩)',I);assert m
tau,nu=int(m[1]),int(m[2]);aa=coord(m[3])
bb=coord(re.search(r'def smallPairB_'+str(G)+r' : QuadInt \d+ \d+ := (⟨[^\n]+⟩)',I)[1])
rr=coord(re.search(r'def anchorRoot : QuadInt \d+ \d+ := (⟨[^\n]+⟩)',W)[1])
rows={'vertices':literal(I,f'smallPairClosure_{G}'),'rootPairs':literal(W,'rootPairs'),'destinations':literal(W,'destinations')}
for name,lines in rows.items():counts[name]=len(lines)
assert len(set(counts.values()))==1;N=counts['vertices']
types={'vertices':'List PairLightCoordinate','rootPairs':'List (PairLightCoordinate × PairLightCoordinate)','destinations':'List (Option Nat × Option Nat)'}
modules=[]
for name,raw in rows.items():
 module=base+name[0].upper()+name[1:];chunks=[];restored=[]
 if name=='destinations':
  assert all(re.fullmatch(r'  \((none|some [0-9]+), (none|some [0-9]+)\),?',x) for x in raw)
  converted=raw
 else:converted=[coord(x) for x in raw]
 for k,off in enumerate(range(0,N,128)):
  group=converted[off:off+128];restored+=group;dn=name+'Chunk'+f'{k:02d}';cn=module+'Chunk'+f'{k:02d}';chunks.append((cn,dn))
  put(cn,imp(['PairLightClosure'])+env()+'\nnoncomputable def '+dn+' : '+types[name]+' := [\n'+'\n'.join(group).rstrip().removesuffix(',')+'\n]\n'+end())
 assert restored==converted
 put(module,imp([x[0] for x in chunks])+env()+'\nnoncomputable def '+name+' : '+types[name]+' :=\n  '+' ++ '.join(x[1] for x in chunks)+'\n'+end());modules.append(module)
 body_evidence[name]={'original_rows_sha256':h('\n'.join(raw)),'converted_rows_sha256':h('\n'.join(converted)),'rows':N,'change':'coordinate constructor syntax only' if name!='destinations' else 'none','chunks':[x[1] for x in chunks],'order_preserved':True}
s=imp(modules)+env()+f'\nnoncomputable def a : PairLightCoordinate := {aa}\nnoncomputable def b : PairLightCoordinate := {bb}\nnoncomputable def anchorRoot : PairLightCoordinate := {rr}\n\nnoncomputable def witnesses : List PairLightRootWitness :=\n  List.zipWith (fun (z : PairLightCoordinate) (rs : PairLightCoordinate × PairLightCoordinate) =>\n    ⟨z, rs.1, rs.2⟩) vertices rootPairs\n'+end();put(base,s)
for idx,off in enumerate(range(0,N,64)):
 c=min(64,N-off);mn=f'SmallPairPureClosure{G}Chunk{idx:02d}';th=f'chunk{idx:02d}_checked'
 s=imp([base])+env()+f'\n/-- Both signs retain the full original global destination vertex list. -/\ntheorem {th} :\n    pairLightIndexedWitnessesPrefixBool {tau} {nu} a b anchorRoot (10^1100) vertices {c}\n      (witnesses.drop {off}) (destinations.drop {off}) = true := by\n  decide +kernel\n'+end();put(mn,s);leaves.append({'module':mn,'name':th,'offset':off,'count':c})
join=f'SmallPairPureClosure{G}'
s=imp([x['module'] for x in leaves])+env()+f'\ntheorem all_checked :\n    pairLightIndexedWitnessesCheckedBool {tau} {nu} a b anchorRoot (10^1100) vertices\n      witnesses destinations = true := by\n  have h{N:04d} : pairLightIndexedWitnessesCheckedBool {tau} {nu} a b anchorRoot (10^1100) vertices\n      (witnesses.drop {N}) (destinations.drop {N}) = true := by\n    rfl\n'
for part in reversed(leaves):
 a,c=part['offset'],part['count']
 s+=f'  have h{a:04d} : pairLightIndexedWitnessesCheckedBool {tau} {nu} a b anchorRoot (10^1100) vertices\n      (witnesses.drop {a}) (destinations.drop {a}) = true := by\n    apply pairLightIndexedWitnessesCheckedBool_of_prefix_drop {tau} {nu} a b anchorRoot (10^1100) vertices {c}\n      (witnesses.drop {a}) (destinations.drop {a}) '+part['name']+f'\n    simpa only [List.drop_drop, Nat.reduceAdd] using h{a+c:04d}\n'
s+='  simpa only [List.drop_zero] using h0000\n'+end();put(join,s)
adapter=f'SmallPairPureClosureAdapter{G}';nsorig=f'PairGraphPrepared{G}'
s=imp([join,'PairLightClosureBridge',f'SmallPairGraphClosure{G}Coverage'])+env()+f'''
theorem a_eq : a = pairLightCoordinates smallPairA_{G} := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_{G} := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates {nsorig}.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_{G}.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = {nsorig}.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = {nsorig}.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_{G} smallPairB_{G} {nsorig}.anchorRoot
      (10^1100) smallPairClosure_{G} {nsorig}.witnesses {nsorig}.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool {tau} {nu}
      (pairLightCoordinates smallPairA_{G}) (pairLightCoordinates smallPairB_{G})
      (pairLightCoordinates {nsorig}.anchorRoot) (10^1100)
      (smallPairClosure_{G}.map pairLightCoordinates)
      ({nsorig}.witnesses.map pairLightRootWitnessCoordinates) {nsorig}.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_{G} smallPairB_{G}
    {nsorig}.anchorRoot (10^1100) smallPairClosure_{G}
    {nsorig}.witnesses {nsorig}.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_{G} smallPairB_{G} {nsorig}.anchorRoot
      (10^1100) smallPairClosure_{G} {nsorig}.witnesses {nsorig}.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_{G} smallPairB_{G}
    {nsorig}.anchorRoot (10^1100) smallPairClosure_{G}
    {nsorig}.witnesses {nsorig}.destinations
    {nsorig}.indexed_coverage_checked original_witnesses_checked
'''+end();put(adapter,s)
# The original closure module replacement is a proposal until bridge and numerical leaves pass.
orig=(A/f'SmallPairGraphClosure{G}.lean').read_text();first=orig.index('theorem PairGraphPrepared');by=orig.index(':= by',first);nextt=orig.index('theorem smallPairClosure_',by)
prefix=orig[orig.index('namespace '):first];header=orig[first:by+len(':= by')]
candidate=imp([adapter])+prefix+header+f'\n  exact PairLightClosurePrepared{G}.original_indexed_checked\n\n'+orig[nextt:]
(P/'ORIGINAL_CLOSURE_REPLACEMENT.lean').write_text(candidate)
plan={'status':'PREPARED_NOT_COMPILED','graph':G,'model':[tau,nu],'rows':N,'targets':targets,'pure_targets':targets[:-1],'leaves':leaves,'data_preservation':body_evidence,'original_data_sha256':{str(A/f'SmallPairGraphInputs{G}.lean'):h(I),str(A/f'SmallPairGraphWitnessData{G}.lean'):h(W)},'source_manifest':{n:h((D/(n+'.lean')).read_text()) for n in targets},'adapter':adapter,'original_closure_replacement_installed':False,'complete_global_destination_indices':True,'both_signs':True}
(P/'PURE_CLOSURE_PLAN.json').write_text(json.dumps(plan,indent=2)+'\n')
print(json.dumps({'graph':G,'rows':N,'pure_modules':len(targets)-1,'leaves':len(leaves),'adapter':adapter}))
