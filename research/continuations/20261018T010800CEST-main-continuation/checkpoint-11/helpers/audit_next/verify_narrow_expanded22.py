"""Independent source-only review; does not import/execute transform or Lean."""
from pathlib import Path
import ast, hashlib, json, re
root=Path(__file__).resolve().parents[1]
old=root/'pair_backend_next/expanded22_timeout_fallback'
new=root/'pair_inputs_narrow_next/expanded22'
sha=lambda b:hashlib.sha256(b).hexdigest()
helper=root/'pair_inputs_narrow_next/narrow_expanded_inputs.py'
assert sha(helper.read_bytes())=='4c120fa958983bdc2f39d1fd38db30738f541f1372d28ac5de5b035ebb113e78'
ast.parse(helper.read_text())
assert sha((old/'manifest.json').read_bytes())=='8dbdf530c318fd2d4f52149ebb78af2ababf65e18ce4205e0c2c50044bbddc20'
assert sha((new/'manifest.json').read_bytes())=='ea0c17c70258d31f49a9fab572c8e4a587aaa3c6931257d0495cd58b703bf710'
assert (new/'source_manifest.before.json').read_bytes()==(old/'manifest.json').read_bytes()
base=json.loads((old/'manifest.json').read_text())['results'][0]['files']
report=json.loads((new/'manifest.json').read_text())
assert set(base)==set(report['files'])
assert {str(p.relative_to(new)) for p in (new/'D1Bound5').glob('*.lean')}==set(base)
allbefore=[];allafter=[];checks=[]
for name,pin in base.items():
 before=(old/name).read_bytes();after=(new/name).read_bytes()
 assert sha(before)==pin['sha256'] and len(before)==pin['bytes']
 match=re.match(rb'(?:import [^\n]+\n)+',before); assert match
 imps=match.group(); body=before[match.end():]
 if name.endswith('Inputs22.lean'):
  assert imps==b'import D1Bound5.SmallPairGraphCheck\n'
  assert after==b'import D1Bound5.Coordinates\n'+body
 elif name.endswith('Arithmetic22.lean'):
  assert imps==b'import D1Bound5.SmallPairGraphInputs22\nimport D1Bound5.TwoSmallSeedDisks\n'
  assert after==imps+b'import D1Bound5.SmallPairGraphCheck\n'+body
 else: assert after==before
 end=re.match(rb'(?:import [^\n]+\n)+',after).end()
 assert after[end:]==body
 evidence=report['files'][name]
 assert evidence['pre_sha256']==sha(before) and evidence['post_sha256']==sha(after)
 assert evidence['body_sha256']==sha(body)
 checks.append(dict(file=name,pre_sha256=sha(before),post_sha256=sha(after),bytes=len(after),body_byte_identical=True,file_byte_identical=before==after))
 allbefore.append(before.decode());allafter.append(after.decode())
assert sum(x['bytes'] for x in checks)==1664515
assert sum(x['file_byte_identical'] for x in checks)==4
before='\n'.join(allbefore);after='\n'.join(allafter)
original=(root/'finite_next/two_small/D1Bound5/SmallPairGraphData22.lean').read_text()
public=['smallPairSeeds_22_checked','smallPairFilter_22_checked','smallPairLarge_22_count','smallPairClosure_22_checked','smallPairNoTriangle_22_checked']
for name in public:
 pat=rf'theorem {name}\b(.*?) :='
 assert len(re.findall(pat,original,re.S))==1
 assert re.findall(pat,original,re.S)==re.findall(pat,before,re.S)==re.findall(pat,after,re.S)
inputs=(new/'D1Bound5/SmallPairGraphInputs22.lean').read_text()
assert re.findall(r'^def (\S+) :',inputs,re.M)==['smallPairA_22','smallPairB_22','smallPairClosure_22','smallPairLarge_22','colors']
assert not re.search(r'^(theorem|axiom|instance|noncomputable|opaque|abbrev) ',inputs,re.M)
local_import_sources=['pair_witness_next/PairClosureWitness.lean','pair_witness_next/PairClosureIndexedWitness.lean','pair_structural_next/PairTraceZeroGraph.lean','pair_structural_next/PairGraphNoThreeTransfer.lean','finite_next/extensions/D1Bound5/PairExtensionCore.lean','finite_next/two_small/D1Bound5/SmallPairGraphCheck.lean']
result=dict(status='Independent source/import-availability review PASS; no compilation, installation or remote mutation',
 helper_sha256=sha(helper.read_bytes()),base_manifest_sha256=sha((old/'manifest.json').read_bytes()),variant_manifest_sha256=sha((new/'manifest.json').read_bytes()),
 helper_review='Full source read and ast.parse only; helper not executed. Checks pinned source manifest and all source hashes/lengths, literal-only Inputs schema, exactly two import changes, disjoint new output and accepted-pilot exclusions before writing; freezes original manifest and rechecks original inputs afterward.',
 exact_changes=['Inputs replaces only SmallPairGraphCheck import with Coordinates','Arithmetic adds explicit SmallPairGraphCheck import'],
 all_six_bodies_byte_identical=True,other_four_files_byte_identical=True,original_five_public_theorem_types_exact=True,
 coordinates_read=dict(device='788d1b22-4569-4161-bfbe-d886d48c6a75',path='/Users/tp/Lean/D1Bound5/D1Bound5/Coordinates.lean',sha256='da0cb0c42a6044e813dcdaaa1831735e6baddba8fa16b037f5289e53bcfae065',bytes=2477),
 import_availability=['Actual remote Coordinates imports QuadraticAlgebra.Basic and defines D1Bound5.QuadInt plus its namespace. Inputs contains only five literal coordinate/list/Nat definitions; no graph checker or theorem is used there.',
 'Arithmetic explicitly restores SmallPairGraphCheck, retaining TwoSmallSeedDisks for seedRootDisk_1_1.',
 'WitnessData explicitly imports PairClosureWitness, which defines PairRootWitness and imports PairExtensionCore. Indexed closure imports PairClosureIndexedWitness; PairExtensionCore defines pairClosureBool.',
 'Triangle explicitly imports PairTraceZeroGraph, which imports PairGraphNoThreeTransfer, which explicitly imports SmallPairGraphCheck. Sieve import is unchanged.',
 'GraphData retains all three theorem-owner imports. No generated import cycle or removed public theorem results.'],
 local_dependency_sources={p:sha((root/p).read_bytes()) for p in local_import_sources},
 files=checks,total_source_bytes=1664515,
 limitation='Source-level availability and preservation only; Lean elaboration and kernel computations remain coordinator gates. The import reduction makes no runtime or final-main completion claim.')
out=root/'audit_next/narrow_expanded22_review.json';out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(dict(status=result['status'],report=str(out.relative_to(root)),report_sha256=sha(out.read_bytes()),variant_manifest_sha256=result['variant_manifest_sha256']),indent=2))
