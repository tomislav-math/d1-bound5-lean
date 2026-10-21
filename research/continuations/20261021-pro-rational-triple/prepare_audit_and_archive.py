"""Archive one exact accepted source closure and prepare its original-statement audit."""
from pathlib import Path
import fcntl, hashlib, importlib.util, json, re, subprocess, sys

ROOT=Path('/Users/tp/Lean/D1Bound5')
WORK=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
RUN=ROOT/'research/continuations/20261020T100000CEST-work-resume'
OUT=Path(__file__).resolve().parent
AUDIT=RUN/'pro-rational-triple-audit'
BASE='387c7d884a4a70a9f9026303f6169c149f36cb39'
NAME='RationalTripleExclusion'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def put(p,v):
 with Path(p).open('x') as f:f.write(json.dumps(v,indent=2,sort_keys=True)+'\n')
def headers(p):
 text=Path(p).read_text();ns=re.search(r'^namespace (\S+)',text,re.M).group(1)
 return [{'kind':'theorem','local_name':m.group(1),'name':ns+'.'+m.group(1),'header':m.group(2).strip()}
  for m in re.finditer(r'^theorem\s+(\S+)\s*(.*?)\s*:=',text,re.M|re.S)]
def norm(s):return ' '.join(s.split())
assert sha(WORK/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
assert sha(RUN/'bound_scoped_audit_runner_proposal_v1.py')=='efd9cc779529ee334e841e20d37acad7cc06d5e7c29f41124f98f28a02e1e25d'
with (WORK/'continuation-driver.lock').open('r+') as owner,(WORK/'continuation-intake.lock').open('r+') as intake:
 for f in [owner,intake]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert not read(WORK/'continuation-active.json').get('active')
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()==BASE
 spec=importlib.util.spec_from_file_location('rational_archive_driver',WORK/'continuation_driver_capacity.py')
 mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
 d=mod.Driver(ROOT,WORK);latest=d.latest()
 n=NAME;src=ROOT/'D1Bound5'/(n+'.lean');receipt=OUT/(n+'-BUILD_RECEIPT.json')
 row=read(receipt);closure=read(OUT/(n+'-SOURCE_CLOSURE.json'))
 assert row['accepted_build'] and row['exit']==0 and not row['timed_out'] and not row['interrupted']
 assert row['source_sha256']==sha(src)==closure[n] and d.closure(n)==closure
 assert row['fingerprint']==mod.fingerprint(closure) and d.artifacts(n)==row['artifacts']
 assert (OUT/(n+'.lean')).read_bytes()==src.read_bytes()
 original=OUT/'originals'/(n+'.lean');old_headers=headers(original);new_headers=headers(src)
 assert len(old_headers)==1
 assert [(x['name'],norm(x['header'])) for x in old_headers]==[(x['name'],norm(x['header'])) for x in new_headers]
 backup=RUN/'repair-rational-triple-exclusion-wave25-before'/(n+'.lean')
 assert backup.read_bytes()==original.read_bytes()
 assert not AUDIT.exists();AUDIT.mkdir()
 snap=AUDIT/(n+'.lean');snap.write_bytes(src.read_bytes())
 harness="""import D1Bound5.RationalTripleExclusion
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open scoped NumberField
open Module
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let name := `D1Bound5.IsD1Tuple.not_rational_one_three_eight
  let ax ← Lean.collectAxioms name
  let bad := ax.filter fun n =>
    !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
  unless bad.isEmpty do
    Lean.throwError "Unexpected axioms in {name}: {bad}"
  Lean.logInfo m!"RATIONAL_TRIPLE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
"""+old_headers[0]['header']+""" :=
  IsD1Tuple.not_rational_one_three_eight hK phi a ha hmon sgn h0 h1 h2

end D1Bound5

#check @_root_.D1Bound5.IsD1Tuple.not_rational_one_three_eight
"""
 (AUDIT/'AnalyticAudit.lean').write_text(harness)
 example=re.findall(r'^example\s*(.*?)\s*:=',harness,re.M|re.S)
 assert [norm(x) for x in example]==[norm(x['header']) for x in old_headers]
 for filename,value in [
  ('TARGETS.json',[n]),('REPLAY_TARGETS.json',[n]),
  ('SOURCE_MAP.json',{n:{'source':str(src.relative_to(ROOT)),'snapshot':str(snap.relative_to(ROOT)),'sha256':sha(src)}}),
  ('BUILD_RECEIPT_MAP.json',{n:{'receipt':str(receipt.relative_to(ROOT)),'closure':str((OUT/(n+'-SOURCE_CLOSURE.json')).relative_to(ROOT))}}),
  ('SCOPED_ORIGINAL_DECLARATIONS.json',[{'module':n,'original_path':str(original),'original_source_path':str(backup),'original_sha256':sha(original),'current_sha256':sha(src),'normalizations':[],'declarations':old_headers}]),
  ('DECLARATION_NAMES.json',[x['name'] for x in old_headers])]:put(AUDIT/filename,value)
 oldmap=read(ROOT/'research/continuations/20261020-completed-checkpoint/SOURCE_MAP.json')['sources']
 archived={};acceptance={}
 for dep,h in sorted(closure.items()):
  current=ROOT/'D1Bound5'/(dep+'.lean');assert sha(current)==h
  dc=d.closure(dep);key=mod.fingerprint(dc);manifest=d.expected_manifest(dep,key,latest)
  assert manifest and d.artifacts(dep)==manifest,dep
  if dep==n:
   archived[dep]={'path':str(current.relative_to(ROOT)),'sha256':h,'payload_path':str((OUT/(n+'.lean')).relative_to(ROOT)),'assurance':'guarded_build_exact_types_and_targeted_replay_pending'}
  else:
   item=oldmap[dep];assert item['sha256']==h
   commit,path=(BASE,item['payload_path']) if 'payload_path' in item else (item['base_commit'],item['base_path'])
   blob=subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT,timeout=15)
   assert hashlib.sha256(blob).hexdigest()==h
   archived[dep]={'path':str(current.relative_to(ROOT)),'sha256':h,'base_commit':commit,'base_path':path,'assurance':'reused_accepted_dependency_with_matching_current_artifacts'}
  acceptance[dep]={'fingerprint':key,'artifacts':manifest,'original_receipt':latest.get((dep,key)),'baseline_entry':None if (dep,key) in latest else d.baseline['accepted'][dep]}
 put(OUT/'SOURCE_MAP.json',{'base_commit':BASE,'sources':archived})
 put(OUT/'ACCEPTED_DEPENDENCY_EVIDENCE.json',acceptance)
 cfg=OUT/'configuration';cfg.mkdir()
 for path,h in d.static.items():
  assert sha(ROOT/path)==h;(cfg/Path(path).name).write_bytes((ROOT/path).read_bytes())
 (OUT/'repair-rational-triple-exclusion-wave25-APPLIED.json').write_bytes((RUN/'repair-rational-triple-exclusion-wave25-APPLIED.json').read_bytes())
 put(OUT/'STATEMENT_REVIEW.json',{'original_theorem_count':1,'original_public_headers_unchanged':True,'audit_examples_exactly_match_original_headers':True,'source_closure_modules':len(closure),'newly_built_modules':[n],'root_integration':False,'main_theorem_complete':False})
 print(json.dumps({'prepared_audit':str(AUDIT),'theorems':1,'source_closure':len(closure),'reused_dependency_modules':len(closure)-1}))
