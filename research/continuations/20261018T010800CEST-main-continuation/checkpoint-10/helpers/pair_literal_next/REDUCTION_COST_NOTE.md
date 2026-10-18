# Row34 kernel-reduction fallback assessment

This is a source-based design assessment and exact Python operation count,
not a Lean profile or a measured speedup. No accepted generic source changed.
The active Left34 certificate must finish or time out before the root agent
chooses another build.

## Evidence from the current definitions

The active left certificate supplies
`(pairSplitByMask cachedVertices colors).1`, where `cachedVertices` is a
`List.zipWith` over the original vertices and literal signatures. The accepted
full certificate traverses this cached class in three syntactic places:
projected-vertex coverage, signature validation, and independence. Its original
vertex argument, `(pairSplitByMask smallPairLarge_34 colors).1`, is used in the
coverage equality. Every pair in the independence recursion projects its two
cached records and walks their signature lists.

`pairSplitByMask` recursively constructs a pair of lists with a local `tail`.
Projection reduces only the required component; the source does not justify
claiming that both color lists are evaluated eagerly or that splitting is
exponential. Whether the pinned kernel shares particular repeated reductions
was not established. The direct-literal fallback removes split/zip
construction from all repeated cached-list traversals regardless of that
sharing behavior. It retains the original split vertex list in the coverage
check, so the mathematical connection is checked exactly as before.

Exact replay of the frozen row34 source and sieve gives:

| Work | Left | Right |
| --- | ---: | ---: |
| Vertices | 229 | 228 |
| Unordered same-color pairs | 26,106 | 25,878 |
| Ordered cached-mask evaluations | 179,338 | 178,244 |
| Mean masks per pair | 6.870 | 6.888 |
| Canonical coordinate modulus checks | 11,450 | 11,400 |
| Floor witnesses checked | 2 | 1 |

There are no cheap-negative-obstruction survivors in this row. Its three
survivors are nonreal radicands handled by the existing norm-floor checker.
The cost distribution therefore points to modular traversal and list/record
reduction, not the two left floor inequalities. The one-time large-coordinate
modulus checks also remain a distinct possible cost; no measured fraction is
assigned to them here. Exact counts are in
`audit_next/row34_cached_operation_counts.json`.

## Minimal prepared fallback

`pair_literal_next/generated/SmallPairLiteralCachedData34.lean` contains direct
constructor lists `leftCached` and `rightCached`, with the identical original
coordinates, order, and canonical residues. Its wrappers change only the
cached-list argument of the accepted
`pairCachedFloorIndependentCertificateBool`. The original split-vertex
coverage target, signature validation, original floor rows, and old final
`pairIndependentBool` target are unchanged.

This is the smallest controlled comparison: no new algebra, new mask rule,
new floor computation, or changed accepted checker is involved. It adds about
366KB of source because coordinates become literal a second time. The portable
generator can reproduce it on the Mac from hash-pinned existing files and
compare the exact output manifest before intake. No kernel success or speedup
is claimed for this fallback.

If a later run still needs localization, coverage, signature validity, and
sparse independence can be named and compiled separately and then recombined
with the existing Boolean conjunction. This is proof-neutral and avoids
attributing all elapsed time to pair traversal without evidence.

## What mask precomputation would actually change

Read directly from pinned Lean4.33.1
`src/lean/Init/Data/Nat/Bitwise/Basic.lean`:

```
def testBit (m n : Nat) : Bool := 1 &&& (m >>> n) != 0
```

`shiftRight` has an external runtime implementation and a recursive logical
body. The kernel-specific reduction optimization for that operation was not
verified, so no per-bit asymptotic timing claim is made. The current mask
formula does not explicitly compute a power `p^2`; it computes the bit index
`reResidue*p+imResidue`. The largest current mask has9409bits. Simply storing
`p^2` would not remove an operation occurring in the accepted formula.

Two later candidates, only if the literal comparison still leaves a problem:

1. A separate raw-natural residue helper can compute the two product
   coordinates using cached nonnegative residues and only two final modulus
   operations. The current ZMod expression contains seven modular products,
   four modular sums, and repeated casts of the same residues/constants.
   Prove equality to the accepted `pairResidueMaskBool`, then use it in a new
   checker; keep the passed checker unchanged. Actual elapsed improvement
   would still need a kernel benchmark.
2. A prechecked row-bitmask table could replace
   `mask.testBit (r*p+c)` by `rowMask[r].testBit c`, with every row table checked
   against the original mask and invalid indices rejected. This shortens the
   bit index from at most9408 to at most96. It requires an exact test-bit/shift
   equivalence proof and could trade shift work for list lookup. It is useful
   only if those shifts are a real bottleneck; it is not yet implemented.

Reordering the same25 masks is another mathematically small option because
conjunction is permutation-invariant. An exact greedy diagnostic reduces
Left34 mask calls from179,338 to40,193 and Right34 from178,244 to39,787 while
retaining all masks once and the same three survivors. However it puts larger
moduli first (79,71,67,...), increasing bit indices and operand sizes. Fewer
calls alone do not establish a speedup. The full diagnostic is
`audit_next/row34_sieve_permutation_diagnostic.json`; no sieve was changed.
