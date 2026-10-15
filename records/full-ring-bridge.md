# Full integer-ring bridge

Continuation begun 2026-10-15 at 17:17:21 UTC, using the existing project.
The previous accepted source was 49dda62363d663bce06709c9a4b99185901cc158.
No manuscript or handoff source is modified by these proofs.

## Mathematical construction

Start with an arbitrary integral basis B of the full ring of integers of
any degree-two number field. Write 1 = a B(0) + b B(1). If d=gcd(a,b),
then 1=d z for an algebraic integer z. Taking the integral algebraic norm
gives 1=d^2 N(z), hence d=1. Choose integers u,v with au+bv=1 and set
w=-v B(0)+u B(1). The inverse coordinate formulas are
n=u x+v y and m=-b x+a y. These prove that every algebraic integer has a
unique expression n+m w, not merely that these expressions form an order.
Express w^2 in this basis and use QuadraticAlgebra.lift to construct the
ring equivalence. Translating w by floor(tau/2) gives tau=0 or tau=1.

For a totally complex number field, a generator w of the full integer
ring has nonreal image under every complex embedding. Otherwise all
integer-ring elements have real images, and expressing any field element
as a quotient of algebraic integers would make the embedding real.
From w^2-tau w+nu=0 one gets 2 Re(w)=tau, |w|^2=nu and
Delta=4nu-tau^2=4 Im(w)^2>0. Expanding x+y w proves
|x+y w|^2=x^2+tau x y+nu y^2. The coordinate norm is also identified with
mathlib's determinant-defined Algebra.norm over Z; equivalence invariance
then identifies the absolute algebraic norm on the full integer ring.

Maximality is used without unique factorization. If z^2=a^2 m and a is a
nonzero integer, z/a in the field is integral because its square is an
integer. Hence z/a belongs to the full ring. In a tau=0 model, applying
this to w shows that every square divisor of nu is a unit. In a tau=1
model apply it to 2w-1: the square divisor a must divide 2. The relation
Delta=4nu-1 then forces a to divide 1. Thus Delta is squarefree.
Finally, if tau=0 and nu=3 modulo 4, (1+w)/2 satisfies an integral monic
quadratic. Its existence in the full ring would give 2 y=1 in the second
integer coordinate, a contradiction.

Consequently EVERY imaginary quadratic number field has a full-ring
isomorphism from one of the following two types of model:
- QuadInt 0 d, with d>0 squarefree and d not 3 modulo 4;
- QuadInt 1 ((d+1)/4), with d>0 squarefree and d=3 modulo 4.
The theorem proves existence of an appropriate model; no uniqueness of d
or of the chosen isomorphism is claimed by its Lean type.

## Application already included

The previously compiled coordinate proof of rationality for common
extensions of {1,3} now transfers to the actual full integer ring of
every imaginary quadratic field. This has no bound on the extension,
no hypothesis that a square root is nonzero, and no coordinate-model
assumption in the final statement. The separate signed-cardinality part
of the paper's lemma is not proved here.

## Declarations

FullRingBasis: integral_basis_one_gcd; exists_integral_generator;
exists_quadratic_ring_equiv; exists_normalized_quadratic_ring_equiv.
CoordinateChange: QuadInt.shift; QuadInt.discriminant_shift.
ComplexCoordinates: QuadInt.complex_image; complex_generator_parameters;
discriminant_pos_of_complex_embedding; norm_sq_complex_image;
complex_im_zero_iff (all with prefix QuadInt).
FullRingBridge: full_ring_generator_nonreal;
exists_imaginary_quadratic_ring_equiv; norm_sq_full_ring_equiv;
one_le_norm_integer; full_ring_one_three_common_extension_is_integer.
MaximalCoordinates: integral_of_quadratic_relation;
square_division_in_full_ring; squarefree_trace_zero_parameter;
squarefree_trace_one_discriminant; trace_zero_parameter_not_three_mod_four.
FullRingClassification: exists_full_integer_coordinates.
NormCompatibility: QuadInt.algebra_norm_eq; algebra_norm_ring_equiv;
norm_sq_eq_absolute_norm.

## Verification scope

The separate Lean sources were actually compiled with the pinned Lean
4.33.1 and mathlib 0df444a360eaa60ab8c11dca51a86af692955474. Integrated
build and final audit receipts belong in the continuation build record.
This note is a same-assistant mathematical back-translation, not an
independent external review. These bridge results do not prove the bound
five or discharge analytic estimates, Bennett's identity or graph coverage.
