"""Exact source-only decomposition for owned graphs. No compiler, queue or Git mutation."""
from pathlib import Path
import ast,hashlib,json,re,sys
sys.set_int_max_str_digits(0)
R=Path('/Users/tp/Lean/D1Bound5');O=Path(__file__).resolve().parent
A=R/'research/continuations/20261018T010800CEST-main-continuation/prepared-light-remaining39/D1Bound5'
H=lambda s:hashlib.sha256(s.encode() if isinstance(s,str) else s).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def decls(s):return [(m[1],m[2],m[0]) for m in re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=',s,re.M|re.S)]
def literal(s,n):
 m=re.search(r'^def '+n+r'[^\n]*:= \[\n(.*?)^\]\n',s,re.M|re.S);assert m,n
 rows=m[1].splitlines(keepends=True);assert rows and all(x.startswith('  ') for x in rows)
 return m,rows

def main(i):
 assert i in [23,30]
 out=O/f'graph{i}';assert not out.exists();out.mkdir();(out/'originals').mkdir();(out/'candidates').mkdir()
 candidates={};originals={};pure=[];join=[];light_info={};names=[]
 def src(n):
  s=(R/'D1Bound5'/(n+'.lean')).read_text();originals[n]=s;return s
 def add(n,s,group=None):
  assert n not in candidates,n
  assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s),n
  candidates[n]=s
  if group is not None:group.append(n)
 light=src(f'SmallPairLightData{i}')
 footer=f'end D1Bound5.PairLightPrepared{i}\n'
 ms=list(re.finditer(r'^def (\w+) : [^\n]+ :=',light,re.M));assert [m[1] for m in ms]==['sieve','leftVertices','leftCached','leftRows','rightVertices','rightCached','rightRows']
 head=light[:ms[0].start()];assert light.endswith(footer)
 blocks={m[1]:light[m.start():ms[j+1].start() if j+1<len(ms) else len(light)-len(footer)] for j,m in enumerate(ms)}
 assert head+''.join(blocks.values())+footer==light
 parts={};data_modules=[]
 for n,b in blocks.items():
  module=f'SmallPairLightData{i}{n[0].upper()+n[1:]}'
  if n.endswith('Cached'):
   m,rows=literal(b,n);chunks=[];rowcollect=[]
   for k,off in enumerate(range(0,len(rows),120)):
    cname=n+f'Chunk{k:02d}';cm=module+f'Chunk{k:02d}';chunk=rows[off:off+120];rowcollect+=chunk
    body=f'noncomputable\ndef {cname} : List PairLightCachedVertex := [\n'+''.join(chunk)+']\n\n'
    add(cm,head+body+footer,pure);chunks.append((cm,cname))
   assert rowcollect==rows
   text=''.join(f'import D1Bound5.{cm}\n' for cm,_ in chunks)+'\n'+head[head.index('namespace '):]
   text+=f'noncomputable\ndef {n} : List PairLightCachedVertex := '+' ++ '.join(cn for _,cn in chunks)+'\n\n'+footer
   add(module,text,pure)
  else:add(module,head+b+footer,pure)
  data_modules.append(module)
 add(f'SmallPairLightData{i}',''.join(f'import D1Bound5.{n}\n' for n in data_modules),pure)
 adaptive=src(f'SmallPairLightAdaptiveData{i}');adaptive=re.sub(r'^def (\w*Cached\d*)',r'noncomputable\ndef \1',adaptive,flags=re.M)
 add(f'SmallPairLightAdaptiveData{i}',adaptive,pure)
 add(f'SmallPairLightAdaptiveValidation{i}',src(f'SmallPairLightAdaptiveValidation{i}'),pure)
 for side in ['left','right']:
  kind=side.title();N=len(literal(blocks[side+'Cached'],side+'Cached')[1])
  parents=sorted((R/'D1Bound5').glob(f'SmallPairLightAdaptive{kind}{i}_*.lean'))
  assert parents and all(re.fullmatch(f'SmallPairLightAdaptive{kind}{i}_[0-9]{{3}}.lean',p.name) for p in parents)
  offset=0;parent_records=[]
  for p in parents:
   s=src(p.stem);m=re.search(r'pairLightSelectedFloorPrefixBool (\d+) (\d+) PairLightPrepared'+str(i)+r'\.sieve (\d+)',s);assert m
   tau,nu,count=map(int,m.groups());header=s[s.index('theorem '):s.index(':=',s.index('theorem '))]
   parent_key=p.stem[-3:];pieces=[]
   # Twelve complete heads stay below the previously measured leaf workload.
   for j,local in enumerate(range(0,count,12)):
    c=min(12,count-local);off=offset+local;name=f'SmallPairParallel{kind}{i}_{parent_key}Part{j:02d}';th=f'{side}_parallel_{parent_key}_part{j:02d}_checked'
    imports=[f'SmallPairLightData{i}Sieve',f'SmallPairLightData{i}{kind}Cached',f'SmallPairLightData{i}{kind}Rows','PairLightArithmeticChunks']
    text=''.join(f'import D1Bound5.{n}\n' for n in imports)+f'\nnamespace D1Bound5.PairLightAdaptivePrepared{i}\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
    text+=f'/-- Original heads {off} through {off+c-1}, with every original tail comparison. -/\ntheorem {th} :\n    pairLightSelectedFloorPrefixBool {tau} {nu} PairLightPrepared{i}.sieve {c}\n      (PairLightPrepared{i}.{side}Cached.drop {off}) (PairLightPrepared{i}.{side}Rows.drop {off}) = true := by\n  decide +kernel\n\nend D1Bound5.PairLightAdaptivePrepared{i}\n'
    add(name,text,pure);pieces.append({'module':name,'theorem':th,'offset':off,'count':c,'pairs':c*(N-off-1)-c*(c-1)//2})
   text=f'import D1Bound5.SmallPairLightAdaptiveData{i}\nimport D1Bound5.PairLightArithmeticPrefixConcat\n'+''.join(f'import D1Bound5.{x["module"]}\n' for x in pieces)+f'\nnamespace D1Bound5.PairLightAdaptivePrepared{i}\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'+header+':= by\n'
   for j in reversed(range(len(pieces))):
    x=pieces[j];off=x['offset'];c=x['count'];rest=offset+count-off
    text+=f'  have h{off:04d} : pairLightSelectedFloorPrefixBool {tau} {nu} PairLightPrepared{i}.sieve {rest}\n      (PairLightPrepared{i}.{side}Cached.drop {off}) (PairLightPrepared{i}.{side}Rows.drop {off}) = true := '
    if j==len(pieces)-1:text+=x['theorem']+'\n'
    else:text+=f'by\n    apply pairLightSelectedFloorPrefixBool_of_add {tau} {nu} PairLightPrepared{i}.sieve {c} {rest-c}\n      (PairLightPrepared{i}.{side}Cached.drop {off}) (PairLightPrepared{i}.{side}Rows.drop {off})\n    · exact {x["theorem"]}\n    · simpa only [List.drop_drop, Nat.reduceAdd] using h{off+c:04d}\n'
   text+=f'  exact h{offset:04d}\n\nend D1Bound5.PairLightAdaptivePrepared{i}\n'
   assert decls(text)[0][2]==decls(s)[0][2]
   add(p.stem,text,join);parent_records.append({'module':p.stem,'offset':offset,'count':count,'pieces':pieces});offset+=count
  assert offset==N,(offset,N)
  light_info[side]={'vertices':N,'parents':parent_records,'pairs':N*(N-1)//2}
  add(f'SmallPairLight{kind}{i}',src(f'SmallPairLight{kind}{i}'),join)
 # Recover the exact eight archived modules from the merged original.
 target=f'SmallPairGraphData{i}';merged=src(target)
 marks=list(re.finditer(r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n',merged,re.M));assert len(marks)==8
 archived={}
 for j,m in enumerate(marks):
  n=m[1];s=(A/(n+'.lean')).read_text();assert H(s)==m[2]
  body=re.sub(r'\A(?:import [^\n]+\n)+','',s).strip();segment=merged[m.end():marks[j+1].start() if j+1<len(marks) else len(merged)].strip();assert body==segment,n
  archived[n]=s
  originals[n+'.archived']=s
 inp=archived[f'SmallPairGraphInputs{i}'];wm=archived[f'SmallPairGraphWitnessData{i}']
 model=re.search(r'def smallPairA_'+str(i)+r' : QuadInt (\d+) (\d+)',inp);tau,nu=map(int,model.groups())
 rows=len(literal(inp,f'smallPairClosure_{i}')[1]);assert len(literal(wm,'rootPairs')[1])==rows==len(literal(wm,'destinations')[1])
 closure_order=[]
 for n in [f'SmallPairGraphInputs{i}',f'SmallPairGraphWitnessData{i}']:add(n,archived[n],closure_order)
 closure_parts=[]
 for j,off in enumerate(range(0,rows,64)):
  c=min(64,rows-off);name=f'SmallPairGraphClosure{i}Chunk{j:02d}';th=f'indexed_chunk{j:02d}_checked'
  s=f'import D1Bound5.SmallPairGraphWitnessData{i}\nimport D1Bound5.PairClosureIndexedChunks\n\nnamespace D1Bound5.PairGraphPrepared{i}\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n/-- Both mutation signs use the complete original destination list. -/\ntheorem {th} :\n    pairIndexedWitnessesPrefixBool smallPairA_{i} smallPairB_{i} anchorRoot\n      (10^1100) smallPairClosure_{i} {c}\n      (witnesses.drop {off}) (destinations.drop {off}) = true := by\n  decide +kernel\n\nend D1Bound5.PairGraphPrepared{i}\n'
  add(name,s,closure_order);closure_parts.append({'module':name,'theorem':th,'offset':off,'count':c})
 coverage=(R/'D1Bound5/SmallPairGraphClosure29Coverage.lean').read_text().replace('QuadInt 1 1',f'QuadInt {tau} {nu}')
 for a,b in [('WitnessData29',f'WitnessData{i}'),('Prepared29',f'Prepared{i}'),('smallPairA_29',f'smallPairA_{i}'),('smallPairB_29',f'smallPairB_{i}'),('smallPairClosure_29',f'smallPairClosure_{i}')]:coverage=coverage.replace(a,b)
 assert not re.search(r'\b\w*29\b',coverage)
 add(f'SmallPairGraphClosure{i}Coverage',coverage,closure_order)
 old=archived[f'SmallPairGraphClosure{i}'];th=list(re.finditer(r'^theorem ',old,re.M));assert len(th)==2
 head=old[th[0].start():old.index(':=',th[0].start())];last=old[th[1].start():]
 prefix=old[re.match(r'(?:import [^\n]+\n)+',old).end():th[0].start()]
 text=f'import D1Bound5.SmallPairGraphClosure{i}Coverage\n'+''.join(f'import D1Bound5.{p["module"]}\n' for p in closure_parts)+prefix+head+':= by\n'
 text+=f'  apply pairClosureIndexedWitnessBool_of_checked_parts\n    smallPairA_{i} smallPairB_{i} anchorRoot (10^1100) smallPairClosure_{i}\n    witnesses destinations indexed_coverage_checked\n  have h{rows:04d} : pairIndexedWitnessesCheckedBool smallPairA_{i} smallPairB_{i} anchorRoot\n      (10^1100) smallPairClosure_{i} (witnesses.drop {rows}) (destinations.drop {rows}) = true := by\n    rfl\n'
 for p in reversed(closure_parts):
  off,c=p['offset'],p['count'];text+=f'  have h{off:04d} : pairIndexedWitnessesCheckedBool smallPairA_{i} smallPairB_{i} anchorRoot\n      (10^1100) smallPairClosure_{i} (witnesses.drop {off}) (destinations.drop {off}) = true := by\n    apply pairIndexedWitnessesCheckedBool_of_prefix_drop\n      smallPairA_{i} smallPairB_{i} anchorRoot (10^1100) smallPairClosure_{i} {c}\n      (witnesses.drop {off}) (destinations.drop {off}) {p["theorem"]}\n    simpa only [List.drop_drop, Nat.reduceAdd] using h{off+c:04d}\n'
 text+='  simpa only [List.drop_zero] using h0000\n\n'+last
 assert [x[2] for x in decls(text)]==[x[2] for x in decls(old)]
 add(f'SmallPairGraphClosure{i}',text,closure_order)
 assembly=[]
 add(f'SmallPairGraphArithmetic{i}',archived[f'SmallPairGraphArithmetic{i}'],assembly)
 raw=archived[f'SmallPairRawSelectedData{i}'];ds=list(re.finditer(r'^def (\w+)\s*:',raw,re.M));assert [m[1] for m in ds]==['leftCached','leftRows','rightCached','rightRows']
 end=raw.index(f'end D1Bound5.PairSelectedPrepared{i}');rawmods=[]
 for j,m in enumerate(ds):
  n=f'SmallPairRawSelectedData{i}{m[1][0].upper()+m[1][1:]}';s=raw[:ds[0].start()]+raw[m.start():ds[j+1].start() if j+1<len(ds) else end]+raw[end:]
  add(n,s,assembly);rawmods.append(n)
 add(f'SmallPairRawSelectedData{i}',''.join(f'import D1Bound5.{n}\n' for n in rawmods),assembly)
 for n in [f'SmallPairLightAssembly{i}',f'SmallPairGraphTriangle{i}',target]:add(n,archived[n],assembly)
 order=pure+join+closure_order+assembly;assert len(order)==len(set(order))==len(candidates)
 for n,s in candidates.items():(out/'candidates'/(n+'.lean')).write_text(s)
 for n,s in originals.items():(out/'originals'/(n+'.lean')).write_text(s)
 plan={'status':'PREPARED_SOURCE_ONLY_NOT_INSTALLED_NOT_COMPILED','graph':i,'model':[tau,nu],'pure_init_targets':pure,'join_targets':join,'closure_targets':closure_order,'assembly_targets':assembly,'build_order':order,'source_manifest':{n:H(s) for n,s in candidates.items()},'original_manifest':{n:H(s) for n,s in originals.items()},'light':light_info,'closure_rows':rows,'closure_parts':closure_parts,'full_original_tails':True,'both_mutation_signs_and_global_destination_indices':True,'original_header_preservation':True,'cached_definition_structure_changed_to_exact_literal_chunk_concatenation':True,'cached_original_row_bytes_preserved':True,'no_proof_acceptance_claim':True}
 save(out/'PLAN.json',plan)
 print(json.dumps({'graph':i,'modules':len(candidates),'pure_init':len(pure),'side_counts':{s:x['vertices'] for s,x in light_info.items()},'closure_rows':rows,'directory':str(out)}),flush=True)
if __name__=='__main__':
 for i in map(int,sys.argv[1:]):main(i)
