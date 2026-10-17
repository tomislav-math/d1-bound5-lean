# Exact second complete homogeneous Lagrange moment (2026-10-17)

Status: **three new standalone Lean theorems verified**, isolated from the accepted root. The previous weighted-moment recurrence proved earlier today was consulted and reused, NOT counted anew.

Let F be a field and a_i, i in s, pairwise distinct, with m=|s|>=2. Write
D_i = product_(j in s, j!=i) (a_i-a_j), e1 = sum_i a_i, and
e2 = sum_(unordered distinct pairs {i,j}) a_i a_j.

The exact new formula proved in Lean is

    sum_i a_i^(m+1) / D_i = e1^2 - e2.

The expression e1^2-e2 is the second complete homogeneous symmetric
value h2(a), i.e. sum_(i<=j) a_i a_j after any ordering of s. For all
distinct nonzero anchors, setting b_i=a_i^(-1), the proved reciprocal
transfer yields the further new formula

    sum_i a_i^(-3)/D_i =
      (-1)^(m-1)/(product_i a_i) * (e1(b)^2 - e2(b)).

Proof mechanism: the degree-(m-2) nodal coefficient is e2 by Vieta.
Use the previously proven exact Lagrange weighted-moment recurrence with
shift 1. Of the lower-order moments, all except degrees m-1 and m vanish.
The moment at m-1 is 1 and that at m is e1. The monic recurrence thus
gives the stated formula. The reciprocal version uses the previously
proved exact sign/product Vandermonde transfer with k=2.

Lean names:
- `D1Bound5.nodal_coefficient_two_below_top`
- `D1Bound5.lagrange_power_moment_second_hsymm`
- `D1Bound5.reciprocal_anchor_third_power_hsymm`

Location: `research/continuations/20261017T154335CEST-hsymm-recurrence/SecondHomogeneousMomentTrial.lean`. Final SHA256
758416a8bd474aa4a1e8de7552d3a32a2aa2eef923c1fed655f2eafb14004db2.

Verification: PINNED trial04 EXIT 0, isolated output-module compilation EXIT 0,
targeted installed same-kernel leanchecker EXIT 0, exact elaborated theorem
types and transitive axiom lists standard-only, no sorry/admit/custom axiom.
Input exploratory dependencies match their previously checked source hashes.
Existing accepted root source audit PASS (82 modules, 387 theorems), both
accepted hash manifests PASS. No root integration, independent review,
clean-checkout build or all-order h_k formula is claimed.

The initially re-proved nodal recurrence was identified as a duplicate of
`lagrange_power_moment_step` from the earlier isolated source. It is NOT
counted in the three new declarations. Failed elaboration and duplicate
records are preserved without promoting them into accepted dependencies.

Still open: genuine all-k equality with complete homogeneous symmetric
polynomials, analytic interpolation error/remainder bounds, arbitrary-order
Bennett identity, finite exhaustive verification and descent, final main
sextuple exclusions, faithful MainStatement proof and final release gates.
