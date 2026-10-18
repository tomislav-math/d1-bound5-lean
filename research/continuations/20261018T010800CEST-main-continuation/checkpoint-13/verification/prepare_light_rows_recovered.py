"""New optional Init-only backend over the frozen selected/literal generator.

The source-only dry run reproduces every frozen selected word and floor before
converting representation. Original heavy data remains the exact assembly
equality target. No old source is changed, no Lean process is started, and only
explicitly staged rows can be emitted to a NEW directory. The seven structural
rows retain the existing trace-zero backend; all48 remain diagnostic inputs.
"""
from pathlib import Path
import argparse
import ast
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
RAW_GENERATOR = "pair_selected_scale_next/prepare_selected_rows.py"
RAW_SHA = "ec862156543e3f4304b253e54591adfbcdc32acfd4f459f6fd8c16547bf32174"
LIGHT_PINS = {
    "pair_light_next/PairLightArithmetic.lean": "ac3b9e9f7d91be83861de5b2f384eb0c669c61cfa9bd323309d57565e89af6eb",
    "pair_light_next/PairLightArithmeticBridge.lean": "74989ea9779fa4da2831c156377a44908c388871054e7832fd443986758442a6",
    "audit_next/pair_light_bridge_74989ea_review.json": "be8112b3252d0e023ee26bf4e4a63c7ca82f0c31819084142e688cf0353fb6b6",
}
sha = lambda b: hashlib.sha256(b).hexdigest()


def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def literal(items):
    return "[\n" + ",\n".join("  " + item for item in items) + "\n]"


def light_sources(k, tau, nu, vertices, classes, sieve, selected, raw_files):
    """Representation-only conversion; retain exact original heavy targets."""
    ns = f"PairLightPrepared{k}"
    source = "import D1Bound5.PairLightArithmetic\n\n" + f"namespace D1Bound5.{ns}\n"
    source += "set_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n"
    source += "def sieve : List (Nat × Nat) := " + literal([f"({p-1}, {mask})" for p, mask in sieve]) + "\n\n"
    for side, indices, rows in zip(("left", "right"), classes, selected):
        coords = [vertices[i] for i in indices]
        source += f"def {side}Vertices : List PairLightCoordinate := " + literal([f"({a}, {b})" for a, b in coords]) + "\n\n"
        records = []
        for a, b in coords:
            sig = ", ".join(f"({a % p}, {b % p})" for p, _ in sieve)
            records.append(f"(({a}, {b}), [{sig}])")
        source += f"def {side}Cached : List PairLightCachedVertex := " + literal(records) + "\n\n"
        source += f"def {side}Rows : List (Nat × List Nat) := " + literal([
            f"({code}, [{', '.join(map(str, ks))}])" for code, ks in rows]) + "\n\n"
    source += f"end D1Bound5.{ns}\n"
    # Five original scaffold modules and the exact raw data module remain.
    replaced = {f"D1Bound5/SmallPairRawSelected{side}{k}.lean" for side in ("Left", "Right")}
    files = {name: text for name, text in raw_files.items() if name not in replaced}
    files[f"D1Bound5/SmallPairLightData{k}.lean"] = source
    for side in ("Left", "Right"):
        lower = side.lower()
        files[f"D1Bound5/SmallPairLight{side}{k}.lean"] = f'''import D1Bound5.SmallPairLightData{k}

namespace D1Bound5.{ns}
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {lower}_coverage_checked :
    decide ({lower}Cached.map Prod.fst = {lower}Vertices) = true := by
  decide +kernel

theorem {lower}_signatures_checked :
    ({lower}Cached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := by
  decide +kernel

theorem {lower}_independent_checked :
    pairLightSelectedFloorIndependentBool {tau} {nu} sieve {lower}Cached {lower}Rows = true := by
  decide +kernel

theorem {lower}_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool {tau} {nu} sieve
      {lower}Vertices {lower}Cached {lower}Rows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨{lower}_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨{lower}_signatures_checked, {lower}_independent_checked⟩⟩

end D1Bound5.{ns}
'''
    assembly = f'''import D1Bound5.SmallPairLightLeft{k}
import D1Bound5.SmallPairLightRight{k}
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData{k}

namespace D1Bound5.{ns}
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_{tau}_{nu} := by
  rfl

'''
    for side, projection in (("left", 1), ("right", 2)):
        target = f"(pairSplitByMask smallPairLarge_{k} PairGraphPrepared{k}.colors).{projection}"
        assembly += f'''theorem {side}Vertices_eq :
    {side}Vertices = {target}.map pairLightCoordinates := by
  decide +kernel

theorem {side}Cached_eq :
    {side}Cached = PairSelectedPrepared{k}.{side}Cached.map pairLightCachedCoordinates := by
  rfl

theorem {side}Rows_eq : {side}Rows = PairSelectedPrepared{k}.{side}Rows := by
  rfl

theorem {side}_checked :
    pairIndependentBool smallPairSieve_{tau}_{nu} {target} = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_{tau}_{nu}
    {target} PairSelectedPrepared{k}.{side}Cached PairSelectedPrepared{k}.{side}Rows
  rw [← sieve_eq, ← {side}Vertices_eq, ← {side}Cached_eq, ← {side}Rows_eq]
  exact {side}_certificate_checked

'''
    assembly += f"end D1Bound5.{ns}\n"
    files[f"D1Bound5/SmallPairLightAssembly{k}.lean"] = assembly
    triangle_name = f"D1Bound5/SmallPairGraphTriangle{k}.lean"
    old_triangle = raw_files[triangle_name]
    old_body = old_triangle[old_triangle.index("namespace D1Bound5\n"):]
    body = old_body.replace(f"PairSelectedPrepared{k}.left_checked", f"{ns}.left_checked").replace(
        f"PairSelectedPrepared{k}.right_checked", f"{ns}.right_checked")
    files[triangle_name] = f"import D1Bound5.SmallPairLightAssembly{k}\n\n" + body
    # Exact public type; only proof references/imports change.
    pattern = rf"theorem smallPairNoTriangle_{k}_checked\b(.*?) :="
    assert re.findall(pattern, files[triangle_name], re.S) == re.findall(pattern, old_triangle, re.S)
    for name, text in raw_files.items():
        if name not in replaced | {triangle_name}:
            assert files[name] == text
    # Pure data/check chain has only the lightweight definitions as its root.
    assert re.findall(r"^import (.+)$", source, re.M) == ["D1Bound5.PairLightArithmetic"]
    for side in ("Left", "Right"):
        assert re.findall(r"^import (.+)$", files[f"D1Bound5/SmallPairLight{side}{k}.lean"], re.M) == [f"D1Bound5.SmallPairLightData{k}"]
    return files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, default=ROOT)
    parser.add_argument("--rows", default="all")
    parser.add_argument("--stage-rows", default="47")
    parser.add_argument("--output-dir", type=Path, default=Path(__file__).parent / "dry_inventory")
    parser.add_argument("--emit", action="store_true")
    parser.add_argument("--expected-manifest", type=Path)
    args = parser.parse_args()
    root = args.workspace
    assert sha((root / RAW_GENERATOR).read_bytes()) == RAW_SHA
    raw = load_module(root / RAW_GENERATOR, "frozen_selected_rows")
    pins = {**raw.PINS, **LIGHT_PINS, RAW_GENERATOR: RAW_SHA}
    for name, h in pins.items():
        assert sha((root / name).read_bytes()) == h, name
    review = json.loads((root / "audit_next/pair_light_bridge_74989ea_review.json").read_text())
    assert review["source_sha256"] == LIGHT_PINS["pair_light_next/PairLightArithmeticBridge.lean"]
    assert review["source_review_pass"] is True and review["reviewer"]
    read = lambda name: json.loads((root / name).read_text())
    backend_pins = read("pair_backend_next/backend_source_pins.json")
    for name, h in backend_pins.items():
        assert sha((root / name).read_bytes()) == h, name
    inputs = {r["row"]: r for r in read("pair_witness_next/all48_input_fingerprints.json")}
    diagnostics = {r["row"]: r for r in read("pair_witness_next/all48_diagnostic_manifest.json")["rows"]}
    costs = {r["row"]: r for r in read("crossblock_performance_next/selected_mask_costs.json")["rows"]}
    sieve_pins = read("pair_witness_next/cached_sieve_fingerprints.json")
    floor_manifest = read("sparse_floor_next/generated/manifest.json")
    old_manifest = {r["row"]: r for r in read("pair_backend_next/all47_dry/manifest.json")["results"]}
    floors = raw.load_module(root / "sparse_floor_next/generate_floor_witnesses.py", "frozen_light_floors")
    rows = list(range(1, 49)) if args.rows == "all" else [int(x) for x in args.rows.split(",")]
    staged = {int(x) for x in args.stage_rows.split(",") if x}
    assert rows and len(rows) == len(set(rows)) and set(rows) <= set(range(1, 49))
    assert staged <= set(rows) and not staged & raw.STRUCTURAL
    reports, pending = [], {}
    for k in rows:
        original = f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean"
        t, n, vertices = floors.parse_source(root / original, k, inputs[k]["files"][original], diagnostics[k])
        sieve_name = f"finite_fast_next/sieves/SmallPairSieve_{t}_{n}.lean"
        sieve = floors.parse_sieve(root / sieve_name, t, n, sieve_pins[sieve_name])
        floor_name = f"row{k:02}.json"
        floor_bytes = (root / "sparse_floor_next/generated" / floor_name).read_bytes()
        assert sha(floor_bytes) == floor_manifest["files"][floor_name]["sha256"]
        colors = [(int(diagnostics[k]["color_mask"]) >> i) & 1 for i in range(len(vertices))]
        assert int(diagnostics[k]["color_mask"]) >> len(vertices) == 0
        selected, classes, stats, code_digest = raw.selected_words(vertices, colors, sieve, t, n, json.loads(floor_bytes))
        assert code_digest == costs[k]["packed_codes_digest"]
        for color, stat in enumerate(stats):
            for key in ("vertices", "pairs", "old_mask_calls", "selected_mask_calls", "selected_index_sum", "guard_tags", "floor_tags"):
                assert stat[key] == costs[k]["classes"][color].get(key, 0)
        if k == 34:
            source = (root / "pair_selected_next/generated/SmallPairSelectedData34.lean").read_text()
            for side, actual in zip(("left", "right"), selected):
                assert ast.literal_eval(re.search(rf"def {side}Rows .*? := (\[.*?\n\])", source, re.S).group(1)) == actual
        report = dict(row=k, tau=t, nu=n, structural=k in raw.STRUCTURAL,
            classes=[dict(s) for s in stats], packed_codes_digest=code_digest,
            selected_rows_digest=raw.digest(selected), class_indices_digest=raw.digest(classes))
        if k in staged:
            raw_files = raw.stage_row(root, k, selected, classes, sieve, floors, floor_manifest, old_manifest)
            files = light_sources(k, t, n, vertices, classes, sieve, selected, raw_files)
            assert not pending.keys() & files.keys()
            pending.update(files)
            report["files"] = {name: dict(sha256=sha(text.encode()), bytes=len(text.encode())) for name, text in files.items()}
        reports.append(report)
        print(f"row{k}: exact selected/floor replay; light source staged={k in staged}", flush=True)
    manifest = dict(status="Uncompiled representation-only light backend; no performance or theorem acceptance claimed",
        generator_sha256=sha(Path(__file__).read_bytes()), source_pins=pins, backend_pins=backend_pins,
        rows=rows, staged_rows=sorted(staged), results=reports,
        bridge_source_review_is_not_kernel_acceptance=True,
        all_original_data_and_public_types_preserved=True,
        pure_data_and_checks_have_no_heavy_import=True,
        mandatory_assembly_equalities=["sieve", "ordered original split vertices", "original cached records", "original packed words and floors"],
        file_count=len(pending), total_source_bytes=sum(len(s.encode()) for s in pending.values()))
    if args.expected_manifest:
        assert manifest == json.loads(args.expected_manifest.read_text())
    assert not args.output_dir.exists(), "Choose a NEW output directory; old sources are never overwritten"
    args.output_dir.mkdir(parents=True)
    if args.emit:
        for name, source in pending.items():
            path = args.output_dir / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(source)
    (args.output_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps(dict(emitted=args.emit, files=len(pending), bytes=manifest["total_source_bytes"],
        manifest_sha256=sha((args.output_dir / "manifest.json").read_bytes())), indent=2))


if __name__ == "__main__":
    main()
