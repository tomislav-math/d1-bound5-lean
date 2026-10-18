# Selected-mask certificate: bounded implementation plan

The proposed certificate checks one rejecting modular mask per actual pair,
instead of searching the ordered sieve. It preserves the existing sparse
integer guard and floor checks for the pairs accepted by every mask.
This is complementary to literal cached vertices; it does not replace them.

The local diagnostic reread all pinned original vertex/graph files and current
mask definitions. It independently reconstructed the complete survivor sets
and checked exact equality to the frozen sets. These Python counts are not
Lean certificates or kernel speed measurements.

| Scope | Actual pairs | Existing mask evaluations | Selected mask evaluations | Guard checks | Floor checks |
|---|---:|---:|---:|---:|---:|
| Graph34 left | 26,106 | 179,338 | 26,104 | 0 | 2 |
| Graph34 right | 25,878 | 178,244 | 25,877 | 0 | 1 |
| 41 nonstructural rows | 7,447,008 | 49,224,076 | 7,403,150 | 15,244 | 28,614 |
| All48, for comparison | 8,063,266 | 56,507,297 | 7,994,626 | 40,026 | 28,614 |

The available structural manifest covers rows16,22,27,31,32,37,41. Thus the
precise nonstructural count here is41, independent of how many are presently
queued or already accepted. Selected masks reduce their arithmetic mask
evaluations by6.65times; this is not a claim of the same elapsed-time speedup.

Each row packs its tags into one ordinary natural number in base32. Tags0--24
are actual positions in the existing sieve; tag30 proves an actual repeated
vertex; tag31 invokes the existing integer guard or consumes a checked floor.
Tags25--29 reject. The real vertex tail, not the packed word, drives recursion.
Each tail entry consumes exactly one digit. At the end, the residual word
must be zero and the floor list empty. Every actual head must have exactly
one witness row. Zero high digits still cause actual mask0 checks; they cannot
truncate coverage. Missing aligned sieve/signature entries reject.

Graph34 left needs229 packed numerals totaling39,255 decimal digits and the
same two floor witnesses. The longest numeral is1,139bits. All41 rows need
33,021 packed numerals totaling11,197,262 decimal digits (approximately4.66MB
binary payload), instead of7.45million separate tag constructors. Normal
selected-mask pairs also avoid the prior huge-coordinate equality test.

The source is split into two small new modules, leaving accepted sources
unchanged:

1. `PairSelectedCachedMask.lean`: an aligned indexed lookup of the existing
   sieve and both cached signatures; its soundness theorem proves that one
   false selected term makes the original cached sieve false. No new
   signature-validity or mask-validity assumption is required by this lemma.
2. `PairSelectedFloorWitnesses.lean`: complete packed row traversal, sparse
   guard/floor consumption, exact vertex coverage and signature validation.
   Its final theorem proves the unchanged `pairIndependentBool` assertion.

The bounded next step is to compile these generic modules, then generate only
Graph34 left against the literal cache already being tested. Compare accepted
kernel elapsed time and peak memory against that same literal-cache baseline.
Only after this concrete certificate succeeds should broader generation be
considered. A direct-natural arithmetic replacement for the current ZMod
formula could reduce per-mask overhead further, but requires its own exact
equivalence theorem and should be a later, separately measured change.

The existing greedy sieve permutation reduces Graph34 left to40,193 mask
calls, versus26,104 for selected masks. It starts with larger moduli and does
not remove the search or equality checks, so the count alone cannot establish
which implementation is faster. A stronger structural theorem for the
remaining rows would require new mathematics; the present plan uses only
already established obstruction and cached-sieve soundness results.

Reproduce the counts with `python3 crossblock_performance_next/selected_mask_costs.py`.
The diagnostic writes only its own local JSON report; it generates no Lean
data, invokes no compiler, and performs no remote operation.
