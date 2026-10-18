"""Re-enumerate all same-color sieve survivors with cached small bitsets.

Uses the actual pinned Lean masks. This is diagnostic Python, not a proof.
There is no square-root computation or mutation of any Lean source.
"""
from collections import defaultdict
from pathlib import Path
import json
import time
from classify_pair_survivors import ROOT, OUT, inputs, diagnostics, load_sieve, sha


def verify_row(k):
    for name, digest in inputs[k]["files"].items():
        assert sha((ROOT / name).read_bytes()) == digest, name
    row = json.loads((ROOT / f"finite_next/two_small/closures/pair_{k:02}.json").read_text())
    graph = json.loads((ROOT / f"finite_next/two_small/graphs/pair_{k:02}.json").read_text())
    vs = list(map(tuple, row["large"]))
    tau, nu = row["tau"], row["nu"]
    color_mask = int(diagnostics[k]["color_mask"])
    colors = [(color_mask >> i) & 1 for i in range(len(vs))]
    color_words = [sum(1 << i for i, c in enumerate(colors) if c == color) for color in (0, 1)]
    tables = []
    for p, mask in load_sieve(tau, nu):
        sig = [(a % p, b % p) for a, b in vs]
        groups = defaultdict(int)
        for i, v in enumerate(sig):
            groups[v] |= 1 << i
        tables.append((p, mask, sig, groups, {}))
    found = set()
    for i in range(len(vs)):
        possible = (color_words[colors[i]] >> (i + 1)) << (i + 1)
        for p, mask, sig, groups, cache in tables:
            if not possible:
                break
            u = sig[i]
            if u not in cache:
                a, b = u
                word = 0
                for (c, d), group_word in groups.items():
                    index = ((a * c - nu * b * d + 1) % p) * p + ((a * d + b * c + tau * b * d) % p)
                    if (mask >> index) & 1:
                        word |= group_word
                cache[u] = word
            possible &= cache[u]
        while possible:
            bit = possible & -possible
            j = bit.bit_length() - 1
            found.add((i, j))
            possible ^= bit
    expected = {(i, j) for i, j in graph["modular_edges"] if colors[i] == colors[j]}
    assert found == expected, (k, len(found - expected), len(expected - found))
    assert len(found) == diagnostics[k]["same_color_modular_survivors"]
    return dict(row=k, vertices=len(vs), same_color_unordered_pairs=diagnostics[k]["same_color_unordered_checks"],
        regenerated_survivors=len(found), exact_set_equality=True)


def main():
    start = time.monotonic()
    rows = []
    for k in range(1, 49):
        rows.append(verify_row(k))
        if k % 12 == 0:
            print(f"Exact same-color sieve re-enumeration: {k}/48 rows", flush=True)
    result = dict(scope="Exact Python diagnostic only; no kernel claim", rows=rows,
        total_same_color_unordered_pairs=sum(r["same_color_unordered_pairs"] for r in rows),
        total_survivors=sum(r["regenerated_survivors"] for r in rows),
        elapsed_seconds=time.monotonic()-start)
    assert result["total_survivors"] == 68640
    (OUT / "PAIR_SURVIVOR_COMPLETENESS.json").write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps({k:v for k,v in result.items() if k != "rows"},indent=2),flush=True)


if __name__ == "__main__":
    main()
