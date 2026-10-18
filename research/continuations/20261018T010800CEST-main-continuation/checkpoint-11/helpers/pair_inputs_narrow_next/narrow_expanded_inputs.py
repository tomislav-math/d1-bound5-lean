#!/usr/bin/env python3
"""Prepare a new, import-only copy of an already expanded pair-graph row.

This helper reads a hash-pinned staging manifest. It never runs the staging
generator, writes to its input tree, installs sources, or invokes Lean.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def split_imports(data: bytes) -> tuple[bytes, bytes]:
    """Retain every body byte, including the blank line after the imports."""
    lines = data.splitlines(keepends=True)
    count = 0
    while count < len(lines) and lines[count].startswith(b"import "):
        require(lines[count].endswith(b"\n"), "Import must end with LF")
        count += 1
    require(count > 0, "Expected a nonempty initial import block")
    return b"".join(lines[:count]), b"".join(lines[count:])


def check_literal_inputs(body: bytes, row: int, tau: int, nu: int) -> None:
    """Reject compact/bundled Inputs: the expanded schema has five literal defs."""
    text = body.decode("utf-8")
    number = r"-?[0-9]+"
    coordinate = rf"⟨{number}, *{number}⟩"
    typ = rf"QuadInt {tau} {nu}"
    expected_defs = [f"smallPairA_{row}", f"smallPairB_{row}",
                     f"smallPairClosure_{row}", f"smallPairLarge_{row}", "colors"]
    actual_defs = re.findall(r"^def ([A-Za-z0-9_]+)\b", text, re.MULTILINE)
    require(actual_defs == expected_defs, "Not the five-definition expanded Inputs schema")
    fixed_lines = {"", "namespace D1Bound5", "set_option maxRecDepth 100000",
                   "open QuadInt", f"namespace PairGraphPrepared{row}",
                   f"end PairGraphPrepared{row}", "end D1Bound5", "]"}
    patterns = [
        rf"def smallPair[AB]_{row} : {typ} := {coordinate}",
        rf"def smallPair(?:Closure|Large)_{row} : List \({typ}\) := \[",
        rf"  {coordinate},?",
        r"def colors : ℕ := [0-9]+",
    ]
    for line in text.splitlines():
        require(line in fixed_lines or any(re.fullmatch(p, line) for p in patterns),
                "Unexpected nonliteral or bundled declaration in Inputs")


def prepare(source_root: Path, expected_manifest_sha: str, row: int,
            output: Path) -> dict:
    source_root = source_root.resolve()
    output = output.resolve()
    require(row not in {16, 34, 41}, "Accepted pilot rows are outside this helper's scope")
    require(not output.exists(), "Output must be a new directory")
    require(source_root != output and source_root not in output.parents
            and output not in source_root.parents, "Input and output trees must be disjoint")
    manifest_path = source_root / "manifest.json"
    manifest_bytes = manifest_path.read_bytes()
    require(sha256(manifest_bytes) == expected_manifest_sha, "Input manifest SHA mismatch")
    original_manifest = json.loads(manifest_bytes)
    results = [r for r in original_manifest["results"] if r["row"] == row]
    require(len(results) == 1, "Manifest must contain the selected row exactly once")
    result = results[0]
    files = result["files"]
    inputs_name = f"D1Bound5/SmallPairGraphInputs{row}.lean"
    arithmetic_name = f"D1Bound5/SmallPairGraphArithmetic{row}.lean"
    require(inputs_name in files and arithmetic_name in files,
            "Expected expanded Inputs and Arithmetic modules")
    originals = {}
    variants = {}
    evidence = {}
    for name, pin in files.items():
        relative = Path(name)
        require(not relative.is_absolute() and ".." not in relative.parts
                and len(relative.parts) == 2 and relative.parts[0] == "D1Bound5"
                and relative.suffix == ".lean", "Unexpected manifest path")
        data = (source_root / relative).read_bytes()
        require(sha256(data) == pin["sha256"] and len(data) == pin["bytes"],
                f"Input source pin mismatch: {name}")
        old_imports, body = split_imports(data)
        new_imports = old_imports
        if name == inputs_name:
            require(old_imports == b"import D1Bound5.SmallPairGraphCheck\n",
                    "Unexpected Inputs import block; compact sources are not supported")
            check_literal_inputs(body, row, result["tau"], result["nu"])
            new_imports = b"import D1Bound5.Coordinates\n"
        elif name == arithmetic_name:
            expected = (f"import D1Bound5.SmallPairGraphInputs{row}\n"
                        "import D1Bound5.TwoSmallSeedDisks\n").encode()
            require(old_imports == expected, "Unexpected Arithmetic import block")
            new_imports += b"import D1Bound5.SmallPairGraphCheck\n"
        transformed = new_imports + body
        require(split_imports(transformed)[1] == body, f"Body changed: {name}")
        if name not in {inputs_name, arithmetic_name}:
            require(transformed == data, f"Unexpected source change: {name}")
        originals[name] = data
        variants[name] = transformed
        evidence[name] = {
            "pre_sha256": sha256(data), "post_sha256": sha256(transformed),
            "pre_bytes": len(data), "post_bytes": len(transformed),
            "body_sha256": sha256(body), "body_byte_identical": True,
            "file_byte_identical": transformed == data,
            "old_imports": old_imports.decode().splitlines(),
            "new_imports": new_imports.decode().splitlines(),
        }
    require(sum(not r["file_byte_identical"] for r in evidence.values()) == 2,
            "Exactly two import blocks must change")

    report = {
        "status": "Source-only import variant; not installed or compiled; no kernel claim",
        "row": row, "backend": result["backend"],
        "input_manifest_sha256": expected_manifest_sha,
        "transform_sha256": sha256(Path(__file__).read_bytes()),
        "source_generator_executed": False,
        "all_bodies_byte_identical": True,
        "unchanged_files": sum(r["file_byte_identical"] for r in evidence.values()),
        "total_pre_bytes": sum(map(len, originals.values())),
        "total_post_bytes": sum(map(len, variants.values())),
        "files": evidence,
    }
    # Validate everything before creating a separate output tree.
    output.mkdir(parents=True)
    for name, data in variants.items():
        target = output / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
    (output / "source_manifest.before.json").write_bytes(manifest_bytes)
    (output / "manifest.json").write_text(json.dumps(report, indent=2) + "\n")
    for name, data in originals.items():
        require((source_root / name).read_bytes() == data, f"Source changed during copy: {name}")
    require(manifest_path.read_bytes() == manifest_bytes, "Source manifest changed during copy")
    return report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", required=True, type=Path)
    parser.add_argument("--manifest-sha256", required=True)
    parser.add_argument("--row", required=True, type=int)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    report = prepare(args.source_root, args.manifest_sha256, args.row, args.output)
    print(json.dumps({k: report[k] for k in ["status", "row", "all_bodies_byte_identical",
                                           "unchanged_files", "total_post_bytes"]}, indent=2))


if __name__ == "__main__":
    main()
