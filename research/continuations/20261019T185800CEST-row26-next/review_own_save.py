"""Review this new unit for a separate explicit private Git save.
All Git commands are read-only. Earlier staged work, including the refused older
commit scope, is preserved and excluded from this new unit's path manifest.
"""
from pathlib import Path
from datetime import datetime
import ast,fcntl,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text());assert summary['outcome']=='COMPLETED_UNIT'
assert summary['new_compilations']==88 and summary['targeted_installed_same_kernel_replays']==88
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):patterns=ast.literal_eval(node.value)
assert patterns
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
    assert git('branch','--show-current').decode().strip()=='main'
    origin=git('remote','get-url','origin').decode().strip()
    assert origin in ['https://github.com/tomislav-math/d1-bound5-lean.git','https://github.com/tomislav-math/d1-bound5-lean','git@github.com:tomislav-math/d1-bound5-lean.git']
    inherited={p:sha(git('show',':'+p)) for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    ownprefix=str(out.relative_to(root))+'/'
    assert not any(p.startswith(ownprefix) or p.startswith('records/runs/'+out.name+'-') for p in inherited), 'Own files already staged: inspect rather than replace'
    head=git('rev-parse','HEAD').decode().strip()
    save(out/'SAVE_START_STATE.json',{'time':datetime.now().astimezone().isoformat(),'head':head,'inherited_index':inherited,'inherited_count':len(inherited),'policy':'All inherited staged bytes are excluded and must remain intact. No old refused commit is retried.'})
    guards=json.loads((out/'audit/TARGETED_REPLAY_GUARDS.json').read_text())
    for n,h in guards['project_sources'].items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
    for p,h in {**guards['compiled_artifacts'],**guards['immutable_inputs']}.items():assert sha((root/p).read_bytes())==h
    for m in json.loads((out/'SOURCE_MAP.json').read_text()).values():
        assert sha((root/m['source']).read_bytes())==m['sha256']==sha((root/m['snapshot']).read_bytes())
    files=[str(p.relative_to(root)) for p in sorted(out.rglob('*')) if p.is_file()]
    files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(out.name+'-*')) if p.is_file()]
    assert len(files)==len(set(files)) and not set(files)&set(inherited)
    reviewed={};raw_log_whitespace=[]
    for name in files:
        p=root/name;assert not p.is_symlink() and p.suffix in {'.md','.json','.lean','.log','.py','.txt'}
        assert '.lake/' not in name and '__pycache__' not in name and p.stat().st_size<=5*1024*1024
        data=p.read_bytes();text=data.decode('utf-8')
        assert not any(re.search(pattern,text) for pattern in patterns),'Credential-shaped content: value withheld'
        if any(line.rstrip()!=line for line in text.splitlines()):
            assert p.suffix=='.log', 'Unexpected non-log whitespace; fix before staging'
            raw_log_whitespace.append(name)
        reviewed[name]={'sha256':sha(data),'bytes':len(data)}
    record=str((out/'STAGING_REVIEW.json').relative_to(root));manifest=str((out/'STAGING_PATHS.txt').relative_to(root))
    files += [record,manifest]
    manifest_text='\n'.join(files)+'\n'
    with (out/'STAGING_PATHS.txt').open('x') as f:f.write(manifest_text)
    reviewed[manifest]={'sha256':sha(manifest_text.encode()),'bytes':len(manifest_text.encode())}
    save(out/'STAGING_REVIEW.json',{'time':datetime.now().astimezone().isoformat(),'status':'NEW_UNIT_EXPLICIT_PATHS_REVIEWED_NOT_STAGED','head_before':head,'files':files,'reviewed_bytes':reviewed,'raw_log_whitespace_exceptions':raw_log_whitespace,'inherited_index_preserved':inherited,'scope_note':'Only this new four-block unit. No common status file or prior pending proof package is consumed. The review record cannot include its own digest.'})
    print('NEW_UNIT_SAVE_REVIEW_PASS','own_paths',len(files),'inherited_excluded',len(inherited),'head',head)
