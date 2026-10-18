"""Portable optional graph staging with explicit verified backend selection.

Never installs, compiles, or edits an existing source. The frozen cp7 helpers
remain unchanged. All original declarations and public theorem statements are
preserved; only certificate proof ownership changes. Default pilots are 16,34;
row41 is excluded by default because its separate integration is owned by root.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
STRUCTURAL = {16, 22, 27, 31, 32, 37, 41}
FLOOR = {1, 6, 8, 9, 11, 12, 15, 17, 23, 24, 30, 33, 34, 40, 43, 46, 48}
INTEGER = set(range(1, 49)) - STRUCTURAL - FLOOR
assert len(INTEGER) == 24
sha = lambda b: hashlib.sha256(b).hexdigest()


def load_module(path, name, expected):
    assert sha(path.read_bytes()) == expected, str(path)
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def header(imports, namespace="D1Bound5", compute=False):
    return "".join(f"import D1Bound5.{m}\n" for m in imports) + f"\nnamespace {namespace}\n" + (
        "set_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n" if compute
        else "set_option maxRecDepth 100000\n\n")


def emit_row(row, staging, floors, sieve, floor_manifest):
    k, t, n = row["row"], row["tau"], row["nu"]
    ns = f"PairGraphPrepared{k}"
    backend = "structural" if k in STRUCTURAL else "sparse_floor" if k in FLOOR else "cached_integer"
    files = {}
    def put(module, text):
        files[f"D1Bound5/{module}.lean"] = text
    def original_statement(name):
        block = staging.theorem_block(row["source"], name)
        marker = " := by\n  decide +kernel"
        assert marker in block
        return block.split(marker, 1)[0] + " :="

    # Public data occurs exactly once. Closure witnesses live in a separate
    # data module, so neither color check imports their large numeral arrays.
    put(f"SmallPairGraphInputs{k}", header(["SmallPairGraphCheck"]) +
        "open QuadInt\n\n" + row["declarations"] + f"namespace {ns}\n\n" +
        f"def colors : ℕ := {row['diagnostic']['color_mask']}\n\n" +
        f"end {ns}\nend D1Bound5\n")
    roots = ",\n".join(f"  ({staging.lean_pair(r)}, {staging.lean_pair(s)})" for r, s in row["root_pairs"])
    dests = ",\n".join(f"  ({staging.lean_option(a)}, {staging.lean_option(b)})" for a, b in row["destinations"])
    put(f"SmallPairGraphWitnessData{k}", header([f"SmallPairGraphInputs{k}", "PairClosureWitness"],
        namespace=f"D1Bound5.{ns}") + f'''def anchorRoot : QuadInt {t} {n} := {staging.lean_pair(row["anchor_root"])}

def rootPairs : List (QuadInt {t} {n} × QuadInt {t} {n}) := [
{roots}
]

def witnesses : List (PairRootWitness {t} {n}) :=
  List.zipWith (fun (z : QuadInt {t} {n}) (rs : QuadInt {t} {n} × QuadInt {t} {n}) =>
    ⟨z, rs.1, rs.2⟩) smallPairClosure_{k} rootPairs

def destinations : List (Option ℕ × Option ℕ) := [
{dests}
]

end D1Bound5.{ns}
''')
    names = [f"smallPairSeeds_{k}_checked", f"smallPairFilter_{k}_checked", f"smallPairLarge_{k}_count"]
    put(f"SmallPairGraphArithmetic{k}", header([f"SmallPairGraphInputs{k}", "TwoSmallSeedDisks"],
        compute=True) + "\n\n".join(staging.theorem_block(row["source"], name) for name in names) +
        "\n\nend D1Bound5\n")
    put(f"SmallPairGraphClosure{k}", header([f"SmallPairGraphWitnessData{k}", "PairClosureIndexedWitness"],
        compute=True) + f'''open {ns}

theorem {ns}.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_{k} smallPairB_{k} anchorRoot
      (10^1100) smallPairClosure_{k} witnesses destinations = true := by
  decide +kernel

{original_statement(f"smallPairClosure_{k}_checked")}
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_{k} smallPairB_{k} anchorRoot
    (10^1100) smallPairClosure_{k} witnesses destinations {ns}.indexed_checked

end D1Bound5
''')
    triangle = original_statement(f"smallPairNoTriangle_{k}_checked")
    report = {"backend": backend}
    if backend == "structural":
        assert (t == 0 and n > 1) or (t == 1 and 4*n-1 > 1)
        assert all(2*a + t*b == 0 for a, b in row["large"])
        model = "zero" if t == 0 else "one"
        put(f"SmallPairGraphTriangle{k}", header([f"SmallPairGraphInputs{k}", "PairTraceZeroGraph",
            f"SmallPairSieve_{t}_{n}"], compute=True) + f'''theorem {ns}.all_trace_zero_checked :
    pairAllTraceZeroBool smallPairLarge_{k} = true := by
  decide +kernel

{triangle}
  pairGraphTriangleFreeBool_of_trace_zero_tau_{model} (by decide)
    smallPairSieve_{t}_{n} smallPairSieve_{t}_{n}_valid smallPairLarge_{k}
    {ns}.all_trace_zero_checked

end D1Bound5
''')
        report["linear_trace_checks"] = len(row["large"])
    else:
        colors = [(int(row["diagnostic"]["color_mask"]) >> i) & 1 for i in range(len(row["large"]))]
        floor_data, floor_rows = floors.build_row(k, row["large"], colors, sieve, t, n, row["diagnostic"])
        nfloors = sum(c["floor_witness_count"] for c in floor_data["colors"])
        assert (nfloors > 0) == (backend == "sparse_floor")
        if backend == "sparse_floor":
            fname = f"SmallPairFloorWitnessData{k}.lean"
            floor_text = floors.lean_data(k, floor_rows)
            assert sha(floor_text.encode()) == floor_manifest["files"][fname]["sha256"]
            put(f"SmallPairFloorWitnessData{k}", floor_text)
        signatures = [[(a % p, b % p) for p, _ in sieve] for a, b in row["large"]]
        sigrows = ",\n".join("  [" + ", ".join(f"({a}, {b})" for a, b in xs) + "]" for xs in signatures)
        put(f"SmallPairGraphCachedData{k}", header([f"SmallPairGraphInputs{k}", "PairCachedResidues",
            f"SmallPairSieve_{t}_{n}"], namespace=f"D1Bound5.{ns}") + f'''def cachedSignatures : List (List (ℕ × ℕ)) := [
{sigrows}
]

def cachedVertices : List (PairResidueVertex {t} {n}) :=
  List.zipWith (fun (z : QuadInt {t} {n}) (sig : List (ℕ × ℕ)) => ⟨z, sig⟩)
    smallPairLarge_{k} cachedSignatures

end D1Bound5.{ns}
''')
        checker = "Floor" if backend == "sparse_floor" else "Integer"
        generic = "PairCachedFloorWitnesses" if backend == "sparse_floor" else "PairCachedIntegerObstruction"
        theorem = "pairIndependentBool_of_cached_floor_certificate" if backend == "sparse_floor" else "pairIndependentBool_of_cached_integer_certificate"
        for side, projection in [("Left", 1), ("Right", 2)]:
            lower = side.lower()
            floor_arg = f"\n      PairFloorWitness{k}.{lower}Rows" if backend == "sparse_floor" else ""
            floor_proof_arg = f"\n    PairFloorWitness{k}.{lower}Rows" if backend == "sparse_floor" else ""
            imports = [f"SmallPairGraphCachedData{k}", generic]
            if backend == "sparse_floor":
                imports.append(f"SmallPairFloorWitnessData{k}")
            put(f"SmallPairGraph{side}{k}", header(imports, namespace=f"D1Bound5.{ns}", compute=True) + f'''theorem {lower}_certificate_checked :
    pairCached{checker}IndependentCertificateBool smallPairSieve_{t}_{n}
      (pairSplitByMask smallPairLarge_{k} colors).{projection}
      (pairSplitByMask cachedVertices colors).{projection}{floor_arg} = true := by
  decide +kernel

theorem {lower}_checked :
    pairIndependentBool smallPairSieve_{t}_{n}
      (pairSplitByMask smallPairLarge_{k} colors).{projection} = true :=
  {theorem} (by decide) smallPairSieve_{t}_{n}
    (pairSplitByMask smallPairLarge_{k} colors).{projection}
    (pairSplitByMask cachedVertices colors).{projection}{floor_proof_arg} {lower}_certificate_checked

end D1Bound5.{ns}
''')
        put(f"SmallPairGraphTriangle{k}", header([f"SmallPairGraphLeft{k}", f"SmallPairGraphRight{k}"]) + f'''open {ns}

{triangle}
  pairGraphTriangleFreeBool_of_split smallPairSieve_{t}_{n} smallPairLarge_{k} colors
    {ns}.left_checked {ns}.right_checked

end D1Bound5
''')
        report.update(floor_witness_count=nfloors, dispositions=floor_data["counts"],
            color_counts=row["diagnostic"]["color_counts"],
            full_unordered_pairs=floor_data["full_unordered_pairs"],
            signature_list_sha256=sha(json.dumps(signatures, separators=(",", ":")).encode()))
    put(f"SmallPairGraphData{k}", "".join(f"import D1Bound5.{m}\n" for m in
        [f"SmallPairGraphArithmetic{k}", f"SmallPairGraphClosure{k}", f"SmallPairGraphTriangle{k}"]))

    joined = "\n".join(files.values())
    assert sum(text.count(row["declarations"]) for text in files.values()) == 1
    for name in names:
        assert staging.theorem_block(row["source"], name) in joined
    for name in names + [f"smallPairClosure_{k}_checked", f"smallPairNoTriangle_{k}_checked"]:
        pat = rf"theorem {name}\b(.*?) :="
        old = re.findall(pat, row["source"], re.S)
        new = re.findall(pat, joined, re.S)
        assert len(old) == len(new) == 1 and old == new, name
    report.update(public_statements_preserved=True, arithmetic_blocks_preserved=True,
        declaration_block_occurrences=1,
        original_declarations_sha256=sha(row["declarations"].encode()))
    return files, report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rows", default="16,34")
    parser.add_argument("--exclude-rows", default="41")
    parser.add_argument("--input-dir", type=Path, default=ROOT / "finite_next/two_small/D1Bound5")
    parser.add_argument("--manifest-dir", type=Path, default=ROOT / "pair_witness_next")
    parser.add_argument("--sieve-dir", type=Path, default=ROOT / "finite_fast_next/sieves")
    parser.add_argument("--root-routine", type=Path, default=ROOT / "finite_next/two_small/generate_pair_closures.py")
    parser.add_argument("--staging-helper", type=Path, default=ROOT / "pair_witness_next/pair_staging.py")
    parser.add_argument("--floor-generator", type=Path, default=ROOT / "sparse_floor_next/generate_floor_witnesses.py")
    parser.add_argument("--floor-manifest", type=Path, default=ROOT / "sparse_floor_next/generated/manifest.json")
    parser.add_argument("--helper-dir", type=Path, help="optional flat directory containing all pinned Lean helpers")
    parser.add_argument("--source-pins", type=Path, default=HERE / "backend_source_pins.json")
    parser.add_argument("--output-dir", type=Path, default=HERE / "staged_pilots")
    parser.add_argument("--dry-run", action="store_true", help="write a manifest only, no Lean modules")
    parser.add_argument("--expected-manifest", type=Path, help="require exact generated source hashes before any Lean output")
    args = parser.parse_args()
    rows = list(range(1, 49)) if args.rows == "all" else [int(x) for x in args.rows.split(",")]
    excluded = {int(x) for x in args.exclude_rows.split(",") if x}
    rows = [k for k in rows if k not in excluded]
    assert rows and len(rows) == len(set(rows)) and all(1 <= k <= 48 for k in rows)
    pins = json.loads(args.source_pins.read_text())
    for relative, digest in pins.items():
        if relative.endswith(".lean"):
            path = args.helper_dir / Path(relative).name if args.helper_dir else ROOT / relative
            assert sha(path.read_bytes()) == digest, str(path)
    staging = load_module(args.staging_helper, "frozen_pair_staging_v1", pins["pair_witness_next/pair_staging.py"])
    floors = load_module(args.floor_generator, "frozen_sparse_floor_generator", pins["sparse_floor_next/generate_floor_witnesses.py"])
    staging.configure(args.input_dir, args.manifest_dir, args.root_routine, source_only=True)
    sieve_pins = json.loads((args.manifest_dir / "cached_sieve_fingerprints.json").read_text())
    floor_manifest = json.loads(args.floor_manifest.read_text())
    expected = ({r["row"]: r for r in json.loads(args.expected_manifest.read_text())["results"]}
        if args.expected_manifest else None)
    pending, reports = {}, []
    for k in rows:
        row = staging.load_row(k)
        t, n = row["tau"], row["nu"]
        relative = f"finite_fast_next/sieves/SmallPairSieve_{t}_{n}.lean"
        sieve = floors.parse_sieve(args.sieve_dir / Path(relative).name, t, n, sieve_pins[relative])
        files, report = emit_row(row, staging, floors, sieve, floor_manifest)
        encoded = {name: dict(sha256=sha(text.encode()), bytes=len(text.encode())) for name, text in files.items()}
        report.update(row=k, tau=t, nu=n, original_source_sha256=row["diagnostic"]["source_sha256"],
            vertices=len(row["vertices"]), large_vertices=len(row["large"]), files=encoded)
        if expected is not None:
            assert k in expected and encoded == expected[k]["files"], f"row{k}: generated bytes differ"
            assert report == expected[k], f"row{k}: preservation/backend metadata differ"
        assert not (pending.keys() & files.keys())
        pending.update(files)
        reports.append(report)
        print(f"row{k} {report['backend']}: {len(files)} modules verified", flush=True)
    # Verify every requested row before writing any Lean output.
    args.output_dir.mkdir(parents=True, exist_ok=True)
    if not args.dry_run:
        for name, text in pending.items():
            destination = args.output_dir / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_text(text)
    result = dict(status="Uncompiled optional replacements; no installation or kernel claim",
        rows=rows, excluded_rows=sorted(excluded), dry_run=args.dry_run,
        expected_manifest_verified=expected is not None, source_only=True,
        generator_sha256=sha(Path(__file__).read_bytes()),
        source_pins_sha256=sha(args.source_pins.read_bytes()), generic_source_pins=pins,
        floor_manifest_sha256=sha(args.floor_manifest.read_bytes()),
        backend_policy={"structural": sorted(STRUCTURAL), "cached_integer": sorted(INTEGER), "sparse_floor": sorted(FLOOR)},
        file_count=len(pending), total_bytes=sum(len(s.encode()) for s in pending.values()),
        ownership="Install as replacements: original public declarations occur once in Inputs; GraphData imports all original public theorem owners",
        isolation="Each color computation imports only Inputs/CachedData and generic checkers, never closure or arithmetic certificates",
        results=reports)
    dest = args.output_dir / "manifest.json"
    dest.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"file_count": result["file_count"], "total_bytes": result["total_bytes"],
        "manifest": str(dest), "sha256": sha(dest.read_bytes())}, indent=2))


if __name__ == "__main__":
    main()
