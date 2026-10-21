"""Install only row35 exact archived components and reviewed complete-tail closure parts.
No compiler, Git mutation, timeout change, hold release, or change to rows17/48.
"""
from pathlib import Path
from datetime import datetime,timezone
import fcntl,hashlib,importlib.util,json,os,re,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation'
U=R/'research/continuations/20261020T100000CEST-work-resume';O=Path(__file__).resolve().parent
P=U/'graph-data17_35_48-integrated-prefix-proposal';BASE='8489909dbf3a492370e470bef243edabb1abe5ab'
DRIVER='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
OLD='bbdf849a2fe20ad1c1dbc31b97a11b26d2a85585f3aba995282c64d92bc21f7f';NEW='bd10abcbcb8b3652c7cc692c2786f2dda353af12b14c140bba660a499605c4f0'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dg(b):return hashlib.sha256(b).hexdigest()
def load(p):return json.loads(Path(p).read_text())
def put(p,b):
 if isinstance(b,str):b=b.encode()
 with Path(p).open('xb') as f:f.write(b);f.flush();os.fsync(f.fileno())
def save(p,x):put(p,json.dumps(x,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git',*a],cwd=R,text=True,timeout=30).strip()
def body(s):return re.sub(r'^import [^\n]*(?:\n|$)','',s,flags=re.M).strip()
def headers(s):return [s[m.start():s.index(':=',m.start())] for m in re.finditer(r'^(?:def|theorem|lemma|abbrev|structure) ',s,re.M)]
def imports(s):return re.findall(r'^import D1Bound5\.(\w+)\s*$',s,re.M)
assert sha(P/'PLAN.json')=='6a1a8d225e4a7872244f8815ea26cb01b74eb57719cf0f1d26f225031dd8a2c6'
assert sha(W/'continuation_driver_capacity.py')==DRIVER
plan=load(P/'PLAN.json');row=next(item for item in plan['parents'] if item['row']==35);target=row['module'];names=row['build_order'];assert row['row']==35 and target=='SmallPairGraphData35'
blobs={n:(P/(n+'.lean')).read_bytes() for n in names}
assert all(dg(b)==plan['source_manifest'][n] for n,b in blobs.items())
pre=(P/(target+'.before.lean')).read_bytes();assert dg(pre)==row['preimage_sha256']
marks=list(re.finditer(r'^/- Preserved body from D1Bound5\.(\w+); original SHA256 ([0-9a-f]{64})\. -/\n',pre.decode(),re.M))
assert len(marks)==8 and body(pre.decode()[:marks[0].start()])==''
originals={};public=[];provenance={str(P/'PLAN.json'):sha(P/'PLAN.json')}
for i,(m,c) in enumerate(zip(marks,row['original_components'])):
 n=c['module'];a=Path(c['archive_path']);ab=a.read_bytes();s=ab.decode();end=marks[i+1].start() if i+1<len(marks) else len(pre.decode())
 assert n==m[1] and dg(ab)==m[2]==c['archive_sha256']
 assert body(s)==pre.decode()[m.end():end].strip() and dg(body(s).encode())==c['archive_body_sha256']
 assert imports(s)==c['archive_imports'];originals[n]=ab;public+=headers(s);provenance[str(a)]=dg(ab)
 if c['closure_first_proof_replaced']:
  assert n=='SmallPairGraphClosure35';ns=blobs[n].decode();a1=list(re.finditer(r'^theorem ',s,re.M));a2=list(re.finditer(r'^theorem ',ns,re.M))
  assert len(a1)==len(a2)==2 and headers(s)==headers(ns)
  assert body(s[:a1[0].start()])==body(ns[:a2[0].start()]) and s[a1[1].start():]==ns[a2[1].start():]
 else:assert ab==blobs[n]
assert public==row['original_public_headers']==headers(pre.decode()) and len(public)==28
assert [j for p in row['prefix_parts'] for j in range(p['offset'],p['offset']+p['count'])]==list(range(739))
# Reuse the accepted structural projection proof, with only row/model substitutions.
cov33=R/'D1Bound5/SmallPairGraphClosure33Coverage.lean';assert sha(cov33)==NEW
cov35=cov33.read_text().replace('33','35').encode()
assert headers(cov35.decode())==headers(blobs['SmallPairGraphClosure35Coverage'].decode())
assert 'List.zipWith' in (P/'SmallPairGraphWitnessData35.lean').read_text()
originals['SmallPairGraphClosure35Coverage']=blobs['SmallPairGraphClosure35Coverage'];blobs['SmallPairGraphClosure35Coverage']=cov35
for n in names:
 s=blobs[n].decode();assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s)
seen=set();external=set()
for n in names:
 deps=set(imports(blobs[n].decode()));assert deps&set(names)<=seen;external|=deps-set(names);seen.add(n)
assert external==set(row['proposed_external_imports'])
for n in names:originals.setdefault(n,(P/(n+'.lean')).read_bytes())
# Bind the one known changed pilot to actual accepted build and audit records.
cov_receipt_path=R/'research/continuations/20261021-pro-graph33/coverage-projection/SmallPairGraphClosure33Coverage-BUILD_RECEIPT.json'
cov_receipt=load(cov_receipt_path);assert cov_receipt['source_sha256']==NEW and cov_receipt['accepted_build'] and cov_receipt['exit']==0
ap=U/'pro-graph33-audit/BOUND_AUDIT_FINAL.json';audit=load(ap)
assert audit['status']=='BOUND_SCOPED_AUDIT_PASS' and all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in audit['records'])
assert any(x['label']=='SmallPairGraphClosure33Coverage-targeted-replay' for x in audit['records'])
provenance.update({str(cov33):NEW,str(cov_receipt_path):sha(cov_receipt_path),str(ap):sha(ap)})
oldgate=plan['runtime_pilot_gate'];pilots=oldgate['all_required_current_pilot_targets'];assert len(pilots)==30
spec=importlib.util.spec_from_file_location('row35_install_driver',W/'continuation_driver_capacity.py');dmod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=dmod;spec.loader.exec_module(dmod)
with (W/'continuation-driver.lock').open('r+') as owner,(W/'continuation-intake.lock').open('r+') as intake:
 for f in [owner,intake]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('rev-parse','HEAD')==BASE and git('branch','--show-current')=='main' and not git('diff','--cached','--name-only')
 ps=subprocess.check_output(['ps','-axo','pid=,comm='],text=True)
 assert not any(Path(z[-1]).name in ('lean','lake','leanchecker') for l in ps.splitlines() if (z:=l.split()))
 d=dmod.Driver(R,W);active_bytes=d.active_path.read_bytes();active=load(d.active_path);assert not active.get('active') and not active.get('protected_closure')
 q,qn,closures,accepted,unknown,eligible=d.snapshot();assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
 assert target in qn and target not in accepted and all(not (R/'D1Bound5'/(n+'.lean')).exists() and n not in qn for n in row['new_names'])
 assert not any(target in closures[n] for n in accepted), 'Accepted consumer would change'
 assert closures[target]==row['original_project_source_closure'] and sha(R/'D1Bound5'/(target+'.lean'))==row['preimage_sha256']
 pilot_differences={};latest=d.latest();pilot_receipts={}
 required=set(closures[target])-{target}
 for n in pilots:
  oldc=oldgate['required_current_pilot_project_source_closures'][n];actual=closures[n]
  diffs={k:{'before':oldc.get(k),'after':actual.get(k)} for k in set(oldc)|set(actual) if oldc.get(k)!=actual.get(k)}
  assert not diffs or diffs=={'SmallPairGraphClosure33Coverage':{'before':OLD,'after':NEW}},(n,diffs)
  if diffs:pilot_differences[n]=diffs
  assert n in accepted;rec=latest.get((n,dmod.fingerprint(actual)));assert rec and rec['accepted_build'] and rec['exit']==0 and not rec['timed_out'] and not rec['interrupted'] and rec['closure_unchanged'] and rec['shared_artifacts_unchanged']
  pilot_receipts[n]=rec;required.update(actual)
 assert pilot_differences and required<=accepted
 for n in ['SmallPairGraphData33','SmallPairGraphData40']:assert n in accepted
 for k,v in q.items():
  if k=='blocked_modules' or k.startswith('held_until_'):assert not set(v)&(required|set(names))
 artifacts={};evidence={};sources={}
 for n in sorted(required):
  key=dmod.fingerprint(closures[n]);m=d.expected_manifest(n,key,latest);assert m and d.artifacts(n)==m,n
  sources[n]=closures[n][n];evidence[n]={'fingerprint':key,'artifacts':m,'original_receipt':latest.get((n,key)),'baseline_entry':None if (n,key) in latest else d.baseline['accepted'][n]}
  for path,h in m.items():assert path not in artifacts or artifacts[path]==h;artifacts[path]=h
 static=dict(d.static);queue_bytes=d.queue_path.read_bytes();index_sha=sha(R/'.git/index')
 untouched={n:sha(R/'D1Bound5'/(n+'.lean')) for n in ['SmallPairGraphData17','SmallPairGraphData48']}
 def stable():
  assert git('rev-parse','HEAD')==BASE and sha(R/'.git/index')==index_sha
  assert d.queue_path.read_bytes()==queue_bytes and d.active_path.read_bytes()==active_bytes
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
  assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False)
  assert all(sha(p)==h for p,h in provenance.items())
 stable();recdir=O/'installation';recdir.mkdir();(O/'candidates').mkdir();(O/'originals').mkdir()
 put(recdir/'SmallPairGraphData35.before.lean',pre);put(recdir/'QUEUE_BEFORE.json',queue_bytes);put(recdir/'ACTIVE_BEFORE.json',active_bytes)
 for n in names:put(O/'candidates'/(n+'.lean'),blobs[n]);put(O/'originals'/(n+'.lean'),originals[n])
 pins={n:dg(blobs[n]) for n in names}
 save(O/'PLAN.json',{'status':'REVIEWED_ROW35_ONLY_NOT_BUILT','base_commit':BASE,'source_manifest':pins,'build_order':names,'original_public_headers':public,'original_public_declarations':28,'prefix_parts':row['prefix_parts'],'complete_rows':739,'structural_coverage_sha256':pins['SmallPairGraphClosure35Coverage'],'original_plan_sha256':sha(P/'PLAN.json'),'pilot_provenance_delta':pilot_differences,'immutable_provenance':provenance})
 save(recdir/'GUARDS_BEFORE.json',{'head':BASE,'index_sha256':index_sha,'source_sha256':sources,'compiled_artifacts':artifacts,'configuration':static,'pilot_receipts':pilot_receipts,'target_original_closure':closures[target],'untouched_rows':untouched})
 save(recdir/'ACCEPTED_INPUT_EVIDENCE.json',evidence)
 stable()
 for n in row['new_names']:put(R/'D1Bound5'/(n+'.lean'),blobs[n])
 tmp=R/'D1Bound5/SmallPairGraphData35.partition.tmp';assert not tmp.exists();put(tmp,blobs[target]);assert sha(R/'D1Bound5'/(target+'.lean'))==row['preimage_sha256'];os.replace(tmp,R/'D1Bound5'/(target+'.lean'))
 after=json.loads(queue_bytes);after['names']+=row['new_names'];assert {k:v for k,v in after.items() if k!='names'}=={k:v for k,v in q.items() if k!='names'}
 dmod.atomic_json(d.queue_path,after)
 assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in pins.items())
 assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
 assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in untouched.items())
 assert d.manifest_matches(artifacts,cached=False) and d.manifest_matches(static,cached=False)
 assert d.active_path.read_bytes()==active_bytes and git('rev-parse','HEAD')==BASE and sha(R/'.git/index')==index_sha
 save(recdir/'QUEUE_AFTER.json',after)
 result={'status':'INSTALLED_UNCOMPILED_ROW35_EXACT_SPLIT','utc':datetime.now(timezone.utc).isoformat(),'new_modules':row['new_names'],'replaced_module':target,'other_rows_unchanged':True,'all_28_original_public_headers_and_data_preserved':True,'pilot_count':30,'pilot_delta_bound_to_accepted_receipts':True,'both_locks_held':True,'configuration_and_hold_settings_unchanged':True,'compiler_started':False,'root_integration':False}
 save(recdir/'APPLICATION_RECEIPT.json',result)
 wrapper=R/'research/continuations/20261021-pro-graph17-right-complete/bounded_build.py';assert sha(wrapper)=='3c62d9c27d3df9c7cad370d491169b3d99415debf3295bd1390a19448287ade3'
 s=wrapper.read_text();s,n=re.subn(r'^PINS = .*$', 'PINS = '+repr(pins),s,count=1,flags=re.M);assert n==1;put(O/'bounded_build.py',s)
 print(json.dumps(result),flush=True)
