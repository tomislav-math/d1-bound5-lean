"""Reproduce the isolated row-34 selected-mask pilot from frozen sources.

This emits only untrusted packed words and three new Lean modules.  The
literal cached classes, original vertices, sieve, sparse floors, and public
independence targets are unchanged.  No Lean build or source installation is
performed.  Kernel checking remains necessary; the Python checks are diagnostics.
"""
from pathlib import Path
import argparse
import ast
from collections import Counter
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--original-file", type=Path, default=ROOT / "finite_next/two_small/D1Bound5/SmallPairGraphData34.lean")
parser.add_argument("--accepted-dir", type=Path, default=ROOT / "pair_backend_next/staged_pilots_floor_fix/D1Bound5")
parser.add_argument("--literal-file", type=Path, default=ROOT / "pair_literal_next/generated/SmallPairLiteralCachedData34.lean")
parser.add_argument("--sieve-file", type=Path, default=ROOT / "finite_fast_next/sieves/SmallPairSieve_1_2.lean")
parser.add_argument("--helper-dir", type=Path, default=ROOT / "pair_witness_next")
parser.add_argument("--floor-checker-file", type=Path, default=ROOT / "floor_next/QuadSquareFloorObstruction.lean")
parser.add_argument("--output-dir", type=Path, default=HERE / "generated")
parser.add_argument("--expected-manifest", type=Path)
args = parser.parse_args()
sha = lambda data: hashlib.sha256(data).hexdigest()
pins = {
    args.original_file: "1e469696e498732377849734e4c3d693c95bc813fde9070fa40208039cb2b565",
    args.accepted_dir / "SmallPairGraphInputs34.lean": "80081fbe80d8267dc85a4c97cf17a7c063a9e61364395f31e58acc93a3d048b9",
    args.accepted_dir / "SmallPairGraphCachedData34.lean": "75ece134d8fff706db6a7afacf437fe93d2227ee0cb5e26fb0ae0d10478de03d",
    args.accepted_dir / "SmallPairFloorWitnessData34.lean": "4228760f9ba2009598b01b33ce40c9dcabd2bacaeb3f1cd9c95e2ba31163b073",
    args.literal_file: "2b14c33742c58890230b20e7b3ee455905f4ac50c88dc86a4da3bd7719777af1",
    args.sieve_file: "0e06eb108afce10f63dd87b8402973d477820e1a7d76cfa29f8e0be3d77d5235",
    args.helper_dir / "PairSelectedCachedMask.lean": "842d5e0cce863d3301c8c65c34a04d2d07c08d156761bf506cdbbebcdd0db1f4",
    args.helper_dir / "PairSelectedFloorWitnesses.lean": "5627d261d76c8200c3ce7a8601856a8cef8aa9e7be044b0ebf81c7f060ce8b74",
    args.helper_dir / "PairCachedFloorWitnesses.lean": "344ed1b90b84f82b59da3776e3d6e5f30a12a3e268e2e655e2aac504ca085b06",
    args.helper_dir / "PairCachedResidues.lean": "8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100",
    args.helper_dir / "PairNegativeIntegerObstruction.lean": "099be79d73801fcfb76bdc30024dc74b43ab6bdb2e935fcd75d8e115af902e02",
    args.floor_checker_file: "189bc6919f96623fb014a3f2f03e165069f8dce0da25caec94ef0406cc2c9b3e",
}
for path, digest in pins.items():
    assert sha(path.read_bytes()) == digest, f"Frozen source mismatch: {path}"

original = args.original_file.read_text()
inputs = (args.accepted_dir / "SmallPairGraphInputs34.lean").read_text()
cached = (args.accepted_dir / "SmallPairGraphCachedData34.lean").read_text()
literal_source = args.literal_file.read_text()
floor_source = (args.accepted_dir / "SmallPairFloorWitnessData34.lean").read_text()
sieve_source = args.sieve_file.read_text()
large_pattern = r"def smallPairLarge_34 .*? := \[(.*?)\n\]"
large_text = re.search(large_pattern, original, re.S).group(1)
assert re.search(large_pattern, inputs, re.S).group(1) == large_text
coordinate_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
vertices = [tuple(map(int, p)) for p in re.findall(coordinate_pattern, large_text)]
assert re.sub(coordinate_pattern, "", large_text).replace(",", "").strip() == ""
assert len(vertices) == 457 and len(set(vertices)) == 457
colors = int(re.search(r"def colors : ℕ := (\d+)", inputs).group(1))
assert colors >> len(vertices) == 0
signatures = ast.literal_eval(re.search(r"def cachedSignatures .*? := (\[.*?\n\])", cached, re.S).group(1))
mask_defs = {name: int(value) for name, value in re.findall(r"def (smallPairMask_1_2_\d+) : ℕ := (\d+)", sieve_source)}
sieve_text = re.search(r"def smallPairSieve_1_2 .*? := \[(.*?)\n\]", sieve_source, re.S).group(1)
sieve_pattern = r"\((\d+),\s*(smallPairMask_1_2_\d+)\)"
sieve = [(int(k) + 1, mask_defs[name]) for k, name in re.findall(sieve_pattern, sieve_text)]
assert re.sub(sieve_pattern, "", sieve_text).replace(",", "").strip() == ""
assert len(sieve) == 25
assert signatures == [[(a % p, b % p) for p, _ in sieve] for a, b in vertices]
classes = [[i for i in range(len(vertices)) if ((colors >> i) & 1) == color] for color in (0, 1)]
assert list(map(len, classes)) == [229, 228]

# Parse the actual reused constructor lists, independently of the split data.
record_pattern = r"⟨⟨(-?\d+),\s*(-?\d+)⟩,\s*(\[[^\]]*\])⟩"
class_records = []
floor_rows = []
for side, indices in zip(("left", "right"), classes):
    body = re.search(rf"def {side}Cached .*? := \[(.*?)\n\]", literal_source, re.S).group(1)
    records = [((int(a), int(b)), ast.literal_eval(sig)) for a, b, sig in re.findall(record_pattern, body)]
    assert re.sub(record_pattern, "", body).replace(",", "").strip() == ""
    assert records == [(vertices[i], signatures[i]) for i in indices]
    class_records.append(records)
    rows = ast.literal_eval(re.search(rf"def {side}Rows .*? := (\[.*?\n\])", floor_source, re.S).group(1))
    assert len(rows) == len(records)
    assert all(isinstance(k, int) and k >= 0 for row in rows for k in row)
    floor_rows.append(rows)

def residue_accepts(index, u, v):
    p, mask = sieve[index]
    a, b = u[index]
    c, d = v[index]
    re_mod = (a * c - 2 * b * d + 1) % p
    im_mod = (a * d + b * c + b * d) % p
    return bool((mask >> (re_mod * p + im_mod)) & 1)

def radicand(x, y):
    a, b = x
    c, d = y
    return a * c - 2 * b * d + 1, a * d + b * c + b * d

def negative_obstruction(z):
    a, b = z
    return b == 0 and a < 0 and a % 7 != 0

def floor_accepts(z, k):
    a, b = z
    if b != 0:
        n = a * a + a * b + 2 * b * b
        return k * k < n < (k + 1) * (k + 1)
    if a > 0:
        return k * k < a < (k + 1) * (k + 1)
    return 7 * k * k < -a < 7 * (k + 1) * (k + 1)

selected_rows = []
stats = []
for records, original_rows in zip(class_records, floor_rows):
    rows = []
    counts = Counter()
    fallbacks = []
    for head, (x, u) in enumerate(records):
        tags = []
        floor_cursor = 0
        for target in range(head + 1, len(records)):
            y, v = records[target]
            if x == y:
                tag = 30
                counts["duplicate"] += 1
            else:
                tag = next((i for i in range(25) if not residue_accepts(i, u, v)), 31)
                if tag == 31:
                    z = radicand(x, y)
                    if negative_obstruction(z):
                        counts["negative_guard"] += 1
                    else:
                        assert floor_cursor < len(original_rows[head]), (head, target, "missing floor")
                        k = original_rows[head][floor_cursor]
                        assert floor_accepts(z, k), (head, target, "invalid floor")
                        floor_cursor += 1
                        counts["floor"] += 1
                    fallbacks.append([head, target])
                else:
                    counts["selected_mask"] += 1
            counts[f"tag_{tag}"] += 1
            tags.append(tag)
        assert floor_cursor == len(original_rows[head]), (head, "extra floors")
        code = sum(tag << (5 * i) for i, tag in enumerate(tags))
        # Replay full-tail tag consumption, including implicit leading zeros.
        remainder = code
        for tag in tags:
            assert remainder % 32 == tag
            remainder //= 32
        assert remainder == 0
        rows.append((code, original_rows[head]))
    assert [ks for _, ks in rows] == original_rows
    assert rows[-1] == (0, [])
    selected_rows.append(rows)
    stats.append({"vertices": len(records), "pairs": len(records) * (len(records) - 1) // 2,
                  "counts": dict(sorted(counts.items())), "fallback_class_indices": fallbacks})
assert [s["counts"].get("floor", 0) for s in stats] == [2, 1]
assert all(s["counts"].get("negative_guard", 0) == 0 for s in stats)
assert sum(s["pairs"] for s in stats) == 51984

data = """import Mathlib.Data.List.Basic

namespace D1Bound5.PairSelectedPilot34
set_option maxRecDepth 100000

"""
for side, rows in zip(("left", "right"), selected_rows):
    data += "/-- One packed word per actual head; floor lists equal the frozen original rows. -/\n"
    data += f"def {side}Rows : List (ℕ × List ℕ) := [\n"
    data += ",\n".join(f"  ({code}, [{', '.join(map(str, ks))}])" for code, ks in rows)
    data += "\n]\n\n"
data += "end D1Bound5.PairSelectedPilot34\n"
files = {"SmallPairSelectedData34.lean": data}
for side, projection in (("Left", 1), ("Right", 2)):
    lower = side.lower()
    files[f"SmallPairSelected{side}34.lean"] = f"""import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.PairSelectedFloorWitnesses
import D1Bound5.SmallPairSelectedData34

namespace D1Bound5.PairSelectedPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {lower}_certificate_checked :
    pairSelectedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{projection}
      PairLiteralPilot34.{lower}Cached {lower}Rows = true := by
  decide +kernel

/-- Exact original split-class target, with unchanged literal cache and coverage. -/
theorem {lower}_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{projection} = true :=
  pairIndependentBool_of_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{projection}
    PairLiteralPilot34.{lower}Cached {lower}Rows {lower}_certificate_checked

end D1Bound5.PairSelectedPilot34
"""
outputs = {name: {"sha256": sha(text.encode()), "bytes": len(text.encode())} for name, text in files.items()}
if args.expected_manifest:
    expected = json.loads(args.expected_manifest.read_text())
    assert outputs == expected["files"], "Selected pilot source fingerprint mismatch"
    assert {p.name: h for p, h in pins.items()} == expected["source_pins_by_filename"]
args.output_dir.mkdir(parents=True, exist_ok=True)
for name, text in files.items():
    (args.output_dir / name).write_text(text)
manifest = {
    "status": "Uncompiled isolated row34 pilot; Python diagnostic checks are not kernel proofs",
    "generator_sha256": sha(Path(__file__).read_bytes()),
    "source_pins_by_filename": {p.name: h for p, h in pins.items()},
    "row": 34,
    "model": {"tau": 1, "nu": 2},
    "class_stats": dict(zip(("left", "right"), stats)),
    "packed_tag_order": "Least significant base32 digit is first actual tail vertex; complete tail drives traversal",
    "floors_value_identical_to_original_rows": True,
    "cached_classes_reused_without_coordinate_or_signature_duplication": True,
    "old_split_vertex_coverage_and_signature_checks_retained": True,
    "files": outputs,
}
(args.output_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
print(json.dumps({"generator_sha256": manifest["generator_sha256"], "files": outputs, "class_stats": manifest["class_stats"]}, indent=2))
