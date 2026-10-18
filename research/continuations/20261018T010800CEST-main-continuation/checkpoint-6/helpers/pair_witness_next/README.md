# Optional witness-based pair closure

`PairClosureWitness.lean` is an alternative certificate evaluator for the
existing `pairClosureBool`. It does not change the graph's vertex list, norm
bound, descent argument, or final exclusion theorem.

The input data are an anchor root `r0` and one `PairRootWitness` per vertex,
in the original vertex order. The checker verifies:

1. `r0*r0 = a*b+1`;
2. the list of witness vertices is exactly the original vertex list;
3. both supplied roots square to `a*z+1` and `b*z+1` at every vertex;
4. each of the two distinct signed mutations is outside the bound or belongs
   to the original vertex list.

The four choices of signs of the two vertex roots produce only two different
mutations. The sign of the anchor root is covered too. This follows by factoring
the difference of two squares and using the already accepted
`quadInt_mul_eq_zero` under positive discriminant. Zero roots cause no exception.

The computational checker contains no `rootCandidate`, `hasSquareRoot`, or
`Nat.sqrt`. Canonical roots occur only in the symbolic proof that the supplied
mutations cover both original deterministic neighbors. The final theorem
`pairClosureBool_of_witness_checked` has exactly the old Boolean closure
certificate as its conclusion, so existing graph consumers remain unchanged.
There is also `pairClosure_of_witness_checked` with the exact closure hypothesis
consumed by `pairClosure_complete_full_ring`.

This is an optional performance fallback, not a measured speedup. It replaces
repeated square-root discovery with exact integer multiplication and retains
ordinary list membership searches. It does not optimize the seed search,
filtering, or triangle certificate.

Provenance: read the actual accepted `PairExtensionCore.lean` and
`PairExtensionComplete.lean` on the pinned project on 2026-10-18. In particular,
the sign-case proof follows the existing `mutate_eq_canonical` structure, while
the endpoint exactly matches the existing closure predicate.

Status: root reported kernel compilation of the generic
`PairClosureWitness.lean` (SHA `c3e5b89a...`) passed in 32.3 seconds.
The data-specific certificates below remain pending. This agent performed no
compilation or remote writes.

Independent mathematical review by `article_audit` passed. Its Boolean API
finding was repaired using the inspected pinned-core theorem
`Bool.and_eq_true_iff` (`Init/Data/Bool.lean:176`).

## Graph 41 pilot

Run `python pair_witness_next/generate_graph41_witnesses.py` from the shared
workspace to reproduce the data and isolated certificate. The generator asserts
the frozen original source SHA, exact list-literal SHA, phase-source SHA, and
the SHA of the existing exact-root routine before computing any witnesses.
It reads the original closure list and asserts that the imported phase list is
literally identical. It never writes either original input.

The generated `SmallPairWitnessData41.lean` imports the separate
`SmallPairPhaseData41` module, uses its anchors and closure, and stores only the
two roots per vertex. `zipWith` attaches those roots to the existing closure
vertices, so the enormous vertex coordinates are not duplicated.

The Python diagnostics verified the anchor root `(-1,2)`, all 746 root equations
for 373 vertices, and all 1492 vertex-root sign combinations. Among the 746
distinct signed mutation checks, 745 are in the original closure and one is
outside the bound. These diagnostics are not the Lean proof.

`SmallPairWitnessClosure41.lean` contains the actual `decide +kernel` certificate
and `closure_checked_by_witness`, which concludes the unchanged
`pairClosureBool anchorA anchorB (10^1100) closure = true`. Both await the root
agent's serial compilation. `graph41_witness_manifest.json` records all exact
input and output hashes, counts, and the ordered destination-index digest.

## Original Graph 41 endpoint

`prepare_graph41_integration.py` prepares
`integration/SmallPairGraphData41.lean` without installing it. The data
declarations remain byte-for-byte identical to the frozen original. All five
consumer theorem names and types remain unchanged. The seed, closure, filter,
and triangle proof bodies refer to the isolated pilot theorems; the cheap
vertex-count certificate remains unchanged. The generator asserts these
properties and records them in an integration manifest. This replacement is
ready only after all imported pilot certificates pass.

## Reproducible all-48 exploration

`all48_input_fingerprints.json` freezes the 48 original source/closure-JSON/
graph-JSON triplets. `explore_all48.py` first checks all 144 hashes and the
exact-root routine hash, then parses the actual original Lean data, checks it
against the JSON, verifies all supplied roots and bounded mutations, and
prepares a BFS color mask from each existing exact-edge graph. The resulting
`all48_diagnostic_manifest.json` records per-row hashes, masks, and counts.

The exact Python diagnostics cover 37,003 closure vertices, 74,006 root
equations, and 74,006 signed mutations. Every bounded mutation is in the
unchanged vertex list. All 48 existing exact-edge graphs are bipartite.
The proposed two-color certificates would inspect 8,063,266 unordered
same-color pairs in total; the existing modular graphs have 68,640 same-color
survivors. These are diagnostic counts, not certified timings or Lean results.

The same module pattern therefore applies to all 48 rows: separate original
data, seed/filter certificates, supplied-root data and closure certificate,
two independent-class checks, and a proof-only endpoint replacement. Color
masks and generated roots remain untrusted inputs until the respective Lean
checkers prove them. The generic split theorem covers every vertex for any
mask; it does not rely on completeness of the JSON edge list. No other heavy
graph compilation has been queued and no original source was replaced.
