"""Prepare exact original-statement audit and archive source references; no compiler or Git mutation."""
from pathlib import Path
import hashlib, importlib.util, json, re, subprocess, sys

ROOT = Path('/Users/tp/Lean/D1Bound5')
RUN = ROOT / 'research/continuations/20261020T100000CEST-work-resume'
WORK = ROOT / 'research/continuations/20261018T010800CEST-main-continuation'
OUT = Path(__file__).resolve().parent
AUDIT = RUN / 'pro-graph33-audit'
BASE = '61898e5136b6ac2c10b4b2f17c6cdb5ed7972e0e'
TARGETS = ['SmallPairGraphClosure33Chunk04', 'SmallPairGraphClosure33Chunk05',
           'SmallPairGraphClosure33Coverage', 'SmallPairGraphClosure33', 'SmallPairGraphData33']
def sha(p):
 return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def put(p, value):
 with Path(p).open('x') as f:
  f.write(json.dumps(value, indent=2, sort_keys=True) + '\n')
def headers(p):
 text = Path(p).read_text()
 ns = re.search(r'^namespace (\S+)', text, re.M)
 ns = ns.group(1) if ns else ''
 result = []
 for m in re.finditer(r'^theorem\s+(\S+)\s*(.*?)\s*:=', text, re.M | re.S):
  result.append({'kind': 'theorem', 'local_name': m.group(1),
    'name': ns + '.' + m.group(1), 'header': m.group(2).strip()})
 return result
def norm(s):
 return ' '.join(s.split())

spec=importlib.util.spec_from_file_location('d1_graph33_archive_driver',WORK/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
d=mod.Driver(ROOT,WORK)
assert not json.loads(d.active_path.read_text()).get('active'), 'Compiler still active'
assert subprocess.run(['git','rev-parse','HEAD'],cwd=ROOT,capture_output=True,text=True,check=True).stdout.strip()==BASE
latest=d.latest()
source_map={}; receipt_map={}; original_records=[]; all_decls=[]
def unit_dir(n):
 return OUT/'coverage-projection' if n=='SmallPairGraphClosure33Coverage' else OUT
original_dir=OUT/'originals';original_dir.mkdir(exist_ok=False)
for n in TARGETS:
 unit=unit_dir(n)
 src=ROOT/'D1Bound5'/(n+'.lean')
 receipt=unit/(n+'-BUILD_RECEIPT.json')
 row=json.loads(receipt.read_text())
 closure=json.loads((unit/(n+'-SOURCE_CLOSURE.json')).read_text())
 assert row['accepted_build'] and row['exit']==0 and not row['timed_out'] and not row['interrupted']
 assert row['source_sha256']==sha(src)==closure[n] and d.closure(n)==closure
 assert row['fingerprint']==mod.fingerprint(closure) and d.artifacts(n)==row['artifacts']
 assert (unit/(n+'.lean')).read_bytes()==src.read_bytes()
 original=(RUN/'before'/(n+'.lean')) if n!='SmallPairGraphData33' else (RUN/'graph-data40_33-segment-split-proposal'/(n+'.lean'))
 old_headers=headers(original); new_headers=headers(src)
 assert [(x['name'],norm(x['header'])) for x in old_headers]==[(x['name'],norm(x['header'])) for x in new_headers], 'Changed public statement: '+n
 snap=AUDIT/(n+'.lean')
 with snap.open('xb') as f:f.write(src.read_bytes())
 old_copy=original_dir/(n+'.lean')
 with old_copy.open('xb') as f:f.write(original.read_bytes())
 source_map[n]={'source':str(src.relative_to(ROOT)),'snapshot':str(snap.relative_to(ROOT)),'sha256':sha(src)}
 receipt_map[n]={'receipt':str(receipt.relative_to(ROOT)),'closure':str((unit/(n+'-SOURCE_CLOSURE.json')).relative_to(ROOT))}
 original_records.append({'module':n,'original_path':str(old_copy),'original_source_path':str(original),
   'original_sha256':sha(original),'current_sha256':sha(src),'normalizations':[],'declarations':old_headers})
 all_decls.extend(old_headers)
assert len(all_decls)==5
audit_targets=TARGETS[:-1]  # The aggregate contains imports only and has its own build receipt.
source_map.pop('SmallPairGraphData33')
receipt_map.pop('SmallPairGraphData33')
original_records=[x for x in original_records if x['module'] in audit_targets]
examples=re.findall(r'^example\s*(.*?)\s*:=',(AUDIT/'AnalyticAudit.lean').read_text(),re.M|re.S)
assert [norm(x) for x in examples]==[norm(x['header']) for x in all_decls], 'Audit does not reproduce the exact original statements'
for name,value in [('TARGETS.json',audit_targets),('REPLAY_TARGETS.json',audit_targets),('SOURCE_MAP.json',source_map),
 ('BUILD_RECEIPT_MAP.json',receipt_map),('SCOPED_ORIGINAL_DECLARATIONS.json',original_records),
 ('DECLARATION_NAMES.json',[x['name'] for x in all_decls])]:
 put(AUDIT/name,value)
closure=d.closure('SmallPairGraphData33')
oldmap=json.loads((ROOT/'research/continuations/20261020-completed-checkpoint/SOURCE_MAP.json').read_text())['sources']
archived={}
acceptance={}
for n,h in sorted(closure.items()):
 current=ROOT/'D1Bound5'/(n+'.lean')
 assert sha(current)==h
 dc=d.closure(n);key=mod.fingerprint(dc);manifest=d.expected_manifest(n,key,latest)
 assert manifest and d.artifacts(n)==manifest, 'Unaccepted dependency '+n
 if n in TARGETS:
  archived[n]={'path':str(current.relative_to(ROOT)),'sha256':h,'payload_path':str((unit_dir(n)/(n+'.lean')).relative_to(ROOT)),
   'assurance':'guarded_build_exact_types_and_targeted_replay_pending'}
 else:
  item=dict(oldmap[n]);assert item['sha256']==h
  if 'payload_path' in item:
   ref_commit=BASE;ref_path=item['payload_path']
  else:
   ref_commit=item['base_commit'];ref_path=item['base_path']
  blob=subprocess.run(['git','show',ref_commit+':'+ref_path],cwd=ROOT,capture_output=True,check=True,timeout=15).stdout
  assert hashlib.sha256(blob).hexdigest()==h
  archived[n]={'path':str(current.relative_to(ROOT)),'sha256':h,'base_commit':ref_commit,'base_path':ref_path,
   'assurance':'reused_accepted_dependency_with_matching_current_artifacts'}
 acceptance[n]={'fingerprint':key,'artifacts':manifest,
   'original_receipt':latest.get((n,key)),'baseline_entry':None if (n,key) in latest else d.baseline['accepted'][n]}
put(OUT/'SOURCE_MAP.json',{'base_commit':BASE,'sources':archived})
put(OUT/'ACCEPTED_DEPENDENCY_EVIDENCE.json',acceptance)
cfg=OUT/'configuration';cfg.mkdir()
for path,h in d.static.items():
 assert sha(ROOT/path)==h
 with (cfg/Path(path).name).open('xb') as f:f.write((ROOT/path).read_bytes())
put(OUT/'STATEMENT_REVIEW.json',{'original_theorem_count':5,'original_public_headers_unchanged':True,
 'audit_examples_exactly_match_original_headers':True,'source_closure_modules':len(closure),
 'newly_built_modules':TARGETS,'root_integration':False,'main_theorem_complete':False})
print(json.dumps({'prepared_audit':str(AUDIT),'theorems':5,'source_closure':len(closure),'newly_built_modules':5,'prior_dependency_modules':len(closure)-5}))
