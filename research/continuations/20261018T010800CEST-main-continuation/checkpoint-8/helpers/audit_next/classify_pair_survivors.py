"""Exact local diagnostics for frozen same-color modular survivors.

No Lean/remote source mutation and no quadratic-field root routine is used.
Only real integer residuals reaching the cheap guard use Python's exact isqrt.
All source, graph and current sieve bytes are checked against existing pins.
"""
from collections import Counter
from pathlib import Path
import hashlib
import json
import math
import re
import time

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent
sha = lambda b: hashlib.sha256(b).hexdigest()
pins = json.loads((ROOT / "pair_witness_next/cached_sieve_fingerprints.json").read_text())
inputs = {r["row"]: r for r in json.loads((ROOT / "pair_witness_next/all48_input_fingerprints.json").read_text())}
diagnostics = {r["row"]: r for r in json.loads((ROOT / "pair_witness_next/all48_diagnostic_manifest.json").read_text())["rows"]}


def load_sieve(tau, nu):
    name = f"finite_fast_next/sieves/SmallPairSieve_{tau}_{nu}.lean"
    data = (ROOT / name).read_bytes()
    assert sha(data) == pins[name], name
    text = data.decode()
    values = {name: int(v) for name, v in re.findall(r"def (smallPairMask_\d+_\d+_\d+) : ℕ := (\d+)", text)}
    body = re.search(rf"def smallPairSieve_{tau}_{nu} .*? := \[(.*?)\n\]", text, re.S).group(1)
    pairs = [(int(k) + 1, values[name]) for k, name in re.findall(r"\((\d+),(smallPairMask_\d+_\d+_\d+)\)", body)]
    assert len(pairs) == 25
    return pairs


def classify(k):
    info = diagnostics[k]
    for name, digest in inputs[k]["files"].items():
        assert sha((ROOT / name).read_bytes()) == digest, name
    source = (ROOT / f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean").read_text()
    tau, nu = map(int, re.search(rf"def smallPairA_{k} : QuadInt (\d+) (\d+)", source).groups())
    body = re.search(rf"def smallPairLarge_{k} .*? := \[(.*?)\n\]", source, re.S).group(1)
    assert sha(body.encode()) == info["large_literal_sha256"]
    vertices = [tuple(map(int, z)) for z in re.findall(r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩", body)]
    old = json.loads((ROOT / f"finite_next/two_small/closures/pair_{k:02}.json").read_text())
    assert vertices == list(map(tuple, old["large"]))
    graph = json.loads((ROOT / f"finite_next/two_small/graphs/pair_{k:02}.json").read_text())
    sieve = load_sieve(tau, nu)
    assert [p for p, _ in sieve] == graph["moduli"]
    colors = [(int(info["color_mask"]) >> i) & 1 for i in range(len(vertices))]
    assert [colors.count(i) for i in (0, 1)] == info["color_counts"]
    assert all(colors[i] != colors[j] for i, j in graph["exact_edges"])
    signatures = [[(a % p, b % p) for a, b in vertices] for p, _ in sieve]
    q = nu if tau == 0 else 4 * nu - 1
    assert tau in (0, 1) and q > 0
    count, by_color = Counter(), [Counter(), Counter()]
    remainders = Counter()
    examples = {}
    integer_sqrt_calls = 0
    surviving_pairs = []
    for i, j in graph["modular_edges"]:
        assert 0 <= i < j < len(vertices)
        if colors[i] != colors[j]:
            continue
        # Independently recheck every supplied same-color survivor against
        # the current pinned masks and the actual cached coordinate formula.
        for (p, mask), sig in zip(sieve, signatures):
            a, b = sig[i]
            c, d = sig[j]
            re_mod = (a * c - nu * b * d + 1) % p
            im_mod = (a * d + b * c + tau * b * d) % p
            assert (mask >> (re_mod * p + im_mod)) & 1, (k, i, j, p)
        a, b = vertices[i]
        c, d = vertices[j]
        re_z = a * c - nu * b * d + 1
        im_z = a * d + b * c + tau * b * d
        label = "negative" if re_z < 0 else "positive" if re_z > 0 else "zero"
        category = ("real_" if im_z == 0 else "nonreal_re_") + label
        count["sieve_survivors"] += 1
        count[category] += 1
        by_color[colors[i]]["sieve_survivors"] += 1
        by_color[colors[i]][category] += 1
        guard_reject = im_z == 0 and re_z < 0 and re_z % q != 0
        if guard_reject:
            obstruction = "negative_integer_divisibility_reject"
            remainders[re_z % q] += 1
        else:
            count["after_negative_integer_guard"] += 1
            by_color[colors[i]]["after_negative_integer_guard"] += 1
            surviving_pairs.append([i, j])
            if im_z:
                obstruction = "nonreal_remaining_no_root_recomputation"
            elif re_z == 0:
                obstruction = "zero_actual_square_unexpected"
            else:
                rad = re_z if re_z > 0 else (-re_z) // q
                z = math.isqrt(rad)
                integer_sqrt_calls += 1
                assert z * z <= rad < (z + 1) * (z + 1)
                kind = "positive_integer" if re_z > 0 else "negative_integer_scaled"
                obstruction = kind + ("_actual_square_unexpected" if z * z == rad else "_strict_floor_obstruction")
        count[obstruction] += 1
        by_color[colors[i]][obstruction] += 1
        if obstruction not in examples:
            examples[obstruction] = dict(indices=[i, j], color=colors[i], re_sign=label,
                im_zero=(im_z == 0), re_digits=len(str(abs(re_z))), re_mod_guard_modulus=re_z % q)
    assert count["sieve_survivors"] == info["same_color_modular_survivors"], k
    assert not any("unexpected" in key for key in count), (k, count)
    return dict(row=k, tau=tau, nu=nu, guard_modulus=q, large_vertices=len(vertices),
        color_counts=info["color_counts"], same_color_unordered_pairs=info["same_color_unordered_checks"],
        counts=dict(count), by_color=list(map(dict, by_color)),
        negative_remainders=dict(sorted(remainders.items())),
        exact_integer_isqrt_calls=integer_sqrt_calls, examples=examples,
        after_guard_pairs=surviving_pairs)


def main():
    started = time.monotonic()
    rows = [classify(k) for k in range(1, 49)]
    total, models = Counter(), {}
    for row in rows:
        total.update(row["counts"])
        key = f'{row["tau"]},{row["nu"]}'
        models.setdefault(key, Counter()).update(row["counts"])
    assert total["sieve_survivors"] == 68640
    report = dict(scope="Exact Python diagnostic only; not a Lean/kernel certificate",
        survivor_source="Frozen complete modular_edges lists; all input hashes checked; every same-color survivor independently retested against current pinned masks",
        no_quadratic_field_root_routine=True,
        integer_isqrt_calls=sum(r["exact_integer_isqrt_calls"] for r in rows),
        elapsed_seconds=time.monotonic() - started,
        total=dict(total), by_model={k: dict(v) for k, v in sorted(models.items())}, rows=rows,
        input_hashes={name: sha((ROOT / name).read_bytes()) for name in
            ["pair_witness_next/all48_diagnostic_manifest.json", "pair_witness_next/all48_input_fingerprints.json", "pair_witness_next/cached_sieve_fingerprints.json"]},
        sieve_source_hashes=pins)
    (OUT / "PAIR_SURVIVOR_CLASSIFICATION.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ["scope", "elapsed_seconds", "integer_isqrt_calls", "total", "by_model"]}, indent=2), flush=True)


if __name__ == "__main__":
    main()
