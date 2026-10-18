# Independent review of the full arbitrary-order determinant chain

Reviewer: allorder_det worker. Scope: current local Bennett worker drafts through
`BennettDeterminantNonzero`, together with this worker's four interface modules.
This is a mathematical/source audit, not a claim of compiler acceptance.

No substantive mathematical defect was found.

- Local pole multiplicity is k+delta(i,j), so coefficient index is k+delta(i,j)-1.
  On its full multi-index antidiagonal the numerator index h is at most k.
- The residual-transfer identity has the exact generalized choose factor
  choose(k+nu,r), with no missing factorial or power. The denominator degree is
  card(I)*k+1, so numerator degree r<card(I)*k is exactly the required gap.
- Polynomial entries have degree <=k. The zero interpolation node supplies an
  identically-one binomial multiplier, so column replacement and truncation
  give determinant divisibility by X^(card(I)*k). The degree bound forces a
  single monomial.
- Entry homogenization is G(N)=N^k P(1/N). Its determinant multiplier is
  N^(card(I)*k), cancelling the monomial at all nonzero N. Polynomial equality
  over the infinite characteristic-zero field extends constancy to every N.
- At N=-a_q, off-diagonal entries in column q vanish because h<=k-1 and k>=1.
  The surviving diagonal entry is choose(k+nu,k)*product_(l!=q)(a_q-a_l)^(-k).
- The complementary submatrix is the smaller construction at nu-k, with
  column j scaled by (a_j-a_q)^(-k). The shift uses binomial addition and holds
  for arbitrary nu, including negative values. Both directed difference
  factors are retained. Removing the final row and column has sign (-1)^(2n)=1.
- The finite-index induction removes only the last node, preserving zero at
  index0 until the singleton base. The singleton determinant is choose(k+nu,k).
- At nu=1/2, every upper choose parameter k+1/2-v*k is a half-integer and avoids
  all natural integers. Therefore every choose factor is nonzero in any
  characteristic-zero field. Distinctness gives nonzero difference factors.
- The actual final determinant theorems correctly require k>=1. There is no
  unintended use of the k=0 off-diagonal construction.

## Direct comparison with the frozen manuscript

Read remotely `paper/Diophantine_tuples_bound_five_2026-10-15.tex`, lines938–1018.
The grouped power-series coefficient in the new construction expands to the
manuscript's finite multi-index residue formula, using
`bennettPoleSeries_coeff` for each local reciprocal factor. A separate Lean
expansion to that exact multi-index notation has not been provided.

The determinant constant uses v'=0,...,m and choose(k+nu-v'k,k), equal to the
paper product indexed v=v'-1=-1,...,m-1 of choose(nu-vk,k). The paper writes the
directed difference product with reversed orientation; since all ordered
pairs occur, exchanging the two indices gives the identical product, with no
extra sign. Evaluation P(1/N) gives the paper's N^(-(m+1)k) determinant factor.

The subsequent global scaling Q=(4H^m*c*Delta^2)^k f, polynomial integrality,
column divisibility and analytic coefficient/error estimates remain separate
formalization obligations. The determinant chain alone does not prove the
paper's main bound-five theorem.
