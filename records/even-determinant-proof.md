# Even-dimensional root determinant

Status: all four theorems and the coefficient-reduction homomorphism have
compiled with exit 0. The integrated continuation audit is recorded separately.
This is a proof of the arithmetic nonsingularity assertion preceding
lem:product-four. It is NOT Bennett's arbitrary-order determinant identity.

## Ring identity

For an arbitrary commutative ring, set A(i,0)=1 and A(i,1)=v(i).
Then AA^t=J+vv^t. The rectangular determinant identity in pinned mathlib
reduces det(I+J+vv^t) to the determinant of a two-by-two matrix. Thus

  det(I+J+vv^t) = (1+n)(1+sum(v_i^2)) - (sum(v_i))^2.

No domain, inverse, positivity or symmetry assumption is used. The formula
also includes the empty index type.

## Characteristic two

Suppose the number n of indices is even, M_ii=v_i, and
M_ij^2=v_i*v_j+1 for every i!=j. Frobenius is a ring homomorphism, so it
commutes with determinants and finite sums. Entrywise squaring M gives
I+J+vv^t. In characteristic two, n=0 as a scalar and
sum(v_i^2)=(sum(v_i))^2. The identity therefore gives det(M)^2=1.
The coefficient ring is permitted to have zero divisors. No nonzero-root
hypothesis has been added.

## Integral number rings

For any quadratic number field K, the proved full integer-ring basis gives
an equivalence with QuadInt tau nu. Reducing the two integer coefficients
modulo two is an explicitly constructed ring homomorphism into
QuadraticAlgebra (ZMod 2) (-nu) tau. This target is nontrivial and its
characteristic two is proved directly. Consequently an integral M with
vanishing determinant would reduce to determinant zero, contradicting
its determinant square being one. This establishes nonsingularity for
all quadratic number fields, not just imaginary ones.

For an imaginary quadratic K, the earlier proved lower bound for the
complex modulus of a nonzero algebraic integer then implies
1<=|det(M)| at every complex embedding.

## Statement review

Declarations quantify over arbitrary finite index types of even size and
actual matrices in the full ring of integers. The original D(1) root data
are the hypotheses, not a hidden rank or determinant assumption. The
ring equivalence and characteristic-two map are constructed in the proof.
This self-review is not an independent referee or independent-kernel audit.
