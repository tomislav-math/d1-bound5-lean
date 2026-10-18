"""Separate literal-class data fallback; never edit or compile passed sources.

The accepted sparse certificate and original split-vertex coverage target are
unchanged. Only its cached-list argument becomes a direct constructor list.
"""
from pathlib import Path
import argparse
import ast
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--original-file", type=Path, default=ROOT / "finite_next/two_small/D1Bound5/SmallPairGraphData34.lean")
parser.add_argument("--accepted-dir", type=Path, default=ROOT / "pair_backend_next/staged_pilots_floor_fix/D1Bound5")
parser.add_argument("--sieve-file", type=Path, default=ROOT / "finite_fast_next/sieves/SmallPairSieve_1_2.lean")
parser.add_argument("--checker-file", type=Path, default=ROOT / "pair_witness_next/PairCachedFloorWitnesses.lean")
parser.add_argument("--output-dir", type=Path, default=HERE / "generated")
parser.add_argument("--expected-manifest", type=Path)
args = parser.parse_args()
sha = lambda b: hashlib.sha256(b).hexdigest()
pins = {
    args.original_file: "1e469696e498732377849734e4c3d693c95bc813fde9070fa40208039cb2b565",
    args.accepted_dir / "SmallPairGraphInputs34.lean": "80081fbe80d8267dc85a4c97cf17a7c063a9e61364395f31e58acc93a3d048b9",
    args.accepted_dir / "SmallPairGraphCachedData34.lean": "75ece134d8fff706db6a7afacf437fe93d2227ee0cb5e26fb0ae0d10478de03d",
    args.accepted_dir / "SmallPairFloorWitnessData34.lean": "4228760f9ba2009598b01b33ce40c9dcabd2bacaeb3f1cd9c95e2ba31163b073",
    args.sieve_file: "0e06eb108afce10f63dd87b8402973d477820e1a7d76cfa29f8e0be3d77d5235",
    args.checker_file: "344ed1b90b84f82b59da3776e3d6e5f30a12a3e268e2e655e2aac504ca085b06",
}
for path, digest in pins.items():
    assert sha(path.read_bytes()) == digest, str(path)
original = args.original_file.read_text()
inputs = (args.accepted_dir / "SmallPairGraphInputs34.lean").read_text()
cached = (args.accepted_dir / "SmallPairGraphCachedData34.lean").read_text()
sieve_source = args.sieve_file.read_text()
pattern = r"def smallPairLarge_34 .*? := \[(.*?)\n\]"
literal = re.search(pattern, original, re.S).group(1)
assert re.search(pattern, inputs, re.S).group(1) == literal
pair_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
vertices = [tuple(map(int, x)) for x in re.findall(pair_pattern, literal)]
assert re.sub(pair_pattern, "", literal).replace(",", "").strip() == ""
assert len(vertices) == 457
colors = int(re.search(r"def colors : ℕ := (\d+)", inputs).group(1))
signature_literal = re.search(r"def cachedSignatures .*? := (\[.*?\n\])", cached, re.S).group(1)
signatures = ast.literal_eval(signature_literal)
sieve_literal = re.search(r"def smallPairSieve_1_2 .*? := \[(.*?)\n\]", sieve_source, re.S).group(1)
sieve_pattern = r"\((\d+),\s*(smallPairMask_1_2_\d+)\)"
moduli = [int(k) + 1 for k, _ in re.findall(sieve_pattern, sieve_literal)]
assert re.sub(sieve_pattern, "", sieve_literal).replace(",", "").strip() == ""
assert len(moduli) == 25
assert signatures == [[(a % p, b % p) for p in moduli] for a, b in vertices]
classes = [[i for i in range(len(vertices)) if (colors >> i) & 1 == c] for c in (0, 1)]
assert list(map(len, classes)) == [229, 228]

data = '''import D1Bound5.SmallPairGraphInputs34
import D1Bound5.PairCachedResidues
import D1Bound5.SmallPairSieve_1_2

namespace D1Bound5.PairLiteralPilot34
set_option maxRecDepth 100000

'''
for name, indices in zip(("leftCached", "rightCached"), classes):
    entries = []
    for i in indices:
        a, b = vertices[i]
        sig = ", ".join(f"({u}, {v})" for u, v in signatures[i])
        entries.append(f"  ⟨⟨{a}, {b}⟩, [{sig}]⟩")
    data += f"/-- Exact existing color class, stored without split or zip redexes. -/\ndef {name} : List (PairResidueVertex 1 2) := [\n" + ",\n".join(entries) + "\n]\n\n"
data += "end D1Bound5.PairLiteralPilot34\n"
files = {"SmallPairLiteralCachedData34.lean": data}
for side, projection in [("Left", 1), ("Right", 2)]:
    lower = side.lower()
    files[f"SmallPairLiteral{side}34.lean"] = f'''import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.PairCachedFloorWitnesses
import D1Bound5.SmallPairFloorWitnessData34

namespace D1Bound5.PairLiteralPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {lower}_certificate_checked :
    pairCachedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{projection}
      {lower}Cached PairFloorWitness34.{lower}Rows = true := by
  decide +kernel

/-- Same original split-class target; the accepted generic checker is unchanged. -/
theorem {lower}_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{projection} = true :=
  pairIndependentBool_of_cached_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{projection}
    {lower}Cached PairFloorWitness34.{lower}Rows {lower}_certificate_checked

end D1Bound5.PairLiteralPilot34
'''
outputs = {name: {"sha256": sha(text.encode()), "bytes": len(text.encode())}
           for name, text in files.items()}
if args.expected_manifest:
    expected = json.loads(args.expected_manifest.read_text())
    assert outputs == expected["files"], "Literal fallback source fingerprint mismatch"
args.output_dir.mkdir(parents=True, exist_ok=True)
for name, text in files.items():
    (args.output_dir / name).write_text(text)
report = {
    "status": "Uncompiled separate fallback; no accepted source edits or speedup claim",
    "source_pins_by_filename": {p.name: h for p, h in pins.items()},
    "generator_sha256": sha(Path(__file__).read_bytes()),
    "class_sizes": list(map(len, classes)),
    "original_vertex_order_preserved": True,
    "canonical_signatures_checked_against_original_sieve": True,
    "old_split_vertex_coverage_and_signature_checks_retained": True,
    "checker_and_floor_data_unchanged": True,
    "class_original_indices": classes,
    "files": outputs,
}
(args.output_dir / "manifest.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps({k: v for k, v in report.items() if k not in ["source_pins_by_filename", "class_original_indices"]}, indent=2))
