"""Reproduce the 48 frozen floor JSON files from existing pinned inputs.

No Lean/Git/network operation. No original source, manifest, or directory is
modified. All 48 exact serialized byte counts and SHA256 values must match
the existing requirements BEFORE a new output directory can be created.
Default mode computes and checks only; --apply exclusively writes a new dir.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import sys
import types

MATERIALIZER_SHA = "303299e125503841fa9fe651186d9b10e44faaefaefefacd2f049ade6130f1b0"
REQUIREMENTS_SHA = "5a15034bf8bad9a11647231e683f1006f5b4512c3f715a21269555273b6a85fb"
FLOOR_GENERATOR_SHA = "1f9564b5ac95a26dc7017d7c4dbca1bad0b15eed0aad02817452a97903790f68"
sha = lambda data: hashlib.sha256(data).hexdigest()


def pinned_materializer(path):
    """Bootstrap from exact bytes, without imports creating __pycache__."""
    path = Path(os.path.abspath(path))
    directory = os.open("/", os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
    fd = None
    try:
        for part in path.parts[1:-1]:
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW,
                            dir_fd=directory)
            os.close(directory)
            directory = child
        fd = os.open(path.name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK,
                     dir_fd=directory)
        if not stat.S_ISREG(os.fstat(fd).st_mode):
            raise ValueError("Materializer is not a regular file")
        chunks = []
        while True:
            block = os.read(fd, 1024 * 1024)
            if not block:
                break
            chunks.append(block)
        data = b"".join(chunks)
    finally:
        if fd is not None:
            os.close(fd)
        os.close(directory)
    if sha(data) != MATERIALIZER_SHA:
        raise ValueError("Materializer SHA mismatch")
    return module_from_bytes(data, path, "pinned_floor_materializer")


def module_from_bytes(data, path, name):
    module = types.ModuleType(name)
    module.__file__ = str(path)
    # The frozen modules have standard-library imports only and their main()
    # guards do not run under these unique module names. No import cache write.
    exec(compile(data, str(path), "exec", dont_inherit=True, optimize=0), module.__dict__)
    return module


class FrozenInput:
    """Supply the pinned parser its immutable, freshly verified source bytes."""
    def __init__(self, name, data):
        self.name, self.data = name, data

    def read_bytes(self):
        return self.data

    def __str__(self):
        return self.name


def compute(materializer, files, selected):
    required = {item["path"]: item for item in files}
    found = {item["path"]: item for item in selected}
    payloads = {}

    def checked(path):
        if path not in payloads:
            item = found[path]
            data = materializer.read_regular(item["source"], item["bytes"])
            if sha(data) != item["sha256"]:
                raise ValueError("Input changed since inventory: " + path)
            payloads[path] = data
        return payloads[path]

    def read_json(path):
        return json.loads(checked(path), object_pairs_hook=materializer.unique_object)

    routine = "sparse_floor_next/generate_floor_witnesses.py"
    routine_bytes = checked(routine)
    if sha(routine_bytes) != FLOOR_GENERATOR_SHA:
        raise ValueError("Floor generator SHA mismatch")
    floors = module_from_bytes(routine_bytes, found[routine]["source"], "pinned_floor_generator")
    inputs = {r["row"]: r for r in read_json("pair_witness_next/all48_input_fingerprints.json")}
    diagnostics = {r["row"]: r for r in read_json("pair_witness_next/all48_diagnostic_manifest.json")["rows"]}
    sieve_pins = read_json("pair_witness_next/cached_sieve_fingerprints.json")
    manifest = read_json("sparse_floor_next/generated/manifest.json")
    output, report = {}, []
    for row in range(1, 49):
        original = f"finite_next/two_small/D1Bound5/SmallPairGraphData{row}.lean"
        original_pin = inputs[row]["files"][original]
        if original_pin != required[original]["sha256"]:
            raise ValueError("Original source pin disagreement: " + original)
        tau, nu, vertices = floors.parse_source(
            FrozenInput(original, checked(original)), row, original_pin, diagnostics[row])
        sieve_path = f"finite_fast_next/sieves/SmallPairSieve_{tau}_{nu}.lean"
        if sieve_pins[sieve_path] != required[sieve_path]["sha256"]:
            raise ValueError("Sieve pin disagreement: " + sieve_path)
        sieve = floors.parse_sieve(FrozenInput(sieve_path, checked(sieve_path)),
                                   tau, nu, sieve_pins[sieve_path])
        mask = int(diagnostics[row]["color_mask"])
        if mask < 0 or mask >> len(vertices):
            raise ValueError("Invalid color mask")
        colors = [(mask >> i) & 1 for i in range(len(vertices))]
        data, _ = floors.build_row(row, vertices, colors, sieve, tau, nu, diagnostics[row])
        raw = (json.dumps(data, separators=(",", ":")) + "\n").encode()
        name = f"row{row:02}.json"
        relative = "sparse_floor_next/generated/" + name
        expected = required[relative]
        actual = dict(bytes=len(raw), sha256=sha(raw))
        if actual != manifest["files"][name]:
            raise ValueError("Regenerated floor differs from original manifest: " + name)
        if actual != {key: expected[key] for key in ("bytes", "sha256")}:
            raise ValueError("Regenerated floor differs from requirements: " + name)
        output[name] = raw
        report.append(dict(name=name, **actual))
        print(json.dumps(dict(row=row, verified=True, **actual)), flush=True)
    if len(output) != 48:
        raise ValueError("Incomplete floor output")
    return output, dict(requirements_sha256=REQUIREMENTS_SHA,
                        materializer_sha256=MATERIALIZER_SHA,
                        floor_generator_sha256=FLOOR_GENERATOR_SHA,
                        file_count=48, total_bytes=sum(map(len, output.values())),
                        files=report, input_sources=[found[p] for p in sorted(payloads)])


def write_output(materializer, destination, output, manifest):
    destination, parent = materializer.destination_parent(destination)
    root_fd = None
    try:
        os.mkdir(destination.name, mode=0o700, dir_fd=parent)
        root_fd = os.open(destination.name, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW,
                          dir_fd=parent)
        for name in sorted(output):
            materializer.write_new(root_fd, name, output[name])
        materializer.write_new(root_fd, "regeneration_manifest.json",
                              (json.dumps(manifest, indent=2) + "\n").encode())
    finally:
        if root_fd is not None:
            os.close(root_fd)
        os.close(parent)


def main():
    here = Path(__file__).absolute().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--materializer", type=Path, default=here / "materialize_inputs.py")
    parser.add_argument("--requirements", type=Path, default=here / "input_requirements.json")
    parser.add_argument("--search-root", type=Path, action="append", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    materializer = pinned_materializer(args.materializer)
    destination, parent = materializer.destination_parent(args.output)
    os.close(parent)
    files = materializer.requirements(args.requirements, REQUIREMENTS_SHA)
    selected, missing, rejected = materializer.inventory(
        files, [materializer.absolute(p) for p in args.search_root])
    floor_paths = {f"sparse_floor_next/generated/row{k:02}.json" for k in range(1, 49)}
    other_missing = [item for item in missing if item["path"] not in floor_paths]
    print(json.dumps(dict(found=len(selected), missing_floor_rows=len(missing)-len(other_missing),
                          other_missing=other_missing, rejected_candidates=rejected)), flush=True)
    if other_missing:
        return 2
    output, manifest = compute(materializer, files, selected)
    # No output directory has been created before all 48 exact comparisons.
    print(json.dumps(dict(all_48_verified=True, bytes=manifest["total_bytes"],
                          apply=args.apply, output=str(destination))), flush=True)
    if args.apply:
        write_output(materializer, destination, output, manifest)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, TypeError, KeyError, AssertionError) as exc:
        print(json.dumps(dict(error=str(exc), note="No existing file is overwritten. Only a new --apply output may be partial after an I/O failure.")), file=sys.stderr)
        sys.exit(1)
