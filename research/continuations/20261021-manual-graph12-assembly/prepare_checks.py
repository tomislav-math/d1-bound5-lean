"""Bind an explicit accepted row12 proof unit to original types and source provenance."""
from pathlib import Path
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation';U=R/'research/continuations/20261020T100000CEST-work-resume';O=Path(__file__).resolve().parent
scope=sys.argv[1];assert re.fullmatch(r'[a-z0-9-]+',scope);targets= json.loads((O/(scope+'-TARGETS.json')).read_text());A=U/('pro-graph12-'+scope+'-audit')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):return json.loads(Path(p).read_text())
def put(p,v):
 with Path(p).open('x') as f:f.write(json.dumps(v,indent=2,sort_keys=True)+'\n')
def declarations(text):
 result=[]
 for m in re.finditer(r'^(def|theorem)\s+(\S+)\s*(.*?)\s*:=',text,re.M|re.S):
  stack=[];opens=[]
  for line in text[:m.start()].splitlines():
   if line.startswith('namespace '):stack.append(line[10:].strip())
   elif line.startswith('end '):assert stack;stack.pop()
   elif line.startswith('open '):opens.append(line)
  ns='.'.join(stack);assert ns.startswith('D1Bound5')
  result.append({'kind':m[1],'local_name':m[2],'name':ns+'.'+m[2],'namespace':ns,'opens':list(dict.fromkeys(opens)),'header':m[3].strip()})
 return result
assert sha(W/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
assert sha(U/'bound_scoped_audit_runner_proposal_v1.py')=='efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
with (W/'continuation-driver.lock').open('r+') as owner,(W/'continuation-intake.lock').open('r+') as intake:
 for f in (owner,intake):fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert not load(W/'continuation-active.json').get('active')
 assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=R)
 base=subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()
 spec=importlib.util.spec_from_file_location('row12_prepare_driver',W/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod);d=mod.Driver(R,W);latest=d.latest()
 plan=load(O/'PLAN.json');assert set(targets)<=set(plan['source_manifest']);assert not A.exists();A.mkdir()
 all_decls=[];smap={};rmap={};original_records=[];union={};builds={}
 for n in targets:
  src=R/'D1Bound5'/(n+'.lean');h=sha(src);assert h==plan['source_manifest'][n]
  row=load(O/(n+'-BUILD_RECEIPT.json'));c=load(O/(n+'-SOURCE_CLOSURE.json'))
  assert row['accepted_build'] and row['exit']==0 and not row['timed_out'] and not row['interrupted'] and row['closure_unchanged'] and row['shared_artifacts_unchanged']
  assert row['source_sha256']==h and d.closure(n)==c and mod.fingerprint(c)==row['fingerprint'] and d.artifacts(n)==row['artifacts']
  assert (O/(n+'.lean')).read_bytes()==src.read_bytes()
  for key,value in c.items():assert key not in union or union[key]==value;union[key]=value
  old=O/'originals'/(n+'.lean');od=declarations(old.read_text());nd=declarations(src.read_text())
  assert [(x['name'],x['kind'],x['header']) for x in od]==[(x['name'],x['kind'],x['header']) for x in nd],n
  (A/(n+'.lean')).write_bytes(src.read_bytes());smap[n]={'source':str(src.relative_to(R)),'snapshot':str((A/(n+'.lean')).relative_to(R)),'sha256':h}
  rmap[n]={'receipt':str((O/(n+'-BUILD_RECEIPT.json')).relative_to(R)),'closure':str((O/(n+'-SOURCE_CLOSURE.json')).relative_to(R))}
  original_records.append({'module':n,'original_path':str(old),'original_source_path':str(old),'original_sha256':sha(old),'current_sha256':h,'normalizations':[],'declarations':od})
  all_decls+=od;builds[n]=row
 names=[x['name'] for x in all_decls];assert len(names)==len(set(names))
 harness=''.join('import D1Bound5.'+n+'\n' for n in targets)+'import Lean.Elab.Command\nimport Lean.Util.CollectAxioms\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'
 harness+='run_cmd do\n  let names : List Lean.Name := [\n    '+',\n    '.join('`'+n for n in names)+']\n  for name in names do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do\n      Lean.throwError "Unexpected axioms in {name}: {bad}"\n    Lean.logInfo m!"GRAPH12_CLOSURE_AXIOMS_PASS {name}: {ax}"\n\n'
 for x in all_decls:
  harness+='namespace '+x['namespace']+'\n'+'\n'.join(x['opens'])+'\nexample\n'+x['header']+' :=\n  _root_.'+x['name']+'\nend '+x['namespace']+'\n\n'
 harness+=''.join('#check @_root_.'+n+'\n' for n in names)
 examples=re.findall(r'^example\s*(.*?)\s*:=',harness,re.M|re.S);assert examples==[x['header'] for x in all_decls]
 (A/'AnalyticAudit.lean').write_text(harness)
 for name,v in [('TARGETS.json',targets),('REPLAY_TARGETS.json',targets),('SOURCE_MAP.json',smap),('BUILD_RECEIPT_MAP.json',rmap),('SCOPED_ORIGINAL_DECLARATIONS.json',original_records),('DECLARATION_NAMES.json',names)]:put(A/name,v)
 oldmap={}
 for rel in ['20261020-completed-checkpoint','20261021-pro-graph33','20261021-pro-one-small','20261021-pro-graph17-left000','20261021-pro-graph17-left-complete','20261021-pro-graph17-right-complete']:
  for n,item in load(R/'research/continuations'/rel/'SOURCE_MAP.json')['sources'].items():oldmap[(n,item['sha256'])]=item
 for n,item in load(R/'research/continuations/20261021-pro-graph12-sides/foundation-SOURCE_MAP.json')['sources'].items():oldmap[(n,item['sha256'])]=item
 for prior_scope in ['left','right']:
  for n,item in load(R/'research/continuations/20261021-pro-graph12-partitions'/(prior_scope+'-SOURCE_MAP.json'))['sources'].items():oldmap[(n,item['sha256'])]=item
 for n,item in load(R/'research/continuations/20261021-pro-graph12-closure-half-pilot/first-block-SOURCE_MAP.json')['sources'].items():oldmap[(n,item['sha256'])]=item
 for n,item in load(R/'research/continuations/20261021-pro-graph12-closure-rest/closure-rest-SOURCE_MAP.json')['sources'].items():oldmap[(n,item['sha256'])]=item
 source_map={};evidence={}
 for n,h in sorted(union.items()):
  c=d.closure(n);key=mod.fingerprint(c);mf=d.expected_manifest(n,key,latest);assert mf and d.artifacts(n)==mf,n
  if n in plan['source_manifest']:
   assert sha(O/'candidates'/(n+'.lean'))==h
   source_map[n]={'path':'D1Bound5/'+n+'.lean','sha256':h,'payload_path':str((O/'candidates'/(n+'.lean')).relative_to(R)),'assurance':'guarded_build_pass_current_audit_pending'}
  else:
   item=oldmap[(n,h)];commit,path=(base,item['payload_path']) if 'payload_path' in item else (item['base_commit'],item['base_path'])
   blob=subprocess.check_output(['git','show',commit+':'+path],cwd=R,timeout=15);assert hashlib.sha256(blob).hexdigest()==h
   source_map[n]={'path':'D1Bound5/'+n+'.lean','sha256':h,'base_commit':commit,'base_path':path,'assurance':'reused_accepted_source_and_artifacts'}
  evidence[n]={'fingerprint':key,'artifacts':mf,'original_receipt':latest.get((n,key)),'baseline_entry':None if (n,key) in latest else d.baseline['accepted'][n]}
 put(O/(scope+'-SOURCE_MAP.json'),{'base_commit':base,'sources':source_map})
 put(O/(scope+'-ACCEPTED_DEPENDENCY_EVIDENCE.json'),evidence)
 put(O/(scope+'-PREPARATION.json'),{'targets':targets,'declarations':len(names),'theorems':sum(x['kind']=='theorem' for x in all_decls),'definitions':sum(x['kind']=='def' for x in all_decls),'source_closure_modules':len(union),'audit':str(A.relative_to(R)),'public_headers_exact':True,'base_commit':base,'root_integration':False,'main_theorem_complete':False})
 print(json.dumps({'status':'ACCEPTED_UNIT_PREPARED_FOR_AUDIT','targets':targets,'declarations':len(names),'source_closure':len(union),'audit':str(A)}))
