"""Review explicit current and recovered research records for a private save.
All Git operations in this script are read-only; staging/commit/push are separate.
"""
from pathlib import Path
from datetime import datetime
import ast, fcntl, hashlib, json, re, subprocess
root=Path('/Users/tp/Lean/D1Bound5'); out=Path(__file__).resolve().parent
previous=root/'research/continuations/20261019T211452CEST-analytic-final-branches'
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def digest(data): return hashlib.sha256(data).hexdigest()
def git(*args): return subprocess.check_output(['git',*args],cwd=root)
initial=json.loads((out/'INITIAL_STATE.json').read_text())
inherited=initial['inherited_index']
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text())
assert summary['outcome']=='COMPLETED_UNIT'
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):
        patterns=ast.literal_eval(node.value)
assert patterns
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    active=json.loads((work/'continuation-active.json').read_text())
    assert not active.get('active') and not active.get('protected_closure')
    assert git('branch','--show-current').decode().strip()=='main'
    assert git('remote','get-url','origin').decode().strip()=='https://github.com/tomislav-math/d1-bound5-lean.git'
    actual={p:digest(git('show',':'+p)) for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert actual==inherited, 'Inherited index drift; stop without mutations'
    for n,h in json.loads((out/'VERIFIED_SOURCE_CLOSURE.json').read_text()).items():
        assert digest((root/'D1Bound5'/(n+'.lean')).read_bytes())==h
    folders=[out,previous]
    files=[p for folder in folders for p in folder.rglob('*') if p.is_file() and '__pycache__' not in p.parts]
    files += [p for folder in folders for p in (root/'records/runs').glob(folder.name+'-*') if p.is_file()]
    names=sorted(set(str(p.relative_to(root)) for p in files))
    assert not set(names)&set(inherited)
    assert len(names)==len(files)
    reviewed={}; whitespace=[]
    for n in names:
        p=root/n
        assert not p.is_symlink() and p.suffix in {'.py','.lean','.json','.md','.txt','.log'}
        assert p.stat().st_size<5*1024*1024 and '.lake/' not in n
        data=p.read_bytes(); text=data.decode('utf-8')
        assert not any(re.search(pattern,text) for pattern in patterns), 'Credential-shaped content; value withheld'
        if any(line.rstrip()!=line for line in text.splitlines()):
            assert p.suffix=='.log', 'Non-log whitespace requires separate review: '+n
            whitespace.append(n)
        reviewed[n]={'sha256':digest(data),'bytes':len(data)}
    manifest=str((out/'STAGING_PATHS.txt').relative_to(root))
    report=str((out/'STAGING_REVIEW.json').relative_to(root))
    names += [manifest,report]
    with (out/'STAGING_PATHS.txt').open('x') as f:f.write('\n'.join(names)+'\n')
    reviewed[manifest]={'sha256':digest((root/manifest).read_bytes()),'bytes':(root/manifest).stat().st_size}
    with (out/'STAGING_REVIEW.json').open('x') as f:
        f.write(json.dumps({'time':datetime.now().astimezone().isoformat(),
            'head_before':git('rev-parse','HEAD').decode().strip(),'files':names,
            'reviewed_bytes':reviewed,'inherited_index_preserved':inherited,
            'raw_log_whitespace_exceptions':whitespace,
            'scope':'Current analytic unit and recovered previous research records only; uncompiled and failed trials retain their recorded status. No accepted-root promotion or inherited staged package is included.'},indent=2)+'\n')
print('EXPLICIT_PRIVATE_SAVE_REVIEW_PASS',len(names),'paths; inherited',len(inherited),'preserved')
