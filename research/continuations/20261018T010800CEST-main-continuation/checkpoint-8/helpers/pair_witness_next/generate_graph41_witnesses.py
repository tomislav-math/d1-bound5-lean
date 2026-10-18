"""Generate a kernel-checkable closure witness for the frozen Graph 41 list.

Python checks are diagnostics only. The generated Lean certificate proves the
new checker by `decide +kernel` and then derives the unchanged old checker.
No original graph or phase source is written.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent
SOURCE = ROOT / "finite_next/two_small/D1Bound5/SmallPairGraphData41.lean"
PHASE = ROOT / "finite_fast_next/graph_phases/SmallPairPhaseData41.lean"
ROUTINE = ROOT / "finite_next/two_small/generate_pair_closures.py"
EXPECTED_SOURCE = "2fb18d40fa756d1fe49844454f5ddeff9c85122a82d47bf5c418699a95b879b1"
EXPECTED_LITERAL = "c45130d6187cec6281dc89a36e20ad2041efaf8adb82723173a4ad578e600d58"
EXPECTED_PHASE = "95c24b71d27834fe4f16c6643582c88186bf124cb854123ec33fc14ed5c4b3a8"
EXPECTED_ROUTINE = "d34a4e980c38ec61cd520b5b6112221374ec479ffeafa726d09567726beca894"


def sha(data):
    return hashlib.sha256(data).hexdigest()


assert sha(SOURCE.read_bytes()) == EXPECTED_SOURCE, "Frozen original source changed"
assert sha(PHASE.read_bytes()) == EXPECTED_PHASE, "Frozen phase data changed"
assert sha(ROUTINE.read_bytes()) == EXPECTED_ROUTINE, "Exact-root routine changed"
source = SOURCE.read_text()
phase = PHASE.read_text()
literal = re.search(r"def smallPairClosure_41 .*? := \[(.*?)\n\]", source, re.S).group(1)
phase_literal = re.search(r"def closure .*? := \[(.*?)\n\]", phase, re.S).group(1)
assert sha(literal.encode()) == EXPECTED_LITERAL
assert literal == phase_literal, "Phase closure differs from frozen original"
pair_pattern = r"⟨\s*(-?\d+)\s*,\s*(-?\d+)\s*⟩"
vertices = [tuple(map(int, m)) for m in re.findall(pair_pattern, literal)]
assert re.sub(pair_pattern, "", literal).replace(",", "").strip() == ""
assert len(vertices) == len(set(vertices)), "Duplicate frozen vertices"


def anchor(name):
    found = re.search(rf"def {name} : QuadInt 1 2 := {pair_pattern}", source)
    assert found is not None
    return tuple(map(int, found.groups()))


a, b = anchor("smallPairA_41"), anchor("smallPairB_41")
assert a == (0, -2) and b == (2, -2)
spec = importlib.util.spec_from_file_location("frozen_pair_closure", ROUTINE)
exact = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exact)
tau, nu, bound = 1, 2, 10 ** 1100
mul = lambda x, y: exact.mul(tau, nu, x, y)
norm = lambda x: exact.norm(tau, nu, x)
root = lambda x: exact.root(tau, nu, x)
add, scale = exact.add, exact.scale
one = (1, 0)
r0 = root(add(mul(a, b), one))
assert r0 is not None and mul(r0, r0) == add(mul(a, b), one)
root_pairs = []
indices = {v: i for i, v in enumerate(vertices)}
inside = outside = 0
destinations = []
for z in vertices:
    az, bz = add(mul(a, z), one), add(mul(b, z), one)
    r, s = root(az), root(bz)
    assert r is not None and s is not None
    assert mul(r, r) == az and mul(s, s) == bz
    root_pairs.append((r, s))
    mid = add(add(a, b), mul(add(scale(2, mul(a, b)), one), z))
    rr = scale(2, mul(mul(r0, r), s))
    pair_destinations = []
    candidates = [add(mid, rr), add(mid, scale(-1, rr))]
    for candidate in candidates:
        if norm(candidate) <= bound:
            assert candidate in indices, "Bounded mutation missing from frozen list"
            pair_destinations.append(indices[candidate])
            inside += 1
        else:
            pair_destinations.append(None)
            outside += 1
    # Explicitly check all four vertex-root sign choices, including zeros.
    for er in (1, -1):
        for es in (1, -1):
            candidate = add(mid, scale(2, mul(mul(r0, scale(er, r)), scale(es, s))))
            assert candidate in candidates
            assert norm(candidate) > bound or candidate in indices
    destinations.append(pair_destinations)


def lean_pair(z):
    return f"⟨{z[0]}, {z[1]}⟩"


rows = ",\n".join(f"  ({lean_pair(r)}, {lean_pair(s)})" for r, s in root_pairs)
data = f'''import D1Bound5.PairClosureWitness
import D1Bound5.SmallPairPhaseData41

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000

/-- A supplied anchor root, checked in the closure certificate. -/
def anchorRootWitness : QuadInt 1 2 := {lean_pair(r0)}

/-- Supplied roots in exactly the frozen closure order; no vertices duplicated. -/
def vertexRootPairs : List (QuadInt 1 2 × QuadInt 1 2) := [
{rows}
]

def closureWitnesses : List (PairRootWitness 1 2) :=
  List.zipWith (fun (z : QuadInt 1 2) (rs : QuadInt 1 2 × QuadInt 1 2) =>
    ⟨z, rs.1, rs.2⟩) closure vertexRootPairs

end D1Bound5.PairPhasePilot41
'''
certificate = '''import D1Bound5.SmallPairWitnessData41

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- All supplied roots and all bounded mutations are verified by the kernel. -/
theorem closure_witness_checked :
    pairClosureWitnessBool anchorA anchorB anchorRootWitness (10^1100)
      closure closureWitnesses = true := by
  decide +kernel

/-- The original closure certificate, obtained without recomputing roots. -/
theorem closure_checked_by_witness :
    pairClosureBool anchorA anchorB (10^1100) closure = true :=
  pairClosureBool_of_witness_checked (by decide) anchorA anchorB anchorRootWitness
    (10^1100) closure closureWitnesses closure_witness_checked

end D1Bound5.PairPhasePilot41
'''
(OUT / "SmallPairWitnessData41.lean").write_text(data)
(OUT / "SmallPairWitnessClosure41.lean").write_text(certificate)
list_bytes = json.dumps(vertices, separators=(",", ":")).encode()
manifest = {
    "scope": "Exact Graph41 closure witness; Python diagnostics, Lean kernel proof pending",
    "original_source_sha256": EXPECTED_SOURCE,
    "closure_literal_sha256": EXPECTED_LITERAL,
    "closure_integer_list_sha256": sha(list_bytes),
    "phase_data_sha256": EXPECTED_PHASE,
    "exact_root_routine_sha256": EXPECTED_ROUTINE,
    "generic_checker_sha256": sha((OUT / "PairClosureWitness.lean").read_bytes()),
    "tau": tau, "nu": nu, "anchors": [a, b], "anchor_root": r0,
    "bound": "10^1100", "vertices": len(vertices),
    "vertex_square_equalities_checked": 2 * len(vertices),
    "four_sign_cases_checked": 4 * len(vertices),
    "distinct_signed_mutations_inside_bound": inside,
    "distinct_signed_mutations_outside_bound": outside,
    "ordered_destination_indices_sha256": sha(json.dumps(destinations, separators=(",", ":")).encode()),
    "files": {name: {"sha256": sha((OUT / name).read_bytes()), "bytes": (OUT / name).stat().st_size}
              for name in ["SmallPairWitnessData41.lean", "SmallPairWitnessClosure41.lean"]},
}
(OUT / "graph41_witness_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
print(json.dumps(manifest, indent=2))
