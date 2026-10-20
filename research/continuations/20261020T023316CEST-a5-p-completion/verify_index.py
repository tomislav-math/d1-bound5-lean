"""Read-only verification of the exact selected index; preserves every inherited blob."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, json, subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*args):return subprocess.check_output(['git','-C',str(root),*args])
review=json.loads((out/'STAGING_REVIEW.json').read_text());paths=review['files'];inherited=review['inherited_index']
assert paths==(out/'STAGING_PATHS.txt').read_text().splitlines()
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
    assert git('branch','--show-current').decode().strip()=='main' and git('rev-parse','HEAD').decode().strip()==review['head']
    actual=set(p for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p)
    assert actual==set(paths)|set(inherited) and not set(paths)&set(inherited)
    for p,h in inherited.items():assert sha(git('show',':'+p))==h
    for p in paths:
        b=git('show',':'+p);assert b==(root/p).read_bytes()
        if p in review['reviewed']:assert sha(b)==review['reviewed'][p]['sha256']
    for n,h in json.loads((out/'FINAL_SOURCE_GUARDS.json').read_text()).items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
    for p,h in json.loads((out/'FINAL_ARTIFACT_GUARDS.json').read_text()).items():assert sha((root/p).read_bytes())==h
    clean=[p for p in paths if p not in review['raw_source_log_whitespace_exceptions']]
    result=subprocess.run(['git','-C',str(root),'diff','--cached','--check','--',*clean],capture_output=True,text=True)
    assert result.returncode==0,result.stdout
    print('EXACT_REVIEWED_INDEX_PASS',len(paths),'selected paths;',len(inherited),'inherited blobs preserved;',datetime.now().astimezone().isoformat())
