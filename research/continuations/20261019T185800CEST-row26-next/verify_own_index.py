"""Read-only check of exactly this new staged unit and all inherited index bytes.
No staging, commit, push, permission changes or mutation of proof data.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,json,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(data):return hashlib.sha256(data).hexdigest()
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
review=json.loads((out/'STAGING_REVIEW.json').read_text());files=review['files']
assert files==(out/'STAGING_PATHS.txt').read_text().splitlines()
inherited=review['inherited_index_preserved']
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
    assert git('branch','--show-current').decode().strip()=='main'
    assert git('rev-parse','HEAD').decode().strip()==review['head_before']
    actual=set(p for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p)
    assert actual==set(files)|set(inherited) and not set(files)&set(inherited)
    for p,h in inherited.items():assert sha(git('show',':'+p))==h, 'Inherited index changed'
    for p in files:
        blob=git('show',':'+p);assert blob==(root/p).read_bytes(),p
        if p in review['reviewed_bytes']:assert sha(blob)==review['reviewed_bytes'][p]['sha256'],p
    guards=json.loads((out/'audit/TARGETED_REPLAY_GUARDS.json').read_text())
    for n,h in guards['project_sources'].items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
    for p,h in {**guards['compiled_artifacts'],**guards['immutable_inputs']}.items():assert sha((root/p).read_bytes())==h
    cleanfiles=[p for p in files if p not in review['raw_log_whitespace_exceptions']]
    result=subprocess.run(['git','diff','--cached','--check','--',*cleanfiles],cwd=root,capture_output=True,text=True)
    assert result.returncode==0,result.stdout
    print('NEW_UNIT_EXACT_INDEX_PASS',len(files),'own paths;',len(inherited),'inherited paths preserved;',datetime.now().astimezone().isoformat())
