"""Review and hold the existing project locks for one explicit proof publication.
No Git mutation or compiler launch. Actual staging, commit and push stay separate.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse, ast, fcntl, hashlib, json, os, re, signal, subprocess, time
R=Path('/Users/tp/Lean/D1Bound5')
W=R/'research/continuations/20261018T010800CEST-main-continuation'
U=R/'research/continuations/20261020T100000CEST-work-resume'
O=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('scope');p.add_argument('--next',required=True);p.add_argument('--extra',action='append',default=[]);args=p.parse_args()
assert re.fullmatch(r'[a-z0-9-]+',args.scope)
scope=args.scope;A=U/('pro-graph35-'+scope+'-audit')
owner_path=W/('pro-graph35-'+scope+'-publication-owner.json')
release=W/('pro-graph35-'+scope+'-publication-release.json')
stop=False
def halted(*_):
 global stop
 stop=True
for sig in [signal.SIGINT,signal.SIGTERM,signal.SIGHUP]:signal.signal(sig,halted)
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,v):Path(p).write_text(json.dumps(v,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git',*a],cwd=R,text=True,timeout=30).strip()
with (W/'continuation-driver.lock').open('r+') as owner,(W/'continuation-intake.lock').open('r+') as intake:
 for f in [owner,intake]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert not git('diff','--cached','--name-only') and git('branch','--show-current')=='main'
 assert not read(W/'continuation-active.json').get('active') and not read(A/'active-targeted-replay.json')['active']
 assert not owner_path.exists() and not release.exists()
 ps=subprocess.check_output(['ps','-axo','pid=,comm='],text=True)
 assert not any(Path(z[-1]).name in ['lean','lake','leanchecker'] for line in ps.splitlines() if (z:=line.split()))
 summary=read(O/(scope+'-VERIFICATION_SUMMARY.json'));assert summary['status']=='SCOPED_VERIFICATION_PASS'
 final=read(A/'BOUND_AUDIT_FINAL.json');assert final['status']=='BOUND_SCOPED_AUDIT_PASS'
 assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] and not x['binding_drift_paths'] for x in final['records'])
 evidence=read(O/(scope+'-ACCEPTED_DEPENDENCY_EVIDENCE.json'));sources=read(O/(scope+'-SOURCE_MAP.json'))['sources']
 assert set(evidence)==set(sources)
 for n,item in sources.items():
  assert sha(R/item['path'])==item['sha256']
  for rel,h in evidence[n]['artifacts'].items():assert sha(R/rel)==h
 for rel,h in read(O/'CONFIGURATION.json').items():assert sha(R/rel)==h
 state=read(O/(scope+'-PROOF_STATE.json'));assert hashlib.sha256(json.dumps(state,sort_keys=True,separators=(',',':')).encode()).hexdigest()==summary['proof_fingerprint']
 for rel,h in read(A/'PREPARATION_BINDINGS.json')['files'].items():assert sha(rel)==h
 head=git('rev-parse','HEAD')
 statuses=[]
 for f in sorted(O.glob('*-VERIFICATION_SUMMARY.json')):
  v=read(f)
  if v.get('status')=='SCOPED_VERIFICATION_PASS':statuses.append(f.stem.replace('-VERIFICATION_SUMMARY','')+': '+str(v['guarded_builds'])+' guarded builds, '+str(v['declarations'])+' exact public-type/axiom checks, '+str(v['targeted_same_kernel_replays'])+' targeted replays.')
 (O/'README.md').write_text('# Graph35 verified working units\n\n'+'\n'.join(statuses)+'\n\nOnly the scopes listed above have completed their stated checks. Other prepared\nsource candidates remain drafts until their own genuine receipts pass. Original\nstatements, complete tails, data and model parameters are preserved.\n\nEach scope retains original successful build/audit/replay records and an exact\nsource reconstruction map. Replays use the installed SAME Lean kernel; no\nexternal independent implementation or review is claimed. Canonical root\nintegration and the original main theorem remain incomplete.\n\nNext action: '+args.next+'\n')
 (R/'records/PRO_CONTINUATION_HANDOFF.md').write_text('# Current D1 formalization handoff\n\nMain theorem UNPROVED. No new canonical root integration.\nCompleted current scope: graph35 '+scope+'.\n'+str(summary['guarded_builds'])+' guarded builds, '+str(summary['declarations'])+' exact original public-type/transitive-axiom checks,\nand '+str(summary['targeted_same_kernel_replays'])+' targeted installed SAME-kernel replays passed. All exits zero, no\ntimeout or binding drift. Source and required artifact hashes were revalidated.\nNo original statement or hypothesis was weakened.\n\nEvidence: '+str(O.relative_to(R))+'/.\nSummary: '+scope+'-VERIFICATION_SUMMARY.json.\nAudit: '+str(A.relative_to(R))+'/.\nProof fingerprint: '+summary['proof_fingerprint']+'.\nPublication prepared, not yet pushed; starting HEAD '+head+'.\n\nGraph17 is already a complete verified working endpoint, synchronized in\n8489909dbf3a492370e470bef243edabb1abe5ab. Main/root verification remains open.\n\nNext exact action: '+args.next+'\n\nUse current source/receipt and actual process state before acquiring the existing\nproject locks. Preserve all unrelated work and old receipts. The inherited idle\nPython terminal79436 was left untouched. Automations unchanged.\n')
 q=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(R/'scripts/git_sync_preflight.py')],cwd=R,capture_output=True,text=True,timeout=40)
 assert q.returncode==0,q.stdout;save(O/(scope+'-GIT_PREFLIGHT.json'),{'exit':0,'report':json.loads(q.stdout)})
 paths=set(git('ls-files','--others','--exclude-standard','--',str(O.relative_to(R)),str(A.relative_to(R))).splitlines())
 paths|=set(git('diff','--name-only','--',str(O.relative_to(R)),str(A.relative_to(R))).splitlines());paths.add('records/PRO_CONTINUATION_HANDOFF.md');paths.discard('')
 for rel in args.extra:
  f=R/rel;assert f.resolve().is_relative_to(R.resolve()) and not any(x in Path(rel).parts for x in ['.git','.lake','..']);paths.add(rel)
 for rel in paths:
  f=R/rel;assert f.is_file() and not f.is_symlink() and '.lake' not in f.parts and f.suffix not in ['.olean','.ilean','.c','.o','.so','.dylib'];raw=f.read_bytes();assert len(raw)<5*1024*1024 and b'\0' not in raw;txt=raw.decode()
  if f.suffix=='.json':json.loads(txt)
  if f.suffix=='.py':ast.parse(txt)
 hashes={rel:sha(R/rel) for rel in sorted(paths)};manifest=O/(scope+'-SELECTED_FILES_SHA256.json');save(manifest,hashes);paths.add(str(manifest.relative_to(R)));plist=O/(scope+'-STAGING_PATHS.txt');paths.add(str(plist.relative_to(R)));plist.write_text('\n'.join(sorted(paths))+'\n')
 data={'active':True,'pid':os.getpid(),'parent_pid':os.getppid(),'scope':scope,'purpose':'Reviewed graph35 unit publication','utc':datetime.now(timezone.utc).isoformat(),'timeout_seconds':240,'child_processes':[]};save(owner_path,data)
 print(json.dumps({'status':'VERIFIED_UNIT_SELECTED','scope':scope,'selected_files':len(paths),'head':head,'owner_pid':os.getpid(),'proof_fingerprint':summary['proof_fingerprint']}),flush=True)
 end=time.monotonic()+240
 while not stop and not release.exists() and time.monotonic()<end:time.sleep(1)
 data.update(active=False,finished_utc=datetime.now(timezone.utc).isoformat(),reason='released' if release.exists() else 'signal' if stop else 'bounded_timeout');save(owner_path,data);print(json.dumps(data),flush=True)
