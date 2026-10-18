"""Read and reconstruct a frozen row for optional certificate generation.

No files are written by this module. Python calculations remain diagnostics;
generated Lean checkers recheck all mathematical certificate inputs.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
ROUTINE_SHA = "d34a4e980c38ec61cd520b5b6112221374ec479ffeafa726d09567726beca894"
sha = lambda b: hashlib.sha256(b).hexdigest()
CONFIG = None


def configure(input_dir=None, manifest_dir=None, routine=None, source_only=False):
    """Select explicit portable paths; source-only mode needs no large JSON copies.

    The exact original Lean source hash and every reconstructed-data digest are
    always checked. Historical JSON hashes remain in the manifest; when JSON
    is available locally it is checked too, but it is not a generator input.
    """
    global CONFIG, INPUTS, DIAGNOSTICS, exact
    input_dir = Path(input_dir or ROOT / "finite_next/two_small/D1Bound5")
    manifest_dir = Path(manifest_dir or HERE)
    routine = Path(routine or ROOT / "finite_next/two_small/generate_pair_closures.py")
    INPUTS = {r["row"]: r for r in json.loads((manifest_dir / "all48_input_fingerprints.json").read_text())}
    DIAGNOSTICS = {r["row"]: r for r in json.loads((manifest_dir / "all48_diagnostic_manifest.json").read_text())["rows"]}
    assert sha(routine.read_bytes()) == ROUTINE_SHA, str(routine)
    spec = importlib.util.spec_from_file_location("frozen_staging_exact", routine)
    exact = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(exact)
    CONFIG = dict(input_dir=input_dir, source_only=source_only)


def lean_pair(z):
    return f"⟨{z[0]}, {z[1]}⟩"


def lean_option(n):
    return "none" if n is None else f"some {n}"


def theorem_block(source, name):
    found = re.search(rf"theorem {name}\b.*?(?=\n\ntheorem |\n\nend D1Bound5)", source, re.S)
    assert found is not None, name
    return found.group()


def load_row(k):
    if CONFIG is None:
        configure()
    assert k in INPUTS
    source_path = CONFIG["input_dir"] / f"SmallPairGraphData{k}.lean"
    original_key = f"finite_next/two_small/D1Bound5/SmallPairGraphData{k}.lean"
    assert sha(source_path.read_bytes()) == INPUTS[k]["files"][original_key], str(source_path)
    if not CONFIG["source_only"]:
        for filename, digest in INPUTS[k]["files"].items():
            assert sha((ROOT / filename).read_bytes()) == digest, filename
    source = source_path.read_text()
    pair_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
    anchor_pattern = rf"def smallPairA_{k} : QuadInt (\d+) (\d+) := {pair_pattern}"
    t, n, ax, ay = map(int, re.search(anchor_pattern, source).groups())
    a = (ax, ay)
    b = tuple(map(int, re.search(rf"def smallPairB_{k} : QuadInt {t} {n} := {pair_pattern}", source).groups()))
    literal = re.search(rf"def smallPairClosure_{k} .*? := \[(.*?)\n\]", source, re.S).group(1)
    vertices = [tuple(map(int, p)) for p in re.findall(pair_pattern, literal)]
    assert re.sub(pair_pattern, "", literal).replace(",", "").strip() == ""
    assert sha(literal.encode()) == DIAGNOSTICS[k]["closure_literal_sha256"]
    large_literal = re.search(rf"def smallPairLarge_{k} .*? := \[(.*?)\n\]", source, re.S).group(1)
    large = [tuple(map(int, p)) for p in re.findall(pair_pattern, large_literal)]
    assert re.sub(pair_pattern, "", large_literal).replace(",", "").strip() == ""
    assert sha(large_literal.encode()) == DIAGNOSTICS[k]["large_literal_sha256"]
    if not CONFIG["source_only"]:
        data = json.loads((ROOT / f"finite_next/two_small/closures/pair_{k:02}.json").read_text())
        assert (t, n, a, b) == (data["tau"], data["nu"], tuple(data["anchors"][0]), tuple(data["anchors"][1]))
        assert vertices == list(map(tuple, data["closure"]))
        assert large == list(map(tuple, data["large"]))
    mul = lambda x, y: exact.mul(t, n, x, y)
    root = lambda x: exact.root(t, n, x)
    norm = lambda x: exact.norm(t, n, x)
    add, scale, one = exact.add, exact.scale, (1, 0)
    r0 = root(add(mul(a, b), one))
    assert r0 is not None and mul(r0, r0) == add(mul(a, b), one)
    root_pairs, destinations = [], []
    index = {z: j for j, z in enumerate(vertices)}
    assert len(index) == len(vertices)
    for z in vertices:
        az, bz = add(mul(a, z), one), add(mul(b, z), one)
        r, s = root(az), root(bz)
        assert r is not None and s is not None
        assert mul(r, r) == az and mul(s, s) == bz
        root_pairs.append((r, s))
        mid = add(add(a, b), mul(add(scale(2, mul(a, b)), one), z))
        rr = scale(2, mul(mul(r0, r), s))
        ds = []
        for sign in (1, -1):
            w = add(mid, scale(sign, rr))
            if norm(w) <= 10 ** 1100:
                assert w in index
                ds.append(index[w])
            else:
                ds.append(None)
        destinations.append(ds)
    assert sha(json.dumps(root_pairs, separators=(",", ":")).encode()) == DIAGNOSTICS[k]["root_pair_list_sha256"]
    assert sha(json.dumps(destinations, separators=(",", ":")).encode()) == DIAGNOSTICS[k]["destination_indices_sha256"]
    declarations = source[source.index(f"def smallPairA_{k} "):source.index(f"theorem smallPairSeeds_{k}_checked")]
    return dict(row=k, tau=t, nu=n, anchors=(a, b), anchor_root=r0, vertices=vertices,
                root_pairs=root_pairs, destinations=destinations, source=source,
                declarations=declarations, large=large, diagnostic=DIAGNOSTICS[k])
