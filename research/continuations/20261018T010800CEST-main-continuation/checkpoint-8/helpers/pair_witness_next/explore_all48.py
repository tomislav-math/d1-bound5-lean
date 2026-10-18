"""Reproducible exact diagnostics for extending the Graph41 certificate design.

Only prepares a manifest. It neither emits nor queues 48 Lean compilations.
Every asserted root and mutation uses Python integer arithmetic. The proposed
Lean witnesses/color masks remain untrusted until their kernel checks pass.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent
ROUTINE = ROOT / "finite_next/two_small/generate_pair_closures.py"
ROUTINE_SHA = "d34a4e980c38ec61cd520b5b6112221374ec479ffeafa726d09567726beca894"
sha = lambda b: hashlib.sha256(b).hexdigest()
assert sha(ROUTINE.read_bytes()) == ROUTINE_SHA
inputs = json.loads((OUT / "all48_input_fingerprints.json").read_text())
assert [row["row"] for row in inputs] == list(range(1, 49))
for row in inputs:
    for filename, digest in row["files"].items():
        assert sha((ROOT / filename).read_bytes()) == digest, filename
spec = importlib.util.spec_from_file_location("frozen_pair_closure_all48", ROUTINE)
exact = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exact)
pair_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
bound, rows = 10 ** 1100, []


def parse_list(source, name):
    found = re.search(rf"def {name} : List \(QuadInt (\d+) (\d+)\) := \[(.*?)\n\]", source, re.S)
    assert found is not None, name
    t, n = map(int, found.groups()[:2])
    literal = found.group(3)
    vertices = [tuple(map(int, p)) for p in re.findall(pair_pattern, literal)]
    assert re.sub(pair_pattern, "", literal).replace(",", "").strip() == ""
    return t, n, literal, vertices


for snapshot in inputs:
    k = snapshot["row"]
    source_path = ROOT / f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean"
    source = source_path.read_text()
    t, n, literal, vertices = parse_list(source, f"smallPairClosure_{k}")
    lt, ln, large_literal, large = parse_list(source, f"smallPairLarge_{k}")
    assert (t, n) == (lt, ln)
    closure_data = json.loads((ROOT / f"finite_next/two_small/closures/pair_{k:02}.json").read_text())
    graph = json.loads((ROOT / f"finite_next/two_small/graphs/pair_{k:02}.json").read_text())
    assert vertices == [tuple(v) for v in closure_data["closure"]]
    assert large == [tuple(v) for v in closure_data["large"]]
    a, b = [tuple(v) for v in closure_data["anchors"]]
    for name, anchor in [(f"smallPairA_{k}", a), (f"smallPairB_{k}", b)]:
        found = re.search(rf"def {name} : QuadInt {t} {n} := {pair_pattern}", source)
        assert found is not None and tuple(map(int, found.groups())) == anchor
    mul = lambda x, y: exact.mul(t, n, x, y)
    norm = lambda x: exact.norm(t, n, x)
    root = lambda x: exact.root(t, n, x)
    add, scale = exact.add, exact.scale
    one = (1, 0)
    r0 = root(add(mul(a, b), one))
    assert r0 is not None and mul(r0, r0) == add(mul(a, b), one)
    root_pairs, destinations = [], []
    index = {z: j for j, z in enumerate(vertices)}
    assert len(index) == len(vertices)
    inside = outside = 0
    for z in vertices:
        az, bz = add(mul(a, z), one), add(mul(b, z), one)
        r, s = root(az), root(bz)
        assert r is not None and s is not None, (k, z)
        assert mul(r, r) == az and mul(s, s) == bz
        root_pairs.append((r, s))
        mid = add(add(a, b), mul(add(scale(2, mul(a, b)), one), z))
        rr = scale(2, mul(mul(r0, r), s))
        ds = []
        for sign in (1, -1):
            w = add(mid, scale(sign, rr))
            if norm(w) <= bound:
                assert w in index, (k, "Missing bounded mutation")
                ds.append(index[w]); inside += 1
            else:
                ds.append(None); outside += 1
        destinations.append(ds)
    # This BFS is preparation only. The Lean independent-class checker will
    # check every same-color pair, irrespective of these untrusted JSON edges.
    adjacency = [[] for _ in large]
    for i, j in graph["exact_edges"]:
        assert 0 <= i < j < len(large)
        assert root(add(mul(large[i], large[j]), one)) is not None
        adjacency[i].append(j); adjacency[j].append(i)
    colors = [None] * len(large)
    conflict = None
    for i in range(len(large)):
        if colors[i] is not None:
            continue
        colors[i] = 0
        queue = [i]
        for u in queue:
            for v in adjacency[u]:
                if colors[v] is None:
                    colors[v] = 1 - colors[u]; queue.append(v)
                elif colors[v] == colors[u]:
                    conflict = [u, v]
    counts = [colors.count(0), colors.count(1)]
    same_color_survivors = sum(colors[i] == colors[j] for i, j in graph["modular_edges"])
    rows.append({
        "row": k, "tau": t, "nu": n,
        "source_sha256": sha(source_path.read_bytes()),
        "closure_literal_sha256": sha(literal.encode()),
        "large_literal_sha256": sha(large_literal.encode()),
        "closure_vertices": len(vertices), "large_vertices": len(large),
        "anchor_root": r0, "root_equations_checked": 2 * len(vertices),
        "root_pair_list_sha256": sha(json.dumps(root_pairs, separators=(",", ":")).encode()),
        "inside_mutations": inside, "outside_mutations": outside,
        "destination_indices_sha256": sha(json.dumps(destinations, separators=(",", ":")).encode()),
        "exact_edges_rechecked": len(graph["exact_edges"]),
        "bipartite_diagnostic": conflict is None,
        "color_conflict": conflict, "color_counts": counts,
        "color_mask": str(sum(int(c) << i for i, c in enumerate(colors))),
        "same_color_unordered_checks": sum(c * (c - 1) // 2 for c in counts),
        "same_color_modular_survivors": same_color_survivors,
    })

summary = {
    "status": "Python diagnostics only; no all48 Lean acceptance claimed",
    "rows": len(rows),
    "closure_vertices": sum(r["closure_vertices"] for r in rows),
    "root_equations_checked": sum(r["root_equations_checked"] for r in rows),
    "signed_mutations_checked": sum(r["inside_mutations"] + r["outside_mutations"] for r in rows),
    "bipartite_rows": sum(r["bipartite_diagnostic"] for r in rows),
    "nonbipartite_rows": [r["row"] for r in rows if not r["bipartite_diagnostic"]],
    "same_color_unordered_checks": sum(r["same_color_unordered_checks"] for r in rows),
    "same_color_modular_survivors": sum(r["same_color_modular_survivors"] for r in rows),
    "input_snapshot_sha256": sha((OUT / "all48_input_fingerprints.json").read_bytes()),
    "exact_root_routine_sha256": ROUTINE_SHA,
}
(OUT / "all48_diagnostic_manifest.json").write_text(json.dumps({"summary": summary, "rows": rows}, indent=2) + "\n")
print(json.dumps(summary, indent=2))
