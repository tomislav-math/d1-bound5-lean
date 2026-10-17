# Exact finite-order pole and homogeneous interpolation tails

17 October 2026. Pinned Lean 4.33.1, mathlib 0df444a360eaa60ab8c11dca51a86af692955474.

## Mathematics

For any field F, a != 0, a != z and n >= 0, the exact finite identity is

  1/(a-z) = sum_{k=0}^{n-1} z^k/a^(k+1) + z^n/(a^n (a-z)).

It follows by telescoping the rational remainders R_k=z^k/(a^k(a-z)), for which R_k-R_(k+1)=z^k/a^(k+1). Multiplying by arbitrary weights and commuting two finite sums gives the corresponding formula for any finite system of poles, without distinctness or characteristic assumptions.

For a nonempty finite index set S with pairwise distinct nonzero a_i, put D_i=prod_{j in S, j!=i}(a_i-a_j), b_i=1/a_i, m=|S| and C=(-1)^(m-1)/prod_i a_i. The newly proved finite generating-function theorem states, for any z != a_i and every n >= 0,

  sum_i 1/(D_i (a_i-z))
    = C sum_{k=0}^{n-1} h_k(b_1,...,b_m) z^k
      + z^n sum_i 1/(D_i a_i^n (a_i-z)).

The proof applies the earlier root-proved all-degree identity

  sum_i b_i^(k+1)/D_i = C h_k(b_1,...,b_m)

to each finite Taylor coefficient. The remainder is an explicit rational expression and no convergence/interchange of infinite sums is invoked. Zero values among the weights and repeated pole values are permitted in the general weighted lemma, subject only to nonzero denominators. The specialized hsymm formula requires precisely the distinct/nonzero anchor hypotheses above.

## Proof files and status

Accepted candidate modules: `D1Bound5/WeightedPoleFiniteTail.lean` (two theorems) and `D1Bound5/PoleHomogeneousTail.lean` (one theorem). Trial files and the initially failed attempted rewrite are kept under `research/continuations/20261017T172102CEST-pole-interpolation/`. The earlier 16:47 research source was not modified. Audit script: `scripts/PoleHomogeneousTailAudit.lean`.

The first direct compilation of the earlier finite-tail draft failed because an unnecessary `rw [Finset.mul_sum]` was applied after that sum had already been distributed. Removing only this redundant rewrite gave a pinned elaboration EXIT 0 and standard transitive axiom lists. This is a genuine repaired Lean error, not a change of mathematical hypotheses.

## Remaining obligations

This unit proves an EXACT FINITE rational expansion, not absolute convergence or the square-root interpolation tail bound in frozen v4 equation `eq:coherent-tail`. Next prove a complex norm envelope for evaluated `MvPolynomial.hsymm`, bound the binomial/square-root Taylor coefficients, justify the infinite-series passage, and recover the numerical remainder inequality. Bennett's arbitrary-order determinant, certified finite graph coverage/descent, the three sextuple exclusions and `MainStatement` remain UNPROVED.

Build, kernel replay, axiom, fingerprint and Git statuses are documented in the separate dated run receipt after actual execution. No claim of clean-checkout or independent review is made.

## Precise next analytic bound and library entry points

For any finite nonempty index type I, complex values b_i and a real rho >= 0 such that ||b_i|| <= rho, one should prove

  ||aeval b (MvPolynomial.hsymm I Complex k)||
    <= Nat.choose (Fintype.card I + k - 1) k * rho^k.

It follows by bounding each degree-k multiset monomial by rho^k and then counting all multisets. Verified local pinned mathlib API: `Sym.card_sym_eq_choose` in `Mathlib/Data/Sym/Card.lean`, line 113, gives `Fintype.card (Sym I k) = (Fintype.card I + k - 1).choose k`. The evaluated hsymm/multiset-sum identity is already root-proved in `HomogeneousSymmetric`. Use `Finset.norm_prod_le`, `norm_sum_le` and the explicit `Sym` cardinal theorem. Then take rho=1/A1 and use the binomial generating function to derive the manuscript's `eq:coherent-tail`, retaining its strict A1*P>1 assumption and m in {2,3,4}. This is a next-step plan, not an accomplished Lean result.
