"""Read-only exact index and proof-artifact validation before a plain commit."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,json,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*a):return subprocess.check_output(['git',*a],cwd=root)
with (work/'continuation-driver.lock').open('r') as owner,(work/'continuation-intake.lock').open('r') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    assert not json.loads((work/'continuation-active.json').read_text())['active']
    review=json.loads((out/'STAGING_REVIEW.json').read_text());paths=review['files'];initial=json.loads((out/'INITIAL_STATE.json').read_text())
    assert set(git('diff','--cached','--name-only','-z').decode().strip('\0').split('\0'))==set(paths)|set(initial['inherited_index'])
    assert git('rev-parse','HEAD').decode().strip()==initial['head']
    for p,h in initial['inherited_index'].items():assert sha(git('show',':'+p))==h
    for p in paths:
        b=git('show',':'+p);assert b==(root/p).read_bytes()
        if p in review['reviewed_bytes']:assert sha(b)==review['reviewed_bytes'][p]['sha256']
    for folder in [out/'audit-fixed',root/'research/continuations/20261019T171838CEST-three-small-exclusion/audit-independent',root/'research/continuations/20261019T171838CEST-three-small-exclusion/graph-pilot-audit']:
        g=json.loads((folder/'TARGETED_REPLAY_GUARDS.json').read_text())
        for n,h in g['project_sources'].items():assert sha((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
        for p,h in {**g['compiled_artifacts'],**g['immutable_inputs']}.items():assert sha((root/p).read_bytes())==h
    print('EXACT_INDEX_AND_CURRENT_PROOF_GUARDS_PASS',len(paths),'inherited index preserved',datetime.now().astimezone().isoformat())
