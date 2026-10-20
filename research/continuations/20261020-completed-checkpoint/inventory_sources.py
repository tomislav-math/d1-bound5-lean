"""Read-only current-source/build inventory. Only writes new sibling inventory JSONs; no compiler or Git mutation."""
from pathlib import Path
import hashlib,json,re,subprocess,datetime,collections
root=Path('/Users/tp/Lean/D1Bound5'); run=root/'research/continuations/20261018T010800CEST-main-continuation'; out=Path(__file__).resolve().parent
sha=lambda b:hashlib.sha256(b).hexdigest()
def git(*args): return subprocess.check_output(['git',*args],cwd=str(root))
head=git('rev-parse','HEAD').decode().strip(); indexsha=sha((root/'.git/index').read_bytes())
inputs={str(p.relative_to(root)):sha(p.read_bytes()) for p in [run/'continuation-builds.json',run/'continuation-trusted-baseline.json',run/'continuation-queue.json',root/'lean-toolchain',root/'lake-manifest.json',root/'lakefile.lean'] if p.exists()}
rows=json.loads((run/'continuation-builds.json').read_text()); baseline=json.loads((run/'continuation-trusted-baseline.json').read_text()); queue=json.loads((run/'continuation-queue.json').read_text())
latest={(r['name'],r['fingerprint']):(i,r) for i,r in enumerate(rows)}
headblobs=collections.defaultdict(list)
for record in git('ls-tree','-r','-z','HEAD').split(b'\0'):
 if not record: continue
 meta,path=record.split(b'\t',1); mode,typ,oid=meta.split()
 if typ==b'blob': headblobs[oid.decode()].append(path.decode())
current={}; deps={}; parseerrors={}
for p in sorted((root/'D1Bound5').glob('*.lean')):
 data=p.read_bytes(); name=p.stem; oid=hashlib.sha1(b'blob '+str(len(data)).encode()+b'\0'+data).hexdigest()
 current[name]={'path':str(p.relative_to(root)),'sha256':sha(data),'bytes':len(data),'git_blob':oid,'head_paths':headblobs.get(oid,[])}
 direct=[]
 for line in re.findall(rb'^\s*import\s+([^\n]+)',data,re.M):
  code=line.split(b'--',1)[0]; found=re.findall(rb'\bD1Bound5\.([A-Za-z0-9_.]+)',code)
  if b'D1Bound5' in code and not found: parseerrors[name]='unsupported import syntax'
  direct += [s.decode() for s in found]
 deps[name]=list(dict.fromkeys(direct))
closures={}
def closure(name,seen=None):
 if name in closures:return closures[name]
 if name not in current: raise ValueError('missing dependency '+name)
 if name in parseerrors:raise ValueError(parseerrors[name])
 seen=set() if seen is None else seen
 if name in seen: raise ValueError('cyclic import '+name)
 seen=seen|{name}; result={name:current[name]['sha256']}
 for d in deps[name]:result.update(closure(d,seen))
 closures[name]=result;return result
hashcache={}; selected={}; excluded={}; candidates=0
for name in current:
 try:c=closure(name)
 except Exception as e:excluded[name]={'reason':'closure_error','error':str(e)};continue
 fp=sha(json.dumps(c,sort_keys=True).encode()); pair=latest.get((name,fp)); idx,row=pair if pair else (None,None)
 trusted=baseline.get('accepted',{}).get(name,{})
 manifest=None; assurance=None
 if row is not None and not row.get('accepted_build',False):
  excluded[name]={'reason':'latest_current_fingerprint_not_accepted','registry_row_index':idx,'receipt':row,'fingerprint':fp};continue
 if row is not None and row.get('artifacts'):
  manifest=row['artifacts'];assurance='guarded_build' if all(row.get(k) is True for k in ['accepted_build','closure_unchanged','shared_artifacts_unchanged']) and row.get('exit')==0 and not row.get('timed_out',False) and not row.get('interrupted',False) else 'historical_accepted_build_missing_modern_guard_fields'
 elif trusted.get('fingerprint')==fp and trusted.get('artifacts'):
  manifest=trusted['artifacts'];assurance='trusted_baseline_matching_current_fingerprint'
 if manifest is None:
  excluded[name]={'reason':'no_current_accepted_receipt_or_baseline','fingerprint':fp};continue
 candidates+=1; mismatches=[]
 for path,want in manifest.items():
  if path not in hashcache:
   try:hashcache[path]=sha((root/path).read_bytes())
   except FileNotFoundError:hashcache[path]=None
  if hashcache[path]!=want:mismatches.append(path)
 if mismatches:
  excluded[name]={'reason':'artifact_manifest_mismatch','fingerprint':fp,'registry_row_index':idx,'mismatch_paths':mismatches};continue
 if '.lake/build/lib/lean/D1Bound5/'+name+'.olean' not in manifest:
  excluded[name]={'reason':'no_olean_in_trusted_manifest','fingerprint':fp,'registry_row_index':idx};continue
 selected[name]={**current[name],'assurance':assurance,'fingerprint':fp,'current_source_closure':dict(sorted(c.items())),'current_artifacts_match':True,'registry_path':str((run/'continuation-builds.json').relative_to(root)),'registry_row_index':idx,'receipt':row,'baseline_entry':trusted if assurance=='trusted_baseline_matching_current_fingerprint' or (row and not row.get('artifacts')) else None,'direct_imports':deps[name]}
 if candidates%100==0:print('CHECKED',candidates,'ACCEPTED',len(selected),flush=True)
acceptednames=set(selected)
for name,entry in selected.items():entry['dependencies_without_current_acceptance']=sorted(set(entry['current_source_closure'])-acceptednames)
unsynced={n:e for n,e in selected.items() if not e['head_paths']}
required=set().union(*(set(e['current_source_closure']) for e in unsynced.values())) if unsynced else set()
requiredsources={n:current[n] for n in sorted(required)}
stale_sources=[n for n,v in current.items() if sha((root/v['path']).read_bytes())!=v['sha256']]
inputsafter={p:sha((root/p).read_bytes()) for p in inputs}
head_after=git('rev-parse','HEAD').decode().strip(); indexafter=sha((root/'.git/index').read_bytes())
unchanged=not stale_sources and inputsafter==inputs and head_after==head and indexafter==indexsha
summary={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'head':head,'canonical_source_count':len(current),'queued_count':len(queue['names']),'registry_rows':len(rows),'baseline_count':len(baseline.get('accepted',{})),'current_accepted_count':len(selected),'current_accepted_not_in_HEAD_count':len(unsynced),'current_accepted_already_in_HEAD_count':len(selected)-len(unsynced),'unsynced_source_bytes':sum(e['bytes'] for e in unsynced.values()),'unsynced_assurance_counts':dict(collections.Counter(e['assurance'] for e in unsynced.values())),'accepted_assurance_counts':dict(collections.Counter(e['assurance'] for e in selected.values())),'required_closure_count':len(required),'required_closure_unaccepted':sorted(required-acceptednames),'excluded_reason_counts':dict(collections.Counter(e['reason'] for e in excluded.values())),'artifact_files_hashed':len(hashcache),'source_and_control_and_HEAD_and_index_unchanged':unchanged,'stale_sources':stale_sources,'input_sha256':inputs,'index_sha256':indexsha,'root_Lean_file_not_evaluated':str(root/'D1Bound5.lean'),'assurance_limit':'Current accepted compiled artifacts with exact source-closure and artifact hash checks. No new Lean compilation, extra exact-type/axiom audit, fresh replay, main/root completion or independent semantic acceptance claimed.'}
assert unchanged,'Concurrent relevant mutation; do not use inventory'
for filename,data in [('accepted_current_sources.json',{'summary':summary,'accepted_not_in_HEAD':unsynced,'accepted_already_in_HEAD':{n:e for n,e in selected.items() if e['head_paths']},'required_dependency_sources':requiredsources,'excluded_current_sources':{n:{**current[n],**e} for n,e in excluded.items()}}),('inventory_summary.json',summary)]:
 with (out/filename).open('x') as f:json.dump(data,f,indent=2,sort_keys=True);f.write('\n')
print(json.dumps(summary,indent=2),flush=True)
