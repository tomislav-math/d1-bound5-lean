"""Restore only graph29, preserving original data/types and complete indexed tails."""
from pathlib import Path
from datetime import datetime,timezone
import ast,fcntl,hashlib,importlib.util,json,os,re,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';W=C/'20261018T010800CEST-main-continuation';S=W/'prepared-light-remaining39/D1Bound5';O=Path(__file__).resolve().parent
BASE='4db869718a6f962e60d30ba75abc47bc5e57a1f3';TARGET='SmallPairGraphData29';PRE='a053d55a62f07a2134b0d7c268a43914566376355049b5828289445cd2450e99'
DRIVER='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dg(b):return hashlib.sha256(b).hexdigest()
def load(p):return json.loads(Path(p).read_text())
def put(p,b):
 if isinstance(b,str):b=b.encode()
 with Path(p).open('xb') as f:f.write(b)
def save(p,x):put(p,json.dumps(x,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git',*a],cwd=R,text=True,timeout=30).strip()
def body(s):return re.sub(r'^import [^\n]*(?:\n|$)','',s,flags=re.M).strip()
def headers(s):return [s[m.start():s.index(':=',m.start())] for m in re.finditer(r'^(?:def|theorem|lemma|abbrev|structure) ',s,re.M)]
def imports(s):return re.findall(r'^import D1Bound5\.(\w+)\s*$',s,re.M)
assert sha(W/'continuation_driver_capacity.py')==DRIVER
pre=(R/'D1Bound5'/(TARGET+'.lean')).read_bytes();assert dg(pre)==PRE
text=pre.decode();marks=list(re.finditer(r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n',text,re.M));assert len(marks)==8 and body(text[:marks[0].start()])==''
originals={};blobs={};public=[];provenance={}
for i,m in enumerate(marks):
 n=m[1];p=S/(n+'.lean');b=p.read_bytes();end=marks[i+1].start() if i+1<len(marks) else len(text)
 assert dg(b)==m[2] and body(b.decode())==text[m.end():end].strip()
 originals[n]=b;blobs[n]=b;public+=headers(b.decode());provenance[str(p)]=dg(b)
assert public==headers(text) and len(public)==28
for n,key in [('SmallPairGraphInputs29','smallPairClosure_29'),('SmallPairGraphWitnessData29','rootPairs'),('SmallPairGraphWitnessData29','destinations')]:
 match=re.search(r'^def '+key+r'\b.*?:=\s*\[\n(.*?)\n\]',blobs[n].decode(),re.M|re.S);assert match and len([x for x in match[1].splitlines() if x.strip()])==763
chunks=[]
for j,off in enumerate(range(0,763,64)):
 n=f'SmallPairGraphClosure29Chunk{j:02d}';count=min(64,763-off);chunks.append({'module':n,'offset':off,'count':count})
 s=f"""import D1Bound5.SmallPairGraphWitnessData29
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared29
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk{j:02d}_checked :
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 {count}
      (witnesses.drop {off}) (destinations.drop {off}) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared29
"""
 blobs[n]=s.encode();originals[n]=blobs[n]
assert [i for p in chunks for i in range(p['offset'],p['offset']+p['count'])]==list(range(763))
cov=R/'D1Bound5/SmallPairGraphClosure48Coverage.lean';assert sha(cov)=='cf547bf730123feb39f681d5a24fa79be0441f9efa99e2fe1672ec6e23f4d1e6'
blobs['SmallPairGraphClosure29Coverage']=cov.read_text().replace('48','29').replace('QuadInt 1 8','QuadInt 1 1').encode();originals['SmallPairGraphClosure29Coverage']=blobs['SmallPairGraphClosure29Coverage'];provenance[str(cov)]=sha(cov)
assert 'List.zipWith' in blobs['SmallPairGraphWitnessData29'].decode()
old=originals['SmallPairGraphClosure29'].decode();starts=list(re.finditer(r'^theorem ',old,re.M));assert len(starts)==2
prefix=re.sub(r'^import [^\n]*(?:\n|$)','',old[:starts[0].start()],flags=re.M).lstrip('\n');first=old[starts[0].start():old.index(':=',starts[0].start())]
suffix=old[starts[1].start():]
proof="""  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_29 smallPairB_29 anchorRoot (10^1100) smallPairClosure_29
    witnesses destinations indexed_coverage_checked
  have h763 : pairIndexedWitnessesCheckedBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 (witnesses.drop 763) (destinations.drop 763) = true := by
    rfl
"""
for j,p in reversed(list(enumerate(chunks))):
 off=p['offset'];count=p['count'];proof+=f"""  have h{off:03d} : pairIndexedWitnessesCheckedBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 (witnesses.drop {off}) (destinations.drop {off}) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_29 smallPairB_29 anchorRoot (10^1100) smallPairClosure_29 {count}
      (witnesses.drop {off}) (destinations.drop {off}) indexed_chunk{j:02d}_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h{off+count:03d}
"""
proof+='  simpa only [List.drop_zero] using h000\n\n'
new='import D1Bound5.SmallPairGraphClosure29Coverage\n'+''.join('import D1Bound5.'+p['module']+'\n' for p in chunks)+'\n'+prefix+first+':= by\n'+proof+suffix
assert headers(new)==headers(old) and new[new.index('theorem smallPairClosure_29_checked'):]==suffix
blobs['SmallPairGraphClosure29']=new.encode()
core=['SmallPairGraphInputs29','SmallPairGraphWitnessData29']+[p['module'] for p in chunks]+['SmallPairGraphClosure29Coverage','SmallPairGraphClosure29']
assembly=['SmallPairGraphArithmetic29','SmallPairRawSelectedData29','SmallPairLightAssembly29','SmallPairGraphTriangle29',TARGET];order=core+assembly
assert set(order)==set(blobs) and len(order)==21
seen=set();external=set()
for n in order:
 s=blobs[n].decode();dep=set(imports(s));assert dep&set(order)<=seen;external|=dep-set(order);seen.add(n)
 assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s)
old_external=set(imports(text[:marks[0].start()]));assert external==(old_external-{'PairClosureIndexedWitness'})|{'PairClosureIndexedChunks'}
spec=importlib.util.spec_from_file_location('graph29_restore_driver',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (W/'continuation-driver.lock').open('r+') as a,(W/'continuation-intake.lock').open('r+') as b:
 for f in [a,b]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('rev-parse','HEAD')==BASE and git('branch','--show-current')=='main' and not git('diff','--cached','--name-only')
 ps=subprocess.check_output(['ps','-axo','pid=,comm='],text=True);assert not any(Path(z[-1]).name in ('lean','lake','leanchecker') for l in ps.splitlines() if (z:=l.split()))
 d=m.Driver(R,W);active_bytes=d.active_path.read_bytes();assert not load(d.active_path).get('active') and not load(d.active_path).get('protected_closure')
 q,names,closures,accepted,unknown,eligible=d.snapshot();assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
 newnames=[n for n in order if n!=TARGET];assert TARGET in names and TARGET not in accepted and all(not (R/'D1Bound5'/(n+'.lean')).exists() and n not in names for n in newnames)
 assert not any(TARGET in closures[n] for n in accepted)
 required=set(closures[TARGET])-{TARGET}
 for n in external|{'SmallPairGraphClosure48Coverage','SmallPairGraphData48','SmallPairGraphData12'}:required.update(d.closure(n))
 assert required<=accepted
 for k,v in q.items():
  if k=='blocked_modules' or k.startswith('held_until_'):assert not set(v)&(required|set(order))
 latest=d.latest();artifacts={};evidence={};sources={}
 for n in sorted(required):
  c=d.closure(n);key=m.fingerprint(c);mf=d.expected_manifest(n,key,latest);assert mf and d.artifacts(n)==mf,n;sources[n]=c[n]
  evidence[n]={'fingerprint':key,'artifacts':mf,'original_receipt':latest.get((n,key)),'baseline_entry':None if (n,key) in latest else d.baseline['accepted'][n]}
  for p,h in mf.items():assert p not in artifacts or artifacts[p]==h;artifacts[p]=h
 static=dict(d.static);qb=d.queue_path.read_bytes();index=sha(R/'.git/index')
 def stable():
  assert git('rev-parse','HEAD')==BASE and sha(R/'.git/index')==index and d.queue_path.read_bytes()==qb and d.active_path.read_bytes()==active_bytes
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items()) and all(sha(p)==h for p,h in provenance.items())
  assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False)
  assert sha(R/'D1Bound5'/(TARGET+'.lean'))==PRE
 stable();I=O/'installation';I.mkdir();(O/'candidates').mkdir();(O/'originals').mkdir()
 put(I/(TARGET+'.before.lean'),pre);put(I/'QUEUE_BEFORE.json',qb);put(I/'ACTIVE_BEFORE.json',active_bytes)
 for n in order:put(O/'candidates'/(n+'.lean'),blobs[n]);put(O/'originals'/(n+'.lean'),originals[n])
 pins={n:dg(blobs[n]) for n in order}
 save(O/'PLAN.json',{'status':'REVIEWED_GRAPH29_RESTORATION_NOT_BUILT','base_commit':BASE,'source_manifest':pins,'build_order':order,'original_public_declarations':28,'original_public_headers':public,'prefix_parts':chunks,'closure_rows':763,'source_provenance':provenance,'original_merged_sha256':PRE,'root_integration':False,'main_theorem_complete':False})
 save(I/'GUARDS_BEFORE.json',{'head':BASE,'index_sha256':index,'accepted_sources':sources,'accepted_artifacts':artifacts,'configuration':static,'original_target_closure':closures[TARGET]});save(I/'ACCEPTED_INPUT_EVIDENCE.json',evidence)
 stable()
 for n in newnames:put(R/'D1Bound5'/(n+'.lean'),blobs[n])
 tmp=R/'D1Bound5/SmallPairGraphData29.partition.tmp';assert not tmp.exists();put(tmp,blobs[TARGET]);assert sha(R/'D1Bound5'/(TARGET+'.lean'))==PRE;os.replace(tmp,R/'D1Bound5'/(TARGET+'.lean'))
 q2=json.loads(qb);q2['names']+=newnames;assert {k:v for k,v in q2.items() if k!='names'}=={k:v for k,v in q.items() if k!='names'};m.atomic_json(d.queue_path,q2)
 assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in pins.items()) and all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
 assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False) and d.active_path.read_bytes()==active_bytes and git('rev-parse','HEAD')==BASE and sha(R/'.git/index')==index
 save(I/'QUEUE_AFTER.json',q2)
 Sides=C/'20261021-evening-graph29-sides';wrapper=re.sub(r'^PINS = .*$','PINS = '+repr(pins),(Sides/'bounded_build.py').read_text(),flags=re.M);ast.parse(wrapper);put(O/'bounded_build.py',wrapper)
 for script in ['prepare_checks.py','finish_checks.py']:
  s=(Sides/script).read_text().replace('GRAPH29_SIDES_AXIOMS_PASS','GRAPH29_CLOSURE_AXIOMS_PASS')
  if script=='prepare_checks.py':
   key=' source_map={};evidence={}';assert key in s;s=s.replace(key," for side in ['left','right']:\n  for n,item in load(R/'research/continuations/20261021-evening-graph29-sides'/(side+'-SOURCE_MAP.json'))['sources'].items():oldmap[(n,item['sha256'])]=item\n"+key)
  ast.parse(s);put(O/script,s)
 pilot=['SmallPairGraphInputs29','SmallPairGraphWitnessData29','SmallPairGraphClosure29Chunk00','SmallPairGraphClosure29Coverage'];rest=[n for n in core if n not in pilot]
 for scope,targets in [('closure-pilot',pilot),('closure-rest',rest),('assembly',assembly)]:save(O/(scope+'-TARGETS.json'),targets)
 result={'status':'GRAPH29_RESTORED_UNCOMPILED','utc':datetime.now(timezone.utc).isoformat(),'new_modules':newnames,'original_declarations_preserved':28,'complete_rows':763,'partition_counts':[p['count'] for p in chunks],'all_original_data_unchanged':True,'both_mutation_signs_and_global_indices_preserved':True,'both_locks_held':True,'compiler_started':False,'root_integration':False}
 save(I/'APPLICATION_RECEIPT.json',result);print(json.dumps(result),flush=True)
