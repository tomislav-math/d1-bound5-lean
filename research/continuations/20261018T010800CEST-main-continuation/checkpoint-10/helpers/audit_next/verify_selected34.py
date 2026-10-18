"""Decode actual emitted base32 witnesses independently of their generator.

No Lean builds, remote calls, source edits or square-root routines. Checks the
full original tails, selected exact masks, floor witnesses and exhaustion.
"""
from pathlib import Path
import argparse
import ast
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--generated-dir", type=Path, required=True)
    args = parser.parse_args()
    generated = args.generated_dir
    for name, digest in {
        "PairSelectedCachedMask.lean": "842d5e0cce863d3301c8c65c34a04d2d07c08d156761bf506cdbbebcdd0db1f4",
        "PairSelectedFloorWitnesses.lean": "5627d261d76c8200c3ce7a8601856a8cef8aa9e7be044b0ebf81c7f060ce8b74",
    }.items():
        assert sha(ROOT / "pair_witness_next" / name) == digest
    manifest = json.loads((generated / "manifest.json").read_text())
    actual_files = {}
    for name, meta in manifest["files"].items():
        p = generated / name
        assert sha(p) == meta["sha256"] and p.stat().st_size == meta["bytes"]
        actual_files[name] = p.read_text()
    data_files = [(name, text) for name, text in actual_files.items() if "def leftRows" in text]
    assert len(data_files) == 1
    data_name, data = data_files[0]
    assert "namespace D1Bound5.PairSelectedPilot34" in data
    literal_path = ROOT / "pair_literal_next/generated/SmallPairLiteralCachedData34.lean"
    assert sha(literal_path) == "2b14c33742c58890230b20e7b3ee455905f4ac50c88dc86a4da3bd7719777af1"
    literal = literal_path.read_text()
    accepted = ROOT / "pair_backend_next/staged_pilots_floor_fix/D1Bound5"
    floor_path = accepted / "SmallPairFloorWitnessData34.lean"
    assert sha(floor_path) == "4228760f9ba2009598b01b33ce40c9dcabd2bacaeb3f1cd9c95e2ba31163b073"
    floors = floor_path.read_text()
    input_path = accepted / "SmallPairGraphInputs34.lean"
    assert sha(input_path) == "80081fbe80d8267dc85a4c97cf17a7c063a9e61364395f31e58acc93a3d048b9"
    inputs = input_path.read_text()
    vertex_body = re.search(r"def smallPairLarge_34 .*? := \[(.*?)\n\]", inputs, re.S).group(1)
    vertices = [tuple(map(int, p)) for p in re.findall(r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩", vertex_body)]
    colors = int(re.search(r"def colors : ℕ := (\d+)", inputs).group(1))
    sieve_path = ROOT / "finite_fast_next/sieves/SmallPairSieve_1_2.lean"
    assert sha(sieve_path) == "0e06eb108afce10f63dd87b8402973d477820e1a7d76cfa29f8e0be3d77d5235"
    sieve = sieve_path.read_text()
    masks = {name: int(value) for name, value in re.findall(r"def (smallPairMask_1_2_\d+) : ℕ := (\d+)", sieve)}
    sbody = re.search(r"def smallPairSieve_1_2 .*? := \[(.*?)\n\]", sieve, re.S).group(1)
    entries = [(int(k)+1, masks[name]) for k, name in re.findall(r"\((\d+),\s*(smallPairMask_1_2_\d+)\)", sbody)]
    assert len(entries) == 25
    reports = []
    for color, side in enumerate(["left", "right"]):
        rbody = re.search(rf"def {side}Rows .*? := (\[.*?\n\])", data, re.S).group(1)
        rows = ast.literal_eval(rbody)
        lbody = re.search(rf"def {side}Cached .*? := \[(.*?)\n\]", literal, re.S).group(1)
        pattern = r"⟨⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩,\s*(\[.*?\])⟩"
        cached = [((int(a), int(b)), ast.literal_eval(sig)) for a, b, sig in re.findall(pattern, lbody)]
        assert re.sub(pattern, "", lbody).replace(",", "").strip() == ""
        indices = [i for i in range(len(vertices)) if (colors >> i) & 1 == color]
        assert [z for z, _ in cached] == [vertices[i] for i in indices]
        assert all(sig == [(a % p, b % p) for p, _ in entries] for (a, b), sig in cached)
        old_floor_rows = ast.literal_eval(re.search(rf"def {side}Rows .*? := (\[.*?\n\])", floors, re.S).group(1))
        assert len(rows) == len(cached) == len(old_floor_rows)
        assert [ks for _, ks in rows] == old_floor_rows
        pairs = selected = fallback = repeats = guard = norms = leading_zeros = 0
        histogram = {}
        for offset, (((a, b), sig), (word, ks)) in enumerate(zip(cached, rows)):
            assert type(word) is int and word >= 0
            assert all(type(k) is int and k >= 0 for k in ks)
            used = 0
            for (c, d), sig2 in cached[offset+1:]:
                pairs += 1
                if word == 0:
                    leading_zeros += 1
                tag, word = word % 32, word // 32
                histogram[tag] = histogram.get(tag, 0) + 1
                if tag < 25:
                    assert tag < len(entries) and tag < len(sig) and tag < len(sig2)
                    p, mask = entries[tag]
                    (u, v), (w, x) = sig[tag], sig2[tag]
                    index = ((u*w-2*v*x+1) % p)*p + ((u*x+v*w+v*x) % p)
                    assert ((mask >> index) & 1) == 0
                    selected += 1
                elif tag == 30:
                    assert (a, b) == (c, d)
                    repeats += 1
                elif tag == 31:
                    fallback += 1
                    rr, ii = a*c-2*b*d+1, a*d+b*c+b*d
                    if ii == 0 and rr < 0 and rr % 7 != 0:
                        guard += 1
                    else:
                        assert used < len(ks), "Missing floor witness"
                        k = ks[used]
                        used += 1
                        # These actual frozen row34 residuals are nonreal.
                        assert ii != 0
                        norm = rr*rr+rr*ii+2*ii*ii
                        assert k*k < norm < (k+1)*(k+1)
                        norms += 1
                else:
                    raise AssertionError((side, offset, "invalid tag", tag))
            assert word == 0, "Trailing code survives the full actual tail"
            assert used == len(ks), "Unused floor witness survives the row"
        assert rows[-1] == (0, [])
        wrappers = [text for name, text in actual_files.items() if side.title() in name and "theorem" in text]
        assert len(wrappers) == 1
        wrapper = wrappers[0]
        assert f"(pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).{color+1}" in wrapper
        assert f"PairLiteralPilot34.{side}Cached" in wrapper
        assert "pairSelectedFloorIndependentCertificateBool smallPairSieve_1_2" in wrapper
        assert "pairIndependentBool_of_selected_floor_certificate (by decide) smallPairSieve_1_2" in wrapper
        assert "decide +kernel" in wrapper
        reports.append(dict(side=side, heads=len(rows), pairs=pairs, selected_masks=selected,
            fallback_tags=fallback, repeated_vertex_tags=repeats, integer_guards=guard,
            actual_norm_floors=norms, implicit_zero_tags_checked=leading_zeros,
            tag_histogram=dict(sorted(histogram.items())), code_and_floors_exhausted=True))
    assert sum(r["pairs"] for r in reports) == 51984
    assert sum(r["actual_norm_floors"] for r in reports) == 3
    report = dict(status="Independent emitted packed data/source replay PASS; no compiler or speedup claim",
        generator_not_imported_or_run=True, square_root_calls=0, exact_literal_coverage=True,
        original_floor_rows_unchanged=True, all_actual_tail_pairs_checked=True,
        outer_head_row_counts_exact=True, classes=reports,
        emitted_file_hashes={name: sha(generated / name) for name in actual_files},
        generic_source_hashes={name: sha(ROOT / "pair_witness_next" / name) for name in
            ["PairSelectedCachedMask.lean", "PairSelectedFloorWitnesses.lean"]},
        manifest_sha256=sha(generated / "manifest.json"))
    out = ROOT / "audit_next/selected34_independent_review.json"
    out.write_text(json.dumps(report, indent=2)+"\n")
    print(json.dumps(dict(status=report["status"], classes=reports, report_sha256=sha(out)), indent=2))


if __name__ == "__main__":
    main()
