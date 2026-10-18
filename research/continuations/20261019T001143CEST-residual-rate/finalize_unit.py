"""Record only already completed guarded proof checks. No Git mutations."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, shutil, sys
r=Path('/Users/tp/Lean/D1Bound5')
w=r/'research/continuations/20261018T010800CEST-main-continuation'
o=Path(__file__).resolve().parent
ts=['BennettTwoResidualRate','BennettRootTransfer','FullRingOrdinaryHeight']
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
spec=importlib.util.spec_from_file_location('d1_final_rate',w/'continuation_driver_capacity.py')
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (w/'continuation-driver.lock').open('a+') as ow,(w/'continuation-intake.lock').open('a+') as it:
 fcntl.flock(ow,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(it,fcntl.LOCK_EX|fcntl.LOCK_NB)
 d=m.Driver(r,w);active=json.loads(d.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
 q,names,closures,accepted,unknown,eligible=d.snapshot();assert not unknown and q['max_parallel']==1 and all(t in accepted for t in ts)
 cr=json.loads((o/'TARGETED_REPLAY_RECEIPTS.json').read_text());assert len(cr)==4 and all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in cr)
 assert not json.loads((o/'active-targeted-replay.json').read_text())['active']
 text=(o/'residual-rate-type-axioms.log').read_text();assert text.count('RESIDUAL_RATE_AXIOMS_PASS')==11
 guards=json.loads((o/'TARGETED_REPLAY_GUARDS.json').read_text());assert all(sha(r/'D1Bound5'/f'{n}.lean')==h for n,h in guards['project_sources'].items())
 assert d.manifest_matches(guards['compiled_artifacts']) and d.manifest_matches(guards['immutable_inputs'])
 builds={}
 for n in ts:
  v=json.loads((o/(n+'-BUILD_RECEIPT.json')).read_text());assert v['accepted_build'] and v['source_sha256']==sha(r/'D1Bound5'/f'{n}.lean')
  assert (o/(n+'.lean')).read_bytes()==(r/'D1Bound5'/f'{n}.lean').read_bytes()
  builds[n]={k:v[k] for k in ['source_sha256','fingerprint','exit','seconds','closure_unchanged','shared_artifacts_unchanged']}
  (o/(n+'-SOURCE_CLOSURE.json')).write_text(json.dumps(closures[n],indent=2)+'\n')
 now=datetime.now().astimezone().isoformat()
 summary={'time':now,'outcome':'COMPLETED_UNIT','newly_verified_modules':ts,'newly_verified_public_theorems':9,'definitions':2,'builds':builds,'checks':cr,'source_closure_count':len(guards['project_sources']),'allowed_axioms':['propext','Classical.choice','Quot.sound'],'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False}
 (o/'VERIFICATION_SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n')
 nxt={}
 for t in ['UnitPairFirstExtensionBound','UnitPairCubic','UnitPairCubicIteration','UnitPairCubicNumeric','MainTheorem']:
  if t not in closures:continue
  missing=[n for n in closures[t] if n!=t and n not in accepted]
  nxt[t]={'accepted_current_build':t in accepted,'eligible':t in eligible,'missing_count':len(missing),'unaccepted_dependencies':missing,'ready_prerequisites':[n for n in missing if n in eligible]}
 (o/'NEXT_DEPENDENCIES.json').write_text(json.dumps({'time':now,'unknown':unknown,'targets':nxt},indent=2)+'\n')
 msg='Three working modules now prove the exact half-rate residual, the full-ring two-anchor inequality for every positive integer order, and the ordinary height envelope for an actual ordered D(1)-quadruple. The terminal root nonzero, signed integral approximations, nonzero integral row, and all coefficient/residual estimates are derived internally. The parameterized height envelope retains its explicit logarithmic h,r,u premises. Nine original theorems and two definitions passed pinned builds, exact type/transitive-axiom checks and three targeted installed SAME-kernel replays; only propext, Classical.choice and Quot.sound. No root integration, final finite exclusion, independent final review, whole-root clean checkout or MainStatement proof. Evidence: research/continuations/20261019T001143CEST-residual-rate/VERIFICATION_SUMMARY.json.'
 title='## 19 October 2026 — full-ring all-positive-order Bennett inequality verified'
 for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
  path=r/name;old=path.read_text();assert title not in old
  addition=title+'\n\n'+msg+'\n'
  if name in ['STATUS.md','records/open-obligations.md']:
   head,tail=old.split('\n',1);path.write_text(head+'\n\n'+addition+'\n'+tail.lstrip('\n'))
  else:path.write_text(old.rstrip()+'\n\n'+addition)
 (o/'README.md').write_text('# Separately verified residual-rate and full-ring unit\n\n'+msg+'\n\nCanonical working sources are D1Bound5/{module}.lean. The matching copies here preserve this reviewed unit; they are not duplicate accepted imports. Failed attempts remain explicitly named. Earlier completed BennettTwoResidualBound is reused, not counted again. Publication requires subsequent separate reviewed Git calls.\n')
 (r/'records/runs/20261019T001143CEST-residual-rate-FINISH.md').write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+msg+'\n\nAll owned compiler/checker results are collected; queue paused between jobs and both locks release on exit. Inherited staged receipt preserved. Next inspect UnitPairCubicNumeric and the remaining dependencies of UnitPairFirstExtensionBound. The preceding completed but unpublished BennettTwoResidualBound unit is reviewed for preservation, not counted as new mathematics. Git publication is not claimed by this pre-commit record.\n')
 print('UNIT_VERIFIED',now,'9 theorems; 2 definitions;',len(guards['project_sources']),'project modules')
 print('NEXT',json.dumps({k:{'eligible':v['eligible'],'missing_count':v['missing_count'],'ready_prerequisites':v['ready_prerequisites'][:12]} for k,v in nxt.items()}))
