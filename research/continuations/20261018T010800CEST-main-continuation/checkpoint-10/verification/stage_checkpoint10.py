"""Stage only the reviewed research snapshot and verify every indexed blob."""
from pathlib import Path, PurePosixPath
import datetime,hashlib,json,subprocess
ROOT=Path('/Users/tp/Lean/D1Bound5')
RUN=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
def git(*args):
    return subprocess.run(['git',*args],cwd=ROOT,check=True,capture_output=True).stdout
assert git('rev-parse','HEAD').decode().strip()=='0d107611364a193651e5e895d2675d31766eee3a'
assert git('branch','--show-current').decode().strip()=='main'
assert git('remote','get-url','origin').decode().strip()=='https://github.com/tomislav-math/d1-bound5-lean.git'
assert not git('diff','--name-only') and not git('diff','--cached','--name-only')
info=json.loads(subprocess.run(['/Users/tp/.local/bin/gh','api','repos/tomislav-math/d1-bound5-lean'],cwd=ROOT,check=True,capture_output=True).stdout)
assert info['private'] is True and info['permissions']['push'] is True
git('fetch','origin','main')
assert git('rev-parse','HEAD')==git('rev-parse','origin/main')
rows=json.loads((RUN/'checkpoint-10-reviewed-paths.json').read_text())
expected={r['path']:r['sha256'] for r in rows}
assert len(expected)==len(rows)
prefix='research/continuations/20261018T010800CEST-main-continuation/checkpoint-10/'
record='records/runs/20261018T010800CEST-main-continuation-CHECKPOINT-10.md'
for name,digest in expected.items():
    rel=PurePosixPath(name)
    assert not rel.is_absolute() and '..' not in rel.parts and str(rel)==name,name
    assert not any(ord(c)<32 for c in name),name
    assert name.startswith(prefix) or name==record,name
    assert not (ROOT/name).is_symlink(),name
    assert (ROOT/name).resolve().is_relative_to(ROOT.resolve()),name
    assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest,name
spec=RUN/'checkpoint-10-pathspec.nul'
spec.write_bytes(b''.join(n.encode()+b'\0' for n in sorted(expected)))
git('--literal-pathspecs','add','--pathspec-from-file='+str(spec),'--pathspec-file-nul')
changed=git('diff','--cached','--name-only','-z').split(b'\0')
assert {x.decode() for x in changed if x}==set(expected)
index={}
for row in git('ls-files','--stage','-z').split(b'\0'):
    if not row:continue
    meta,name=row.split(b'\t',1)
    if name.decode() in expected:
        mode,oid,stage=meta.split()
        assert stage==b'0' and mode==b'100644'
        index[name.decode()]=oid.decode()
assert set(index)==set(expected)
p=subprocess.Popen(['git','cat-file','--batch'],cwd=ROOT,stdin=subprocess.PIPE,stdout=subprocess.PIPE)
try:
    for name,oid in index.items():
        p.stdin.write((oid+'\n').encode());p.stdin.flush()
        header=p.stdout.readline().split()
        assert header[0].decode()==oid and header[1]==b'blob'
        data=p.stdout.read(int(header[2]));assert p.stdout.read(1)==b'\n'
        assert hashlib.sha256(data).hexdigest()==expected[name],name
finally:
    p.stdin.close();assert p.wait()==0
receipt={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'head':git('rev-parse','HEAD').decode().strip(),
         'private':True,'indexed_files':len(index),'indexed_sha256_verified':True,'scope':'UNACCEPTED RESEARCH DELTA'}
(RUN/'checkpoint-10-index-review.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt))
print(git('diff','--cached','--stat').decode().splitlines()[-1])
