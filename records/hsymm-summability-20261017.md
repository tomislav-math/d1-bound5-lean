# Complex hsymm summability, 17 October 2026

## Mathematical theorem

Let I be a nonempty finite index type, let a : I -> C, and let rho be real with rho >= 0 and |a_i| <= rho for every i. For any z in C with rho |z| < 1, the series

    sum_(k >= 0) z^k h_k((a_i)_(i in I))

is summable. Indeed, with m = |I| and q = m - 1, the root-proved coefficient estimate and negative-binomial majorant give

    |z^k h_k(a)| <= binomial(q+k,q) (rho |z|)^k.

Since rho |z| is nonnegative and strictly below 1, mathlib's theorem `summable_choose_mul_geometric_of_norm_lt_one q` supplies the summability of the majorant; the norm comparison theorem `Summable.of_norm_bounded` yields the series convergence. No distinctness or nonzero assumptions on the coefficient values are needed. The nonempty condition matches the manuscript's m >= 2 interpolation anchor sets.

## Formal source and scope

`D1Bound5/HsymmSummability.lean` exports `D1Bound5.hsymm_aeval_complex_summable`. It depends on `D1Bound5.hsymm_aeval_complex_norm_le_choose`, already root-proved, and mathlib's negative-binomial summability theorem. No analytic convergence assumption is smuggled into the conclusion. The intermediate natural-number identity is explicitly proved using `Nat.choose_symm_add`.

This establishes the absolute majorant required for the hsymm part of the analytic interpolation step. It does NOT establish the exact analytic square-root expansion, the binomial coefficient tail with the manuscript's constants, Bennett's arbitrary-order determinant identity, certified finite coverage/descent, the three sextuple exclusions, or the bound-five main statement.

Verification details are in the separate 18:17 START/PROGRESS/FINISH run records and `research/continuations/20261017T181708CEST-hsymm-summability/`. No independent formal statement review or clean checkout has been performed.
