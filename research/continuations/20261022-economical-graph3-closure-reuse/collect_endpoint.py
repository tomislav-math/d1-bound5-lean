"""Collect graph3 evidence and current endpoints using the guarded driver's existing acceptance semantics.
No compiler, kernel replay, Git mutation, root-manifest update, or scheduler action.
Evidence is written only after all current scope/source/artifact checks pass.
"""
from pathlib import Path
from datetime import datetime,timezone
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';W=C/'20261018T010800CEST-main-continuation';O=C/'20261022-economical-graph3-assembly'
BASE=C/'20261022-economical-graph43-assembly/CURRENT_ENDPOINT_INVENTORY.json'
BASE_SHA='2ecc11303a32aa96af21adfc537cadc66c64f99a8ae3b36c855780b3d2ddbce1'
SCOPES={'left-pilot12-v2': 4, 'left000': 10, 'left001': 10, 'left002': 6, 'right-pilot12-v2': 5, 'right000': 10, 'right001': 10, 'right002': 6, 'parent-integration': 9, 'closure-pilot': 4, 'closure-rest001': 4, 'closure-rest002-v2': 8, 'closure-rest003': 5, 'assembly': 7}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):return json.loads(Path(p).read_text())
def merge(dest,src):
 for n,h in src.items():
  assert n not in dest or dest[n]==h,n
  dest[n]=h
p=W/'continuation_driver_capacity.py';assert sha(p)=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('graph3_endpoint_driver',p);m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m);d=m.Driver(R,W)
with (W/'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 with d.locked():
  active=load(d.active_path);assert not active.get('active') and not active.get('protected_closure')
  assert not any(Path(s.strip()).name in ('lean','lake','leanchecker') for s in subprocess.check_output(['ps','-axo','comm='],text=True).splitlines())
  assert sha(BASE)==BASE_SHA;baseline=load(BASE);previous=baseline['current_accepted_endpoints'];assert len(previous)==31 and baseline['total_endpoints']==48 and 3 not in previous
  assert load(O/'VERIFICATION_SUMMARY.json')['graph3_endpoint_complete'] is True
  scope_records={};verified_sources={};verified_artifacts={};replayed=set();audit_count=0;kernel_count=0
  for short,expected_replays in SCOPES.items():
   folder=C/('20261022-economical-graph3-'+short);summary=load(folder/'VERIFICATION_SUMMARY.json');audits=load(folder/'AUDIT_RESULTS.json')
   assert summary['status']=='SCOPED_VERIFICATION_PASS' and summary['type_axiom_audit_exit']==0 and summary['targeted_kernel_replays']==expected_replays
   assert all(row['exit']==0 and not row['timed_out'] for row in audits)
   kernels=[row for row in audits if 'leanchecker' in row['command']];types=[row for row in audits if 'lean' in row['command'] and 'leanchecker' not in row['command']]
   assert len(kernels)==expected_replays and types
   checked=[row['command'][-1].removeprefix('D1Bound5.') for row in kernels];assert len(checked)==len(set(checked)) and set(checked)<=set(summary['source_closure'])
   missing=set(summary['targets'])-set(checked)
   expected_missing=({'SmallPairLightData3','SmallPairLightAdaptiveData3'} if short=='parent-integration' else {'SmallPairRawSelectedData3','SmallPairGraphData3'} if short=='assembly' else {'SmallPairLightData3Right'} if short=='right-pilot12-v2' else set())
   assert missing==expected_missing
   for n in missing:
    text=(R/'D1Bound5'/(n+'.lean')).read_text();assert not re.search(r'^theorem ',text,re.M)
    assert len(re.findall(r'^def ',text,re.M))==(16 if n=='SmallPairLightAdaptiveData3' else 0)
   assert all(Path(row['command'][-1]).parent==folder for row in types)
   assert not load(folder/'OWNER.json')['active'] and d.manifest_matches(summary['configuration'])
   assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in summary['source_closure'].items())
   assert all(d.artifacts(n)==a for n,a in summary['artifacts'].items())
   assert all(sha(R/n)==h for n,h in summary.get('reference_files',{}).items())
   pub=folder/'PUBLICATION_HASHES.json'
   if pub.exists():
    own_prefix=str(folder.relative_to(R))+'/'
    assert all(sha(R/n)==h for n,h in load(pub).items() if n.startswith(own_prefix))
   merge(verified_sources,summary['source_closure'])
   for n,a in summary['artifacts'].items():merge(verified_artifacts,a)
   replayed.update(row['command'][-1].removeprefix('D1Bound5.') for row in kernels)
   audit_count+=len(types);kernel_count+=len(kernels)
   scope_records[short]={'summary_sha256':sha(folder/'VERIFICATION_SUMMARY.json'),'audit_results_sha256':sha(folder/'AUDIT_RESULTS.json'),'audit_input_sha256':{row['command'][-1]:sha(row['command'][-1]) for row in types},'targeted_kernel_replays':len(kernels),'targets':summary['targets'],'no_separate_kernel_replay_modules':{n:{'definitions':16 if n=='SmallPairLightAdaptiveData3' else 0,'theorems':0,'basis':'guarded typechecked aliases; no separate new replay claimed' if n=='SmallPairLightAdaptiveData3' else 'import facade without declarations'} for n in sorted(missing)}}
  latest=d.latest();closure=d.closure('SmallPairGraphData3');assert set(closure)<=set(verified_sources)
  q=load(d.queue_path);assert q['max_parallel']==1 and q['pause_after_current'] is True
  current=[];evidence={};all_sources={};all_artifacts={}
  for number in range(1,49):
   name='SmallPairGraphData'+str(number);c=d.closure(name);key=m.fingerprint(c);expected=d.expected_manifest(name,key,latest)
   if expected and d.artifacts(name)==expected:
    current.append(number);merge(all_sources,c);merge(all_artifacts,expected)
    evidence[str(number)]={'module':name,'source_closure':c,'build_fingerprint':key,'accepted_artifacts':expected,'basis':'current_guarded_driver_acceptance; graph3 additionally binds all scoped audits/replays'}
  assert current==sorted(set(previous)|{3});assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in all_sources.items())
  assert d.manifest_matches(all_artifacts) and d.manifest_matches(verified_artifacts)
  state={'schema':1,'collector_sha256':sha(Path(__file__)),'configuration':d.static,'status':'GRAPH3_CURRENT_SCOPES_AND_ENDPOINT_VERIFIED','scope_records':scope_records,'scope_count':len(SCOPES),'exact_type_axiom_commands':audit_count,'targeted_kernel_replays':kernel_count,'unique_replayed_modules':sorted(replayed),'verified_sources':verified_sources,'verified_artifacts':verified_artifacts,'endpoint_source_closure':closure,'baseline_inventory_sha256':BASE_SHA,'main_theorem_complete':False,'root_integration':False}
  encoded=json.dumps(state,indent=2,sort_keys=True)+'\n';sp=O/'ENDPOINT_PROOF_STATE.json'
  if sp.exists():assert sp.read_text()==encoded
  else:sp.write_text(encoded)
  result={'schema':1,'status':'CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH3_PASS','utc':datetime.now(timezone.utc).isoformat(),'previous_accepted_endpoints':previous,'previous_accepted_endpoint_count':31,'current_accepted_endpoints':current,'accepted_endpoint_count':len(current),'remaining_endpoints':sorted(set(range(1,49))-set(current)),'remaining_endpoint_count':48-len(current),'total_endpoints':48,'added_endpoints':[3],'removed_endpoints':[],'expected_transition_matches':True,'graph3_endpoint_proof_state_sha256':sha(sp),'current_endpoint_evidence':evidence,'main_theorem_complete':False,'root_integration':False}
  dest=O/'CURRENT_ENDPOINT_INVENTORY.json'
  if dest.exists():
   prior=load(dest);assert {k:v for k,v in prior.items() if k!='utc'}=={k:v for k,v in result.items() if k!='utc'}
  else:dest.write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
  print(json.dumps({'status':result['status'],'accepted_endpoint_count':len(current),'total_endpoints':48,'remaining_endpoint_count':48-len(current),'scope_count':len(SCOPES),'targeted_kernel_replays':kernel_count,'main_theorem_complete':False}))
