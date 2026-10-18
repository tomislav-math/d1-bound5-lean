"""Compact production staging by exact-body bundling of reviewed modules.

No installation or Lean compilation. Existing expanded staging, checkpoints
and the already-intaken rows16/34/41 remain unchanged. The default45 new rows
use one structural GraphData module or four nonstructural modules. Every
namespace body is byte-preserved; only imports and file ownership change.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
EXPANDED_SHA = "4942337e7b44f4c84ef0ef0b75ef6aeb2c90fd5e17d74df28ba8df8af750ec7a"
sha = lambda b: hashlib.sha256(b).hexdigest()


def load(path, name, digest):
    assert sha(path.read_bytes()) == digest, str(path)
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def module_name(path):
    return str(Path(path).with_suffix("")).replace("/", ".")


def module_parts(text):
    imports = re.findall(r"^import (\S+)\s*$", text, re.M)
    prefix = re.match(r"\A(?:import [^\n]+\n)+", text)
    assert prefix is not None
    body = text[prefix.end():].strip()
    assert not re.search(r"^import ", body, re.M)
    return imports, body


def bundle(files, row, backend):
    k = row
    module_files = {module_name(name): text for name, text in files.items()}
    inputs = f"D1Bound5.SmallPairGraphInputs{k}"
    data = f"D1Bound5.SmallPairGraphData{k}"
    left, right = (f"D1Bound5.SmallPairGraph{s}{k}" for s in ("Left", "Right"))
    def mod(stem):
        return f"D1Bound5.{stem}{k}"
    if backend == "structural":
        groups = {data: [inputs, mod("SmallPairGraphWitnessData"),
            mod("SmallPairGraphArithmetic"), mod("SmallPairGraphClosure"),
            mod("SmallPairGraphTriangle"), data]}
    else:
        data_only = [inputs, mod("SmallPairGraphWitnessData"), mod("SmallPairGraphCachedData")]
        if backend == "sparse_floor":
            data_only.append(mod("SmallPairFloorWitnessData"))
        groups = {inputs: data_only, left: [left], right: [right],
            data: [mod("SmallPairGraphArithmetic"), mod("SmallPairGraphClosure"),
                mod("SmallPairGraphTriangle"), data]}
    flattened = [name for names in groups.values() for name in names]
    assert len(flattened) == len(set(flattened)) and set(flattened) == set(module_files)
    owners = {name: owner for owner, names in groups.items() for name in names}
    out, proof = {}, {}
    for owner, names in groups.items():
        imports, bodies = [], []
        for name in names:
            old_imports, body = module_parts(module_files[name])
            for dependency in old_imports:
                replacement = owners.get(dependency, dependency)
                if replacement != owner and replacement not in imports:
                    imports.append(replacement)
            if body:
                bodies.append(body)
        text = "".join(f"import {name}\n" for name in imports) + "\n" + "\n\n".join(bodies) + "\n"
        out[owner.replace(".", "/") + ".lean"] = text
        proof[owner] = dict(original_bodies=names, imports=imports,
            body_hashes={name: sha(module_parts(module_files[name])[1].encode()) for name in names})
    joined = "\n".join(out.values())
    for name, text in module_files.items():
        body = module_parts(text)[1]
        if body:
            assert sum(t.count(body) for t in out.values()) == 1, name
    # Exact theorem bodies, types, predicates and arguments are retained.
    original_joined = "\n".join(module_files.values())
    for label in ["Seeds", "Closure", "Filter", "NoTriangle"]:
        name = f"smallPair{label}_{k}_checked"
        pattern = rf"theorem {name}\b(.*?) :="
        assert re.findall(pattern, joined, re.S) == re.findall(pattern, original_joined, re.S)
    count_pattern = rf"theorem smallPairLarge_{k}_count\b(.*?) :="
    assert re.findall(count_pattern, joined, re.S) == re.findall(count_pattern, original_joined, re.S)

    graph = {name: [dep for dep in record["imports"] if dep in groups] for name, record in proof.items()}
    def descendants(name, visiting=None):
        visiting = set() if visiting is None else visiting
        assert name not in visiting, "Generated import cycle"
        result = set()
        for dep in graph[name]:
            result.add(dep)
            result.update(descendants(dep, visiting | {name}))
        return result
    for name in graph:
        descendants(name)
    if backend != "structural":
        input_text = out[inputs.replace(".", "/") + ".lean"]
        assert not re.search(r"^\s*(theorem|lemma|axiom)\b", input_text, re.M)
        assert descendants(left) == {inputs} and descendants(right) == {inputs}
        assert data not in descendants(left) | descendants(right)
    assert len(out) == (1 if backend == "structural" else 4)
    return out, proof


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rows", default="all")
    parser.add_argument("--exclude-rows", default="16,34,41")
    parser.add_argument("--input-dir", type=Path, default=ROOT / "finite_next/two_small/D1Bound5")
    parser.add_argument("--manifest-dir", type=Path, default=ROOT / "pair_witness_next")
    parser.add_argument("--sieve-dir", type=Path, default=ROOT / "finite_fast_next/sieves")
    parser.add_argument("--root-routine", type=Path, default=ROOT / "finite_next/two_small/generate_pair_closures.py")
    parser.add_argument("--staging-helper", type=Path, default=ROOT / "pair_witness_next/pair_staging.py")
    parser.add_argument("--floor-generator", type=Path, default=ROOT / "sparse_floor_next/generate_floor_witnesses.py")
    parser.add_argument("--floor-manifest", type=Path, default=ROOT / "sparse_floor_next/generated/manifest.json")
    parser.add_argument("--expanded-generator", type=Path, default=HERE / "stage_pair_backends.py")
    parser.add_argument("--expanded-manifest", type=Path, default=HERE / "all47_dry/manifest.json")
    parser.add_argument("--helper-dir", type=Path)
    parser.add_argument("--source-pins", type=Path, default=HERE / "backend_source_pins.json")
    parser.add_argument("--output-dir", type=Path, default=HERE / "compact_production")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--expected-manifest", type=Path)
    args = parser.parse_args()
    rows = list(range(1, 49)) if args.rows == "all" else [int(x) for x in args.rows.split(",")]
    excluded = {int(x) for x in args.exclude_rows.split(",") if x}
    rows = [k for k in rows if k not in excluded]
    assert rows and len(rows) == len(set(rows)) and all(1 <= k <= 48 for k in rows)
    expanded = load(args.expanded_generator, "reviewed_expanded_pair_staging", EXPANDED_SHA)
    pins = json.loads(args.source_pins.read_text())
    for relative, digest in pins.items():
        if relative.endswith(".lean"):
            path = args.helper_dir / Path(relative).name if args.helper_dir else ROOT / relative
            assert sha(path.read_bytes()) == digest, str(path)
    staging = load(args.staging_helper, "frozen_pair_data_helper", pins["pair_witness_next/pair_staging.py"])
    floors = load(args.floor_generator, "frozen_floor_data_helper", pins["sparse_floor_next/generate_floor_witnesses.py"])
    staging.configure(args.input_dir, args.manifest_dir, args.root_routine, source_only=True)
    sieve_pins = json.loads((args.manifest_dir / "cached_sieve_fingerprints.json").read_text())
    floor_manifest = json.loads(args.floor_manifest.read_text())
    old_expected = {r["row"]: r for r in json.loads(args.expanded_manifest.read_text())["results"]}
    expected = ({r["row"]: r for r in json.loads(args.expected_manifest.read_text())["results"]}
        if args.expected_manifest else None)
    pending, reports = {}, []
    for k in rows:
        row = staging.load_row(k)
        t, n = row["tau"], row["nu"]
        rel = f"finite_fast_next/sieves/SmallPairSieve_{t}_{n}.lean"
        sieve = floors.parse_sieve(args.sieve_dir / Path(rel).name, t, n, sieve_pins[rel])
        original_files, expanded_report = expanded.emit_row(row, staging, floors, sieve, floor_manifest)
        original_hashes = {name: dict(sha256=sha(text.encode()), bytes=len(text.encode()))
            for name, text in original_files.items()}
        assert original_hashes == old_expected[k]["files"], f"row{k}: reviewed expanded source changed"
        compact, preservation = bundle(original_files, k, expanded_report["backend"])
        report = dict(row=k, backend=expanded_report["backend"],
            original_source_sha256=row["diagnostic"]["source_sha256"],
            expanded_files=original_hashes, body_ownership=preservation,
            compact_files={name: dict(sha256=sha(text.encode()), bytes=len(text.encode()))
                for name, text in compact.items()},
            namespace_bodies_unchanged=True, public_api_unchanged=True,
            import_acyclic=True, nonstructural_inputs_data_only=True,
            color_proofs_do_not_import_arithmetic_or_closure_certificates=True)
        if expected is not None:
            assert k in expected and report == expected[k], f"row{k}: compact source/ownership changed"
        assert not pending.keys() & compact.keys()
        pending.update(compact)
        reports.append(report)
        print(f"row{k} {report['backend']}: {len(original_files)} -> {len(compact)} modules", flush=True)
    # Check every requested row before any Lean module is written.
    args.output_dir.mkdir(parents=True, exist_ok=True)
    if not args.dry_run:
        for name, text in pending.items():
            p = args.output_dir / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(text)
    result = dict(status="Uncompiled compact replacements only; no installation or main-theorem claim",
        rows=rows, excluded_rows=sorted(excluded), dry_run=args.dry_run,
        expected_compact_manifest_verified=expected is not None,
        generator_sha256=sha(Path(__file__).read_bytes()), expanded_generator_sha256=EXPANDED_SHA,
        expanded_manifest_sha256=sha(args.expanded_manifest.read_bytes()),
        source_pins_sha256=sha(args.source_pins.read_bytes()), generic_source_pins=pins,
        floor_manifest_sha256=sha(args.floor_manifest.read_bytes()),
        compact_modules=len(pending), expanded_modules=sum(len(r["expanded_files"]) for r in reports),
        compact_bytes=sum(len(text.encode()) for text in pending.values()), results=reports)
    dest = args.output_dir / "manifest.json"
    dest.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"compact_modules": result["compact_modules"], "expanded_modules": result["expanded_modules"],
        "bytes": result["compact_bytes"], "manifest": str(dest), "sha256": sha(dest.read_bytes())}, indent=2))


if __name__ == "__main__":
    main()
