"""Read-only exact cost diagnostic; no Lean generation or compilation.

Rechecks frozen source pins and original graph pair sets. Counts the original
sieve's calls and a proposed one-selected-mask-per-pair certificate. Packed
base-32 row sizes are encoding estimates, not kernel performance claims.
"""
from collections import Counter, defaultdict
from pathlib import Path
import hashlib
import json
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "audit_next"))
from classify_pair_survivors import inputs, diagnostics, load_sieve, sha

STRUCTURAL = {16, 22, 27, 31, 32, 37, 41}


def measure(k):
    for name, digest in inputs[k]["files"].items():
        assert sha((ROOT / name).read_bytes()) == digest, name
    data = json.loads((ROOT / f"finite_next/two_small/closures/pair_{k:02}.json").read_text())
    graph = json.loads((ROOT / f"finite_next/two_small/graphs/pair_{k:02}.json").read_text())
    vs = list(map(tuple, data["large"]))
    tau, nu = data["tau"], data["nu"]
    color_mask = int(diagnostics[k]["color_mask"])
    colors = [(color_mask >> i) & 1 for i in range(len(vs))]
    color_words = [sum(1 << i for i, c in enumerate(colors) if c == color) for color in (0, 1)]
    sieve = load_sieve(tau, nu)
    tables = []
    for p, mask in sieve:
        sig = [(a % p, b % p) for a, b in vs]
        groups = defaultdict(int)
        for i, v in enumerate(sig):
            groups[v] |= 1 << i
        tables.append((p, mask, sig, groups, {}))
    expected = {(i, j) for i, j in graph["modular_edges"] if colors[i] == colors[j]}
    found = set()
    summaries = [Counter(), Counter()]
    hist = [Counter(), Counter()]
    packed_hash = hashlib.sha256()
    for i in range(len(vs)):
        possible = (color_words[colors[i]] >> (i + 1)) << (i + 1)
        targets = [j for j in range(i + 1, len(vs)) if colors[i] == colors[j]]
        tags = {j: None for j in targets}
        out = summaries[colors[i]]
        out["vertices"] += 1
        out["pairs"] += len(targets)
        for tag, (p, mask, sig, groups, cache) in enumerate(tables):
            if not possible:
                break
            out["old_mask_calls"] += possible.bit_count()
            u = sig[i]
            if u not in cache:
                a, b = u
                word = 0
                for (c, d), group_word in groups.items():
                    index = ((a*c-nu*b*d+1) % p)*p + ((a*d+b*c+tau*b*d) % p)
                    if (mask >> index) & 1:
                        word |= group_word
                cache[u] = word
            rejected = possible & ~cache[u]
            hist[colors[i]][p] += rejected.bit_count()
            out["selected_mask_calls"] += rejected.bit_count()
            out["selected_index_sum"] += tag * rejected.bit_count()
            while rejected:
                bit = rejected & -rejected
                j = bit.bit_length() - 1
                tags[j] = tag
                rejected ^= bit
            possible &= cache[u]
        while possible:
            bit = possible & -possible
            j = bit.bit_length() - 1
            found.add((i, j))
            a, b = vs[i]
            c, d = vs[j]
            re = a*c-nu*b*d+1
            im = a*d+b*c+tau*b*d
            scale = nu if tau == 0 else 4*nu-1
            if im == 0 and re < 0 and re % scale != 0:
                tags[j] = 31
                out["guard_tags"] += 1
            else:
                tags[j] = 31
                out["floor_tags"] += 1
            possible ^= bit
        assert all(t is not None for t in tags.values())
        code = sum(tags[j] << (5*n) for n, j in enumerate(targets))
        # Decode against the actual tail length: zero high digits do not skip pairs.
        remaining = code
        for j in targets:
            assert remaining % 32 == tags[j]
            remaining //= 32
        assert remaining == 0
        out["packed_decimal_digits"] += len(str(code))
        out["packed_binary_bytes"] += (code.bit_length() + 7)//8
        out["max_row_code_bits"] = max(out["max_row_code_bits"], code.bit_length())
        packed_hash.update(f"{i}:{code}\n".encode())
    assert found == expected
    assert sum(s["pairs"] for s in summaries) == diagnostics[k]["same_color_unordered_checks"]
    return dict(row=k, tau=tau, nu=nu, structural_in_current_manifest=k in STRUCTURAL,
        classes=[dict(color=c, **s, first_reject_modulus_histogram=dict(hist[c])) for c,s in enumerate(summaries)],
        packed_codes_digest=packed_hash.hexdigest(), exact_survivor_set_equality=True)


def aggregate(rows):
    keys = ["vertices", "pairs", "old_mask_calls", "selected_mask_calls", "selected_index_sum",
            "guard_tags", "floor_tags", "packed_decimal_digits", "packed_binary_bytes"]
    return {key: sum(c.get(key,0) for r in rows for c in r["classes"]) for key in keys}


if __name__ == "__main__":
    start = time.monotonic()
    rows = [measure(k) for k in range(1,49)]
    result = dict(status="Exact local diagnostic; no generated Lean certificate or timing claim",
        structural_rows_in_available_manifest=sorted(STRUCTURAL), all48=aggregate(rows),
        remaining41=aggregate([r for r in rows if not r["structural_in_current_manifest"]]),
        elapsed_seconds=time.monotonic()-start, rows=rows)
    path = Path(__file__).with_name("selected_mask_costs.json")
    path.write_text(json.dumps(result,indent=2)+"\n")
    print(json.dumps({k:v for k,v in result.items() if k!="rows"},indent=2))
    print(json.dumps(rows[33],indent=2))
