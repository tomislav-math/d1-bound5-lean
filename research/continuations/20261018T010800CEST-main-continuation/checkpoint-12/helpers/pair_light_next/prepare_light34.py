#!/usr/bin/env python3
"""Prepare only the left34 arithmetic data after the bridge source review.

This converter does not discover witnesses or change packed tags, signatures,
floor values, vertices, or masks. All are parsed from exact frozen source bytes.
It never installs files or invokes Lean. It must not be run before the exact
bridge source has passed independent review; the required receipt records that
source-review gate, not kernel acceptance.
"""
from __future__ import annotations

import argparse
import ast
import hashlib
import json
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]
PINS = {
    "pair_backend_next/staged_pilots_floor_fix/D1Bound5/SmallPairGraphInputs34.lean":
        "80081fbe80d8267dc85a4c97cf17a7c063a9e61364395f31e58acc93a3d048b9",
    "pair_literal_next/generated/SmallPairLiteralCachedData34.lean":
        "2b14c33742c58890230b20e7b3ee455905f4ac50c88dc86a4da3bd7719777af1",
    "pair_selected_next/generated/SmallPairSelectedData34.lean":
        "9a05216afd22493a58f74a21dd802492e7d8d57e0e80180cb8c7e7bd0d6e06c6",
    "finite_fast_next/sieves/SmallPairSieve_1_2.lean":
        "0e06eb108afce10f63dd87b8402973d477820e1a7d76cfa29f8e0be3d77d5235",
    "pair_light_next/PairLightArithmetic.lean":
        "ac3b9e9f7d91be83861de5b2f384eb0c669c61cfa9bd323309d57565e89af6eb",
}


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def one_group(pattern: str, text: str) -> str:
    matches = re.findall(pattern, text, re.S)
    require(len(matches) == 1, "Expected one exact declaration block")
    return matches[0]


def complete_parse(pattern: str, body: str) -> list:
    result = re.findall(pattern, body)
    require(re.sub(pattern, "", body).replace(",", "").strip() == "",
            "Unparsed declaration data")
    return result


def lean_list(items: list[str]) -> str:
    return "[\n" + ",\n".join("  " + item for item in items) + "\n]"


def coord(z: tuple[int, int]) -> str:
    return f"({z[0]}, {z[1]})"


def natural_pairs(items: list[tuple[int, int]]) -> str:
    return "[" + ", ".join(f"({a}, {b})" for a, b in items) + "]"


def prepare(bridge_source: Path, bridge_review: Path, output: Path) -> dict:
    output = output.resolve()
    require(not output.exists(), "Output must be a new directory")
    require(output != ROOT and output not in ROOT.parents,
            "Output must not contain the workspace")
    for source in PINS:
        require(output != (ROOT / source).parent,
                "Output must not be an existing source directory")

    bridge_bytes = bridge_source.read_bytes()
    review_bytes = bridge_review.read_bytes()
    review = json.loads(review_bytes)
    require(review.get("source_sha256") == sha(bridge_bytes),
            "Review must pin the exact current bridge source")
    require(review.get("source_review_pass") is True,
            "Independent bridge source review must pass before generation")
    require(isinstance(review.get("reviewer"), str) and review["reviewer"],
            "Review receipt must identify its independent reviewer")

    data = {}
    for name, expected in PINS.items():
        blob = (ROOT / name).read_bytes()
        require(sha(blob) == expected, f"Frozen input changed: {name}")
        data[name] = blob
    inputs = data[next(p for p in PINS if p.endswith("SmallPairGraphInputs34.lean"))].decode()
    literal = data[next(p for p in PINS if p.endswith("SmallPairLiteralCachedData34.lean"))].decode()
    selected = data[next(p for p in PINS if p.endswith("SmallPairSelectedData34.lean"))].decode()
    sieve_source = data[next(p for p in PINS if p.endswith("SmallPairSieve_1_2.lean"))].decode()

    large_body = one_group(r"def smallPairLarge_34 .*? := \[(.*?)\n\]", inputs)
    all_vertices = [tuple(map(int, z)) for z in
                    complete_parse(r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩", large_body)]
    require(len(all_vertices) == 457 and len(set(all_vertices)) == 457,
            "Unexpected original large list")
    colors = int(one_group(r"def colors : ℕ := (\d+)", inputs))
    require(colors >> len(all_vertices) == 0, "Excess original color bits")
    indices = [i for i in range(len(all_vertices)) if ((colors >> i) & 1) == 0]
    vertices = [all_vertices[i] for i in indices]
    require(len(vertices) == 229, "This converter is only the original left34 class")

    record_body = one_group(r"def leftCached .*? := \[(.*?)\n\]", literal)
    pattern = r"⟨⟨(-?\d+),\s*(-?\d+)⟩,\s*(\[[^\]]*\])⟩"
    records = [((int(a), int(b)), ast.literal_eval(sig))
               for a, b, sig in complete_parse(pattern, record_body)]
    require([x for x, sig in records] == vertices,
            "Literal cached records must cover exactly the original split, in order")

    mask_defs = dict(re.findall(r"def (smallPairMask_1_2_\d+) : ℕ := (\d+)", sieve_source))
    sieve_body = one_group(r"def smallPairSieve_1_2 .*? := \[(.*?)\n\]", sieve_source)
    sieve = [(int(k), int(mask_defs[name])) for k, name in
             complete_parse(r"\((\d+),\s*(smallPairMask_1_2_\d+)\)", sieve_body)]
    require(len(sieve) == 25, "Unexpected original sieve length")
    require(all(sig == [(a % (k + 1), b % (k + 1)) for k, _ in sieve]
                for (a, b), sig in records), "Actual cached signatures mismatch")

    rows = ast.literal_eval(one_group(r"def leftRows .*? := (\[.*?\n\])", selected))
    require(len(rows) == 229, "Unexpected selected row count")
    require(all(isinstance(word, int) and word >= 0 and isinstance(ks, list)
                and all(isinstance(k, int) and k >= 0 for k in ks)
                for word, ks in rows), "Malformed original packed rows")
    require(sum(len(ks) for word, ks in rows) == 2 and rows[-1] == (0, []),
            "Original left34 sparse floor data changed")
    require(all(word >> (5 * (len(rows) - i - 1)) == 0
                for i, (word, ks) in enumerate(rows)), "Original packed word has excess tags")

    source = """import D1Bound5.PairLightArithmetic

namespace D1Bound5.PairLightPilot34
set_option maxRecDepth 100000

"""
    source += "def sieve : List (Nat × Nat) := " + lean_list([f"({k}, {mask})" for k, mask in sieve]) + "\n\n"
    source += "def leftVertices : List PairLightCoordinate := " + lean_list([coord(z) for z in vertices]) + "\n\n"
    source += "def leftCached : List PairLightCachedVertex := " + lean_list(
        [f"({coord(z)}, {natural_pairs(sig)})" for z, sig in records]) + "\n\n"
    source += "def leftRows : List (Nat × List Nat) := " + lean_list(
        [f"({word}, [{', '.join(map(str, ks))}])" for word, ks in rows]) + "\n\n"
    source += "end D1Bound5.PairLightPilot34\n"
    proof = """import D1Bound5.SmallPairLightData34

namespace D1Bound5.PairLightPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Only the isolated arithmetic computation. Connection to the original
class requires the separately checked data equalities and exact bridge. -/
theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      leftVertices leftCached leftRows = true := by
  decide +kernel

end D1Bound5.PairLightPilot34
"""
    files = {"SmallPairLightData34.lean": source.encode(),
             "SmallPairLightLeft34.lean": proof.encode()}
    report = {
        "status": "Uncompiled optional pure left34 pilot; no original theorem claimed",
        "generator_sha256": sha(Path(__file__).read_bytes()),
        "source_pins": PINS,
        "bridge_source_sha256": sha(bridge_bytes),
        "bridge_source_review_sha256": sha(review_bytes),
        "bridge_source_review_is_not_kernel_acceptance": True,
        "model": {"tau": 1, "nu": 2}, "vertices": 229, "pairs": 26106,
        "signature_entries_per_vertex": 25, "floor_witnesses": 2,
        "original_split_indices": indices,
        "representation_changes_only": True,
        "mandatory_assembly_equalities": ["sieve", "leftVertices", "leftCached", "leftRows"],
        "files": {name: {"sha256": sha(blob), "bytes": len(blob)} for name, blob in files.items()},
    }
    output.mkdir(parents=True)
    for name, blob in files.items():
        (output / name).write_bytes(blob)
    (output / "manifest.json").write_text(json.dumps(report, indent=2) + "\n")
    require(all((ROOT / name).read_bytes() == blob for name, blob in data.items()),
            "A frozen source changed during preparation")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bridge-source", required=True, type=Path)
    parser.add_argument("--bridge-review", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    report = prepare(args.bridge_source, args.bridge_review, args.output)
    print(json.dumps({k: report[k] for k in ["status", "vertices", "pairs", "files"]}, indent=2))


if __name__ == "__main__":
    main()
