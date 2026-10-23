"""Archive current verified graph39 changes and evidence for the private repository."""
from pathlib import Path
import base64,hashlib,io,json,zipfile,sys
R=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R))
import guarded_general as g
T=R/'graph39-transfer'
V=R/'results-graph39-verified'
verified=json.loads((V/'VERIFICATION_SUMMARY.json').read_text())
assert verified['status']=='GRAPH39_ENDPOINT_SCOPED_VERIFICATION_PASS'
assert g.closure('SmallPairGraphData39')==verified['source_closure']
assert {n:g.sha(g.artifact(n)) for n in verified['artifacts']}==verified['artifacts']
assert g.external(verified['source_closure'])==verified['external_import_artifacts']
(T/'ENDPOINT_REVIEW.md').write_text('''# Graph39 verified endpoint continuation

The final graph39 endpoint has a guarded Linux build, exact original-type audit,
transitive-axiom audit, and 29 scoped installed-kernel replays. The authoritative
receipt is `results-graph39-verified/VERIFICATION_SUMMARY.json`. This is an endpoint
milestone; it does not claim a completed MainTheorem or accepted root integration.

The mathematical certificate is unchanged: all 915 closure rows, original global
indices and both signs are retained, with 914 filtered vertices and all 458 left
and 456 right independence heads. All 28 original public declarations retain their
exact types; 21 additional helper types were checked. The original raw cached-data
literals are preserved, and `leftCached_eq` and `rightCached_eq` were proved by Lean
against those exact raw lists.

The compiled source representation adds noncomputable modifiers to the two raw
cached-data declarations; splits the exact 458 ordered left cached rows into
128/128/128/74 chunks; and adds noncomputable modifiers to four left cached aliases,
matching the existing right aliases. Every original cached row was verified equal
byte-for-byte, ignoring only an optional final comma. These changes preserve types,
values, index order, bounds, and both-sign coverage.

Two bounded 240-second Linux left-literal attempts timed out. Their source and logs
are retained. A subsequent explicit dependsOnNoncomputable compiler error was fixed
with modifier-only alias changes. The first audit harness needed a noncomputable
section for Type-valued examples; its failure is retained, followed by the passing
exact-type audit. Historical Mac evidence is not reclassified as current Linux
evidence. Fresh guarded compilation kernel-checks rebuilt unchanged proof helpers;
the final root fresh replay remains a separate integration obligation.

The Mac separately completed all 915 original closure rows, exact closure-type and
axiom audit, and 15 scoped kernel replays. Source persistence copies Lean sources and
evidence only. It does not copy Linux artifacts onto the Mac, mutate the Git index,
or claim a fresh Mac endpoint build.
''')
names=['SmallPairGraphArithmetic39','SmallPairRawSelectedData39LeftCached',
 'SmallPairRawSelectedData39LeftRows','SmallPairRawSelectedData39RightCached',
 'SmallPairRawSelectedData39RightRows','SmallPairRawSelectedData39',
 'SmallPairLightAssembly39','SmallPairGraphTriangle39','SmallPairGraphData39',
 'SmallPairLightData39LeftCached','SmallPairLightAdaptiveData39']+[f'SmallPairLightData39LeftCachedChunk{i:02d}' for i in range(4)]
before={n+'.lean':None for n in names}
before['SmallPairGraphData39.lean']='6976f83483d1c3da31e5c4aef54dfded87ee84ea446b7e6814a9507ee3cc20c4'
before['SmallPairLightData39LeftCached.lean']='f3403240a8fc0fada4cd06e9c1e7c768ed130491543cf638fb05badb1916246d'
before['SmallPairLightAdaptiveData39.lean']='db687f29c65ea8793a9fb446dd19fa00a13c08af8920acbedac9f015a17dfa03'
files={f'changed_sources/{n}.lean':g.src(n).read_bytes() for n in names}
for directory in ['results-graph39','results-graph39-recovery','results-graph39-split','results-graph39-adaptive','results-graph39-verified']:
 for f in (R/directory).glob('*'):
  if f.is_file():files[f'{directory}/{f.name}']=f.read_bytes()
for f in T.glob('*'):
 if f.is_file() and f.suffix in ['.json','.py','.log','.lean','.md']:
  files['transfer/'+f.name]=f.read_bytes()
for f in (T/'failures').rglob('*'):
 if f.is_file():files['transfer/failures/'+str(f.relative_to(T/'failures'))]=f.read_bytes()
files['tools/verify_graph39_local.py']=(R/'verify_graph39_local.py').read_bytes()
files['tools/guarded_general.py']=(R/'guarded_general.py').read_bytes()
hashes={n:hashlib.sha256(b).hexdigest() for n,b in files.items()}
manifest={'files':hashes,'canonical_expected_before':before,
 'canonical_new':{n+'.lean':g.sha(g.src(n)) for n in names},
 'evidence_platform':'Linux x86_64 Lean4.33.1','mac_artifacts_rebuilt':False,
 'git_index_mutated':False,'main_theorem_complete':False,'accepted_root_integration':False}
files['MANIFEST.json']=(json.dumps(manifest,indent=2,sort_keys=True)+'\n').encode()
buffer=io.BytesIO()
with zipfile.ZipFile(buffer,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
 for name,body in files.items():z.writestr(name,body)
payload=base64.b64encode(buffer.getvalue()).decode()
(T/'verified_package.b64').write_text(payload)
meta={'archive_bytes':len(buffer.getvalue()),'base64_chars':len(payload),
 'archive_sha256':hashlib.sha256(buffer.getvalue()).hexdigest(),
 'files':len(files),'canonical_source_changes':len(names)}
(T/'PACKAGE_MANIFEST.json').write_text(json.dumps(meta,indent=2)+'\n')
print(json.dumps(meta,indent=2))
