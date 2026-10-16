# Simultaneous integral sign selection for four-by-four root matrices

Source: `D1Bound5/RootMatrixSigns.lean`.
Target: the beginning of `lem:product-four` following equations (integrated-1) and (integrated-2).

## Mathematical content

Let (R) be any commutative ring with a ring homomorphism (f:R\to\mathbb C).
Given four elements (a_i\in R) and a symmetric matrix (M\in R^{4\times4})
with (M_{ii}=a_i) and (M_{ij}^2=a_ia_j+1) for all distinct indices,
assume |f(a_i)f(a_j)| >= 9 for every off-diagonal position.

Choose complex roots (u_i^2=f(a_i)). For every unordered pair
(i<j), the previously kernel-checked scalar sign theorem applies
to (x=f(a_i)f(a_j)) and (t=u_i f(M_{ij})u_j):
(t^2=x(x+1)). It supplies a choice of sign for (M_{ij}) for
which the correction (e_{ij}=u_i f(S_{ij})u_j-x) obeys
[
 |e_{ij}| < 16/31,\qquad |e_{ij}-1/2| < 128/8649.
]
The decision is made once for each *unordered* pair, using the
ordered indices `min i j`, `max i j`; assign the same signed
ring element to both positions. Thus the resulting matrix
(S\in R^{4\times4}) is symmetric, (S_{ii}=a_i),
(S_{ij}=\pm M_{ij}) for (i\ne j), and
(S_{ij}^2=a_ia_j+1). Importantly, the signed entries remain
in the original integral ring; no field divisions or existence
of complex roots in the integer ring are inferred.

Two theorems formalize the choice, first with fixed roots (u_i)
and then choosing all (u_i) using algebraic closure of
(\mathbb C). The latter is directly available for any full
imaginary quadratic integer ring.

## Scope and next target

This proves simultaneous *entrywise* normalization for the
A>=3 determinant branch. It neither proves the matrix spectral
norm estimate nor the adjugate and rank-one determinant upper
bounds, and does not yet handle the mixed A>=1, B>=3 branch
with different first-row constants. Theorem `MainStatement`
is still unproved. The next useful lemma bounds the operator norm
of the symmetric perturbation matrix (E) from its six
entrywise errors, starting with |E_ij|<128/8649.

## Verification

Exact build, source, axiom, replay receipts are recorded in the
dated run and `records/build-record.md`. Draft failures must not
be interpreted as the final acceptance status. The proof uses
no computational search, native decision or custom axioms.
