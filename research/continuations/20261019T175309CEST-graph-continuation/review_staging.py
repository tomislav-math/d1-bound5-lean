"""Prepare exact reviewed path manifest; Git operations here are read-only."""
from pathlib import Path
from datetime import datetime
import ast,hashlib,json,re,subprocess
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
prev=root/'research/continuations/20261019T171838CEST-three-small-exclusion'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*a):return subprocess.check_output(['git',*a],cwd=root)
initial=json.loads((out/'INITIAL_STATE.json').read_text())
assert git('rev-parse','HEAD').decode().strip()==initial['head']
index={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
assert index==initial['inherited_index']
for folder in [out,prev]:
    summary=json.loads((folder/'VERIFICATION_SUMMARY.json').read_text())
    for item in json.loads((folder/'SOURCE_MAP.json').read_text()).values():
        assert sha(root/item['source'])==sha(root/item['snapshot'])==item['sha256']
files=['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']
for folder in [out,prev]:
    files += [str(p.relative_to(root)) for p in sorted(folder.rglob('*')) if p.is_file()]
for prefix in [out.name,prev.name,'20261019T174648CEST-access-observation']:
    files += [str(p.relative_to(root)) for p in sorted((root/'records/runs').glob(prefix+'-*')) if p.is_file()]
assert len(files)==len(set(files)) and not set(files)&set(index)
patterns=None
for node in ast.parse((root/'scripts/git_sync_preflight.py').read_text()).body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOKEN_PATTERNS' for t in node.targets):patterns=ast.literal_eval(node.value)
assert patterns
review={};raw_whitespace=[]
for name in files:
    p=root/name
    assert not p.is_symlink() and p.suffix in {'.md','.json','.py','.lean','.log','.txt'}
    assert p.stat().st_size<=5*1024*1024 and '.lake/' not in name and '__pycache__' not in name
    text=p.read_text();assert not any(re.search(x,text) for x in patterns),'Credential-shaped content; value withheld'
    if any(line.rstrip()!=line for line in text.splitlines()):
        assert p.suffix=='.log','Non-log formatting must be reviewed: '+name
        raw_whitespace.append(name)
    review[name]={'sha256':sha(p),'bytes':p.stat().st_size}
manifest=str((out/'STAGING_PATHS.txt').relative_to(root));reviewfile=str((out/'STAGING_REVIEW.json').relative_to(root))
files += [manifest,reviewfile]
text='\n'.join(files)+'\n';(out/'STAGING_PATHS.txt').write_text(text)
review[manifest]={'sha256':sha(out/'STAGING_PATHS.txt'),'bytes':len(text.encode())}
(out/'STAGING_REVIEW.json').write_text(json.dumps({'time':datetime.now().astimezone().isoformat(),'files':files,'reviewed_bytes':review,'raw_logs_preserved_with_whitespace':raw_whitespace,'inherited_index':index,'scope':'Current graph repair plus exact recovered predecessor and access observations; not bulk acceptance of untracked project sources.'},indent=2)+'\n')
print('REVIEWED_EXPLICIT_PATHS',len(files),'RAW_LOG_WHITESPACE_EXCEPTIONS',len(raw_whitespace))
print('TRACKED_DIFF',git('diff','--stat').decode())
