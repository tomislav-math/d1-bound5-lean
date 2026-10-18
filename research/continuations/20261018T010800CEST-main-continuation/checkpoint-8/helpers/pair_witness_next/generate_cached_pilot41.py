"""Prepare the optional cached-residue pilot, without duplicating vertices.

All source and data fingerprints are pinned. Python diagnostics compare the
cached modular formula to the actual product formula at every scanned mask;
the emitted Lean files independently validate signatures and independent
classes with decide +kernel. No original graph or color source is written.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent / "cached_pilot41"
PILOT = ROOT / "finite_fast_next/graphs/SmallPairBipartitePilotData41.lean"
SIEVE = ROOT / "finite_fast_next/sieves/SmallPairSieve_1_2.lean"
ORIGINAL = ROOT / "finite_next/two_small/D1Bound5/SmallPairGraphData41.lean"
ROUTINE = ROOT / "finite_next/two_small/generate_pair_closures.py"
GENERIC = ROOT / "pair_witness_next/PairCachedResidues.lean"
EXPECTED = {
    PILOT: "2b372ea69aa4ddf10ba200548e2c8626875c378f5024f82c705abd17039c238b",
    SIEVE: "0e06eb108afce10f63dd87b8402973d477820e1a7d76cfa29f8e0be3d77d5235",
    ORIGINAL: "2fb18d40fa756d1fe49844454f5ddeff9c85122a82d47bf5c418699a95b879b1",
    ROUTINE: "d34a4e980c38ec61cd520b5b6112221374ec479ffeafa726d09567726beca894",
    GENERIC: "8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100",
}
sha = lambda b: hashlib.sha256(b).hexdigest()
for path, digest in EXPECTED.items():
    assert sha(path.read_bytes()) == digest, str(path)
pilot, sieve_source, original = PILOT.read_text(), SIEVE.read_text(), ORIGINAL.read_text()
literal = re.search(r"def smallPairPilotLarge_41 .*? := \[(.*?)\n\]", pilot, re.S).group(1)
original_literal = re.search(r"def smallPairLarge_41 .*? := \[(.*?)\n\]", original, re.S).group(1)
assert literal == original_literal
pair_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
vertices = [tuple(map(int, p)) for p in re.findall(pair_pattern, literal)]
assert len(vertices) == 372
assert re.sub(pair_pattern, "", literal).replace(",", "").strip() == ""
colors = int(re.search(r"def smallPairPilotColors_41 : ℕ := (\d+)", pilot).group(1))
mask_values = {name: int(value) for name, value in
    re.findall(r"def (smallPairMask_1_2_\d+) : ℕ := (\d+)", sieve_source)}
sieve_literal = re.search(r"def smallPairSieve_1_2 .*? := \[(.*?)\n\]", sieve_source, re.S).group(1)
entries = re.findall(r"\((\d+),\s*(smallPairMask_1_2_\d+)\)", sieve_literal)
sieve = [(int(k), mask_values[name]) for k, name in entries]
assert len(sieve) == 25
assert re.sub(r"\(\d+,\s*smallPairMask_1_2_\d+\)", "", sieve_literal).replace(",", "").strip() == ""
signatures = [[(x % (k + 1), y % (k + 1)) for k, _ in sieve] for x, y in vertices]
spec = importlib.util.spec_from_file_location("frozen_pair_closure_cached", ROUTINE)
exact = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exact)
classes = [[i for i in range(len(vertices)) if (colors >> i) & 1 == c] for c in (0, 1)]
diagnostics = []
for indices in classes:
    tested = survivors = scanned = 0
    for offset, i in enumerate(indices):
        for j in indices[offset + 1:]:
            assert vertices[i] != vertices[j]
            tested += 1
            product = exact.add(exact.mul(1, 2, vertices[i], vertices[j]), (1, 0))
            accepted = True
            for h, (k, mask) in enumerate(sieve):
                m = k + 1
                u, v = signatures[i][h], signatures[j][h]
                re_cached = (u[0] * v[0] - 2 * u[1] * v[1] + 1) % m
                im_cached = (u[0] * v[1] + u[1] * v[0] + u[1] * v[1]) % m
                assert (re_cached, im_cached) == (product[0] % m, product[1] % m)
                scanned += 1
                if not (mask >> (re_cached * m + im_cached)) & 1:
                    accepted = False
                    break
            if accepted:
                survivors += 1
                assert exact.root(1, 2, product) is None
    diagnostics.append({"vertices": len(indices), "unordered_pairs": tested,
                        "small_modular_products": scanned, "exact_fallback_pairs": survivors})

rows = ",\n".join("  [" + ", ".join(f"({u}, {v})" for u, v in sig) + "]" for sig in signatures)
data = f'''import D1Bound5.PairCachedResidues
import D1Bound5.SmallPairBipartitePilotData41
import D1Bound5.SmallPairSieve_1_2

namespace D1Bound5.PairCachedPilot41
set_option maxRecDepth 100000

/-- Untrusted small residues in the frozen vertex and sieve orders. -/
def signatures : List (List (ℕ × ℕ)) := [
{rows}
]

/-- Attach signatures to the existing vertices without copying their coordinates. -/
def cachedVertices : List (PairResidueVertex 1 2) :=
  List.zipWith (fun (z : QuadInt 1 2) (sig : List (ℕ × ℕ)) => ⟨z, sig⟩)
    smallPairPilotLarge_41 signatures

end D1Bound5.PairCachedPilot41
'''
OUT.mkdir(exist_ok=True)
(OUT / "SmallPairCachedData41.lean").write_text(data)
for name, projection in [("Left", 1), ("Right", 2)]:
    lower = name.lower()
    cert = f'''import D1Bound5.SmallPairCachedData41

namespace D1Bound5.PairCachedPilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem {lower}_certificate_checked :
    pairCachedIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{projection}
      (pairSplitByMask cachedVertices smallPairPilotColors_41).{projection} = true := by
  decide +kernel

/-- The existing independent-class predicate, derived from the cached certificate. -/
theorem {lower}_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{projection} = true :=
  pairIndependentBool_of_cached_certificate smallPairSieve_1_2
    (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{projection}
    (pairSplitByMask cachedVertices smallPairPilotColors_41).{projection}
    {lower}_certificate_checked

end D1Bound5.PairCachedPilot41
'''
    (OUT / f"SmallPairCached{name}41.lean").write_text(cert)
(OUT / "SmallPairCachedPilot41.lean").write_text('''import D1Bound5.SmallPairCachedLeft41
import D1Bound5.SmallPairCachedRight41

namespace D1Bound5.PairCachedPilot41

theorem triangle_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairPilotLarge_41 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2
    smallPairPilotLarge_41 smallPairPilotColors_41 left_checked right_checked

end D1Bound5.PairCachedPilot41
''')
manifest = {
    "status": "Python diagnostics passed; cached Lean certificate compilation pending",
    "inputs": {str(p.relative_to(ROOT)): digest for p, digest in EXPECTED.items()},
    "vertices": len(vertices), "moduli": len(sieve),
    "cached_coordinate_residues": 2 * len(vertices) * len(sieve),
    "signature_list_sha256": sha(json.dumps(signatures, separators=(",", ":")).encode()),
    "left": diagnostics[0], "right": diagnostics[1],
    "files": {p.name: {"sha256": sha(p.read_bytes()), "bytes": p.stat().st_size}
              for p in sorted(OUT.glob("*.lean"))},
}
(OUT / "cached_pilot41_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
print(json.dumps({k: v for k, v in manifest.items() if k != "inputs"}, indent=2))
