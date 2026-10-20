"""Archive already-completed source versions and original receipts; never runs Lean or mutates Git."""
from pathlib import Path
import datetime,hashlib,json,re,subprocess,importlib.util
root=Path('/Users/tp/Lean/D1Bound5')
invdir=root/'research/continuations/20261020T2153Z-completed-sync-inventory'
out=root/'research/continuations/20261020-completed-checkpoint'
inv=json.loads((invdir/'accepted_current_sources.json').read_text())
summary=inv['summary']; base=summary['head']
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*args):return subprocess.check_output(['git',*args],cwd=root)
def dump(p,obj):
 p.parent.mkdir(parents=True,exist_ok=True)
 p.write_text(json.dumps(obj,sort_keys=True,indent=2)+'\n')
def copy(src,dst,want=None):
 assert src.is_file() and not src.is_symlink(),str(src)
 data=src.read_bytes()
 if want:assert sha(data)==want,str(src)
 dst.parent.mkdir(parents=True,exist_ok=True)
 dst.write_bytes(data)
 return sha(data)
assert git('rev-parse','HEAD').decode().strip()==base
index_before=git('ls-files','--stage','-z')
assert sha(index_before)=='c74a4f557980f1ee7bcc57000db967950b4f3c4c75b5d68e37dd6894c1aa31be'
for p,want in summary['input_sha256'].items():assert sha((root/p).read_bytes())==want,p
accepted={**inv['accepted_already_in_HEAD'],**inv['accepted_not_in_HEAD']}
assert len(accepted)==1269 and len(inv['accepted_not_in_HEAD'])==384
assert not any(e['dependencies_without_current_acceptance'] for e in accepted.values())
out.mkdir(exist_ok=False)
source_map={}; log_map={}; log_missing=[]
for name,e in sorted(accepted.items()):
 assert sha((root/e['path']).read_bytes())==e['sha256'],name
 item={k:e[k] for k in ['path','sha256','bytes','git_blob','assurance']}
 if not e['head_paths']:
  dest=out/'sources'/e['path'];copy(root/e['path'],dest,e['sha256'])
  item['payload_path']=str(dest.relative_to(root))
 else:
  item['base_commit']=base;item['base_path']=e['head_paths'][0]
  assert sha(git('show',base+':'+item['base_path']))==e['sha256'],name
 source_map[name]=item
 receipt=e.get('receipt')
 if receipt and receipt.get('log'):
  original=Path(receipt['log'])
  if not original.is_absolute():original=root/original
  assert original.is_relative_to(root),name
  if original.is_file():
   dest=out/'build-logs'/(name+'.log')
   digest=copy(original,dest)
   log_map[name]={'original_path':str(original.relative_to(root)),'payload_path':str(dest.relative_to(root)),'sha256':digest}
  else:log_missing.append(name)
assert not log_missing,log_missing
names=sorted(accepted)
for i in range(0,len(names),100):dump(out/'accepted-receipts'/('part-%02d.json'%(i//100+1)),{n:accepted[n] for n in names[i:i+100]})
dump(out/'SOURCE_MAP.json',{'base_commit':base,'sources':source_map})
dump(out/'BUILD_LOG_MAP.json',log_map)
dump(out/'REQUIRED_NEW_SOURCE_CLOSURE.json',inv['required_dependency_sources'])
dump(out/'EXCLUDED_CURRENT_SOURCES.json',inv['excluded_current_sources'])
dump(out/'INVENTORY_SUMMARY.json',summary)
copy(invdir/'inventory_sources.py',out/'inventory_sources.py')
copy(Path(__file__),out/'prepare_checkpoint.py')
for p in ['lean-toolchain','lakefile.lean','lake-manifest.json']:
 copy(root/p,out/'configuration'/p,summary['input_sha256'][p])
copy(root/'records/runs/20261020T214850Z-USER-REQUESTED-STOP.json',out/'USER_REQUESTED_STOP.json')
copy(root/'research/continuations/20261020T2153Z-completed-sync-review/INDEX_REVIEW.json',out/'INHERITED_INDEX_REVIEW.json')
graph_endpoints=sorted(int(n.removeprefix('SmallPairGraphData')) for n in accepted if re.fullmatch(r'SmallPairGraphData[0-9]+',n))
dump(out/'STATUS.json',{'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'base_commit':base,'new_completed_source_versions':384,'accepted_current_modules':1269,'already_archived_source_versions':885,'new_source_closure_modules':865,'missing_accepted_dependencies':0,'build_logs':len(log_map),'accepted_graph_endpoints':graph_endpoints,'accepted_graph_endpoint_count':len(graph_endpoints),'total_graph_cases':48,'last_completed_module':'SmallPairGraphClosure33Chunk03','interrupted_unaccepted_module':'SmallPairGraphClosure33Chunk04','main_theorem_complete':False,'canonical_root_integration':False,'formalization_and_compilers_stopped':True,'publication_state':'prepared_not_yet_committed_or_pushed'})
(out/'README.md').write_text("""# Completed formalization checkpoint after requested stop

This archival checkpoint saves all 384 current accepted source versions whose bytes were absent everywhere in base commit `52af5fcbfbe50016869f3875a4c1694149aaa6d4`. It also saves current acceptance records for all 1,269 accepted modules, including 885 source versions already present in that commit. Successful build evidence can be newer than the previously published source.

## Exact scope and assurance

The 384 new versions have existing successful guarded-build receipts: exit zero, unchanged source closure, unchanged shared artifacts, no timeout/interruption, and matching current artifact hashes. Their complete project dependency closure contains 865 accepted source versions with no unaccepted dependency. The inventory checked 10,152 artifact hashes without starting a compiler.

Across all 1,269 selected modules, 1,161 have guarded-build evidence and 108 use a trusted baseline matching the current source-closure fingerprint and artifacts. Original selected receipts, fingerprints, closure maps, artifact hashes and original build logs are retained. An artifact hash is evidence metadata; no compiled artifact is included. The build registry and artifact hash check do not by themselves establish an additional exact-type/axiom audit or final theorem acceptance.

There are 20 accepted graph endpoint modules out of 48, now including graph 40. Graph 33 is incomplete: chunks 00 through 03 passed; chunk 04 was interrupted by the user-requested stop and is excluded. MainTheorem and OneSmallImpossible remain unfinished. No root integration or fresh main-theorem replay is claimed.

The separate row26 mixed audit records 58 fresh declaration/type/axiom checks, 17 fresh targeted replays and 17 reused successful replays under its stated guards. It does not claim a fresh full-main replay or pinned external dependency artifact bytes.

## Reconstruction

SOURCE_MAP.json maps every accepted module to its canonical project path and SHA-256. For a payload_path, use the archived source at that path. Otherwise extract base_path from the exact base_commit using Git. Restore it to the recorded canonical path, verify SHA-256, and use the recorded configuration files. This describes reconstruction for future work; it was not run during publication.

accepted-receipts contains complete selected inventory records in bounded-size parts. BUILD_LOG_MAP.json relates the original receipt paths to archived log payloads. REQUIRED_NEW_SOURCE_CLOSURE.json records the complete closure required by the 384 new versions. EXCLUDED_CURRENT_SOURCES.json preserves the reasons the remaining 517 current source versions are not claimed accepted. Those unfinished sources remain local.

## Publication context

The user explicitly requested uploading all completed work after stopping the main Work session and compiler. The existing 547 staged historical entries were separately reviewed and are included in the same publication. They preserve completed audits, compiled-only work and failed historical attempts with their original dated labels. This checkpoint supersedes older progress counts, without rewriting historical evidence.

This is a research archive; canonical Lean sources and root imports are unchanged. No compiler or proof task is restarted, no permission or visibility is changed, and no unfinished module is labeled complete. STATUS.json is a preparation-time status, not a push receipt.
""")
spec=importlib.util.spec_from_file_location('index_review',root/'scripts/git_sync_index_review.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
manifest={}
for p in sorted(out.rglob('*')):
 if not p.is_file():continue
 rel=str(p.relative_to(root));m.safe_path(rel)
 data=p.read_bytes();assert len(data)<=m.MAX_BYTES,rel
 content=data.decode('utf-8')
 assert not any(re.search(pattern,content) for pattern in m.TOKEN_PATTERNS),'Credential-shaped content; value withheld: '+rel
 manifest[rel]={'bytes':len(data),'sha256':sha(data)}
dump(out/'PAYLOAD_MANIFEST.json',manifest)
assert index_before==git('ls-files','--stage','-z')
assert git('rev-parse','HEAD').decode().strip()==base
print(json.dumps({'status':'CHECKPOINT_PREPARED','path':str(out),'new_source_versions':384,'accepted_receipts':1269,'build_logs':len(log_map),'payload_files':len(manifest),'payload_bytes':sum(v['bytes'] for v in manifest.values()),'accepted_graph_endpoints':graph_endpoints,'index_unchanged':True},indent=2))
