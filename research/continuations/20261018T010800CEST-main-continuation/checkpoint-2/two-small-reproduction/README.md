# Two-small nondegenerate pair branch

UNCOMPILED RESEARCH DRAFT. Root alone compiles and writes the remote project.
No new accepted-root result is claimed here. No axioms, sorry, native_decide,
or untrusted external result is introduced by these Lean sources.

## Exact independent reproduction

The48anchor pairs and expected counts were parsed directly from the frozen
actual manuscript. Exact integer closure from the full radius33 seed disks
through radius10^550 produced37003vertices including zero, anchors and small
entries. Filtering only afterward yields the advertised36931vertices.
All48exact square graphs were independently recomputed; they contain the
advertised36854edges in total and every graph has no triangle. Every per-row
vertex and edge count agrees with the manuscript, not just the totals.

`generate_pair_closures.py` and `check_pair_graphs.py` reproduce these checks.
The JSON outputs are diagnostic data, not trusted proof inputs.

## Concrete Lean proof production

- SmallPairLargeDiscriminant proves that Δ>32 forces every compatible pair
  of distinct nonzero norm≤8 entries to be exactly{-1,1}. Thus every
  nondegenerate small pair belongs to the16normalized finite models.
- FastSquareTest proves the correctness of arbitrary finite quadratic-coordinate masks.
  SmallPairSieves supplies25moduli for each of the11actual pair-table models.
  Its filtered root test is logically equivalent to the existing exact root
  test, including zero roots. The modular test is only a rejection prefilter;
  passing never substitutes for an exact square-root check.
- SmallPairGraphCheck proves the lazy triangle check sound, and connects a
  certified seed/closure/filter/triangle result to an actual full-ring
  no-three-large-extensions theorem using PairExtensionComplete.
- TwoSmallSeedDisks adds the seven norm132 root disks needed beyond those
  already produced for the three-small branch.
- SmallPairGraphData1 through SmallPairGraphData48 contain all exact integer
  lists and `decide +kernel` obligations for seeds, bounded closure, final
  filtering and triangle exclusion. The large-coordinate data total about35MB.
- SmallPairGraphs instantiates the generic soundness theorem for each of the
  48 manuscript representative pairs. Its endpoint hypotheses are ordinary
  full-ring/pair/tuple hypotheses; no graph or descent assumptions remain.

Compile after the previous extension infrastructure: FastSquareTest, then SmallPairSieves,
SmallPairGraphCheck and TwoSmallSeedDisks, then individual data modules,
finally SmallPairGraphs. SmallPairLargeDiscriminant is independent of this
expensive graph queue and imports the already compiled SmallQuadruple.

Start graph-data timing with row41 (372eligible vertices), before launching
all48. Computation remains quadratic in graph size. The lazy outer edge gate
and the proved modular prefilter avoid most huge integer square-root calls,
but kernel performance has not yet been measured. A norm-only modular sieve
was explicitly rejected after diagnostics showed it accepts every pair on
rational-axis rows; the final sieve checks both quadratic coordinates.
Certificate verification
must not be replaced with native_decide if the evaluator requires tuning.

## Remaining finite connections

The exact16-model small-pair classification into48nondegenerate orbits, with
maximal-order exclusions and symmetry transport to the representative graph
endpoints, still needs formalization. The product−1 branch is separate:
{-1,1} in every field and the Eisenstein exceptional pair. Source_audit and
crossblock are developing concrete pieces of those exceptional exclusions.

Closing the full two-small proposition also requires the manuscript analytic
cutoff showing the third large modulus cannot exceed10^550. None of the
finite certificates proves that analytic cutoff or the final bound-five theorem.
