# Arbitrary-order Bennett determinant continuation

These are local Lean drafts for the single-writer root agent to compile and
integrate. At creation they are **uncompiled**; this document does not certify
acceptance by Lean. They contain no `sorry`, `admit`, `native_decide`, new axiom,
or assumed residual cancellation. The Diophantine main theorem is still open.

## Sources and scope

The construction is the ordinary explicit residue formula in the frozen
`paper/Diophantine_tuples_bound_five_2026-10-15.tex`, section
`ordinary-residue-construction` (approximately lines 920–1018). The primary
Bennett paper was read independently by the article/source audit agents.
Source audit independently checked the local multiplicities, directed
differences, powers, parameter shifts, residual order, and zero-node condition.

All lemmas are over an arbitrary characteristic-zero field. The determinant
formulas require positive order `k`, distinct nodes, and the first node equal
to zero. The exponent parameter `ν` remains arbitrary until the final
specialization to `1/2`. In particular the proof allows negative shifted
parameters `ν-k`, `ν-2*k`, and so forth.

## Mathematical derivation

For row `i`, set `e_j=k+δ_ij−1` and

`B_ij(z)=∏_{l≠j}(a_j−a_l+z)^−(k+δ_il)`.

The existing explicit `bennettPoleSeries` is the formal power series inverse
of the indicated polynomial, with proved coefficients. Define the entries

`P_ij(x)=Σ_{h+t=e_j} choose(k+ν,h) coeff_t(B_ij) x^h(1+a_j*x)^(k-h)`

and

`G_ij(N)=Σ_{h+t=e_j} choose(k+ν,h) coeff_t(B_ij) (N+a_j)^(k-h)`.

The finite sums prove degree at most `k` directly and give the exact
homogenization identity `N^k P_ij(1/N)=G_ij(N)` for `N≠0`.

The key coefficient transfer is

`coeff_r(P_ij(x)(1+a_j*x)^ν)`

`=choose(k+ν,r) coeff_{e_j}((a_j+z)^r B_ij(z))`.

The independent partial-fraction development in `allorder_next/` proves that
the sum of the explicit coefficients on the right is zero for `r<n*k`:
the denominator has degree `n*k+1` and the polynomial numerator has degree
`r<n*k`. The proof constructs the decomposition using mathlib's actual
partial-fraction theorem, identifies its coefficient with the explicit
power-series residue, and compares the top cleared polynomial coefficient.
No analytic residue theorem or convergence claim is needed.

Truncating the binomial multipliers preserves these coefficients. At the
distinguished zero node the multiplier polynomial is exactly `1`, which
allows the existing column replacement argument to prove

`det P = C * x^(n*k)`.

Homogenization makes `det G` the constant polynomial `C`. Evaluating at
`N=−a_q` leaves just the diagonal in column `q`. A Chu–Vandermonde identity
in formal series identifies the remaining matrix with the reduced node set,
parameter `ν-k`, and column factor `(a_j−a_q)^−k`. This proves the recurrence

`C_n(ν)=choose(k+ν,k) * ∏_{j≠q}(a_q−a_j)^−k`

`                         * ∏_{j≠q}(a_j−a_q)^−k * C_{n−1}(ν-k)`.

The `Fin` induction removes the final node, retaining node zero in every
nonempty prefix. Its one-node base handles zero directly. The closed formula
is

`C_n(ν) = (∏_{v=0}^{n−1} choose(k+ν−v*k,k))`

`          * ∏_{i}∏_{j≠i}(a_i−a_j)^−k`.

At `ν=1/2` each binomial upper parameter avoids every natural number by
parity in characteristic zero. The descending-Pochhammer product then proves
each generalized choose factor nonzero. Distinct nodes prove every remaining
factor nonzero. The final drafts conclude `det G(N)≠0` for every `N`, and
`det P(x)≠0` for `x≠0`.

## Compilation order and ownership

1. `BennettClearedResidues.lean` — grouped arbitrary-order cleared entries;
   degree, evaluations, Chu–Vandermonde pole removal, node removal.
2. `BennettResiduePolynomials.lean` — original entries, degree, homogenization.
3. Agent `allorder_det` dependencies `BennettPartialFractions.lean`,
   `BennettLocalResidues.lean`, `BennettBinomialTransfer.lean`.
4. `BennettResidualCancellation.lean` — actual residual vanishing and actual
   determinant monomial; uses existing `BennettResidualDeterminant.lean`.
5. Agent `allorder_det`'s `BennettDeterminantConstant.lean` — actual cleared
   determinant constant, and equality of any two evaluations.
6. `BennettNodeRemoval.lean` — exact finite-index determinant recurrence.
7. `BennettDeterminantFormula.lean` — closed product formulas for `G` and `P`.
8. Agent `source_audit`'s `BennettChooseNonzero.lean` — half-integer factors.
9. `BennettDeterminantNonzero.lean` — actual arbitrary-order nonvanishing.

The root agent alone writes/compiles the remote repository and performs Git
operations. Agent-generated local drafts must be compiled and inspected before
any status is upgraded. The remaining main-theorem obligations include the
quantitative approximation construction/bounds and their connection to the
Diophantine argument; determinant nonvanishing alone does not prove them.
