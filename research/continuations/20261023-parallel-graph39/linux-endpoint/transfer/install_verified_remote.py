"""Verify Linux evidence archive and install only exact graph39 source changes."""
from pathlib import Path,PurePosixPath
import base64,hashlib,io,json,zipfile,time
R=Path('/Users/tp/Lean/D1Bound5')
W=R/'research/continuations/20261023-parallel-graph39'
O=W/'linux-endpoint'
meta=json.loads((W/'LINUX_PACKAGE_MANIFEST.json').read_text())
archive=base64.b64decode((W/'linux_verified_package.b64').read_text())
assert hashlib.sha256(archive).hexdigest()==meta['archive_sha256']
z=zipfile.ZipFile(io.BytesIO(archive))
manifest=json.loads(z.read('MANIFEST.json'))
for name,h in manifest['files'].items():
 p=PurePosixPath(name)
 assert not p.is_absolute() and '..' not in p.parts
 assert hashlib.sha256(z.read(name)).hexdigest()==h
for name in z.namelist():
 target=O/name
 if target.exists():assert target.read_bytes()==z.read(name),str(target)
 else:
  target.parent.mkdir(parents=True,exist_ok=True)
  target.write_bytes(z.read(name))
verified=json.loads((O/'results-graph39-verified/VERIFICATION_SUMMARY.json').read_text())
assert verified['status']=='GRAPH39_ENDPOINT_SCOPED_VERIFICATION_PASS'
assert len(verified['installed_kernel_scopes'])==29
assert not json.loads((W/'OWNER.json').read_text())['active'],'MAC_CLOSURE_AUDIT_STILL_ACTIVE'
assert json.loads((W/'VERIFICATION_SUMMARY.json').read_text())['status']=='SCOPED_VERIFICATION_PASS'
for name,old in manifest['canonical_expected_before'].items():
 f=R/'D1Bound5'/name
 actual=hashlib.sha256(f.read_bytes()).hexdigest() if f.exists() else None
 assert actual in [old,manifest['canonical_new'][name]],(name,actual,old)
backup=W/'canonical-before-linux-install'
backup.mkdir(exist_ok=True)
for name,old in manifest['canonical_expected_before'].items():
 f=R/'D1Bound5'/name
 if f.exists() and hashlib.sha256(f.read_bytes()).hexdigest()==old:
  b=backup/name
  if b.exists():assert b.read_bytes()==f.read_bytes()
  else:b.write_bytes(f.read_bytes())
 data=(O/'changed_sources'/name).read_bytes()
 assert hashlib.sha256(data).hexdigest()==manifest['canonical_new'][name]
 f.write_bytes(data)
receipt={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
 'status':'VERIFIED_LINUX_GRAPH39_SOURCES_PERSISTED','canonical_new':manifest['canonical_new'],
 'linux_verification':str(O/'results-graph39-verified/VERIFICATION_SUMMARY.json'),
 'mac_closure_verification':str(W/'VERIFICATION_SUMMARY.json'),
 'mac_endpoint_artifacts_rebuilt':False,'git_index_mutated':False,
 'main_theorem_complete':False,'accepted_root_integration':False}
(W/'LINUX_INSTALL_RECEIPT.json').write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
print(json.dumps(receipt,indent=2))
