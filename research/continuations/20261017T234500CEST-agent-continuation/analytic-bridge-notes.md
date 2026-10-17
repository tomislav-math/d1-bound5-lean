# Coherent analytic interpolation bridge

Status: source draft supplied for serial compilation by the root agent. No compiler was run by this agent, and no remote project files were changed.

## Scope and dependencies

The draft imports `D1Bound5.ComplexHalfBinomial`, `D1Bound5.HalfBinomialAnalytic`, and `D1Bound5.InterpolationWeights`. These are the module names confirmed by the root agent during this session.

The frozen paper was read at `paper/Diophantine_tuples_bound_five_2026-10-15.tex`, especially lines 534--591 containing `eq:coherent-exact` and `eq:coherent-tail`. Existing reciprocal interpolation, complete homogeneous moments, analytic half-binomial sums, the coefficient convolution envelope, and the positive-degree remainder estimate were inspected directly.

## Mathematical content

1. `coherent_anchor_power_moment_low` establishes the exact low Taylor moments at every `n < card s`. Multiplying the ordinary barycentric weight by `a_i^(-n)` reduces to the ordinary polynomial power `a_i^(card s - 1 - n)`. Lagrange interpolation gives one at `n = 0` and zero otherwise.
2. `coherent_anchor_power_moment_high` establishes the exact remaining moments at `n = card s + k`. The inverse-power exponent becomes `k + 1`, so the previously verified reciprocal moment identity applies with parity `(-1)^(card s - 1)` and reciprocal total product.
3. `coherent_interpolation_series_exact` proves a reusable theorem for any complex Taylor series converging at each inverse anchor. A finite linear combination of the supplied `HasSum` identities gives a convergent moment series. Removing the first `card s` terms leaves the complete homogeneous tail. The multiplier is nonzero because all anchors are nonzero, so summability of the unscaled tail follows. The exact identity is proved, never assumed.
4. `coherent_half_binomial_exact` specializes to the actual product of principal complex powers `(1 + x/a_i)^(1/2) (1 + y/a_i)^(1/2)`, using the existing analytic `HasSum` theorem. The constant coefficient is computed as one.
5. `coherent_half_binomial_exact_split` removes the leading homogeneous coefficient from the full sum and subtracts `(1 + xy)^(1/2)`. Its left side is the analytic normalization occurring in `eq:coherent-exact`.
6. `coherent_half_binomial_full_tail_norm_le` proves summability of the full `F_m` and the paper-facing estimate on `norm (F_m - f_m)`, by adding the zero-degree term to the already bounded positive-degree tail.

## Audit and remaining integration

The all-order interpolation proof is valid for every nonempty anchor set, including a single anchor. The parity is checked against the reciprocal identity. No positivity assumption on complex anchors or variables is used. There is no circular assumption of the desired identity or of its tail bound. No `sorry`, `admit`, or new axiom occurs.

The code has not yet passed the compiler. Likely elaboration adjustments are finite-sum `HasSum` conversion or simplification of the degree-zero homogeneous polynomial, rather than mathematical gaps.

The draft does not yet identify the normalized expression with the integral ring element named `L_m`, nor prove its Vandermonde coefficients integral or its nonzero modulus at least one. Those are separate algebraic bridges. It also does not finish the global nonexistence theorem.
