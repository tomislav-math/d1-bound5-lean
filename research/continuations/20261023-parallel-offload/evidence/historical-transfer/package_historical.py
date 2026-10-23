from pathlib import Path
import json,hashlib,tarfile,lzma,time,base64,importlib.util,sys
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation';O=R/'research/continuations/20261023-parallel-offload/historical-transfer';inv=json.loads((O/'INVENTORY.json').read_text());spec=importlib.util.spec_from_file_location('history_driver',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m);d=m.Driver(R,W);latest=d.latest();cache={};verified={};rejected={};start=time.time()
# Independently validate acceptance and actual artifacts of the union of every
# candidate's project dependencies; this does not infer acceptance from files.
needed={n for row in inv['accepted'] for n in row['source_closure']}
for n in sorted(needed):
 try:
  c=d.closure(n,source_cache=cache);key=m.fingerprint(c);e=d.expected_manifest(n,key,latest)
  if not e or d.artifacts(n)!=e:rejected[n]='DEPENDENCY_NOT_CURRENTLY_ACCEPTED';continue
  verified[n]={'fingerprint':key,'source_closure':c,'artifacts':e}
 except Exception as ex:rejected[n]=repr(ex)
print('dependency guard',len(verified),'accepted',len(rejected),'rejected',flush=True)
selected=[];filtered={}
for row in inv['accepted']:
 bad=set(row['source_closure'])-set(verified)
 if bad:filtered[row['name']]=sorted(bad);continue
 selected.append(row)
manifest={'status':'MAC_ACCEPTED_ARTIFACT_EXPORT_NOT_LINUX_OR_FRESH_REPLAY','inventory_sha256':m.sha((O/'INVENTORY.json').read_bytes()),'accepted':selected,'dependency_acceptance':verified,'rejected_dependency_modules':rejected,'filtered_candidates':filtered,'configuration':d.static,'driver_sha256':m.sha((W/'continuation_driver_capacity.py').read_bytes()),'toolchain_file':(R/'lean-toolchain').read_text(),'mathlib_manifest_sha256':m.sha((R/'.lake/packages/mathlib/lake-manifest.json').read_bytes())}
(O/'EXPORT_MANIFEST.json').write_text(json.dumps(manifest,sort_keys=True,indent=2)+'\n')
export=O/'accepted-artifacts.tar.xz';count=0
with lzma.open(export,'wb',preset=1) as packed:
 with tarfile.open(fileobj=packed,mode='w|') as tar:
  tar.add(O/'EXPORT_MANIFEST.json',arcname='EXPORT_MANIFEST.json')
  for row in selected:
   for path,h in row['exported_artifacts'].items():
    assert m.sha((R/path).read_bytes())==h,path
    tar.add(R/path,arcname=path,recursive=False);count+=1
   if count%100==0:print('packed files',count,'bytes',export.stat().st_size,flush=True)
# All relevant canonical sources and pinned project configuration must remain
# exactly the reviewed bytes through packaging.
for n,(h,_) in cache.items():assert m.sha((R/'D1Bound5'/(n+'.lean')).read_bytes())==h,n
assert d.manifest_matches(d.static)
summary={'status':'PACKAGED_NOT_INSTALLED','selected':len(selected),'files':count,'compressed_bytes':export.stat().st_size,'archive_sha256':m.sha(export.read_bytes()),'manifest_sha256':m.sha((O/'EXPORT_MANIFEST.json').read_bytes()),'seconds':time.time()-start,'filtered_candidates':len(filtered)};(O/'PACKAGE_SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2),flush=True)
