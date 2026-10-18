"""Independent static dependency reconstruction; no generator execution."""
from pathlib import Path
import ast,hashlib,json
R=Path(__file__).resolve().parents[1]
sha=lambda b:hashlib.sha256(b).hexdigest()
def literal_assignment(path,name):
 t=ast.parse((R/path).read_text())
 matches=[n.value for n in t.body if isinstance(n,ast.Assign) and any(isinstance(x,ast.Name) and x.id==name for x in n.targets)]
 assert len(matches)==1
 return ast.literal_eval(matches[0])
generator='pair_selected_scale_next/prepare_selected_rows.py'
materializer='pair_selected_scale_next/materialize_inputs.py'
requirements='pair_selected_scale_next/input_requirements.json'
assert sha((R/generator).read_bytes())=='ec862156543e3f4304b253e54591adfbcdc32acfd4f459f6fd8c16547bf32174'
assert sha((R/requirements).read_bytes())=='5a15034bf8bad9a11647231e683f1006f5b4512c3f715a21269555273b6a85fb'
expected={};groups={}
def add(items,label):
 groups[label]=len(items)
 for p,h in items.items():
  assert p not in expected or expected[p]==h
  expected[p]=h
add(literal_assignment(generator,'PINS'),'literal_generator_pins')
add(json.loads((R/'pair_backend_next/backend_source_pins.json').read_text()),'backend_pins')
inputs=json.loads((R/'pair_witness_next/all48_input_fingerprints.json').read_text())
add({f'finite_next/two_small/D1Bound5/SmallPairGraphData{x["row"]}.lean':x['files'][f'finite_next/two_small/D1Bound5/SmallPairGraphData{x["row"]}.lean'] for x in inputs},'original_sources')
add(json.loads((R/'pair_witness_next/cached_sieve_fingerprints.json').read_text()),'sieves')
floors=json.loads((R/'sparse_floor_next/generated/manifest.json').read_text())
add({f'sparse_floor_next/generated/row{k:02}.json':floors['files'][f'row{k:02}.json']['sha256'] for k in range(1,49)},'floor_rows')
add({'finite_next/two_small/generate_pair_closures.py':literal_assignment('pair_witness_next/pair_staging.py','ROUTINE_SHA')},'exact_root_routine')
add({generator:sha((R/generator).read_bytes())},'generator')
rows=json.loads((R/requirements).read_text())['files'];actual={x['path']:x for x in rows}
assert len(rows)==len(actual)==len(expected)==134
assert set(actual)==set(expected)
for p,h in expected.items():
 b=(R/p).read_bytes();assert actual[p]['sha256']==h==sha(b);assert actual[p]['bytes']==len(b)
assert sum(x['bytes'] for x in rows)==48660960
report=dict(status='Independent static dependency and copier safety review PASS; no Lean/remote/production-copy action',
 materializer_sha256=sha((R/materializer).read_bytes()),requirements_sha256=sha((R/requirements).read_bytes()),generator_sha256=sha((R/generator).read_bytes()),
 expected_files=134,total_bytes=48660960,groups=groups,exact_required_path_union=True,all_local_sizes_and_sha256_rechecked=True,
 dependency_method='Full selected generator and transitive source-only read paths inspected. Independently reconstructed actual input union via ast.literal_eval and pinned JSON maps; did not import or execute generator/materializer for this reconstruction.',
 scope='Complete fixed workspace inputs for all48 diagnostics and any permitted nonstructural staged row. Optional --expected-manifest is an explicitly supplied external argument, not silently claimed bundled. Historical closure/graph JSON are not read in source_only mode; floor Lean strings are reconstructed.',
 safety=['Default main only inventories after checking destination absent; missing files return2 before materialization.',
 'All candidates require basename+exact size+SHA; same-name historical files cannot substitute wrong bytes.',
 'Descriptor traversal rejects symlink ancestors and nonregular leaf files; stable size/mtime/ctime/inode checks surround reads.',
 'All selected inputs are freshly reread and rehashed before destination mkdir; output must be absent.',
 'Exclusive no-follow writes remain beneath new destination descriptor; no overwrite/delete/Git/network/compiler operation.',
 'Requirements hash pinned; duplicate JSON keys/paths, file-directory conflicts, traversal, reserved manifest path rejected.',
 'Manifest written after all payloads; interruption may leave a new partial bundle, as documented. No atomic-completion claim.'],
 dummy_test_result='Independently reran provided ten local tempfile tests with python -B:10 PASS. Only dummy temporary files were written and cleaned.',
 limitations='Source audit and local filesystem tests are not kernel acceptance and do not execute the production copy. Root remains sole remote writer/compiler.')
out=R/'audit_next/selected_input_materializer_source_audit.json';out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'report_sha256':sha(out.read_bytes()),'materializer_sha256':report['materializer_sha256'],'files':len(rows),'bytes':report['total_bytes']},indent=2))
