#!/usr/bin/env python3
"""Export one verified graph's source, audit and guarded compile evidence as text."""
from pathlib import Path
import base64,gzip,json,sys,time,hashlib
import guarded_general as g
R=Path(__file__).resolve().parent;G=int(sys.argv[1]);assert G in [6,8,10]
O=R/f'graph{G}-owned';files={};sources={};artifacts={};targets=set()
for filename in ['VERIFICATION_SUMMARY.json','CLOSURE_VERIFICATION_SUMMARY.json']:
    row=json.loads((O/filename).read_text());assert row['status']=='SCOPED_VERIFICATION_PASS'
    sources.update(row['source_closure']);artifacts.update(row['artifact_sha256'])
    assert g.external(row['source_closure'])==row['external_import_artifacts']
for scope in ['LIGHT','CLOSURE']:
    targets.update(json.loads((O/f'FULL_{scope}_AUDIT_PLAN.json').read_text())['targets'])
assert all(g.sha(g.src(n))==h for n,h in sources.items()),'SOURCE_CHANGED'
assert all(g.sha(g.artifact(n))==h for n,h in artifacts.items()),'ARTIFACT_CHANGED'
for f in O.iterdir():
    if f.is_file() and f.suffix in ['.json','.log','.lean','.py']:
        files['audit/'+f.name]=f.read_text()
for n in targets:files['verified-sources/'+n+'.lean']=g.src(n).read_text()
receipts={}
for d in sorted(R.glob('results-*')):
    for f in sorted(d.glob('*-receipt.json')):
        row=json.loads(f.read_text());n=row.get('name')
        if n not in sources or row.get('proof_status')!='COMPILED_ONLY':continue
        if row.get('source_closure')!=g.closure(n) or row.get('artifact_sha256')!=g.sha(g.artifact(n)):continue
        if any(g.sha(g.artifact(dep))!=h for dep,h in row.get('dependency_artifacts',{}).items()):continue
        if 'external_import_artifacts' in row and row['external_import_artifacts']!=g.external(row['source_closure']):continue
        receipts[n]=(d,f,row)
assert set(sources)<=set(receipts),('MISSING_COMPILE_RECEIPT',sorted(set(sources)-set(receipts)))
for n,(d,f,row) in receipts.items():
    files['compile/'+d.name+'/'+f.name]=f.read_text()
    log=d/(n+'.log')
    if log.exists():files['compile/'+d.name+'/'+log.name]=log.read_text()
for name in ['guarded_compile.py','guarded_compile_a.py','guarded_general.py','audit_graphs_a.py','continue_graphs_a.py','export_graphs_a.py']:
    files['scripts/'+name]=(R/name).read_text()
meta={'status':'SCOPED_VERIFICATION_PASS','graph':G,'compiled_receipts_revalidated':len(receipts),
 'source_closure':sources,'binary_artifacts_excluded':True,'architecture':'linux-x86_64',
 'toolchain':'4.33.1','main_theorem_complete':False,'targeted_kernel_replays':9,
 'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())}
files['EXPORT_STATUS.json']=json.dumps(meta,indent=2)+'\n'
pack={'files':files,'sha256':{n:hashlib.sha256(s.encode()).hexdigest() for n,s in files.items()}}
raw=json.dumps(pack,sort_keys=True).encode();data=base64.b64encode(gzip.compress(raw)).decode()
(R/f'graph{G}-verified-evidence.b64').write_text(data)
meta={'base64_chars':len(data),'decoded_sha256':hashlib.sha256(raw).hexdigest(),'files':len(files),**meta}
(R/f'graph{G}-verified-evidence-meta.json').write_text(json.dumps(meta,indent=2)+'\n')
print(json.dumps({k:meta[k] for k in ['graph','base64_chars','decoded_sha256','files','compiled_receipts_revalidated']}))
