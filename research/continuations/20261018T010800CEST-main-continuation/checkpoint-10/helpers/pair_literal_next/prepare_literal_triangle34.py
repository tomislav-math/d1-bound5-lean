"""Prepare only the proof-only Triangle34 adapter for literal class proofs.

The active closure, arithmetic and GraphData aggregator are never written.
The resulting file is an optional replacement under the same module name.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--accepted-dir", type=Path, default=ROOT / "pair_backend_next/staged_pilots_floor_fix/D1Bound5")
parser.add_argument("--literal-dir", type=Path, default=HERE / "generated")
parser.add_argument("--output-dir", type=Path, default=HERE / "integration")
args = parser.parse_args()
sha = lambda b: hashlib.sha256(b).hexdigest()
pins = {
    args.accepted_dir / "SmallPairGraphTriangle34.lean": "ee1d0b12d916ba222e08b4b498244c450e380b6bcb43def23bf02d7d728c5a22",
    args.accepted_dir / "SmallPairGraphClosure34.lean": "a5f83b9e9c8233fc7e1eafda5a5ecb640388506da389699f4913e630e946b9f2",
    args.accepted_dir / "SmallPairGraphData34.lean": "d8ad1aa220dcaed2a832293313c73ab7450749353b1a506e9fa01fa978593a38",
    args.literal_dir / "SmallPairLiteralLeft34.lean": "9511792d854b79e3a4294c14e3605ffad6c0fd83b17a469ffdd7f2a2af3cbaa6",
    args.literal_dir / "SmallPairLiteralRight34.lean": "70d44655f88f660ed032bbea9fda6ef02dc359fff00781260c525441ceb63f40",
}
for path, digest in pins.items():
    assert sha(path.read_bytes()) == digest, str(path)
old = (args.accepted_dir / "SmallPairGraphTriangle34.lean").read_text()
new = old
for a, b in [
    ("import D1Bound5.SmallPairGraphLeft34", "import D1Bound5.SmallPairLiteralLeft34"),
    ("import D1Bound5.SmallPairGraphRight34", "import D1Bound5.SmallPairLiteralRight34"),
    ("PairGraphPrepared34.left_checked", "PairLiteralPilot34.left_checked"),
    ("PairGraphPrepared34.right_checked", "PairLiteralPilot34.right_checked"),
]:
    assert new.count(a) == 1, a
    new = new.replace(a, b)
statement = r"theorem smallPairNoTriangle_34_checked\b(.*?) :="
assert re.findall(statement, old, re.S) == re.findall(statement, new, re.S)
assert "SmallPairGraphClosure34" not in new
args.output_dir.mkdir(parents=True, exist_ok=True)
target = args.output_dir / "SmallPairGraphTriangle34.lean"
target.write_text(new)
for path, digest in pins.items():
    assert sha(path.read_bytes()) == digest, "Input changed while preparing adapter"
report = {
    "status": "Uncompiled optional triangle adapter; no active or accepted file replaced",
    "public_theorem_name": "D1Bound5.smallPairNoTriangle_34_checked",
    "public_theorem_type_unchanged": True,
    "original_split_vertices_colors_and_sieve_unchanged": True,
    "closure_and_graphdata_aggregator_unchanged": True,
    "input_pins_by_filename": {p.name: h for p, h in pins.items()},
    "generator_sha256": sha(Path(__file__).read_bytes()),
    "output_sha256": sha(target.read_bytes()),
    "output_bytes": target.stat().st_size,
    "intake_order_after_root_approval": [
        "SmallPairLiteralCachedData34.lean", "SmallPairLiteralLeft34.lean",
        "SmallPairLiteralRight34.lean", "SmallPairGraphTriangle34.lean"],
    "unchanged_consumer": "Existing SmallPairGraphData34 imports the same Triangle34 module name",
}
(args.output_dir / "manifest.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
