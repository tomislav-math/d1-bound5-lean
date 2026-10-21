"""Review exact completed proof units; hold existing locks for explicit Git calls."""
from pathlib import Path
from datetime import datetime,timezone
import ast,fcntl,hashlib,json,os,re,signal,subprocess,time
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';W=C/'20261018T010800CEST-main-continuation';U=C/'20261020T100000CEST-work-resume';O=Path(__file__).resolve().parent
plan=json.loads((O/'PLAN.json').read_text());stop=False
def halt(*_):
 global stop
 stop=True
for s in (signal.SIGTERM,signal.SIGINT,signal.SIGHUP):signal.signal(s,halt)
def load(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,v):Path(p).write_text(json.dumps(v,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git',*a],cwd=R,text=True,timeout=30).strip()
def rel(p):
 p=Path(p);p=p if p.is_absolute() else R/p
 assert p.is_file() and not p.is_symlink() and p.resolve().is_relative_to(R.resolve()),str(p)
 v=str(p.relative_to(R));assert not any(s in ('.git','.lake','..','__pycache__') for s in Path(v).parts)
 return v
with (W/'continuation-driver.lock').open('r+') as owner,(W/'continuation-intake.lock').open('r+') as intake:
 for f in (owner,intake):fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('branch','--show-current')=='main' and not git('diff','--cached','--name-only')
 active=load(W/'continuation-active.json');assert not active.get('active') and not active.get('protected_closure')
 ps=subprocess.check_output(['ps','-axo','pid=,comm='],text=True)
 assert not any(Path(z[-1]).name in ('lean','lake','leanchecker') for line in ps.splitlines() if (z:=line.split()))
 assert not (O/'OWNER.json').exists() and not (O/'RELEASE.json').exists()
 paths=set();checked=[]
 for group in plan['groups']:
  folder=C/group['unit'];scope=group['scope'];audit=U/group['audit']
  summary=load(folder/(scope+'-VERIFICATION_SUMMARY.json'));final=load(audit/'BOUND_AUDIT_FINAL.json')
  assert summary['status']=='SCOPED_VERIFICATION_PASS' and final['status']=='BOUND_SCOPED_AUDIT_PASS'
  assert not load(audit/'active-targeted-replay.json')['active']
  assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] and not x['binding_drift_paths'] for x in final['records'])
  sources=load(folder/(scope+'-SOURCE_MAP.json'))['sources'];evidence=load(folder/(scope+'-ACCEPTED_DEPENDENCY_EVIDENCE.json'));assert set(sources)==set(evidence)
  for n,item in sources.items():
   assert sha(R/item['path'])==item['sha256'],n
   for p,h in evidence[n]['artifacts'].items():assert sha(R/p)==h,p
   if 'payload_path' in item:
    assert sha(R/item['payload_path'])==item['sha256'];paths.add(rel(item['payload_path']))
   else:
    blob=subprocess.check_output(['git','show',item['base_commit']+':'+item['base_path']],cwd=R,timeout=30);assert hashlib.sha256(blob).hexdigest()==item['sha256']
  for p,h in load(folder/'CONFIGURATION.json').items():assert sha(R/p)==h
  state=load(folder/(scope+'-PROOF_STATE.json'));assert hashlib.sha256(json.dumps(state,sort_keys=True,separators=(',',':')).encode()).hexdigest()==summary['proof_fingerprint']
  for p,h in load(audit/'PREPARATION_BINDINGS.json')['files'].items():assert sha(p)==h,p;paths.add(rel(p))
  for d in (folder,audit):
   for p in d.rglob('*'):
    if p.is_file():paths.add(rel(p))
  checked.append({**group,'targets':summary['targets'],'proof_fingerprint':summary['proof_fingerprint'],'declarations':summary['declarations'],'targeted_same_kernel_replays':summary['targeted_same_kernel_replays']})
 head=git('rev-parse','HEAD')
 (R/'records/PRO_CONTINUATION_HANDOFF.md').write_text(plan['handoff']+'\n\nPublication starting HEAD: '+head+'.\nPublication is prepared, not yet pushed. The actual final Git state is recorded\nin POST_PUSH_RECEIPT.json under '+str(O.relative_to(R))+'.\n')
 paths.add('records/PRO_CONTINUATION_HANDOFF.md')
 for p in plan.get('extra',[]):paths.add(rel(p))
 q=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(R/'scripts/git_sync_preflight.py')],cwd=R,capture_output=True,text=True,timeout=40);assert q.returncode==0,q.stdout
 save(O/'GIT_PREFLIGHT.json',json.loads(q.stdout));save(O/'VERIFIED_UNITS.json',{'status':'REUSE_VALIDATION_PASS','units':checked,'head_before':head,'main_theorem_complete':False})
 for p in O.iterdir():
  if p.is_file():paths.add(rel(p))
 changed=set(git('ls-files','--others','--exclude-standard').splitlines())|set(git('diff','--name-only').splitlines());paths&=changed
 patterns=[r'gh[pousr]_[A-Za-z0-9]{20,}',r'github_pat_[A-Za-z0-9_]{30,}',r'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----',r'sk-(?:proj-)?[A-Za-z0-9_-]{28,}',r'(?i)Bearer\s+[A-Za-z0-9_.-]{30,}',r'(?i)https?://[^\s/:]+:[^\s/@]+@']
 for p in sorted(paths):
  f=R/p;rel(f);assert f.suffix not in ('.olean','.ilean','.c','.o','.so','.dylib');raw=f.read_bytes();assert len(raw)<=5*1024*1024 and b'\0' not in raw,p;text=raw.decode();assert not any(re.search(v,text) for v in patterns),'Credential-shaped content: '+p
  if f.suffix=='.json':json.loads(text)
  if f.suffix=='.py':ast.parse(text)
 save(O/'SELECTED_FILES_SHA256.json',{p:sha(R/p) for p in sorted(paths)});paths|={str((O/'SELECTED_FILES_SHA256.json').relative_to(R)),str((O/'STAGING_PATHS.txt').relative_to(R))};(O/'STAGING_PATHS.txt').write_text('\n'.join(sorted(paths))+'\n')
 record={'active':True,'pid':os.getpid(),'parent_pid':os.getppid(),'purpose':plan['purpose'],'utc':datetime.now(timezone.utc).isoformat(),'timeout_seconds':240,'child_processes':[]};save(O/'OWNER.json',record)
 print(json.dumps({'status':'VERIFIED_PUBLICATION_SELECTED','head':head,'selected_files':len(paths),'units':len(checked),'owner_pid':os.getpid()}),flush=True)
 end=time.monotonic()+240
 while not stop and not (O/'RELEASE.json').exists() and time.monotonic()<end:time.sleep(1)
 record.update(active=False,finished_utc=datetime.now(timezone.utc).isoformat(),reason='released' if (O/'RELEASE.json').exists() else 'signal' if stop else 'bounded_timeout');save(O/'OWNER.json',record);print(json.dumps(record),flush=True)
