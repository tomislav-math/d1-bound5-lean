# Reciprocal-anchor moment transfer (17 October 2026)

Status: six proved declarations in standalone pinned Lean source; **not** part of the accepted root import graph.

For a finite set of m indices and nonzero anchors a_i in an arbitrary field, let b_i=a_i^-1, D_i=prod_{j != i}(a_i-a_j), D'_i=prod_{j != i}(b_i-b_j), A=prod_i a_i.

The exact pointwise factorization is

    D_i = a_i^(m-1) (prod_{j != i} a_j) (-1)^(m-1) D'_i.

Consequently, for any k >= 0,

    sum_i b_i^(k+1)/D_i = (-1)^(m-1) A^-1 sum_i b_i^(k+m-1)/D'_i.

This equality is formally proved for all nonzero anchors, including coincident anchors, in `reciprocal_anchor_sum_transfer`. The standard top Lagrange moment for pairwise distinct nodes b_i is 1, so for m >= 1,

    sum_i b_i/D_i = (-1)^(m-1) A^-1.

The last equation is `reciprocal_anchor_first_nonzero`, corresponding to n=m in the interpolation partial-fraction identity of D1_bound5-v4. The general h_k identity for n>m is not proved. The proof reuses mathlib's `Lagrange.coeff_eq_sum`; no custom axioms or `sorry` are used.

Source: `research/continuations/20261017T141411CEST-reciprocal-anchors/ReciprocalAnchorTrial.lean`. Six exact types and transitive axioms PASS, isolated .olean build PASS, installed targeted same-kernel leanchecker replay PASS. Root source audit remains 82/387; private preflight and earlier staged-index review PASS. No root import, full clean checkout, independent reviewer, or completed MainStatement.

Next obligation: formalize for every k the complete homogeneous symmetric polynomial identity for the Lagrange moment at distinct reciprocal nodes, and use it with the previously verified all-order recurrence. Then address analytic square-root tails, arbitrary-order Bennett determinant, finite descent/coverage, and three sextuple exclusions.
