"""Read-only Git review and explicit path-manifest preparation. Never stages, commits or pushes."""
from pathlib import Path
from datetime import datetime
import ast,fcntl,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*args):return subprocess.run(['git','-C',str(root),*args],capture_output=True,check=True).stdout
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text());assert summary['outcome']=='COMPLETED_UNIT'
initial=json.loads((out/'INITIAL_STATE.json').read_text());inherited=initial['inherited_index']
patterns=None
for n in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
 if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in n.targets):patterns=ast.literal_eval(n.value)
assert patterns
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
 assert git('branch','--show-current').decode().strip()=='main'
 head=git('rev-parse','HEAD').decode().strip();assert head==initial['head']
 assert git('remote','get-url','origin').decode().strip() in ['https://github.com/tomislav-math/d1-bound5-lean.git','https://github.com/tomislav-math/d1-bound5-lean','git@github.com:tomislav-math/d1-bound5-lean.git']
 info=json.loads(subprocess.check_output(['/Users/tp/.local/bin/gh','repo','view','tomislav-math/d1-bound5-lean','--json','nameWithOwner,visibility,viewerPermission']))
 assert info['visibility']=='PRIVATE' and info['viewerPermission'] in ['ADMIN','MAINTAIN','WRITE']
 current={p:sha(git('show',':'+p)) for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p};assert current==inherited
 for n,h in json.loads((out/'FINAL_SOURCE_GUARDS.json').read_text()).items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
 for p,h in json.loads((out/'FINAL_ARTIFACT_GUARDS.json').read_text()).items():assert sha((root/p).read_bytes())==h
 for v in json.loads((out/'SOURCE_MAP.json').read_text()).values():assert sha((root/v['source']).read_bytes())==v['sha256']==sha((root/v['snapshot']).read_bytes())
 files=[str(p.relative_to(root)) for p in sorted(out.rglob('*')) if p.is_file() and '__pycache__' not in p.parts]
 files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(out.name+'-*')) if p.is_file()]
 assert len(files)==len(set(files)) and not set(files)&set(inherited)
 reviewed={};raw=[]
 for name in files:
  p=root/name;assert not p.is_symlink() and p.suffix in ['.lean','.json','.md','.py','.txt','.log'] and p.stat().st_size<=5*1024*1024
  data=p.read_bytes();text=data.decode('utf-8');assert not any(re.search(pattern,text) for pattern in patterns),'Credential-shaped content: value withheld'
  reviewed[name]={'sha256':sha(data),'bytes':len(data)}
  if p.suffix in ['.log','.lean']:raw.append(name)
 review=str((out/'STAGING_REVIEW.json').relative_to(root));manifest=str((out/'STAGING_PATHS.txt').relative_to(root));files += [manifest,review]
 (out/'STAGING_PATHS.txt').write_text('\n'.join(files)+'\n')
 reviewed[manifest]={'sha256':sha((root/manifest).read_bytes()),'bytes':(root/manifest).stat().st_size}
 (out/'STAGING_REVIEW.json').write_text(json.dumps({'time':datetime.now().astimezone().isoformat(),'status':'REVIEWED_NOT_STAGED','head':head,'repository':info,'files':files,'reviewed':reviewed,'inherited_index':inherited,'raw_source_log_whitespace_exceptions':raw,'note':'Only this new verified unit and preserved prior-batch evidence. Raw source and compiler-log whitespace are retained for exact-byte provenance. No old staged package is committed.'},indent=2)+'\n')
 print('PRIVATE_UNIT_REVIEW_PASS',len(files),'explicit paths;',len(inherited),'inherited entries preserved')
