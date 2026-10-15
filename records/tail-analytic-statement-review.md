# Statement self-review for the analytic tail continuation

This is a self-review, NOT an independent referee report.
The main theorem about cardinality at most five remains unproved.

The intended terminal declaration is `tail_irregular_of_four_le`.
Back-translation: let K be any totally complex number field of degree two
and phi any embedding into C. Let a,b,c,d belong to the FULL ring of
integers. Suppose a is nonzero, ab+1, ac+1, ad+1 and bc+1 have square roots
in that same ring, |a|<=|b|, |b|>=3, |c|>=4 and |c|<=|d|. Then
b^2+c^2+d^2-2bc-2bd-2cd-4 is nonzero.

The main manuscript application has distinct a,b,c,d and the additional
ordering |b|<=|c|. These extra conditions are not needed by the analytic
proof and are not silently used. The two other square conditions for bd+1
and cd+1 are needed only when applying irregular_growth to conclude D>2BC.

The generic intermediate core carries the explicit hypothesis
`forall s, s != 0 -> 1 <= norm(f s)`. This is not assumed of arbitrary
imaginary quadratic rings: the full-ring wrapper discharges it by the
existing proved `one_le_norm_integer`, with the exact same field K and
embedding phi. Thus the wrapper has no unproved norm hypothesis.

All square-root witnesses remain in their original ring after sign changes.
Auxiliary alpha,beta,gamma are in C and square to the embedded entries.
Only their targets are divided out, with nonzero proofs from the modulus
bounds. No arithmetic square root is divided out. Zero is still an allowed
square in the project definition. No unit-rotation symmetry is used.

The regular completion has both signs. Factoring in the integral domain
O_K gives d=b+c+2r or d=b+c-2r. Replacing r by -r covers the second case.
Nonvanishing of an integral norm is used twice: first to obtain u+v=w
from norm<1, then to contradict 2(ar-uv)=1. This replaces no field case
by an unsupported divisibility assertion.

The C<4 case is intentionally absent here. Completing this declaration
alone must not be reported as completing the full tail-irregular lemma.
It can be joined to a separately proved finite small-tail branch.
