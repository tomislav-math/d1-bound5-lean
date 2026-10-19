"""Review explicit recovered/current Q files; all Git operations are read-only."""
from pathlib import Path
from datetime import datetime
import ast, hashlib, json, re, subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
prior=root/'research/continuations/20261019T152457CEST-q-continuation'
def git(*args): return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
def sha(data): return hashlib.sha256(data).hexdigest()
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text());assert summary['status']=='COMPLETED_UNIT'
initial=json.loads((out/'INITIAL_STATE.json').read_text())
assert git('rev-parse','HEAD').decode().strip()==initial['head']
index={p:sha(git('show',':'+p)) for p in git('diff','--cached','--name-only','-z').decode().split(chr(0)) if p}
assert index==initial['inherited_index']
for p,v in json.loads((out/'PREDECESSOR_FILES.json').read_text())['files'].items():
    assert sha((root/p).read_bytes())==v['sha256'], 'Predecessor bytes changed'
for v in json.loads((out/'SOURCE_MAP.json').read_text()).values():
    assert sha((root/v['source']).read_bytes())==sha((root/v['snapshot']).read_bytes())==v['sha256']
files=['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']
for folder in [prior,out]:
    files += [str(p.relative_to(root)) for p in sorted(folder.rglob('*')) if p.is_file()]
    files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(folder.name+'-*')) if p.is_file()]
assert len(files)==len(set(files)) and not set(files)&set(index)
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):patterns=ast.literal_eval(node.value)
assert patterns
review={}
for name in files:
    p=root/name;assert not p.is_symlink() and p.suffix in {'.md','.json','.txt','.lean','.py','.log'}
    assert p.stat().st_size<=5*1024*1024 and '.lake/' not in name and '__pycache__' not in name
    data=p.read_bytes();text=data.decode()
    assert not any(re.search(pattern,text) for pattern in patterns), 'Credential-shaped content; values withheld'
    review[name]={'sha256':sha(data),'bytes':len(data)}
manifest=str((out/'STAGING_PATHS.txt').relative_to(root));selfpath=str((out/'STAGING_REVIEW.json').relative_to(root))
files += [manifest,selfpath]
text='\n'.join(files)+'\n'
with (out/'STAGING_PATHS.txt').open('x') as f:f.write(text)
review[manifest]={'sha256':sha(text.encode()),'bytes':len(text.encode())}
record={'status':'REVIEWED_FOR_EXPLICIT_STAGING','time':datetime.now().astimezone().isoformat(),'files':files,'reviewed_bytes':review,'inherited_index_preserved':index,'self_record_note':'This record cannot contain its own digest; its indexed bytes must equal its reviewed working bytes.'}
with (out/'STAGING_REVIEW.json').open('x') as f:f.write(json.dumps(record,indent=2)+'\n')
print('REVIEWED_EXPLICIT_PATHS',len(files))
print('TRACKED_DIFF\n'+git('diff','--','STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md').decode())
