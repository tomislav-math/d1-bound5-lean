"""Independent read-only replay of the literal class34 fallback.

Does not import/run the generator, compute square roots, or compile Lean.
Only this diagnostic report is written; all reviewed sources remain frozen.
"""
from pathlib import Path
import ast
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "pair_literal_next/generated"
ACCEPTED = ROOT / "pair_backend_next/staged_pilots_floor_fix/D1Bound5"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    manifest = json.loads((BASE / "manifest.json").read_text())
    paths = {
        "SmallPairGraphData34.lean": ROOT / "finite_next/two_small/D1Bound5/SmallPairGraphData34.lean",
        "SmallPairGraphInputs34.lean": ACCEPTED / "SmallPairGraphInputs34.lean",
        "SmallPairGraphCachedData34.lean": ACCEPTED / "SmallPairGraphCachedData34.lean",
        "SmallPairFloorWitnessData34.lean": ACCEPTED / "SmallPairFloorWitnessData34.lean",
        "SmallPairSieve_1_2.lean": ROOT / "finite_fast_next/sieves/SmallPairSieve_1_2.lean",
        "PairCachedFloorWitnesses.lean": ROOT / "pair_witness_next/PairCachedFloorWitnesses.lean",
    }
    for name, p in paths.items():
        assert sha(p) == manifest["source_pins_by_filename"][name], name
    for name, expected in manifest["files"].items():
        p = BASE / name
        assert sha(p) == expected["sha256"] and p.stat().st_size == expected["bytes"]
    original = paths["SmallPairGraphData34.lean"].read_text()
    inputs = paths["SmallPairGraphInputs34.lean"].read_text()
    cached = paths["SmallPairGraphCachedData34.lean"].read_text()
    floors = paths["SmallPairFloorWitnessData34.lean"].read_text()
    sieve = paths["SmallPairSieve_1_2.lean"].read_text()
    emitted = (BASE / "SmallPairLiteralCachedData34.lean").read_text()
    literal_pattern = r"def smallPairLarge_34 .*? := \[(.*?)\n\]"
    literal = re.search(literal_pattern, original, re.S).group(1)
    assert literal == re.search(literal_pattern, inputs, re.S).group(1)
    pair_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
    vertices = [tuple(map(int, x)) for x in re.findall(pair_pattern, literal)]
    assert re.sub(pair_pattern, "", literal).replace(",", "").strip() == ""
    assert len(vertices) == len(set(vertices)) == 457
    color_mask = int(re.search(r"def colors : ℕ := (\d+)", inputs).group(1))
    canonical = ast.literal_eval(re.search(r"def cachedSignatures .*? := (\[.*?\n\])", cached, re.S).group(1))
    masks = {name: int(value) for name, value in re.findall(r"def (smallPairMask_1_2_\d+) : ℕ := (\d+)", sieve)}
    sbody = re.search(r"def smallPairSieve_1_2 .*? := \[(.*?)\n\]", sieve, re.S).group(1)
    entries = [(int(k)+1, masks[name]) for k, name in re.findall(r"\((\d+),\s*(smallPairMask_1_2_\d+)\)", sbody)]
    assert len(entries) == 25
    assert canonical == [[(a % p, b % p) for p, _ in entries] for a, b in vertices]
    classes = [[i for i in range(457) if ((color_mask >> i) & 1) == c] for c in (0, 1)]
    assert list(map(len, classes)) == [229, 228]
    assert classes == manifest["class_original_indices"]
    reports = []
    record_pattern = r"⟨⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩,\s*(\[.*?\])⟩"
    for color, side in enumerate(["left", "right"]):
        body = re.search(rf"def {side}Cached .*? := \[(.*?)\n\]", emitted, re.S).group(1)
        records = [((int(a), int(b)), ast.literal_eval(s)) for a, b, s in re.findall(record_pattern, body)]
        assert re.sub(record_pattern, "", body).replace(",", "").strip() == ""
        expected = [(vertices[i], canonical[i]) for i in classes[color]]
        assert records == expected, (side, "literal class differs from accepted projection")
        floor_rows = json.loads(re.search(rf"def {side}Rows .*? := (\[.*?\n\])", floors, re.S).group(1))
        assert len(floor_rows) == len(records)
        pairs = scans = survivors = floor_count = 0
        for offset, ((a, b), signature) in enumerate(records):
            used = 0
            for ((c, d), sig2) in records[offset+1:]:
                pairs += 1
                for (p, mask), (u, v), (w, x) in zip(entries, signature, sig2):
                    scans += 1
                    ix = ((u*w - 2*v*x + 1) % p)*p + ((u*x+v*w+v*x) % p)
                    if not ((mask >> ix) & 1):
                        break
                else:
                    survivors += 1
                    rr, ii = a*c-2*b*d+1, a*d+b*c+b*d
                    assert ii != 0, "All three known survivors are nonreal"
                    k = floor_rows[offset][used]
                    used += 1
                    norm = rr*rr+rr*ii+2*ii*ii
                    assert k*k < norm < (k+1)*(k+1)
                    floor_count += 1
            assert used == len(floor_rows[offset]), "Floor row has excess or misordered witnesses"
        wrapper = (BASE / f"SmallPairLiteral{side.title()}34.lean").read_text()
        assert f"(pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{color+1}" in wrapper
        assert f"{side}Cached PairFloorWitness34.{side}Rows" in wrapper
        assert "pairCachedFloorIndependentCertificateBool smallPairSieve_1_2" in wrapper
        assert "pairIndependentBool_of_cached_floor_certificate (by decide) smallPairSieve_1_2" in wrapper
        assert "decide +kernel" in wrapper
        reports.append(dict(side=side, vertices=len(records), exact_projection_equality=True,
            signature_pairs=len(records)*25, pairs=pairs, mask_calls=scans,
            survivors=survivors, original_norm_floors_checked=floor_count))
    assert [r["survivors"] for r in reports] == [2, 1]
    old_triangle = (ACCEPTED / "SmallPairGraphTriangle34.lean").read_text()
    triangle_path = ROOT / "pair_literal_next/integration/SmallPairGraphTriangle34.lean"
    triangle = triangle_path.read_text()
    for old, new in [("SmallPairGraphLeft34", "SmallPairLiteralLeft34"),
                     ("SmallPairGraphRight34", "SmallPairLiteralRight34"),
                     ("PairGraphPrepared34.left_checked", "PairLiteralPilot34.left_checked"),
                     ("PairGraphPrepared34.right_checked", "PairLiteralPilot34.right_checked")]:
        assert old_triangle.count(old) == 1
        old_triangle = old_triangle.replace(old, new)
    assert old_triangle == triangle
    report = dict(status="Independent source/data replay PASS; no Lean compilation or performance claim",
        generator_not_imported_or_run=True, square_root_calls=0,
        original_frozen_data_checked=True, checker_and_floor_data_hashes_unchanged=True,
        emitted_classes_exact_original_projection=True, canonical_residues_recomputed=True,
        classes=reports, triangle_exact_four_substitutions=True,
        triangle_public_theorem_and_predicate_unchanged=True,
        source_hashes={str(p.relative_to(ROOT)): sha(p) for p in
            [ROOT / "pair_literal_next/generate_literal34.py", BASE / "manifest.json", triangle_path]
            + [BASE / name for name in manifest["files"]] + list(paths.values())},
        reduction_note_review="The note explicitly distinguishes source-based potential reduction cost from a measured profile/speedup; direct literals remove cached split/zip redexes while preserving original coverage, signature validation and accepted checker.")
    out = ROOT / "audit_next/literal34_independent_review.json"
    out.write_text(json.dumps(report, indent=2)+"\n")
    print(json.dumps(dict(status=report["status"], classes=reports,
        triangle_sha256=sha(triangle_path), report_sha256=sha(out)), indent=2))


if __name__ == "__main__":
    main()
