"""Review exactly the current recovery package and its two interrupted predecessors.
All Git calls here are read-only. Stage/commit/push remain separate plain operations.
"""
from pathlib import Path
from datetime import datetime
import ast,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
predecessors=['20261019T121446CEST-unit-pair-analytic','20261019T132716CEST-analytic-recovery']
def sha(b):return hashlib.sha256(b).hexdigest()
def git(*a):return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text());assert summary['status']=='COMPLETED_UNIT'
initial=json.loads((out/'INITIAL_STATE.json').read_text());inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
assert git('rev-parse','HEAD').decode().strip()==initial['head']
index={p:sha(git('show',':'+p)) for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
assert index==inherited,'Inherited staging changed'
for n,v in json.loads((out/'SOURCE_MAP.json').read_text()).items():
    assert sha((root/v['source']).read_bytes())==sha((root/v['snapshot']).read_bytes())==v['sha256']
files=['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']
for tag in predecessors+[out.name]:
    d=root/'research/continuations'/tag
    files += [str(p.relative_to(root)) for p in sorted(d.rglob('*')) if p.is_file()]
    files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(tag+'-*')) if p.is_file()]
assert len(files)==len(set(files)) and not set(files)&set(inherited)
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):patterns=ast.literal_eval(node.value)
assert patterns
review={}
for name in files:
    p=root/name;assert not p.is_symlink() and p.suffix in {'.md','.json','.txt','.py','.lean','.log'}
    assert '.lake/' not in name and '__pycache__' not in name and '/D1Bound5Handoff/' not in name
    b=p.read_bytes();assert len(b)<=5*1024*1024
    s=b.decode('utf-8');assert not any(re.search(pattern,s) for pattern in patterns),'Credential-like material; value withheld'
    review[name]={'sha256':sha(b),'bytes':len(b)}
selfpath=str((out/'STAGING_REVIEW.json').relative_to(root));manifest=str((out/'STAGING_PATHS.txt').relative_to(root))
files += [selfpath,manifest];text='\n'.join(files)+'\n'
with (out/'STAGING_PATHS.txt').open('x') as f:f.write(text)
review[manifest]={'sha256':sha(text.encode()),'bytes':len(text.encode())}
record={'status':'REVIEWED_FOR_EXPLICIT_STAGING','time':datetime.now().astimezone().isoformat(),'files':files,'reviewed_bytes':review,'inherited_index_preserved':inherited,'scope':'Canonical verified sources and current evidence, plus preserved failed/successful predecessor trial records; no automatic accepted-root promotion','self_record_hash_note':'This explicit review record does not contain its own digest.'}
with (out/'STAGING_REVIEW.json').open('x') as f:f.write(json.dumps(record,indent=2)+'\n')
print('REVIEWED_EXPLICIT_PATHS',len(files),'bytes',sum(v['bytes'] for v in review.values()))
print('TRACKED_DIFF\n'+git('diff','--','STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md').decode())
