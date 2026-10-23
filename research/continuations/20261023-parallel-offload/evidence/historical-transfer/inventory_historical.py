from pathlib import Path
import importlib.util,sys,json,gzip,base64,time,hashlib
R=Path('/Users/tp/Lean/D1Bound5'); W=R/'research/continuations/20261018T010800CEST-main-continuation'; O=R/'research/continuations/20261023-parallel-offload/historical-transfer';O.mkdir(exist_ok=True)
p=W/'continuation_driver_capacity.py';spec=importlib.util.spec_from_file_location('history_driver',p);m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m);d=m.Driver(R,W);latest=d.latest();q=json.loads(gzip.decompress(base64.b64decode((O.parent/'historical-request.b64').read_text())));cache={};rows=[];rejected={};start=time.time()
for i,n in enumerate(q['missing_local']):
 try:
  c=d.closure(n,source_cache=cache)
  if any(q['local_source_closure'].get(k)!=h for k,h in c.items()):rejected[n]='SOURCE_CLOSURE_DIFFERS';continue
  key=m.fingerprint(c);expected=d.expected_manifest(n,key,latest)
  if not expected:rejected[n]='NO_CURRENT_HISTORICAL_ACCEPTANCE';continue
  actual=d.artifacts(n)
  if actual!=expected:rejected[n]='HISTORICAL_ARTIFACT_CHANGED';continue
  parts={p:h for p,h in expected.items() if p.endswith(('.olean','.olean.server','.olean.private'))}
  if not any(p.endswith('.olean') for p in parts):rejected[n]='NO_OLEAN';continue
  row={'name':n,'source_closure':c,'fingerprint':key,'historical_all_artifacts':expected,'exported_artifacts':parts,'exported_bytes':sum((R/p).stat().st_size for p in parts),'acceptance_row':latest.get((n,key)),'baseline_row':None if latest.get((n,key)) else d.baseline.get('accepted',{}).get(n)};rows.append(row)
 except Exception as e:rejected[n]=type(e).__name__+': '+str(e)
 if i%100==0:print('inventory',i,'accepted',len(rows),'seconds',round(time.time()-start,1),flush=True)
result={'status':'READ_ONLY_HISTORICAL_ACCEPTANCE_INVENTORY_NOT_KERNEL_REPLAY','driver_sha256':m.sha(p.read_bytes()),'request_sha256':m.sha((O.parent/'historical-request.b64').read_bytes()),'source_cache':{n:{'sha256':v[0],'dependencies':v[1]} for n,v in cache.items()},'remote_configuration':d.static,'ledger_path':str(d.state_path),'ledger_sha256':m.sha(d.state_path.read_bytes()),'baseline_path':str(d.baseline_path),'baseline_sha256':m.sha(d.baseline_path.read_bytes()),'baseline_metadata':{k:v for k,v in d.baseline.items() if k!='accepted'},'accepted':rows,'rejected':rejected,'seconds':time.time()-start}
assert d.manifest_matches(d.static)
(O/'INVENTORY.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n');print(json.dumps({'accepted':len(rows),'rejected':len(rejected),'bytes':sum(r['exported_bytes'] for r in rows),'seconds':result['seconds'],'largest':sorted([(r['exported_bytes'],r['name']) for r in rows],reverse=True)[:10]},indent=2),flush=True)
