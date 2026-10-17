# All-order Lagrange remainder bridge — 17 October 2026

Status: FOUR verified standalone Lean theorems, not imported into the accepted D1Bound5 root.

## Mathematically proved

For a finite set s of m pairwise distinct nodes a_i in any field F, let
Q(T) = product_(i in s) (T - a_i) and D_i = product_(j in s, j != i) (a_i-a_j).
For all n >= 0,

    sum_(i in s) a_i^n / D_i = coeff_(m-1) (T^n mod Q(T)).

The remainder uses Lean's monic polynomial division, %ₘ. Its proof applies
Lagrange.coeff_eq_sum to the remainder and proves that evaluation at each
node is unchanged by division by Q. This includes the empty s case.

The complete low-degree normalization is also proved. For 0 <= n < m,
the preceding sum is 1 if n=m-1, and zero otherwise. For m>0,

    sum_(i in s) a_i^m/D_i = sum_(i in s) a_i.

The latter is h_1, obtained using the leading-coefficient cancellation of
T^m-Q(T) and mathlib's exact coefficient formula for the nodal product.

For distinct nonzero a_i, put b_i=a_i^-1 and A=product_(i in s) a_i.
The previously verified reciprocal Vandermonde transfer combines with the
new remainder formula to prove, for EVERY k >= 0,

    sum_(i in s) b_i^(k+1) / D_i
      = (-1)^(m-1) A^-1
        * coeff_(m-1)(T^(k+m-1) mod product_(i in s)(T-b_i)).

No unproved analytic bound or recurrence assumption is inserted. This is an
all-order exact algebraic identity, not yet the explicit identification of
the right coefficient with the complete homogeneous symmetric polynomial
h_k(b_1,...,b_m). The actual h_k equality for every k remains OPEN.
No analytic interpolation error/remainder inequality is proved here.

## Exact source and verification

Source: CompleteHomogeneousMomentsTrial.lean, byte-identical to
exploration/CompleteHomogeneousMomentsTrial.lean at the isolated build.
The latter imports the already compiled isolated
exploration.ReciprocalAnchorTrial; neither is in the accepted root graph.
Source SHA256: 32b701e0e87d9997731519f84d4415ebe71e6d0482896ce7d11ad699b6db7ebb.

- Trials 01 and 04 failed before proof completion; errors corrected.
- Trial06 pinned Lean 4.33.1/mathlib 0df444a360eaa60ab8c11dca51a86af692955474: EXIT 0.
- All four complete elaborated types and transitive axioms printed; only
  propext, Classical.choice and Quot.sound occur.
- Isolated .olean compilation: EXIT 0.
- Installed same-kernel leanchecker --verbose exploration.CompleteHomogeneousMomentsTrial: EXIT 0.
- Existing accepted root source audit: EXIT 0, 82 modules, 387 theorems.
- Existing source and verification-tools hash manifests: strict PASS.
- No integrated root rebuild, clean checkout, whole-root replay,
  independent reviewer, or proof of MainStatement is claimed.

Next: prove equivalence of the remainder coefficient and mathlib
MvPolynomial.hsymm, then continue the required analytic remainder bounds.
Bennett's arbitrary-order determinant, finite certificate soundness/coverage,
descent termination and final sextuple exclusions remain separate open goals.
