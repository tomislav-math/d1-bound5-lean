"""Untrusted sparse floor witnesses for the frozen 48 pair graphs.

Every same-color unordered pair is covered by deterministic current-mask
enumeration. Only survivors of both the cached sieve and negative-integer
guard receive a natural floor witness. Lean will recheck coverage and every
inequality; this generator and its assertions are diagnostics, not proofs.
No field-root routine, compiler, or remote file access is used.
"""
from collections import Counter, defaultdict
from pathlib import Path
import argparse
import hashlib
import json
import math
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
sha = lambda b: hashlib.sha256(b).hexdigest()


def read_json(path):
    return json.loads(path.read_text())


def parse_source(path, row, pin, diagnostic):
    raw = path.read_bytes()
    assert sha(raw) == pin, str(path)
    text = raw.decode()
    tau, nu = map(int, re.search(
        rf"def smallPairA_{row} : QuadInt (\d+) (\d+)", text).groups())
    literal = re.search(rf"def smallPairLarge_{row} .*? := \[(.*?)\n\]", text, re.S).group(1)
    assert sha(literal.encode()) == diagnostic["large_literal_sha256"]
    pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
    vertices = [tuple(map(int, z)) for z in re.findall(pattern, literal)]
    assert re.sub(pattern, "", literal).replace(",", "").strip() == ""
    assert len(vertices) == len(set(vertices)), "Frozen input has a duplicate vertex"
    assert tau in (0, 1) and 4 * nu - tau * tau > 0
    return tau, nu, vertices


def parse_sieve(path, tau, nu, pin):
    raw = path.read_bytes()
    assert sha(raw) == pin, str(path)
    text = raw.decode()
    masks = {name: int(value) for name, value in re.findall(
        r"def (smallPairMask_\d+_\d+_\d+) : ℕ := (\d+)", text)}
    literal = re.search(rf"def smallPairSieve_{tau}_{nu} .*? := \[(.*?)\n\]", text, re.S).group(1)
    pattern = r"\((\d+),\s*(smallPairMask_\d+_\d+_\d+)\)"
    result = [(int(k) + 1, masks[name]) for k, name in re.findall(pattern, literal)]
    assert re.sub(pattern, "", literal).replace(",", "").strip() == ""
    assert len(result) == 25
    return result


def complete_survivors(vertices, colors, sieve, tau, nu):
    """Exact exhaustive sieve via bitsets of residue classes, not graph edges."""
    color_words = [sum(1 << i for i, c in enumerate(colors) if c == color) for color in (0, 1)]
    tables = []
    for p, mask in sieve:
        signatures = [(a % p, b % p) for a, b in vertices]
        groups = defaultdict(int)
        for i, sig in enumerate(signatures):
            groups[sig] |= 1 << i
        tables.append((p, mask, signatures, groups, {}))
    result = []
    for i, (a, b) in enumerate(vertices):
        possible = (color_words[colors[i]] >> (i + 1)) << (i + 1)
        for p, mask, signatures, groups, cache in tables:
            if not possible:
                break
            u = signatures[i]
            if u not in cache:
                word = 0
                for (c, d), group_word in groups.items():
                    index = ((u[0] * c - nu * u[1] * d + 1) % p) * p + (
                        (u[0] * d + u[1] * c + tau * u[1] * d) % p)
                    if (mask >> index) & 1:
                        word |= group_word
                cache[u] = word
            possible &= cache[u]
        targets = []
        while possible:
            bit = possible & -possible
            j = bit.bit_length() - 1
            targets.append(j)
            possible ^= bit
        result.append(targets)
    return result


def build_row(row, vertices, colors, sieve, tau, nu, diagnostic):
    survivors = complete_survivors(vertices, colors, sieve, tau, nu)
    assert sum(map(len, survivors)) == diagnostic["same_color_modular_survivors"]
    counts = Counter()
    q = nu if tau == 0 else 4 * nu - 1
    class_data = []
    lean_rows = []
    for color in (0, 1):
        indices = [i for i, c in enumerate(colors) if c == color]
        heads, witness_rows = [], []
        for i in indices:
            a, b = vertices[i]
            witnesses, rejects = [], []
            for j in survivors[i]:
                c, d = vertices[j]
                re_z = a * c - nu * b * d + 1
                im_z = a * d + b * c + tau * b * d
                # Recheck the direct radicand against every actual mask;
                # this also independently checks the cached multiplication.
                for p, mask in sieve:
                    assert (mask >> ((re_z % p) * p + im_z % p)) & 1
                if im_z == 0 and re_z < 0 and re_z % q != 0:
                    rejects.append(j)
                    counts["cheap_integer_guard"] += 1
                    continue
                if im_z != 0:
                    n = re_z * re_z + tau * re_z * im_z + nu * im_z * im_z
                    kind = "norm"
                    k = math.isqrt(n)
                    assert k * k < n < (k + 1) * (k + 1)
                elif re_z > 0:
                    kind = "positive_real"
                    k = math.isqrt(re_z)
                    assert k * k < re_z < (k + 1) * (k + 1)
                elif re_z < 0:
                    kind = "negative_scaled"
                    k = math.isqrt((-re_z) // q)
                    # Exact direct scaled inequalities: no Lean division needed.
                    assert q * k * k < -re_z < q * (k + 1) * (k + 1)
                else:
                    raise AssertionError((row, i, j, "zero is a square"))
                counts[kind] += 1
                witnesses.append(dict(target_index=j, kind=kind, k=k))
            heads.append(dict(head_index=i, modular_targets=survivors[i],
                cheap_guard_targets=rejects, floor_witnesses=witnesses))
            witness_rows.append([w["k"] for w in witnesses])
        assert len(heads) == diagnostic["color_counts"][color]
        assert not witness_rows or witness_rows[-1] == []
        class_data.append(dict(color=color, name="left" if color == 0 else "right",
            original_vertex_indices=indices, heads=heads,
            floor_witness_count=sum(map(len, witness_rows))))
        lean_rows.append(witness_rows)
    pairs = sum(len(xs) * (len(xs) - 1) // 2 for xs in
        [class_data[0]["original_vertex_indices"], class_data[1]["original_vertex_indices"]])
    assert pairs == diagnostic["same_color_unordered_checks"]
    return dict(row=row, tau=tau, nu=nu, guard_scale=q,
        color_mask=str(diagnostic["color_mask"]), vertices=len(vertices),
        full_unordered_pairs=pairs, modular_survivors=sum(map(len, survivors)),
        counts=dict(counts), colors=class_data), lean_rows


def lean_data(row, rows):
    def literal(xs):
        return "[\n" + ",\n".join("  [" + ", ".join(map(str, ys)) + "]" for ys in xs) + "\n]"
    return f'''import Mathlib.Data.List.Basic

namespace D1Bound5.PairFloorWitness{row}

/-- Untrusted floor witnesses, one list for each original color-class head.
The checker consumes a witness only after the cached sieve and integer guard.
The final head has an empty list; no coordinates or signatures are copied. -/
def leftRows : List (List ℕ) := {literal(rows[0])}

def rightRows : List (List ℕ) := {literal(rows[1])}

end D1Bound5.PairFloorWitness{row}
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rows", default="all", help="all or comma-separated row numbers")
    parser.add_argument("--source-dir", type=Path, default=ROOT / "finite_next/two_small/D1Bound5")
    parser.add_argument("--manifest-dir", type=Path, default=ROOT / "pair_witness_next")
    parser.add_argument("--sieve-dir", type=Path, default=ROOT / "finite_fast_next/sieves")
    parser.add_argument("--output", type=Path, default=HERE / "generated")
    args = parser.parse_args()
    selected = list(range(1, 49)) if args.rows == "all" else [int(x) for x in args.rows.split(",")]
    assert len(selected) == len(set(selected)) and all(1 <= k <= 48 for k in selected)
    inputs = {r["row"]: r for r in read_json(args.manifest_dir / "all48_input_fingerprints.json")}
    diagnostics = {r["row"]: r for r in read_json(args.manifest_dir / "all48_diagnostic_manifest.json")["rows"]}
    sieve_pins = read_json(args.manifest_dir / "cached_sieve_fingerprints.json")
    args.output.mkdir(parents=True, exist_ok=True)
    records, files, source_pins, totals = [], {}, {}, Counter()
    for row in selected:
        source_key = f"finite_next/two_small/D1Bound5/SmallPairGraphData{row}.lean"
        source_path = args.source_dir / f"SmallPairGraphData{row}.lean"
        tau, nu, vertices = parse_source(source_path, row, inputs[row]["files"][source_key], diagnostics[row])
        source_pins[source_key] = inputs[row]["files"][source_key]
        sieve_key = f"finite_fast_next/sieves/SmallPairSieve_{tau}_{nu}.lean"
        sieve = parse_sieve(args.sieve_dir / f"SmallPairSieve_{tau}_{nu}.lean", tau, nu, sieve_pins[sieve_key])
        source_pins[sieve_key] = sieve_pins[sieve_key]
        colors = [(int(diagnostics[row]["color_mask"]) >> i) & 1 for i in range(len(vertices))]
        data, rows = build_row(row, vertices, colors, sieve, tau, nu, diagnostics[row])
        outputs = {f"row{row:02}.json": json.dumps(data, separators=(",", ":")) + "\n",
            f"SmallPairFloorWitnessData{row}.lean": lean_data(row, rows)}
        for name, text in outputs.items():
            p = args.output / name
            p.write_text(text)
            files[name] = dict(sha256=sha(p.read_bytes()), bytes=p.stat().st_size)
        records.append({k: v for k, v in data.items() if k not in ("colors", "color_mask")})
        totals.update(data["counts"])
        print(f"row {row}: {data['modular_survivors']} survivors; "
            f"{sum(map(lambda c: c['floor_witness_count'], data['colors']))} floors", flush=True)
    if set(selected) == set(range(1, 49)):
        assert sum(totals.values()) == 68640
        assert totals == Counter(cheap_integer_guard=40026, positive_real=12443,
            negative_scaled=16165, norm=6)
    manifest = dict(scope="Untrusted generated data; all checks are exact Python diagnostics; no Lean build claim",
        witness_format="List (List Nat) per color, one list per head including last empty row; full original tail order",
        checker_order="distinct vertices, cached sieve, negative integer divisibility guard, one deterministic floor witness",
        full_unordered_pairs=sum(r["full_unordered_pairs"] for r in records),
        counts=dict(totals), rows=records, source_pins=source_pins,
        manifest_pins={p.name: sha(p.read_bytes()) for p in [args.manifest_dir / n for n in
            ["all48_input_fingerprints.json", "all48_diagnostic_manifest.json", "cached_sieve_fingerprints.json"]]},
        generator_sha256=sha(Path(__file__).read_bytes()), files=files)
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps({"counts": dict(totals), "files": len(files),
        "total_bytes": sum(v["bytes"] for v in files.values()), "manifest_sha256":
        sha((args.output / "manifest.json").read_bytes())}, indent=2))


if __name__ == "__main__":
    main()
