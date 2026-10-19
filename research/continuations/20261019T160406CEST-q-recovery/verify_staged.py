"""Read-only exact staged-source, artifact and inherited-index verification."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
def sha(data):return hashlib.sha256(data).hexdigest()
with (work/'continuation-driver.lock').open('r') as owner,(work/'continuation-intake.lock').open('r') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text());assert not active['active'] and not active.get('protected_closure')
    review=json.loads((out/'STAGING_REVIEW.json').read_text());files=review['files'];initial=json.loads((out/'INITIAL_STATE.json').read_text())
    assert (out/'STAGING_PATHS.txt').read_text().splitlines()==files
    assert set(p for p in git('diff','--cached','--name-only','-z').decode().split(chr(0)) if p)==set(files)|set(initial['inherited_index'])
    for p,h in initial['inherited_index'].items():assert sha(git('show',':'+p))==h
    for p in files:
        data=git('show',':'+p);assert data==(root/p).read_bytes()
        if p in review['reviewed_bytes']:assert sha(data)==review['reviewed_bytes'][p]['sha256']
    assert git('branch','--show-current').decode().strip()=='main' and git('rev-parse','HEAD').decode().strip()==initial['head']
    guard=json.loads((out/'audit/TARGETED_REPLAY_GUARDS.json').read_text())
    for n,h in guard['project_sources'].items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
    for p,h in {**guard['compiled_artifacts'],**guard['immutable_inputs']}.items():assert sha((root/p).read_bytes())==h
    check=subprocess.run(['git','diff','--cached','--check','--',*[p for p in files if not p.endswith('.log')]],cwd=root,capture_output=True,text=True)
    assert check.returncode==0,check.stdout
    logs=subprocess.run(['git','diff','--cached','--check','--',*[p for p in files if p.endswith('.log')]],cwd=root,capture_output=True,text=True)
    print('RAW_LOG_WHITESPACE_EXIT',logs.returncode,'warnings',len([s for s in logs.stdout.splitlines() if '.log:' in s]))
    print('EXACT_INDEX_SOURCE_ARTIFACT_PASS',len(files),'explicit paths; inherited index preserved;',datetime.now().astimezone().isoformat())
