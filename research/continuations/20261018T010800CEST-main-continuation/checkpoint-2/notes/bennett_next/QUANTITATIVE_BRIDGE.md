# Exact remaining two-anchor quantitative bridge

Source: frozen manuscript `Diophantine_tuples_bound_five_2026-10-15.tex`,
ordinary residue lemma and proposition `ordinary-all-orders`, approximately
lines 900–1198. This is a mathematical dependency map, not a claim that the
analytic steps have been formalized.

Let `A=|a|`, `B=|b|`, `C=|c|`, `delta=|a-b|`, with
`1≤A≤B`, `C>4B`, and `AC>1000`. Put

`H2=42 B^3 C`,
`R2=27 B (AC-1)^2 / (16 A delta^2)`,
`eta=1-1/(AC)`,
`F2=1+7/(5AC)`,
`p2=sqrt(F2/eta)`,
`e(B)=sqrt(1+1/(BC)) (1+B/C)`.

## Algebra and arithmetic already supplied as drafts

The constructed matrix is exactly

`Q_ij=(4ab(a-b)^2)^k G_ij(abc)`

`     =(4(ab)^2 c(a-b)^2)^k P_ij((abc)^-1)`.

The all-order determinant chain proves nonsingularity. The two-anchor
integrality chain proves actual ring lifts with column 1 divisible by `a^k`
and column 2 by `b^k`. These are actual constructions, not coefficient or
determinant hypotheses. Compilation acceptance must still be tracked by the
root agent; the local draft names do not certify it.

## Exact coefficient estimate still required

For a nonzero node, let `u≤v` be its two distances to the other nodes. On the
circle with radius `2u/5`, the three denominator distances have product at
least

`(2u/5) (3u/5) (v-2u/5)=6u^2(v-2u/5)/25`.

The extra row pole has distance at least `2u/5`; it cancels the factor
`circle length/(2pi)=2u/5`. The analytic numerator divided by the node's
chosen square-root value is at most `p2 F2^k`, because `|w|≤7B/5` and
`|w/(abc)|<1`. These facts must be linked to the actual residue coefficient
using Cauchy's coefficient formula for the selected binomial branch. Formal
power-series identities alone do **not** imply this analytic bound.

The resulting local bounds are

`|Q_i2| ≤ p2 ((50/3) B^2 C F2 * v^2/(v-2u/5))^k`,

`|Q_i1| ≤ p2 ((50/3) A^2 C F2 * v^2/(v-2u/5))^k`.

The geometric inequality `v^2/(v-2u/5)≤5B/2` uses both the triangle bound
`delta≤A+B` and `A≤B`. If delta is the smaller distance, the stronger bound
`5B/3` suffices. Otherwise, with `x=A/B`, the relevant rational functions
are `(1+x)^2/(1+3x/5)` and `(1+x)^2/(x+3/5)`, both at most `5/2` on `[0,1]`.
This purely real step is separable from Cauchy's theorem.

Since `(125/3)(1+7/5000)<42`, the column bounds become

`|Q_i2| < p2 H2^k`,
`|Q_i1| < p2 ((A/B)^2 H2)^k`.

For `k≥1`, these imply the weighted row bound

`(C e(B)/Z) (|Q_i1|/A+|Q_i2|/B) < 3 C H2^k/(B Z)`.

The numerical square bounds are
`p2^2≤5007/4995`, `e(B)^2<25*1001/16000`, and their product multiplied by
4 is strictly less than 9. They do not by themselves replace the actual
coefficient estimate.

## Exact residual estimate: a power-series proof drafted

The original contour route below is no longer necessary for the mathematical
proof. The following exact-constant alternative is now implemented in local
Lean source, pending compilation of its complete dependency chain:

1. `BennettResidualEvaluation` evaluates the actual finite row `sum P_ij theta_j`
   by the absolutely convergent polynomial/binomial Cauchy product. Its tail
   coefficients are `choose(k+1/2,3k+t)` times actual local residue moments.
2. `BennettResiduesAtInfinity` and `BennettRepeatedHsymm` identify these moments
   with degree-`t` complete homogeneous polynomials on `3k+1` repeated nodes.
   This uses polynomial reflection and exact partial fractions, with no
   contour or unproved residue theorem.
3. The existing homogeneous coefficient bound is `choose(3k+t,t) B^t`.
   `BennettResidualMajorant` proves the exact coefficient cancellation
   `abschoose(k+1/2,3k+t)*choose(3k+t,t)`
   `=abschoose(k+1/2,3k)*abschoose(-(2k-1/2),t)`.
   The actual convergent negative-binomial sum gives `eta^(-2k+1/2)`.
4. `BennettChooseGamma` proves the base coefficient is exactly
   `Gamma(k+3/2) Gamma(2k-1/2)/(pi Gamma(3k+1))` from finite Pochhammer products
   and Gamma recurrence, with no reflection formula required.
5. `BennettResidualBound` joins these into a bound on the **actual** P-matrix
   residual. It has only injective-node, positive-order and disk hypotheses.

This closes the analytic residual argument at the source-proof level, not yet
at the compiler-verified level. The normalization from P to the integral Q
matrix and the final scalar R2 inequality remain to be joined. The coefficient
size bound for individual entries and the root transfer remain separate open
analytic work.

For comparison, the manuscript's original derivation is as follows.

The manuscript deforms the integral around all interpolation poles onto the
branch cut starting at `-N`. Both vanishing boundary contributions and the
branch jump must be justified for the selected branch. This gives

`|sum_j Q_ij theta_j| ≤ (4 delta^2/(AB C^2))^k / pi`

`                         * integral_0^infinity x^(k+1/2)/(x+eta)^(3k+1) dx`.

After the beta substitution the right side is

`V2k=(4 delta^2/(AB C^2))^k eta^(-2k+1/2)`

`       * Gamma(k+3/2) Gamma(2k-1/2)/(pi Gamma(3k+1))`.

Purely algebraically, `V2k R2^k=sqrt(eta) b_k`, where

`b_k=(27/4)^k Gamma(k+3/2) Gamma(2k-1/2)/(pi Gamma(3k+1))`.

The actual special-function sequence has `b_1=27/64` and

`b_(k+1)/b_k = [(27/4)(k+3/2)(2k-1/2)(2k+1/2)]`

`                 /[(3k+1)(3k+2)(3k+3)] < 1`.

Denominator minus numerator is exactly
`(432k^2+1110k+273)/32>0`. A focused Gamma-sequence draft can establish the
uniform numerical bound. `BennettTwoBetaBound` contains that sequence proof;
the new power-series route above supplies the actual residual-to-Gamma bound.

## Root transfer and final scalar consequences

Choose the tuple square roots with signs so that the normalized comparison
root has nonnegative real part. The factorization of the difference of
squares gives

`|theta_j-u_j|≤C e(B)/(A_j Z^2)`.

Nonsingularity and the integral column powers produce a nonzero row form in
the full integer ring after division by `H=ab`. Its norm is at least 1,
which yields

`1≤(C e(B)/Z) sum_{j=1,2}|Q_ij|/A_j + V2k Z`.

Combining the **actual** coefficient and residual bounds gives
`1<3 C H2^k/(B Z)+Z/(2R2^k)`. The logarithmic choice
`k=1+floor(log Z/log R2)` then gives the continuous bound
`Z^(2-lambda)<253 B^2 C^2`, and the manuscript's subsequent height envelope.
None of those final consequences should be represented as proved before the
missing analytic coefficient/residual inequalities and root transfer have
been connected to the constructed matrix.
