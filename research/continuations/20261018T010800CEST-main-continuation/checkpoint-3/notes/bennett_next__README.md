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

## Two-anchor arithmetic continuation

The next three drafts address the actual `m=2` integrality statement, not just
an abstract coefficient assumption:

- `BennettTwoDenominatorClearing.lean`: exact power cancellation in all three
  columns, including both pole signs and the surviving column powers.
- `BennettTwoIntegralSummands.lean`: the actual generalized choose factors and
  pole expressions give polynomial integral summands.
- `BennettTwoIntegralEntries.lean`: the actual `bennettClearedResidue` is
  expanded via two antidiagonals, and all summands are summed to a full row.

These use agent `source_audit`'s `BennettBinomialIntegrality.lean` (Catalan and
Vandermonde proofs of `4^h choose(k+1/2,h)` being an integer) and agent
`allorder_det`'s `BennettSubringSums.lean` (integer scalar membership and finite
sum divisibility). They are also uncompiled at creation.

For two anchors, the exact normalization is `H=ab`, `alpha=(0,b,a)`, `N=abc`,
and

`Q_ij = (4ab(a-b)^2)^k G_ij(abc)`

`     = (4(ab)^2 c(a-b)^2)^k P_ij((abc)^-1)`.

For row multiplicities `d0+d1+d2=1` and `h0+h1+h2+1=k+d_j`, the unsigned
cleared monomials are respectively

- column 0: `a^(d1+h1) b^(d2+h2) c^(k-h0) (a-b)^(2k)`;
- column 1: `a^k (ac+1)^(k-h1) b^(d2+h2) (a-b)^(k-d2-h2)`;
- column 2: `b^k (bc+1)^(k-h2) a^(d1+h1) (a-b)^(k-d1-h1)`.

The signs restored in the actual formulas are `(-1)^(2k+d1+h1+d2+h2)`,
`(-1)^(k+d2+h2)`, and `1`, respectively. All exponents are proved
nonnegative from the exact Taylor-index relation.

The final row-lift statement is over any commutative source ring `R`, field
`F` of characteristic zero, and homomorphism `f : R ->+* F`. For distinct
nonzero anchor images it produces `q0,q1,q2 : R` such that the three actual
entries are `f(q0)`, `f(a^k*q1)`, and `f(b^k*q2)`. Taking `R` to be the full
ring of integers gives integrality and column divisibility without assuming
unique factorization. No claim of a uniform polynomial in indeterminates is
needed for that arithmetic application.

## Exact analytic residual continuation

The local drafts `BennettResidualMajorant`, `BennettResidualEvaluation`, and
`BennettResidualBound` implement an elementary alternative to contour
deformation, preserving every manuscript constant. Their last endpoint bounds
the actual Fin3 row `sum P_ij(x)*(1+alpha_j*x)^(1/2)` by

`Gamma(k+3/2)*Gamma(2k-1/2)/(pi*Gamma(3k+1))`

`  * |x|^(3k)/(1-rho*|x|)^(2k-1/2)`.

The proof explicitly evaluates the binomial/polynomial series, removes the
proved low-degree zeros, and invokes allorder_det's exact high-degree
residue-to-repeated-homogeneous identity. The choose multiplication identity
cancels the homogeneous counting factor, giving a real negative-binomial
series whose sum is supplied by mathlib's proved analytic theorem.
source_audit's finite-product/Gamma identity identifies the leading constant.

All new analytic files are uncompiled at creation. No cancellation, residual
formula, coefficient envelope, Gamma identity, or contour estimate is assumed
as an independent mathematical hypothesis in their final endpoint. The
remaining quantified approximation work includes individual entry bounds,
normalization to Q/R2, and root-transfer arithmetic.

`BennettTwoResidualBound` now also applies the exact clearing normalization to
the actual Q-matrix. `BennettTwoResidualRate` proves the identity
`V2k*R2^k=sqrt(eta)*b_k` and combines the actual Q bound with the proved beta
sequence bound, giving the final actual residual `<1/(2*R2^k)` in source.
These joins are uncompiled at creation.

## Coefficient size continuation

The coefficient estimate also admits a positive-series proof. In degrees
`h≤k`, `abschoose(k+1/2,h)≤choose(k+1,h)`. The numerator majorant is
`U^-1*(U+X)^(k+1)`, where `U=|N+alpha_j|`. The remaining pole coefficients have
explicit nonnegative majorants whose actual sums at radius `r` are
`(|d|-r)^(-p)`. `BennettCoefficientMajorant`, allorder_det's
`BennettPositiveSeries`, and `BennettLocalCoefficientBound` implement these
facts and give the bound on the actual local residue coefficient. The extra
row pole pays for the coefficient radius; this is proved using exact natural
exponents, not assumed from the contour picture.

`BennettTwoEntryBounds` instantiates the actual two nonzero columns. At
`r=2*min(X,delta)/5` the elementary geometric and rational inequalities in
`BennettTwoCoefficientConstants` preserve the paper's final `H2=42*B^3*C`.
The temporary prefactor is `F2/eta` instead of `sqrt(F2/eta)`; the strict
rational slack below42 absorbs it for every positive order. Thus no manuscript
constant is silently enlarged. `BennettTwoHeightBounds` now joins the real
normalization to the actual columns, proving the slightly stronger bounds
`|Q_i1|<(42*A^2*B*C)^k` and `|Q_i2|<(42*B^3*C)^k` without the paper's prefactor.
All new coefficient files require compiler acceptance.

## Actual integral root transfer

`BennettRootApproximation` chooses signs of the existing integral root
products in the source ring. The sign ensures nonnegative real part after
division by the actual principal square-root branch, and the difference of
squares gives the root error. For `AC>=1000` and `C>4B`, the branch norm is
less than `6/5` and `|c-a|<5C/4`; their product gives the uniform factor `3/2`.
The same witnesses are then used in every row.

`BennettRootTransfer` combines these errors with the actual matrix bounds
and allorder_det's integral row selection. Its final theorem
`full_ring_bennett_two_integer_k` states, for every `k>=1`,

`1 < 3*C*(42*B^3*C)^k/(B*Z) + Z/(2*R2^k)`.

The hypotheses are actual roots in the full integer ring, nonzero tuple
entries, distinct anchors, and the explicit geometric size conditions.
The terminal root is proved nonzero. The determinant, integral row, modulus
lower bound, root signs, coefficient height, and residual estimate are all
derived from the constructed objects. There are no certificate premises
for any of those steps. These files are source-complete drafts awaiting
the root agent's serial Lean compilation; they do not establish the main
nonexistence theorem by themselves.
