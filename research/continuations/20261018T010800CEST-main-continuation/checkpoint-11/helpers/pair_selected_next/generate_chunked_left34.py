"""Emit an optional16-head-block Left34 pilot; no data copy or compilation."""
from pathlib import Path
import argparse
import ast
import hashlib
import json
import re

ROOT=Path(__file__).resolve().parents[1]
HERE=Path(__file__).resolve().parent
PINS={
    'pair_literal_next/generated/SmallPairLiteralCachedData34.lean':
        '2b14c33742c58890230b20e7b3ee455905f4ac50c88dc86a4da3bd7719777af1',
    'pair_witness_next/PairSelectedFloorChunks.lean':
        'ae80a90f5c4d53ccbe66460627039e66ab249c7b13ce0401db6659ac4baaf02e',
    'pair_witness_next/PairSelectedFloorWitnesses.lean':
        '5627d261d76c8200c3ce7a8601856a8cef8aa9e7be044b0ebf81c7f060ce8b74',
    'pair_selected_next/generated/SmallPairSelectedData34.lean':
        '9a05216afd22493a58f74a21dd802492e7d8d57e0e80180cb8c7e7bd0d6e06c6',
}
sha=lambda b:hashlib.sha256(b).hexdigest()

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output-dir',type=Path,default=HERE/'chunked_left34')
parser.add_argument('--expected-manifest',type=Path)
args=parser.parse_args()
selected_manifest=json.loads((HERE/'generated/manifest.json').read_text())
selected_data=HERE/'generated/SmallPairSelectedData34.lean'
selected_pin=selected_manifest['files']['SmallPairSelectedData34.lean']['sha256']
assert selected_pin==PINS['pair_selected_next/generated/SmallPairSelectedData34.lean']
for rel,pin in PINS.items():assert sha((ROOT/rel).read_bytes())==pin,rel

literal=(ROOT/'pair_literal_next/generated/SmallPairLiteralCachedData34.lean').read_text()
literal_body=re.search(r'def leftCached\b.*? := \[(.*?)\n\]',literal,re.S).group(1)
left_size=len(re.findall(r'^  ⟨⟨',literal_body,re.M))
row_body=re.search(r'def leftRows\b.*? := \[(.*?)\n\]',selected_data.read_text(),re.S).group(1)
rows=ast.literal_eval('['+row_body+']')
assert left_size==len(rows)==selected_manifest['class_stats']['left']['vertices']==229
width=16
blocks=(left_size+width-1)//width
assert blocks==15

lines=['import D1Bound5.SmallPairLiteralCachedData34',
    'import D1Bound5.SmallPairSelectedData34',
    'import D1Bound5.PairSelectedFloorChunks','',
    'namespace D1Bound5.PairSelectedChunkedPilot34',
    'set_option maxRecDepth 100000','set_option maxHeartbeats 0','',
    '/-- Exact original left class. No coordinate or residue is duplicated. -/',
    'def cached00 : List (PairResidueVertex 1 2) := PairLiteralPilot34.leftCached',
    'def rows00 : List (ℕ × List ℕ) := PairSelectedPilot34.leftRows','']
for i in range(1,blocks+1):
    lines += [f'def cached{i:02} : List (PairResidueVertex 1 2) := cached{i-1:02}.drop {width}',
        f'def rows{i:02} : List (ℕ × List ℕ) := rows{i-1:02}.drop {width}','']
lines += ['/-- Full original vertex projection, checked separately from row work. -/',
    'theorem left_coverage_checked :',
    '    PairLiteralPilot34.leftCached.map PairResidueVertex.vertex =',
    '      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 := by',
    '  decide +kernel','',
    '/-- Every original cached signature, checked separately from row work. -/',
    'theorem left_signatures_checked :',
    '    (PairLiteralPilot34.leftCached.all fun x =>',
    '      decide (x.signature = pairCoordinateSignature smallPairSieve_1_2 x.vertex)) = true := by',
    '  decide +kernel','']
for i in range(blocks):
    lines += [f'/-- Heads {i*width} through {min((i+1)*width,left_size)-1}, each against its full actual tail. -/',
        f'theorem left_prefix_{i:02}_checked :',
        f'    pairSelectedFloorPrefixBool smallPairSieve_1_2 {width} cached{i:02} rows{i:02} = true := by',
        '  decide +kernel','']
lines += ['/-- After the15 complete blocks, both original lists are exhausted. -/',
    f'theorem left_remainder_{blocks:02}_checked :',
    f'    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached{blocks:02} rows{blocks:02} = true := by',
    '  rfl','']
for i in reversed(range(blocks)):
    lines += [f'theorem left_remainder_{i:02}_checked :',
        f'    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached{i:02} rows{i:02} = true :=',
        f'  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 {width}',
        f'    cached{i:02} rows{i:02} left_prefix_{i:02}_checked left_remainder_{i+1:02}_checked','']
lines += ['/-- Assemble proof constants; do not recompute a monolithic checker here. -/',
    'theorem left_certificate_checked :',
    '    pairSelectedFloorIndependentCertificateBool smallPairSieve_1_2',
    '      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1',
    '      PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows = true := by',
    '  apply Bool.and_eq_true_iff.mpr',
    '  refine ⟨?_, Bool.and_eq_true_iff.mpr',
    '    ⟨left_signatures_checked, left_remainder_00_checked⟩⟩',
    '  simp [left_coverage_checked]','',
    '/-- Exactly the original left independent-class target. -/',
    'theorem left_checked :',
    '    pairIndependentBool smallPairSieve_1_2',
    '      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 = true :=',
    '  pairIndependentBool_of_selected_floor_certificate (by decide) smallPairSieve_1_2',
    '    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1',
    '    PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows left_certificate_checked','',
    'end D1Bound5.PairSelectedChunkedPilot34','']
text='\n'.join(lines)
output=dict(sha256=sha(text.encode()),bytes=len(text.encode()))
if args.expected_manifest:
    expected=json.loads(args.expected_manifest.read_text())
    assert expected['output']==output
    assert expected['input_pins']==PINS
args.output_dir.mkdir(parents=True,exist_ok=True)
target=args.output_dir/'SmallPairSelectedChunkedLeft34.lean'
target.write_text(text)
manifest=dict(status='Optional new chunked pilot, uncompiled; no original source modified',
    namespace='D1Bound5.PairSelectedChunkedPilot34',width=width,heads=left_size,blocks=blocks,
    intervals=[[i*width,min((i+1)*width,left_size)] for i in range(blocks)],
    prefix_checker_calls=blocks,other_kernel_decisions=['full vertex coverage','full signature validation'],
    terminal_remainder='rfl after240 head drops on both229-entry lists',
    input_pins=PINS,generator_sha256=sha(Path(__file__).read_bytes()),output=output,
    integer_data_duplicated=False,full_actual_tails_preserved=True,
    endpoint='Exact original pairIndependentBool on Left34; assembly uses proved constants')
(args.output_dir/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps(manifest,indent=2))
