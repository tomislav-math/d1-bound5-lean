# Next determinant dependency: a two-by-two reduction

Status: mathematical implementation note, NOT a Lean proof or an accepted
project declaration. The current accepted-source candidate remains the
79-theorem analytic-tail branch. This note does not prove the main bound.

The even-dimensional nonsingularity argument before lem:product-four can
avoid explicitly inverting I+J. Work first over a commutative ring S, with
n indices and entries a_i. Let U be the n-by-2 matrix with row (1,a_i), and
let V be its transpose. Put sigma=sum_i a_i and q=sum_i a_i^2. Then

    UV = J + a a^T,
    VU = [[n, sigma], [sigma, q]].

The rectangular determinant identity gives the polynomial identity

    det(I + J + a a^T) = (1+n)(1+q) - sigma^2.

It is valid over arbitrary commutative rings, including rings with zero
divisors. In characteristic two, q=sigma^2. If n is even, its scalar image
is zero, so the determinant is exactly one. This reduces the all-orders
matrix identity to a two-by-two calculation.

For the original integral matrix M, entrywise squaring modulo 2 gives
I+J+a a^T (diagonal a_i^2 and off-diagonal a_i*a_j+1). Squaring is the
Frobenius ring homomorphism in characteristic two and commutes with the
determinant. Hence det(M)^2 maps to one modulo 2.

The quotient by (2) must be shown nontrivial, not assumed. In the full
imaginary quadratic integer ring, 2*x=1 is impossible: x is nonzero and
has complex modulus at least one, whereas 2*|x|=1. Thus 2 is not a unit,
(2) is a proper ideal, and the determinant cannot have been zero.
The same norm lower bound then supplies |det(M)|>=1. The matrix need not
be assumed symmetric for this nonvanishing calculation alone; all that
is used is its entrywise square data.

## Pinned library APIs actually inspected

At mathlib 0df444a360eaa60ab8c11dca51a86af692955474:

- Mathlib/LinearAlgebra/Matrix/SchurComplement.lean, lines 399-407:
  Matrix.det_one_add_mul_comm A B proves det(1+A*B)=det(1+B*A).
  The library calls this the Weinstein-Aronszajn identity.
- Mathlib/LinearAlgebra/Matrix/Determinant/Basic.lean, line 318:
  RingHom.map_det is available.

Required implementation checks: the exact finite-index and commutative-ring
instances for the rectangular identity, the two-by-two matrix expansion,
Frobenius commuting with finite sums, the characteristic-two quotient
instance, properness of the ideal (2), and transport of the entrywise square
equations. These are remaining proof obligations, not implicit axioms.
No source or manuscript has been changed by this note.
