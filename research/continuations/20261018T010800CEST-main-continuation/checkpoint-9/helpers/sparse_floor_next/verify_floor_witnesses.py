"""Independent replay of emitted Lean floor lists against frozen graph data.

This deliberately does not import the generator and never calls isqrt.
Candidate pair sets use the previously independently re-enumerated frozen
graphs; actual coordinate products and strict square inequalities are checked
anew from the generated Lean naturals. This is diagnostic, not kernel evidence.
"""
from collections import Counter
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent / "generated"
sha = lambda b: hashlib.sha256(b).hexdigest()


def main():
    manifest = json.loads((OUT / "manifest.json").read_text())
    pins = {r["row"]: r for r in json.loads(
        (ROOT / "pair_witness_next/all48_input_fingerprints.json").read_text())}
    totals, summaries = Counter(), []
    for rec in manifest["rows"]:
        row = rec["row"]
        for name in [f"row{row:02}.json", f"SmallPairFloorWitnessData{row}.lean"]:
            assert sha((OUT / name).read_bytes()) == manifest["files"][name]["sha256"]
        graphname = f"finite_next/two_small/graphs/pair_{row:02}.json"
        closurename = f"finite_next/two_small/closures/pair_{row:02}.json"
        for name in [graphname, closurename]:
            assert sha((ROOT / name).read_bytes()) == pins[row]["files"][name]
        graph = json.loads((ROOT / graphname).read_text())
        closure = json.loads((ROOT / closurename).read_text())
        data = json.loads((OUT / f"row{row:02}.json").read_text())
        text = (OUT / f"SmallPairFloorWitnessData{row}.lean").read_text()
        vertices = closure["large"]
        tau, nu = closure["tau"], closure["nu"]
        assert (tau, nu) == (data["tau"], data["nu"])
        colors = [(int(data["color_mask"]) >> i) & 1 for i in range(len(vertices))]
        expected = {(i, j) for i, j in graph["modular_edges"] if colors[i] == colors[j]}
        seen = set()
        rowcount = Counter()
        for color, field in enumerate(["leftRows", "rightRows"]):
            body = re.search(rf"def {field} : List \(List ℕ\) := (\[.*?\n\])", text, re.S).group(1)
            floor_rows = json.loads(body)
            indices = [i for i, c in enumerate(colors) if c == color]
            assert len(floor_rows) == len(indices)
            assert data["colors"][color]["original_vertex_indices"] == indices
            for offset, i in enumerate(indices):
                head = data["colors"][color]["heads"][offset]
                assert head["head_index"] == i
                targets = sorted(j for ii, j in expected if ii == i)
                assert targets == head["modular_targets"]
                floors = list(floor_rows[offset])
                assert all(type(k) is int and k >= 0 for k in floors)
                consumed, rejects, audits = 0, [], []
                for j in targets:
                    seen.add((i, j))
                    a, b = vertices[i]
                    c, d = vertices[j]
                    assert (a, b) != (c, d)
                    re_z = a * c - nu * b * d + 1
                    im_z = a * d + b * c + tau * b * d
                    scale = nu if tau == 0 else 4 * nu - 1
                    if im_z == 0 and re_z < 0 and re_z % scale != 0:
                        rejects.append(j)
                        rowcount["cheap_integer_guard"] += 1
                        continue
                    assert consumed < len(floors), (row, i, j, "missing witness")
                    k = floors[consumed]
                    consumed += 1
                    if im_z != 0:
                        kind = "norm"
                        value = re_z * re_z + tau * re_z * im_z + nu * im_z * im_z
                        assert k * k < value < (k + 1) * (k + 1)
                    elif re_z > 0:
                        kind = "positive_real"
                        assert k * k < re_z < (k + 1) * (k + 1)
                    else:
                        kind = "negative_scaled"
                        assert im_z == 0 and re_z < 0 and tau in (0, 1)
                        assert scale * k * k < -re_z < scale * (k + 1) * (k + 1)
                    audits.append(dict(target_index=j, kind=kind, k=k))
                    rowcount[kind] += 1
                assert consumed == len(floors), (row, i, "extra witness")
                assert rejects == head["cheap_guard_targets"]
                assert audits == head["floor_witnesses"]
        assert seen == expected
        assert dict(rowcount) == rec["counts"]
        totals.update(rowcount)
        summaries.append(dict(row=row, exact_pair_coverage=True,
            lean_naturals_replayed=sum(rowcount.values())-rowcount["cheap_integer_guard"],
            modular_pairs=len(expected)))
    assert dict(totals) == manifest["counts"]
    result = dict(scope="Independent exact Python replay of emitted Lean data; no compiler claim",
        generator_not_imported=True, isqrt_calls=0, counts=dict(totals), rows=summaries,
        data_manifest_sha256=sha((OUT / "manifest.json").read_bytes()),
        verifier_sha256=sha(Path(__file__).read_bytes()))
    (OUT / "verification.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({k: v for k, v in result.items() if k != "rows"}, indent=2))


if __name__ == "__main__":
    main()
