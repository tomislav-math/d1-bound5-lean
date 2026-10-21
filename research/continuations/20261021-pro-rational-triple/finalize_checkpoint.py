"""Finish the RationalTripleExclusion checkpoint from genuine successful receipts."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl, hashlib, importlib.util, json, subprocess, sys

ROOT=Path('/Users/tp/Lean/D1Bound5')
WORK=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
RUN=ROOT/'research/continuations/20261020T100000CEST-work-resume'
OUT=Path(__file__).resolve().parent
AUDIT=RUN/'pro-rational-triple-audit'
BASE='387c7d884a4a70a9f9026303f6169c149f36cb39'
NAME='RationalTripleExclusion'
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,x):Path(p).write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def digest(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':')).encode()).hexdigest()
with (WORK/'continuation-driver.lock').open('r+') as owner,(WORK/'continuation-intake.lock').open('r+') as intake:
 for f in [owner,intake]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert not read(WORK/'continuation-active.json').get('active')
 assert not read(AUDIT/'active-targeted-replay.json')['active']
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()==BASE
 assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT)
 assert read(AUDIT/'BOUND_AUDIT_FINAL.json')['status']=='BOUND_SCOPED_AUDIT_PASS'
 checks=read(AUDIT/'TARGETED_REPLAY_RECEIPTS.json')
 assert [x['label'] for x in checks]==['analytic-type-axioms',NAME+'-targeted-replay']
 assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] and not x['binding_drift_paths'] for x in checks)
 assert (AUDIT/'analytic-type-axioms.log').read_text().count('RATIONAL_TRIPLE_AXIOMS_PASS ')==1
 spec=importlib.util.spec_from_file_location('rational_finish_driver',WORK/'continuation_driver_capacity.py')
 mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
 d=mod.Driver(ROOT,WORK);closure=d.closure(NAME);row=read(OUT/(NAME+'-BUILD_RECEIPT.json'))
 assert row['accepted_build'] and row['exit']==0 and not row['timed_out'] and not row['interrupted']
 assert row['closure_unchanged'] and row['shared_artifacts_unchanged']
 assert row['fingerprint']==mod.fingerprint(closure) and row['source_sha256']==closure[NAME]
 assert d.manifest_matches(read(OUT/'CONFIGURATION.json'))
 evidence=read(OUT/'ACCEPTED_DEPENDENCY_EVIDENCE.json');source_map=read(OUT/'SOURCE_MAP.json')
 assert set(closure)==set(evidence)==set(source_map['sources'])
 for n,h in closure.items():
  assert h==source_map['sources'][n]['sha256']==sha(ROOT/'D1Bound5'/(n+'.lean'))
  assert mod.fingerprint(d.closure(n))==evidence[n]['fingerprint']
  assert d.artifacts(n)==evidence[n]['artifacts']
 assert row['artifacts']==evidence[NAME]['artifacts']
 assert (OUT/(NAME+'.lean')).read_bytes()==(ROOT/'D1Bound5'/(NAME+'.lean')).read_bytes()
 source_map['sources'][NAME]['assurance']='guarded_build_exact_original_public_type_transitive_axioms_targeted_same_kernel_replay'
 save(OUT/'SOURCE_MAP.json',source_map)
 proof_state={'sorted_source_hashes':[[n,closure[n]] for n in sorted(closure)],'configuration_hashes':d.static,
  'accepted_build':{'source_closure':row['fingerprint'],'olean':row['artifacts']['.lake/build/lib/lean/D1Bound5/'+NAME+'.olean']},
  'accepted_audit':{'harness_sha256':sha(AUDIT/'AnalyticAudit.lean'),'exact_original_type':True,'transitive_axioms_checked':True,'targeted_same_kernel_replay_exit':0,'source_artifact_guards_unchanged':True}}
 save(OUT/'PROOF_STATE.json',proof_state)
 summary={'utc':datetime.now(timezone.utc).isoformat(),'module':NAME,'original_public_theorems':1,
  'build':{k:row[k] for k in ['exit','seconds','source_sha256','fingerprint']},
  'exact_type_transitive_axiom_checks':1,'targeted_installed_same_kernel_replays':1,
  'source_closure_modules':len(closure),'reused_dependency_modules':len(closure)-1,
  'independent_supplied_source_patch_review':True,'independent_imported_proof_review':False,
  'root_integration':False,'main_theorem_complete':False,'fresh_whole_root_replay':False,
  'starting_head':BASE,'publication':'PREPARED_NOT_YET_COMMITTED_OR_PUSHED','substantive_fingerprint':digest(proof_state)}
 save(OUT/'VERIFICATION_SUMMARY.json',summary)
 (OUT/'README.md').write_text('# Rational triple exclusion verified working checkpoint\n\n'
  'The original theorem excludes a modulus-ordered full-ring D(1)-sextuple\n'
  'whose first three entries are simultaneously signed 1, 3 and 8, in any\n'
  'totally complex number field of degree two. Its original hypotheses and\n'
  'statement are unchanged. The proof uses the existing analytic cutoff and\n'
  'the strict fourth-entry growth bound greater than 48.\n\n'
  'The repair changes exactly two proof commands, exposing the ring-of-integers\n'
  'coercion and ring-homomorphism images of the numerals 3 and 8.\n'
  'The previous exit-1 attempt is preserved separately and is not accepted.\n\n'
  'One guarded pinned build, the exact original public-type/transitive-axiom\n'
  'audit, and one targeted installed SAME-kernel replay passed. The supplied\n'
  'source patch also received a separate independent review; that review did\n'
  'not independently inspect imported proofs or recompute file hashes.\n\n'
  'SOURCE_MAP.json reconstructs the full 329-module accepted source closure\n'
  'from one new payload and 328 exact prior Git references. Compiled proof\n'
  'objects are not uploaded. Audit records are in\n'
  '../20261020T100000CEST-work-resume/pro-rational-triple-audit/.\n\n'
  'This is a verified working dependency. Canonical root integration,\n'
  'MainTheorem, OneSmallImpossible and final whole-project gates remain open.\n'
  'Publication is established separately by the post-push receipt and handoff.\n')
 print(json.dumps({'status':'RATIONAL_CHECKPOINT_VERIFIED','module':NAME,'source_closure':len(closure),'fingerprint':digest(proof_state),'main_theorem_complete':False}))
