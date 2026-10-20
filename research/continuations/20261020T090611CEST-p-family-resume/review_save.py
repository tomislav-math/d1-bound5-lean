"""Review only the explicit P-family continuation scopes. No Git mutations."""
from pathlib import Path
from datetime import datetime
import ast,fcntl,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*args):return subprocess.check_output(['git','-C',str(root),*args])
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text());assert summary['outcome']=='COMPLETED_UNIT'
initial=json.loads((out/'INITIAL_STATE.json').read_text());inherited=initial['inherited_index']
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
 if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):patterns=ast.literal_eval(node.value)
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
 scopes=[root/initial['previous_run'],out]
 files=[]
 for scope in scopes:
  assert scope.parent==root/'research/continuations'
  files += [str(p.relative_to(root)) for p in sorted(scope.rglob('*')) if p.is_file() and '__pycache__' not in p.parts]
  files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(scope.name+'-*')) if p.is_file()]
 receipt='records/runs/20261020T023316CEST-a5-p-completion-POST_PUSH.json'
 assert (root/receipt).exists();files.append(receipt)
 assert len(files)==len(set(files)) and not set(files)&set(inherited)
 reviewed={};raw=[];whitespace={}
 for name in files:
  p=root/name;assert not p.is_symlink() and p.suffix in ['.lean','.json','.md','.py','.txt','.log'] and p.stat().st_size<=5*1024*1024
  data=p.read_bytes();text=data.decode();assert not any(re.search(pat,text) for pat in patterns),'Credential-shaped content; value withheld'
  reviewed[name]={'sha256':sha(data),'bytes':len(data)}
  if p.suffix in ['.log','.lean']:raw.append(name)
  if p.suffix=='.md':
   bad=[(i+1,line) for i,line in enumerate(text.splitlines()) if line.rstrip()!=line]
   if bad:
    assert '```diff' in text and all(line.strip()=='' or line.startswith((' ','+','-')) for _,line in bad),name
    raw.append(name);whitespace[name]=[i for i,_ in bad]
 wr=str((out/'PRESERVED_WHITESPACE_REVIEW.json').relative_to(root))
 (root/wr).write_text(json.dumps({'scope':'Exact raw source/log bytes and whitespace in retained unified diff blocks. No proof source is rewritten.','diff_notes':whitespace},indent=2)+'\n')
 files.append(wr);reviewed[wr]={'sha256':sha((root/wr).read_bytes()),'bytes':(root/wr).stat().st_size}
 manifest=str((out/'STAGING_PATHS.txt').relative_to(root));review=str((out/'STAGING_REVIEW.json').relative_to(root))
 files += [manifest,review]
 (out/'STAGING_PATHS.txt').write_text('\n'.join(files)+'\n')
 reviewed[manifest]={'sha256':sha((root/manifest).read_bytes()),'bytes':(root/manifest).stat().st_size}
 (out/'STAGING_REVIEW.json').write_text(json.dumps({'time':datetime.now().astimezone().isoformat(),'status':'REVIEWED_NOT_STAGED','head':head,'repository':info,'files':files,'reviewed':reviewed,'inherited_index':inherited,'raw_source_log_whitespace_exceptions':raw,'scope':'Current verified P unit, exact prior P trial evidence and the preceding private-push receipt. No accepted-root promotion or old index commit.'},indent=2)+'\n')
 print('PRIVATE_UNIT_REVIEW_PASS',len(files),'paths;',len(inherited),'inherited blobs preserved')
