"""Read and review this completed batch before explicit plain Git staging.
Writes only its own review record; all Git commands here are read-only.
"""
from pathlib import Path
from datetime import datetime
import ast,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
summary=json.loads((out/'VERIFICATION_SUMMARY.json').read_text());assert summary['status']=='COMPLETED_UNIT'
source_map=json.loads((out/'SOURCE_MAP.json').read_text())
for v in source_map.values():
    assert sha(root/v['source'])==sha(root/v['snapshot'])==v['sha256']
inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
index={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
assert index==inherited,'Preserve another writer index'
assert git('rev-parse','HEAD').decode().strip()==json.loads((out/'INITIAL_STATE.json').read_text())['head']
files=['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']
files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(out.name+'-*')) if p.is_file()]
files += [str(p.relative_to(root)) for p in sorted(out.rglob('*')) if p.is_file()]
assert len(files)==len(set(files)) and not set(files)&set(inherited)
allowed_suffixes={'.md','.json','.py','.lean','.log'}
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):patterns=ast.literal_eval(node.value)
assert patterns
review={}
for name in files:
    p=root/name;assert not p.is_symlink() and p.suffix in allowed_suffixes and p.stat().st_size<=5*1024*1024
    b=p.read_bytes();text=b.decode('utf-8')
    assert not any(re.search(pattern,text) for pattern in patterns),'Credential-shaped content; values withheld'
    assert '.lake/' not in name and '__pycache__' not in name and '/D1Bound5Handoff/' not in name
    review[name]={'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
selfpath=str((out/'STAGING_REVIEW.json').relative_to(root));files.append(selfpath)
record={'status':'REVIEWED_FOR_EXPLICIT_STAGING','time':datetime.now().astimezone().isoformat(),'files':files,'reviewed_bytes':review,'inherited_index_preserved':inherited,'proof_verification':str((out/'VERIFICATION_SUMMARY.json').relative_to(root)),'self_record_hash_note':'This review record is included explicitly but cannot contain its own digest.'}
with (out/'STAGING_REVIEW.json').open('x') as f:f.write(json.dumps(record,indent=2)+'\n')
print('REVIEWED_PATHS',len(files),'TARGETS',len(summary['targets']))
print('RUN_RECORDS',[Path(x).name for x in files if x.startswith('records/runs/')])
print('COMMON_FILES',[p.name for p in sorted(out.iterdir()) if p.is_file() and not p.name.startswith(('PellLight','PellCertificate'))])
print('TRACKED_DIFF\n'+git('diff','--','STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md').decode())
