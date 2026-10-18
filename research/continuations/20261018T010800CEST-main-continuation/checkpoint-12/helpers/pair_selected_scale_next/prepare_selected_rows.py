"""Portable selected/literal graph preparation; diagnostic by default.

Read only SHA-pinned original sources, masks, colors, and sparse floor data.
Reconstruct the same full ordered tails, replacing a sieve scan by its first
rejecting index.  No Lean build or installation is performed.  --emit writes
only explicitly selected prospective modules to a NEW output directory.
Python validation is diagnostic; every emitted certificate still uses Lean's
decide +kernel and concludes the unchanged original Boolean predicate.
"""
from collections import Counter, defaultdict
from pathlib import Path
import argparse
import ast
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
STRUCTURAL = {16, 22, 27, 31, 32, 37, 41}
PINS = {
    "pair_witness_next/all48_input_fingerprints.json": "bdd16d0325e6237beb4875fb7056ffa037e57fc6c6e7b4371f389e2b4f1ed403",
    "pair_witness_next/all48_diagnostic_manifest.json": "49b6332742a0dfadd90242da13148e67192ff4aaab1e672bb790db4a5b50162e",
    "pair_witness_next/cached_sieve_fingerprints.json": "ac4f2af9a284c846b122a07028e564646c8bf341f745b084f0aa7ed1e56e1893",
    "sparse_floor_next/generated/manifest.json": "729158bc68316f922d0572617ea551e25e1aca63ea1c871c69935e5c7d0a12f9",
    "sparse_floor_next/generate_floor_witnesses.py": "1f9564b5ac95a26dc7017d7c4dbca1bad0b15eed0aad02817452a97903790f68",
    "crossblock_performance_next/selected_mask_costs.json": "dd0ca04c26af37ee65400336ed7b5ba1ae64b11dab3345c25cfbd45db51f5da3",
    "pair_backend_next/stage_pair_backends.py": "4942337e7b44f4c84ef0ef0b75ef6aeb2c90fd5e17d74df28ba8df8af750ec7a",
    "pair_backend_next/backend_source_pins.json": "07bcd289cf1e66855f3178c79fd66053518d5657c0e1ae8a55a614e0b7f3d25c",
    "pair_backend_next/all47_dry/manifest.json": "f545ddfd9ae3dfd75f318f815b229afa74119756b6648b919ff0a986d266b198",
    "pair_selected_next/generated/SmallPairSelectedData34.lean": "9a05216afd22493a58f74a21dd802492e7d8d57e0e80180cb8c7e7bd0d6e06c6",
    "pair_witness_next/PairSelectedCachedMask.lean": "842d5e0cce863d3301c8c65c34a04d2d07c08d156761bf506cdbbebcdd0db1f4",
    "pair_witness_next/PairSelectedFloorWitnesses.lean": "5627d261d76c8200c3ce7a8601856a8cef8aa9e7be044b0ebf81c7f060ce8b74",
    "pair_witness_next/PairResidueMaskNat.lean": "f838a6119a4b84b5889032242bf1d0b6ceb9a78264fea0197c14bf45d2cae39f",
    "pair_witness_next/PairRawSelectedFloorWitnesses.lean": "16663ee7ed18799dce07207a0b374d05787f04c1c37fca43ad73b4907ad0a013",
}
sha = lambda b: hashlib.sha256(b).hexdigest()
digest = lambda x: sha(json.dumps(x, separators=(",", ":")).encode())


def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def selected_words(vertices, colors, sieve, tau, nu, frozen):
    """Assign every actual full-tail pair; no positive-edge graph is input."""
    classes = [[i for i, c in enumerate(colors) if c == color] for color in (0, 1)]
    color_words = [sum(1 << i for i in indices) for indices in classes]
    tables = []
    for p, mask in sieve:
        sig = [(a % p, b % p) for a, b in vertices]
        groups = defaultdict(int)
        for i, u in enumerate(sig):
            groups[u] |= 1 << i
        tables.append((p, mask, sig, groups, {}))
    rows, stats, code_digest = [[], []], [Counter(), Counter()], hashlib.sha256()
    floor_heads = {h["head_index"]: h for c in frozen["colors"] for h in c["heads"]}
    assert len(floor_heads) == len(vertices)
    q = nu if tau == 0 else 4 * nu - 1
    assert tau in (0, 1) and q > 0
    for i, x in enumerate(vertices):
        color, out = colors[i], stats[colors[i]]
        targets = [j for j in classes[color] if j > i]
        possible = (color_words[color] >> (i + 1)) << (i + 1)
        tags = {}
        for tag, (p, mask, sig, groups, cache) in enumerate(tables):
            if not possible:
                break
            out["old_mask_calls"] += possible.bit_count()
            u = sig[i]
            if u not in cache:
                allowed = 0
                for (c, d), group in groups.items():
                    idx = ((u[0]*c - nu*u[1]*d + 1) % p)*p + ((u[0]*d + u[1]*c + tau*u[1]*d) % p)
                    if (mask >> idx) & 1:
                        allowed |= group
                cache[u] = allowed
            rejected = possible & ~cache[u]
            out["selected_mask_calls"] += rejected.bit_count()
            out["selected_index_sum"] += tag * rejected.bit_count()
            while rejected:
                bit = rejected & -rejected
                tags[bit.bit_length()-1] = tag
                rejected ^= bit
            possible &= cache[u]
        survivors, guards, floor_cursor = [], [], 0
        head = floor_heads[i]
        ks = [w["k"] for w in head["floor_witnesses"]]
        while possible:
            bit = possible & -possible
            j = bit.bit_length()-1
            survivors.append(j)
            a, b = x
            c, d = vertices[j]
            re_z, im_z = a*c - nu*b*d + 1, a*d + b*c + tau*b*d
            if im_z == 0 and re_z < 0 and re_z % q != 0:
                guards.append(j)
                out["guard_tags"] += 1
            else:
                w = head["floor_witnesses"][floor_cursor]
                assert w["target_index"] == j
                k = w["k"]
                assert isinstance(k, int) and k >= 0
                if im_z != 0:
                    n = re_z*re_z + tau*re_z*im_z + nu*im_z*im_z
                    assert k*k < n < (k+1)*(k+1)
                elif re_z > 0:
                    assert k*k < re_z < (k+1)*(k+1)
                else:
                    assert re_z < 0 and q*k*k < -re_z < q*(k+1)*(k+1)
                floor_cursor += 1
                out["floor_tags"] += 1
            tags[j] = 31
            possible ^= bit
        assert survivors == head["modular_targets"]
        assert guards == head["cheap_guard_targets"]
        assert floor_cursor == len(ks)
        assert set(tags) == set(targets)
        code = sum(tags[j] << (5*n) for n, j in enumerate(targets))
        remaining = code
        for j in targets:
            assert remaining % 32 == tags[j]
            remaining //= 32
        assert remaining == 0
        rows[color].append((code, ks))
        out["vertices"] += 1
        out["pairs"] += len(targets)
        code_digest.update(f"{i}:{code}\n".encode())
    for color, indices in enumerate(classes):
        assert indices == frozen["colors"][color]["original_vertex_indices"]
        assert [ks for _, ks in rows[color]] == [
            [w["k"] for w in h["floor_witnesses"]] for h in frozen["colors"][color]["heads"]]
        assert not rows[color] or rows[color][-1] == (0, [])
    return rows, classes, stats, code_digest.hexdigest()


def stage_row(root, k, selected, classes, sieve, floors, floor_manifest, old_manifest):
    """Retain reviewed source/closure/arithmetic blocks; replace only colors."""
    backend = load_module(root / "pair_backend_next/stage_pair_backends.py", "frozen_backend")
    pins = json.loads((root / "pair_backend_next/backend_source_pins.json").read_text())
    staging = load_module(root / "pair_witness_next/pair_staging.py", "frozen_staging")
    staging.configure(root / "finite_next/two_small/D1Bound5", root / "pair_witness_next",
        root / "finite_next/two_small/generate_pair_closures.py", source_only=True)
    row = staging.load_row(k)
    files, _ = backend.emit_row(row, staging, floors, sieve, floor_manifest)
    assert {name: dict(sha256=sha(s.encode()), bytes=len(s.encode())) for name, s in files.items()} == old_manifest[k]["files"]
    # The full old scaffold was reconstructed and fingerprinted before any change.
    keep = {f"D1Bound5/SmallPairGraph{part}{k}.lean" for part in ("Inputs", "WitnessData", "Arithmetic", "Closure", "Data")}
    files = {name: s for name, s in files.items() if name in keep}
    t, n, ns = row["tau"], row["nu"], f"PairSelectedPrepared{k}"
    header = backend.header
    data = header([f"SmallPairGraphInputs{k}", "PairCachedResidues", f"SmallPairSieve_{t}_{n}"], namespace=f"D1Bound5.{ns}")
    for side, indices, words in zip(("left", "right"), classes, selected):
        records = []
        for i in indices:
            a, b = row["large"][i]
            sig = ", ".join(f"({a % p}, {b % p})" for p, _ in sieve)
            records.append(f"  ⟨⟨{a}, {b}⟩, [{sig}]⟩")
        data += f"def {side}Cached : List (PairResidueVertex {t} {n}) := [\n" + ",\n".join(records) + "\n]\n\n"
        data += f"def {side}Rows : List (ℕ × List ℕ) := [\n" + ",\n".join(
            f"  ({code}, [{', '.join(map(str, ks))}])" for code, ks in words) + "\n]\n\n"
    data += f"end D1Bound5.{ns}\n"
    files[f"D1Bound5/SmallPairRawSelectedData{k}.lean"] = data
    for side, projection in (("Left", 1), ("Right", 2)):
        lower = side.lower()
        target = f"(pairSplitByMask smallPairLarge_{k} PairGraphPrepared{k}.colors).{projection}"
        text = header([f"SmallPairRawSelectedData{k}", "PairRawSelectedFloorWitnesses"], namespace=f"D1Bound5.{ns}", compute=True)
        text += f'''theorem {lower}_coverage_checked :
    decide ({lower}Cached.map PairResidueVertex.vertex = {target}) = true := by
  decide +kernel

theorem {lower}_signatures_checked :
    ({lower}Cached.all fun x => decide (x.signature = pairCoordinateSignature smallPairSieve_{t}_{n} x.vertex)) = true := by
  decide +kernel

theorem {lower}_independent_checked :
    pairRawSelectedFloorIndependentBool smallPairSieve_{t}_{n} {lower}Cached {lower}Rows = true := by
  decide +kernel

theorem {lower}_certificate_checked :
    pairRawSelectedFloorIndependentCertificateBool smallPairSieve_{t}_{n}
      {target} {lower}Cached {lower}Rows = true := by
  unfold pairRawSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨{lower}_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨{lower}_signatures_checked, {lower}_independent_checked⟩⟩

theorem {lower}_checked : pairIndependentBool smallPairSieve_{t}_{n} {target} = true :=
  pairIndependentBool_of_raw_selected_floor_certificate (by decide) smallPairSieve_{t}_{n}
    {target} {lower}Cached {lower}Rows {lower}_certificate_checked

end D1Bound5.{ns}
'''
        files[f"D1Bound5/SmallPairRawSelected{side}{k}.lean"] = text
    original = staging.theorem_block(row["source"], f"smallPairNoTriangle_{k}_checked")
    statement = original.split(" := by\n  decide +kernel", 1)[0] + " :="
    files[f"D1Bound5/SmallPairGraphTriangle{k}.lean"] = header([f"SmallPairRawSelectedLeft{k}", f"SmallPairRawSelectedRight{k}"]) + f'''{statement}
  pairGraphTriangleFreeBool_of_split smallPairSieve_{t}_{n} smallPairLarge_{k} PairGraphPrepared{k}.colors
    {ns}.left_checked {ns}.right_checked

end D1Bound5
'''
    joined = "\n".join(files.values())
    for name in (f"smallPairSeeds_{k}_checked", f"smallPairClosure_{k}_checked", f"smallPairFilter_{k}_checked", f"smallPairNoTriangle_{k}_checked", f"smallPairLarge_{k}_count"):
        pat = rf"theorem {name}\b(.*?) :="
        assert re.findall(pat, joined, re.S) == re.findall(pat, row["source"], re.S)
    assert sum(s.count(row["declarations"]) for s in files.values()) == 1
    return files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, default=ROOT, help="portable input bundle root; no absolute paths are written to the manifest")
    parser.add_argument("--rows", default="all")
    parser.add_argument("--stage-rows", default="47", help="build prospective source bytes/hashes only for these nonstructural rows")
    parser.add_argument("--output-dir", type=Path, default=Path(__file__).parent / "dry_inventory")
    parser.add_argument("--emit", action="store_true", help="write explicitly staged Lean sources into a new directory")
    parser.add_argument("--expected-manifest", type=Path)
    args = parser.parse_args()
    root = args.workspace
    for relative, pin in PINS.items():
        assert sha((root / relative).read_bytes()) == pin, relative
    backend_pins = json.loads((root / "pair_backend_next/backend_source_pins.json").read_text())
    for relative, pin in backend_pins.items():
        assert sha((root / relative).read_bytes()) == pin, relative
    read = lambda relative: json.loads((root / relative).read_text())
    inputs = {r["row"]: r for r in read("pair_witness_next/all48_input_fingerprints.json")}
    diagnostics = {r["row"]: r for r in read("pair_witness_next/all48_diagnostic_manifest.json")["rows"]}
    costs = {r["row"]: r for r in read("crossblock_performance_next/selected_mask_costs.json")["rows"]}
    sieve_pins = read("pair_witness_next/cached_sieve_fingerprints.json")
    floor_manifest = read("sparse_floor_next/generated/manifest.json")
    old_manifest = {r["row"]: r for r in read("pair_backend_next/all47_dry/manifest.json")["results"]}
    floors = load_module(root / "sparse_floor_next/generate_floor_witnesses.py", "pinned_floors")
    rows = list(range(1, 49)) if args.rows == "all" else [int(x) for x in args.rows.split(",")]
    staged = {int(x) for x in args.stage_rows.split(",") if x}
    assert len(rows) == len(set(rows)) and rows and set(rows) <= set(range(1, 49))
    assert staged <= set(rows) and not staged & STRUCTURAL
    reports, pending = [], {}
    for k in rows:
        original = f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean"
        t, n, vertices = floors.parse_source(root / original, k, inputs[k]["files"][original], diagnostics[k])
        sieve_path = f"finite_fast_next/sieves/SmallPairSieve_{t}_{n}.lean"
        sieve = floors.parse_sieve(root / sieve_path, t, n, sieve_pins[sieve_path])
        floor_name = f"row{k:02}.json"
        floor_bytes = (root / "sparse_floor_next/generated" / floor_name).read_bytes()
        assert sha(floor_bytes) == floor_manifest["files"][floor_name]["sha256"]
        frozen = json.loads(floor_bytes)
        colors = [(int(diagnostics[k]["color_mask"]) >> i) & 1 for i in range(len(vertices))]
        assert int(diagnostics[k]["color_mask"]) >> len(vertices) == 0
        selected, classes, stats, packed_digest = selected_words(vertices, colors, sieve, t, n, frozen)
        assert packed_digest == costs[k]["packed_codes_digest"]
        for color, s in enumerate(stats):
            for key in ("vertices", "pairs", "old_mask_calls", "selected_mask_calls", "selected_index_sum", "guard_tags", "floor_tags"):
                assert s[key] == costs[k]["classes"][color].get(key, 0), (k, color, key)
        if k == 34:
            source = (root / "pair_selected_next/generated/SmallPairSelectedData34.lean").read_text()
            for side, actual in zip(("left", "right"), selected):
                literal = re.search(rf"def {side}Rows .*? := (\[.*?\n\])", source, re.S).group(1)
                assert ast.literal_eval(literal) == actual, "Previously certified row34 words/floors changed"
        report = dict(row=k, tau=t, nu=n, structural=k in STRUCTURAL, classes=[dict(s) for s in stats],
            original_source_sha256=inputs[k]["files"][original], sieve_sha256=sieve_pins[sieve_path],
            floor_json_sha256=sha(floor_bytes), packed_codes_digest=packed_digest,
            selected_rows_digest=digest(selected), class_indices_digest=digest(classes),
            every_frozen_floor_and_target_preserved=True, row34_literal_replayed=(k == 34))
        if k in staged:
            files = stage_row(root, k, selected, classes, sieve, floors, floor_manifest, old_manifest)
            assert not pending.keys() & files.keys()
            pending.update(files)
            report["files"] = {name: dict(sha256=sha(s.encode()), bytes=len(s.encode())) for name, s in files.items()}
        reports.append(report)
        print(f"row{k}: classes {list(map(len, classes))}, {sum(s['pairs'] for s in stats)} full-tail pairs verified", flush=True)
    manifest = dict(status="Diagnostic/source-only preparation; no new kernel certificate claimed",
        generator_sha256=sha(Path(__file__).read_bytes()), source_pins=PINS, backend_pins=backend_pins,
        rows=rows, staged_rows=sorted(staged), results=reports,
        file_count=len(pending), total_source_bytes=sum(len(s.encode()) for s in pending.values()),
        full_tail_order_preserved=True, old_public_types_preserved=True,
        original_seed_closure_filter_count_sources_retained=True,
        raw_change_only_uses_accepted_boolean_equality=True)
    if args.expected_manifest:
        assert manifest == json.loads(args.expected_manifest.read_text()), "Dry-run/source fingerprint mismatch"
    assert not args.output_dir.exists(), "Choose a NEW output directory; existing sources are never overwritten"
    args.output_dir.mkdir(parents=True)
    if args.emit:
        for name, s in pending.items():
            path = args.output_dir / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(s)
    (args.output_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps(dict(staged_rows=sorted(staged), emitted=args.emit, file_count=len(pending),
        bytes=manifest["total_source_bytes"], manifest_sha256=sha((args.output_dir / "manifest.json").read_bytes())), indent=2))


if __name__ == "__main__":
    main()
