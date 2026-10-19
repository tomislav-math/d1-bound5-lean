"""Read-only exact-index, current source and compiled artifact review."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,json,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*a):return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
    r=json.loads((out/'STAGING_REVIEW.json').read_text());files=r['files']
    assert files==(out/'STAGING_PATHS.txt').read_text().splitlines()
    inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
    staged={p for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert staged==set(files)|set(inherited)
    for p,h in inherited.items():assert sha(git('show',':'+p))==h
    for p in files:
        b=git('show',':'+p);assert b==(root/p).read_bytes()
        if p in r['reviewed_bytes']:assert sha(b)==r['reviewed_bytes'][p]['sha256']
    assert git('branch','--show-current').decode().strip()=='main'
    assert git('rev-parse','HEAD').decode().strip()==json.loads((out/'INITIAL_STATE.json').read_text())['head']
    guard=json.loads((out/'audit-final/TARGETED_REPLAY_GUARDS.json').read_text())
    for n,h in guard['project_sources'].items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
    for p,h in {**guard['compiled_artifacts'],**guard['immutable_inputs']}.items():assert sha((root/p).read_bytes())==h
    result=subprocess.run(['git','diff','--cached','--check'],cwd=root,capture_output=True,text=True)
    print('EXACT_INDEX_SOURCE_ARTIFACT_PASS',len(files),'reviewed paths; inherited staged receipt preserved')
    print('WHITESPACE_EXIT',result.returncode)
    print(result.stdout[:10000])
    print('TIME',datetime.now().astimezone().isoformat())
