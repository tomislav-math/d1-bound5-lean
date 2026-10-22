"""Restore only graph25, preserving original data/types and complete indexed tails."""
from pathlib import Path
from datetime import datetime,timezone
import ast,fcntl,hashlib,importlib.util,json,os,re,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';W=C/'20261018T010800CEST-main-continuation';S=W/'prepared-light-remaining39/D1Bound5';O=Path(__file__).resolve().parent
TARGET='SmallPairGraphData25';PRE='0779efad350db71a408f5ae4dfb28264806d50f3f009a26aa664723f165173b3'
EXPECTED_ORIGINALS={'SmallPairGraphInputs25': 'e21e9c8c3f0ad8438726b3bcb26af38e89411d1090e9304422abee471ce9c18b', 'SmallPairGraphArithmetic25': 'adbd31c0b9ce182d87399cdbbe96f473c24aa8d054625ec7524511b6667c572d', 'SmallPairGraphWitnessData25': 'aad5db997a1a656ffe11b6d5627d083e2addabe315319a0bfb8ab88b70e20b6a', 'SmallPairGraphClosure25': 'fee51bd2f50af70f54d081386630bc3e88b5b14b2a68c149f1591d3c0cbabff4', 'SmallPairRawSelectedData25': '76ed86bf2dc6bf86b79bbaa574dff6d99fb70878ea6d86009fc7c483af4f7e54', 'SmallPairLightAssembly25': 'bd192e00e2176c523d859addb25c5bf30a7494b725c17168d6f36a58f7031fa6', 'SmallPairGraphTriangle25': 'fa05c5cdeefddbdb8b3935e9a00083ee1ceeed81cdd9aafc2366023452fb1c49', 'SmallPairGraphData25': 'cef7208eaaee99bc29dba01a22e8d816599dd69af1f34088426e5cafe74a600a'}
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
assert O==C/'20261022-graph25-closure'
binding_bytes=(O/'INSTALL_BINDING.json').read_bytes();binding=json.loads(binding_bytes)
BASE=binding['base_commit'];assert re.fullmatch(r'[0-9a-f]{40}',BASE)
assert binding['original_merged_sha256']==PRE and binding['original_merged_bytes']==2152431
assert binding['original_module_sha256']==EXPECTED_ORIGINALS
SCRIPT_PINS = {'prepare_checks.py': '026bd503cef2bc5cb68cb2761bb4bada44c0f957d2c597cfa8103760622e325d', 'finish_checks.py': '29136e226d9d9bbeb5e687bac79513255d319834d8ffff021b43bc5a1616dd9f', 'bounded_build_template.py': '3cd90f876193aef1d6c4014ba9794bb95995ae005f23af4772a020aa0a024cf8'}
assert all(sha(O/n)==h for n,h in SCRIPT_PINS.items())
assert sha(W/'continuation_driver_capacity.py')==DRIVER
pre=(R/'D1Bound5'/(TARGET+'.lean')).read_bytes();assert dg(pre)==PRE and len(pre)==2152431 and pre.endswith(b'\n')
text=pre.decode();marks=list(re.finditer(r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n',text,re.M));assert len(marks)==8 and body(text[:marks[0].start()])==''
originals={};blobs={};public=[];provenance={}
for i,m in enumerate(marks):
 n=m[1];assert n in EXPECTED_ORIGINALS and n not in originals
 p=S/(n+'.lean');b=p.read_bytes();end=marks[i+1].start() if i+1<len(marks) else len(text)
 assert dg(b)==EXPECTED_ORIGINALS[n]
 assert dg(b)==m[2] and body(b.decode())==text[m.end():end].strip()
 originals[n]=b;blobs[n]=b;public+=headers(b.decode());provenance[str(p)]=dg(b)
assert set(originals)==set(EXPECTED_ORIGINALS)
assert public==headers(text) and len(public)==28
assert len(blobs['SmallPairGraphInputs25'])==856689
assert len(blobs['SmallPairGraphWitnessData25'])==457369
assert len(blobs['SmallPairRawSelectedData25'])==833721
for n,key in [('SmallPairGraphInputs25','smallPairClosure_25'),('SmallPairGraphWitnessData25','rootPairs'),('SmallPairGraphWitnessData25','destinations')]:
 match=re.search(r'^def '+key+r'\b.*?:=\s*\[\n(.*?)\n\]',blobs[n].decode(),re.M|re.S);assert match and len([x for x in match[1].splitlines() if x.strip()])==762
chunks=[]
for j,off in enumerate(range(0,762,64)):
 n=f'SmallPairGraphClosure25Chunk{j:02d}';count=min(64,762-off);chunks.append({'module':n,'offset':off,'count':count})
 s=f"""import D1Bound5.SmallPairGraphWitnessData25
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared25
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk{j:02d}_checked :
    pairIndexedWitnessesPrefixBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 {count}
      (witnesses.drop {off}) (destinations.drop {off}) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared25
"""
 blobs[n]=s.encode();originals[n]=blobs[n]
assert [i for p in chunks for i in range(p['offset'],p['offset']+p['count'])]==list(range(762))
cov=R/'D1Bound5/SmallPairGraphClosure29Coverage.lean';assert sha(cov)=='16bbbcfa2e81413a9c2553d413b4d7d2e2f9203e70dc18f06687328ff90afce1'
blobs['SmallPairGraphClosure25Coverage']=cov.read_text().replace('29','25').encode();originals['SmallPairGraphClosure25Coverage']=blobs['SmallPairGraphClosure25Coverage'];provenance[str(cov)]=sha(cov)
assert 'List.zipWith' in blobs['SmallPairGraphWitnessData25'].decode()
old=originals['SmallPairGraphClosure25'].decode();starts=list(re.finditer(r'^theorem ',old,re.M));assert len(starts)==2
prefix=re.sub(r'^import [^\n]*(?:\n|$)','',old[:starts[0].start()],flags=re.M).lstrip('\n');first=old[starts[0].start():old.index(':=',starts[0].start())]
suffix=old[starts[1].start():]
proof="""  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25
    witnesses destinations indexed_coverage_checked
  have h762 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 762) (destinations.drop 762) = true := by
    rfl
"""
for j,p in reversed(list(enumerate(chunks))):
 off=p['offset'];count=p['count'];proof+=f"""  have h{off:03d} : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop {off}) (destinations.drop {off}) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 {count}
      (witnesses.drop {off}) (destinations.drop {off}) indexed_chunk{j:02d}_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h{off+count:03d}
"""
proof+='  simpa only [List.drop_zero] using h000\n\n'
new='import D1Bound5.SmallPairGraphClosure25Coverage\n'+''.join('import D1Bound5.'+p['module']+'\n' for p in chunks)+'\n'+prefix+first+':= by\n'+proof+suffix
assert headers(new)==headers(old) and new[new.index('theorem smallPairClosure_25_checked'):]==suffix
blobs['SmallPairGraphClosure25']=new.encode()
core=['SmallPairGraphInputs25','SmallPairGraphWitnessData25']+[p['module'] for p in chunks]+['SmallPairGraphClosure25Coverage','SmallPairGraphClosure25']
assembly=['SmallPairGraphArithmetic25','SmallPairRawSelectedData25','SmallPairLightAssembly25','SmallPairGraphTriangle25',TARGET];order=core+assembly
assert set(order)==set(blobs) and len(order)==21
seen=set();external=set()
for n in order:
 s=blobs[n].decode();dep=set(imports(s));assert dep&set(order)<=seen;external|=dep-set(order);seen.add(n)
 assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s)
old_external=set(imports(text[:marks[0].start()]));assert external==(old_external-{'PairClosureIndexedWitness'})|{'PairClosureIndexedChunks'}
spec=importlib.util.spec_from_file_location('graph25_restore_driver',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (W/'continuation-driver.lock').open('r+') as a,(W/'continuation-intake.lock').open('r+') as b:
 for f in [a,b]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('rev-parse','HEAD')==BASE and git('branch','--show-current')=='main' and not git('diff','--cached','--name-only')
 ps=subprocess.check_output(['ps','-axo','pid=,comm='],text=True);assert not any(Path(z[-1]).name in ('lean','lake','leanchecker') for l in ps.splitlines() if (z:=l.split()))
 d=m.Driver(R,W);active_bytes=d.active_path.read_bytes();assert not load(d.active_path).get('active') and not load(d.active_path).get('protected_closure')
 q,names,closures,accepted,unknown,eligible=d.snapshot();assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
 newnames=[n for n in order if n!=TARGET];assert TARGET in names and TARGET not in accepted and all(not (R/'D1Bound5'/(n+'.lean')).exists() and n not in names for n in newnames)
 assert not any(TARGET in closures[n] for n in accepted)
 required=set(closures[TARGET])-{TARGET}
 for n in external|{'SmallPairGraphClosure29Coverage','SmallPairGraphData29','SmallPairGraphData48','SmallPairGraphData12'}:required.update(d.closure(n))
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
  assert (O/'INSTALL_BINDING.json').read_bytes()==binding_bytes
  assert all(sha(O/n)==h for n,h in SCRIPT_PINS.items())
 stable();I=O/'installation';I.mkdir();(O/'candidates').mkdir();(O/'originals').mkdir()
 put(I/(TARGET+'.before.lean'),pre);put(I/'QUEUE_BEFORE.json',qb);put(I/'ACTIVE_BEFORE.json',active_bytes)
 put(I/'INSTALL_BINDING_USED.json',binding_bytes);save(I/'SCRIPT_PINS.json',SCRIPT_PINS)
 for n in order:put(O/'candidates'/(n+'.lean'),blobs[n]);put(O/'originals'/(n+'.lean'),originals[n])
 pins={n:dg(blobs[n]) for n in order}
 save(O/'PLAN.json',{'status':'REVIEWED_GRAPH25_RESTORATION_NOT_BUILT','base_commit':BASE,'source_manifest':pins,'build_order':order,'original_public_declarations':28,'original_public_headers':public,'prefix_parts':chunks,'closure_rows':762,'source_provenance':provenance,'original_merged_sha256':PRE,'root_integration':False,'main_theorem_complete':False})
 save(I/'GUARDS_BEFORE.json',{'head':BASE,'index_sha256':index,'accepted_sources':sources,'accepted_artifacts':artifacts,'configuration':static,'original_target_closure':closures[TARGET]});save(I/'ACCEPTED_INPUT_EVIDENCE.json',evidence)
 stable()
 for n in newnames:put(R/'D1Bound5'/(n+'.lean'),blobs[n])
 tmp=R/'D1Bound5/SmallPairGraphData25.partition.tmp';assert not tmp.exists();put(tmp,blobs[TARGET]);assert sha(R/'D1Bound5'/(TARGET+'.lean'))==PRE;os.replace(tmp,R/'D1Bound5'/(TARGET+'.lean'))
 q2=json.loads(qb);q2['names']+=newnames;assert {k:v for k,v in q2.items() if k!='names'}=={k:v for k,v in q.items() if k!='names'};m.atomic_json(d.queue_path,q2)
 assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in pins.items()) and all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
 assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False) and d.active_path.read_bytes()==active_bytes and git('rev-parse','HEAD')==BASE and sha(R/'.git/index')==index
 save(I/'QUEUE_AFTER.json',q2)
 wrapper=re.sub(r'^PINS = .*$', 'PINS = '+repr(pins),(O/'bounded_build_template.py').read_text(),flags=re.M);ast.parse(wrapper);put(O/'bounded_build.py',wrapper)
 pilot=['SmallPairGraphInputs25','SmallPairGraphWitnessData25','SmallPairGraphClosure25Chunk00','SmallPairGraphClosure25Coverage'];rest=[n for n in core if n not in pilot]
 for scope,targets in [('closure-pilot',pilot),('closure-rest',rest),('assembly',assembly)]:save(O/(scope+'-TARGETS.json'),targets)
 result={'status':'GRAPH25_RESTORED_UNCOMPILED','utc':datetime.now(timezone.utc).isoformat(),'new_modules':newnames,'original_declarations_preserved':28,'complete_rows':762,'partition_counts':[p['count'] for p in chunks],'all_original_data_unchanged':True,'both_mutation_signs_and_global_indices_preserved':True,'both_locks_held':True,'compiler_started':False,'root_integration':False}
 save(I/'APPLICATION_RECEIPT.json',result);print(json.dumps(result),flush=True)
