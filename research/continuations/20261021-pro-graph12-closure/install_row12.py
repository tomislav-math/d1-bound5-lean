"""Install the independent row12 archived decomposition and exact 720-row closure proof.
No compiler, Git mutation, timeout increase, hold release, or changes to other rows.
"""
from pathlib import Path
from datetime import datetime,timezone
import ast,fcntl,hashlib,importlib.util,json,os,re,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation'
U=R/'research/continuations/20261020T100000CEST-work-resume';O=Path(__file__).resolve().parent
ARCH=W/'prepared-light-remaining39/D1Bound5';C=R/'D1Bound5'
BASE='f48b97f93624f500e9c11ec0c810ae55f524c720';TARGET='SmallPairGraphData12'
PREIMAGE='005d3224d3bfa971fd9b09e6fd5a6aaf60a4838c6894fb9d32e767d486af3f21'
DRIVER='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
OLD='bbdf849a2fe20ad1c1dbc31b97a11b26d2a85585f3aba995282c64d92bc21f7f';NEW='bd10abcbcb8b3652c7cc692c2786f2dda353af12b14c140bba660a499605c4f0'
def dg(b):return hashlib.sha256(b).hexdigest()
def sha(p):return dg(Path(p).read_bytes())
def load(p):return json.loads(Path(p).read_text())
def put(p,b):
 if isinstance(b,str):b=b.encode()
 with Path(p).open('xb') as f:f.write(b);f.flush();os.fsync(f.fileno())
def save(p,v):put(p,json.dumps(v,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git',*a],cwd=R,text=True,timeout=30).strip()
def body(s):return re.sub(r'^import [^\n]*(?:\n|$)','',s,flags=re.M).strip()
def headers(s):return [s[m.start():s.index(':=',m.start())] for m in re.finditer(r'^(?:def|theorem|lemma|abbrev|structure) ',s,re.M)]
def imports(s):return re.findall(r'^import D1Bound5\.(\w+)\s*$',s,re.M)
assert sha(W/'continuation_driver_capacity.py')==DRIVER
pre=(C/(TARGET+'.lean')).read_bytes();assert dg(pre)==PREIMAGE
marks=list(re.finditer(r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n',pre.decode(),re.M));assert len(marks)==8 and body(pre.decode()[:marks[0].start()])==''
blobs={};originals={};public=[];provenance={};external0=set();components=[]
for i,m in enumerate(marks):
 n=m[1];p=ARCH/(n+'.lean');b=p.read_bytes();s=b.decode();end=marks[i+1].start() if i+1<len(marks) else len(pre.decode())
 assert dg(b)==m[2] and body(s)==pre.decode()[m.end():end].strip()
 blobs[n]=b;originals[n]=b;public+=headers(s);provenance[str(p)]=dg(b);components.append(n);external0.update(imports(s))
assert public==headers(pre.decode()) and len(public)==28
external0-=set(components);assert external0==set(imports(pre.decode()[:marks[0].start()]))
# All actual rows and destinations remain in the original data; only aligned row tails are sliced.
parts=[]
for j in range(6):
 oldname=f'SmallPairGraphClosure17Chunk{j:02d}';template=C/(oldname+'.lean');s=template.read_text();provenance[str(template)]=sha(template)
 newname=f'SmallPairGraphClosure12Chunk{j:02d}';s=s.replace('17','12')
 if j==5:
  assert s.count('smallPairClosure_12 79')==1;s=s.replace('smallPairClosure_12 79','smallPairClosure_12 80')
 blobs[newname]=s.encode();originals[newname]=s.encode();parts.append({'module':newname,'offset':128*j,'count':128 if j<5 else 80})
assert [i for p in parts for i in range(p['offset'],p['offset']+p['count'])]==list(range(720))
# The accepted structural coverage proof avoids re-deciding a gigantic list equality.
cov=C/'SmallPairGraphClosure33Coverage.lean';assert sha(cov)==NEW;provenance[str(cov)]=NEW
coverage=cov.read_text().replace('33','12').replace('QuadInt 1 2','QuadInt 0 1')
blobs['SmallPairGraphClosure12Coverage']=coverage.encode();originals['SmallPairGraphClosure12Coverage']=coverage.encode()
assert 'List.zipWith' in blobs['SmallPairGraphWitnessData12'].decode()
p=C/'SmallPairGraphClosure17.lean';assert sha(p)=='4840fd17cd892930435cec68826aef54d98a8a9821927e698f129eb7ac737f0c';provenance[str(p)]=sha(p)
s=p.read_text().replace('17','12');assert s.count('.drop 719')==2 and s.count('smallPairClosure_12 79')==1;s=s.replace('.drop 719','.drop 720').replace('smallPairClosure_12 79','smallPairClosure_12 80')
old=originals['SmallPairGraphClosure12'].decode();assert headers(s)==headers(old)
a1=list(re.finditer(r'^theorem ',old,re.M));a2=list(re.finditer(r'^theorem ',s,re.M));assert len(a1)==len(a2)==2 and old[a1[1].start():]==s[a2[1].start():] and body(old[:a1[0].start()])==body(s[:a2[0].start()])
blobs['SmallPairGraphClosure12']=s.encode()
names=['SmallPairGraphInputs12','SmallPairGraphArithmetic12','SmallPairGraphWitnessData12']+[p['module'] for p in parts]+['SmallPairGraphClosure12Coverage','SmallPairGraphClosure12','SmallPairRawSelectedData12','SmallPairLightAssembly12','SmallPairGraphTriangle12',TARGET]
assert len(names)==15 and set(names)==set(blobs);newnames=names[:-1]
seen=set();external=set()
for n in names:
 s=blobs[n].decode();deps=set(imports(s));assert deps&set(names)<=seen;external|=deps-set(names);seen.add(n)
 assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s)
assert external==(external0-{'PairClosureIndexedWitness'})|{'PairClosureIndexedChunks'}
for n in components:
 if n!='SmallPairGraphClosure12':assert blobs[n]==originals[n]
# Retain the existing thirty-target pilot gate with the one independently accepted coverage transition.
pilotplan=U/'graph-data17_35_48-integrated-prefix-proposal/PLAN.json';assert sha(pilotplan)=='6a1a8d225e4a7872244f8815ea26cb01b74eb57719cf0f1d26f225031dd8a2c6';provenance[str(pilotplan)]=sha(pilotplan)
gate=load(pilotplan)['runtime_pilot_gate'];pilots=gate['all_required_current_pilot_targets'];assert len(pilots)==30
cr=R/'research/continuations/20261021-pro-graph33/coverage-projection/SmallPairGraphClosure33Coverage-BUILD_RECEIPT.json';cv=load(cr);assert cv['accepted_build'] and cv['exit']==0 and cv['source_sha256']==NEW
ap=U/'pro-graph33-audit/BOUND_AUDIT_FINAL.json';av=load(ap);assert av['status']=='BOUND_SCOPED_AUDIT_PASS' and all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in av['records']);assert any(x['label']=='SmallPairGraphClosure33Coverage-targeted-replay' for x in av['records']);provenance.update({str(cr):sha(cr),str(ap):sha(ap)})
spec=importlib.util.spec_from_file_location('row12_closure_install',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (W/'continuation-driver.lock').open('r+') as a,(W/'continuation-intake.lock').open('r+') as b:
 for f in (a,b):fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('rev-parse','HEAD')==BASE and git('branch','--show-current')=='main' and not git('diff','--cached','--name-only')
 ps=subprocess.check_output(['ps','-axo','pid=,comm='],text=True);assert not any(Path(v[-1]).name in ('lean','lake','leanchecker') for l in ps.splitlines() if (v:=l.split()))
 d=m.Driver(R,W);ab=d.active_path.read_bytes();active=load(d.active_path);assert not active.get('active') and not active.get('protected_closure')
 q,qn,closures,accepted,unknown,eligible=d.snapshot();assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
 assert TARGET in qn and TARGET not in accepted and all(n not in qn and not (C/(n+'.lean')).exists() for n in newnames)
 assert not any(TARGET in closures[n] for n in accepted),'Accepted consumer would change'
 assert sha(C/(TARGET+'.lean'))==PREIMAGE
 latest=d.latest();required=set(closures[TARGET])-{TARGET};diffs={};pilot_receipts={}
 for n in pilots:
  oldc=gate['required_current_pilot_project_source_closures'][n];actual=closures[n];delta={k:{'before':oldc.get(k),'after':actual.get(k)} for k in set(oldc)|set(actual) if oldc.get(k)!=actual.get(k)}
  assert not delta or delta=={'SmallPairGraphClosure33Coverage':{'before':OLD,'after':NEW}},(n,delta)
  if delta:diffs[n]=delta
  assert n in accepted;row=latest.get((n,m.fingerprint(actual)));assert row and row['accepted_build'] and row['exit']==0 and not row['timed_out'] and not row['interrupted'] and row['closure_unchanged'] and row['shared_artifacts_unchanged'];pilot_receipts[n]=row;required.update(actual)
 for n in ['SmallPairGraphClosure17']+[f'SmallPairGraphClosure17Chunk{j:02d}' for j in range(6)]:assert n in accepted;required.update(closures[n])
 assert diffs and required<=accepted and external<=required
 for k,v in q.items():
  if k=='blocked_modules' or k.startswith('held_until_'):assert not set(v)&(required|set(names))
 artifacts={};evidence={};sources={}
 for n in sorted(required):
  fp=m.fingerprint(closures[n]);mf=d.expected_manifest(n,fp,latest);assert mf and d.artifacts(n)==mf,n;sources[n]=closures[n][n]
  evidence[n]={'fingerprint':fp,'artifacts':mf,'original_receipt':latest.get((n,fp)),'baseline_entry':None if (n,fp) in latest else d.baseline['accepted'][n]}
  for rel,h in mf.items():assert rel not in artifacts or artifacts[rel]==h;artifacts[rel]=h
 qb=d.queue_path.read_bytes();index=sha(R/'.git/index');static=dict(d.static);untouched={n:sha(C/(n+'.lean')) for n in ['SmallPairGraphData17','SmallPairGraphData35','SmallPairGraphData48']}
 def stable():
  assert git('rev-parse','HEAD')==BASE and sha(R/'.git/index')==index and d.queue_path.read_bytes()==qb and d.active_path.read_bytes()==ab
  assert sha(C/(TARGET+'.lean'))==PREIMAGE and all(not (C/(n+'.lean')).exists() for n in newnames)
  assert all(sha(C/(n+'.lean'))==h for n,h in sources.items()) and all(sha(p)==h for p,h in provenance.items())
  assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False)
 stable();rec=O/'installation';rec.mkdir();(O/'candidates').mkdir();(O/'originals').mkdir();put(rec/(TARGET+'.before.lean'),pre);put(rec/'QUEUE_BEFORE.json',qb);put(rec/'ACTIVE_BEFORE.json',ab)
 for n in names:put(O/'candidates'/(n+'.lean'),blobs[n]);put(O/'originals'/(n+'.lean'),originals[n])
 pins={n:dg(v) for n,v in blobs.items()};save(O/'PLAN.json',{'status':'REVIEWED_ROW12_RESTORATION_NOT_BUILT','base_commit':BASE,'source_manifest':pins,'build_order':names,'original_public_declarations':28,'original_public_headers':public,'prefix_parts':parts,'complete_rows':720,'model':[0,1],'original_endpoint_sha256':PREIMAGE,'immutable_provenance':provenance,'pilot_provenance_delta':diffs,'root_integration':False})
 save(rec/'GUARDS_BEFORE.json',{'head':BASE,'index_sha256':index,'source_sha256':sources,'compiled_artifacts':artifacts,'configuration':static,'pilot_receipts':pilot_receipts,'target_original_closure':closures[TARGET],'untouched_rows':untouched});save(rec/'ACCEPTED_INPUT_EVIDENCE.json',evidence)
 stable()
 for n in newnames:put(C/(n+'.lean'),blobs[n])
 tmp=C/(TARGET+'.partition.tmp');assert not tmp.exists();put(tmp,blobs[TARGET]);assert sha(C/(TARGET+'.lean'))==PREIMAGE;os.replace(tmp,C/(TARGET+'.lean'))
 after=json.loads(qb);after['names']+=newnames;assert {k:v for k,v in q.items() if k!='names'}=={k:v for k,v in after.items() if k!='names'};m.atomic_json(d.queue_path,after)
 assert all(sha(C/(n+'.lean'))==h for n,h in pins.items()) and all(sha(C/(n+'.lean'))==h for n,h in sources.items()) and all(sha(C/(n+'.lean'))==h for n,h in untouched.items())
 assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False) and d.active_path.read_bytes()==ab and sha(R/'.git/index')==index and git('rev-parse','HEAD')==BASE
 save(rec/'QUEUE_AFTER.json',after);result={'status':'INSTALLED_ROW12_ONLY_UNCOMPILED_EXACT_RESTORATION','utc':datetime.now(timezone.utc).isoformat(),'new_modules':newnames,'replaced_module':TARGET,'all28_original_public_headers_and_data_preserved':True,'complete_closure_rows':720,'pilot_count':30,'both_locks_held':True,'other_rows_unchanged':True,'queue_settings_unchanged':True,'compiler_started':False,'main_theorem_complete':False};save(rec/'APPLICATION_RECEIPT.json',result)
 wrapper=(R/'research/continuations/20261021-pro-graph12-partitions/bounded_build.py').read_text();wrapper,count=re.subn(r'^PINS = .*$', 'PINS = '+repr(pins),wrapper,flags=re.M);assert count==1;ast.parse(wrapper);put(O/'bounded_build.py',wrapper)
 print(json.dumps(result),flush=True)
