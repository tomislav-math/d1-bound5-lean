#!/usr/bin/env python3
"""Archive Linux proof evidence as text, with all compiled receipt guards revalidated."""
from pathlib import Path
import base64,gzip,hashlib,json,time
import guarded_general_b as G
R=Path(__file__).resolve().parent
dirs=list(R.glob('results-graphs-b*'))
dirs += [R/f'results-graph{g}-endpoint-audit' for g in [14,15,21,28,36]]
files={};receipts=[]
for d in dirs:
 if not d.is_dir():continue
 for f in sorted(d.iterdir()):
  if f.suffix not in ['.json','.log','.lean']:continue
  files[str(f.relative_to(R))]=f.read_text()
  if f.name.endswith('-receipt.json'):
   row=json.loads(f.read_text());n=row.get('name')
   if n and row.get('proof_status')=='COMPILED_ONLY':
    assert row['source_closure']==G.closure(n),('SOURCE_CHANGED',n)
    assert row['artifact_sha256']==G.sha(G.artifact(n)),('ARTIFACT_CHANGED',n)
    assert all(G.sha(G.artifact(dep))==h for dep,h in row['dependency_artifacts'].items()),('DEPENDENCY_CHANGED',n)
    if 'external_import_artifacts' in row:assert row['external_import_artifacts']==G.external(G.closure(n)),('EXTERNAL_CHANGED',n)
    receipts.append(n)
for n in ['guarded_compile_b.py','guarded_general_b.py','audit_graphs_b.py','export_graphs_b.py','install_graphs_b_closure.py','pipeline_graphs_b.py']:
 files['scripts/'+n]=(R/n).read_text()
meta={'status':'LINUX_PROOF_EVIDENCE_ARCHIVE','graphs':[14,15,21,28,36],'compiled_receipts_revalidated':len(receipts),'compiled_modules':sorted(receipts),'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'toolchain':'4.33.1','architecture':'linux-x86_64','main_theorem_complete':False,'kernel_milestones_reported_only_in_pergraph_VERIFICATION_SUMMARY':'No all-helpers replay claim','binary_artifacts_excluded':True,'lean_sha256':G.sha(G.BIN/'lean'),'leanchecker_sha256':G.sha(G.BIN/'leanchecker')}
files['EXPORT_STATUS.json']=json.dumps(meta,indent=2,sort_keys=True)+'\n'
pack={'files':files,'sha256':{n:hashlib.sha256(s.encode()).hexdigest() for n,s in files.items()}}
raw=json.dumps(pack,sort_keys=True).encode();data=base64.b64encode(gzip.compress(raw)).decode()
(R/'graphs-b-evidence-export.b64').write_text(data)
(R/'graphs-b-evidence-export-meta.json').write_text(json.dumps({'base64_chars':len(data),'decoded_sha256':hashlib.sha256(raw).hexdigest(),'files':len(files),**meta},indent=2,sort_keys=True)+'\n')
print(json.dumps({'base64_chars':len(data),'decoded_sha256':hashlib.sha256(raw).hexdigest(),'files':len(files),'compiled_receipts_revalidated':len(receipts)}))
