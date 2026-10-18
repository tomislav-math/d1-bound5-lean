"""Prepare a separate Triangle34 adapter for the selected-mask class proofs.

The frozen literal adapter, active closure, original graph data and every
consumer remain untouched.  Only two imports and two proof references change.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--literal-triangle", type=Path, default=ROOT / "pair_literal_next/integration/SmallPairGraphTriangle34.lean")
parser.add_argument("--accepted-dir", type=Path, default=ROOT / "pair_backend_next/staged_pilots_floor_fix/D1Bound5")
parser.add_argument("--selected-dir", type=Path, default=HERE / "generated")
parser.add_argument("--output-dir", type=Path, default=HERE / "integration")
parser.add_argument("--expected-manifest", type=Path)
args = parser.parse_args()
sha = lambda data: hashlib.sha256(data).hexdigest()
pins = {
    args.literal_triangle: "21f5be42adf0b7bcc0160e74e6c766e30bd0f1546af912e11caa489bca3630c0",
    args.accepted_dir / "SmallPairGraphClosure34.lean": "a5f83b9e9c8233fc7e1eafda5a5ecb640388506da389699f4913e630e946b9f2",
    args.accepted_dir / "SmallPairGraphData34.lean": "d8ad1aa220dcaed2a832293313c73ab7450749353b1a506e9fa01fa978593a38",
    args.selected_dir / "SmallPairSelectedLeft34.lean": "a61269d7e6cc32e6c11a9f0a7b6c500c19296dfdd23519ab6c029566a5f20360",
    args.selected_dir / "SmallPairSelectedRight34.lean": "38cc12845f3b274a9a1afeb50ab3028782d4a4f892c769cc50c21e75c300a512",
}
for path, digest in pins.items():
    assert sha(path.read_bytes()) == digest, f"Frozen source mismatch: {path}"
old = args.literal_triangle.read_text()
new = old
for before, after in [
    ("import D1Bound5.SmallPairLiteralLeft34", "import D1Bound5.SmallPairSelectedLeft34"),
    ("import D1Bound5.SmallPairLiteralRight34", "import D1Bound5.SmallPairSelectedRight34"),
    ("PairLiteralPilot34.left_checked", "PairSelectedPilot34.left_checked"),
    ("PairLiteralPilot34.right_checked", "PairSelectedPilot34.right_checked"),
]:
    assert new.count(before) == 1, before
    new = new.replace(before, after)
statement = r"theorem smallPairNoTriangle_34_checked\b(.*?) :="
assert re.findall(statement, old, re.S) == re.findall(statement, new, re.S)
output_digest = sha(new.encode())
output_bytes = len(new.encode())
if args.expected_manifest:
    expected = json.loads(args.expected_manifest.read_text())
    assert expected["output_sha256"] == output_digest
    assert expected["output_bytes"] == output_bytes
args.output_dir.mkdir(parents=True, exist_ok=True)
target = args.output_dir / "SmallPairGraphTriangle34.lean"
target.write_text(new)
for path, digest in pins.items():
    assert sha(path.read_bytes()) == digest, "Input changed while preparing adapter"
manifest = {
    "status": "Uncompiled separate selected-mask triangle adapter; no accepted or active source replaced",
    "public_theorem_name": "D1Bound5.smallPairNoTriangle_34_checked",
    "public_theorem_type_unchanged": True,
    "original_split_vertices_colors_and_sieve_unchanged": True,
    "closure_graphdata_and_literal_adapter_unchanged": True,
    "input_pins_by_filename": {p.name: digest for p, digest in pins.items()},
    "generator_sha256": sha(Path(__file__).read_bytes()),
    "output_sha256": output_digest,
    "output_bytes": output_bytes,
    "unchanged_consumer": "Existing SmallPairGraphData34 imports the same Triangle34 module name",
    "dependencies": ["SmallPairSelectedLeft34.lean", "SmallPairSelectedRight34.lean"],
}
(args.output_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
print(json.dumps(manifest, indent=2))
