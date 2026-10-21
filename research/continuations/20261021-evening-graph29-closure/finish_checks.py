"""Record only completed exact scoped checks, with current source and artifact equality."""
from pathlib import Path
from datetime import datetime,timezone
import fcntl,hashlib,importlib.util,json,sys
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation';U=R/'research/continuations/20261020T100000CEST-work-resume';O=Path(__file__).resolve().parent
scope=sys.argv[1];A=U/('pro-graph29-'+scope+'-audit')
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,v):Path(p).write_text(json.dumps(v,indent=2,sort_keys=True)+'\n')
with (W/'continuation-driver.lock').open('r+') as owner,(W/'continuation-intake.lock').open('r+') as intake:
 for f in (owner,intake):fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert not read(W/'continuation-active.json').get('active') and not read(A/'active-targeted-replay.json')['active']
 summary=read(O/(scope+'-PREPARATION.json'));targets=summary['targets'];receipts=read(A/'TARGETED_REPLAY_RECEIPTS.json')
 assert read(A/'BOUND_AUDIT_FINAL.json')['status']=='BOUND_SCOPED_AUDIT_PASS'
 assert [x['label'] for x in receipts]==['analytic-type-axioms']+[n+'-targeted-replay' for n in targets]
 assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] and not x['binding_drift_paths'] for x in receipts)
 log=(A/'analytic-type-axioms.log').read_text();assert log.count('GRAPH29_CLOSURE_AXIOMS_PASS ')==summary['declarations']
 spec=importlib.util.spec_from_file_location('row29_finish_driver',W/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod);d=mod.Driver(R,W)
 sm=read(O/(scope+'-SOURCE_MAP.json'));ev=read(O/(scope+'-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
 for n,item in sm['sources'].items():
  assert sha(R/item['path'])==item['sha256'];assert mod.fingerprint(d.closure(n))==ev[n]['fingerprint'];assert d.artifacts(n)==ev[n]['artifacts']
  if n in targets:item['assurance']='guarded_build_exact_public_type_transitive_axioms_targeted_same_kernel_replay'
 assert d.manifest_matches(read(O/'CONFIGURATION.json'))
 state={'sources':[[n,x['sha256']] for n,x in sorted(sm['sources'].items())],'configuration':d.static,'build_fingerprints':{n:ev[n]['fingerprint'] for n in targets},'artifact_fingerprints':{n:ev[n]['artifacts'] for n in targets},'audit_harness_sha256':sha(A/'AnalyticAudit.lean'),'accepted_checks':[{'label':x['label'],'exit':x['exit'],'guards_unchanged':x['guards_unchanged']} for x in receipts]}
 fp=hashlib.sha256(json.dumps(state,sort_keys=True,separators=(',',':')).encode()).hexdigest()
 write(O/(scope+'-SOURCE_MAP.json'),sm);write(O/(scope+'-PROOF_STATE.json'),state)
 summary.update(status='SCOPED_VERIFICATION_PASS',utc=datetime.now(timezone.utc).isoformat(),guarded_builds=len(targets),targeted_same_kernel_replays=len(targets),proof_fingerprint=fp,whole_graph29_complete=False,publication='PREPARED_NOT_YET_PUSHED')
 write(O/(scope+'-VERIFICATION_SUMMARY.json'),summary)
 print(json.dumps(summary))
