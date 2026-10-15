# Target statement review

This is a self-review based on the elaborated Lean output. It is not an
independent external review and does not satisfy that final release gate.

## Back-translation of MainStatement

For every field K which is a number field over Q, has degree two over Q,
and is totally complex, and every finite subset A of its ring of integers,
if every member is nonzero and for every two unequal members x,y there is
an r in the same ring with r*r=x*y+1, then A has at most five members.

The chosen `NumberField.RingOfIntegers K` is mathlib's integral closure of Z
in K. The target is not restricted to an order Z[sqrt(-d)]. A `Finset`
contains no duplicate entries. Neither the definition nor the target
requires the square value or its root to be nonzero. There is no
positivity, norm-separation, finite field list, or supplied approximation
hypothesis in `MainStatement`. The number-field structures are universally
quantified. The degree and totally complex conditions specify the intended
imaginary quadratic fields.

## Proven conventions

`square_integers_iff_field` proves that taking a square root in K or in its
ring of integers is equivalent for integral square values. Its proof uses
integrality of r^2 to deduce integrality of r, including r=0.

`IsD1.exists_ordered_sextuple` proves the actual selection step for an
arbitrary linearly ordered weight. `Tuple.sort` permutes indices, so ties
in weights do not identify entries or discard cases. The image/cardinality
lemmas prove the converse passage from indexed tuples to finite sets.

`zero_square_pair` checks the valid pair {-1,1} over Z. The half-integral
regression checks omega^2=omega-1 in `QuadInt 1 1`.

## Not yet established

`MainStatement` is a definition of a proposition, with no term proving it.
A clean axiom list for that definition is not a proof of the proposition.
No theorem in this milestone establishes the cardinality bound.

The explicit coordinate ring `QuadInt tau nu` has correct quadratic
arithmetic, but its identification with the full ring of integers of
arbitrary imaginary quadratic fields remains a separate open obligation.
The half-integral regression test alone does not establish that bridge.

The generic interval-chain theorem has explicit exclusion and overlap
hypotheses. The six modular certificates exclude the six stated elements,
but do not prove that the preceding enumeration has no other cases.

## OneThree module

The coordinate theorem has no bound on the size of the common extension.
It quantifies over all integral tau,nu with 4nu-tau^2 positive, and concludes
that a coordinate element whose translates z+1 and 3z+1 are squares is an
integer cast. This includes tau=1 and nonmaximal orders. It does not assert
that an arbitrary number field has already been identified with that model.

In the contradiction argument, nonzero imaginary coordinate forces f and g
nonzero. The relation g^2*V=3*f^2*X and X+Delta*V=8 imply X,V positive,
including exclusion of the zero-factor cases. Only then does X*V=12*k^2
force the integral square k^2 to be at least one. The determinant k is
integral even in the half-integral basis because
`e*h-f*g = 2*(r.re*s.im-r.im*s.re)`. No parity convention is omitted.

The negative-extension cardinality part of lem:pr-one-three is not claimed
by this module. Independent external review and the global ring bridge
remain open release gates.


## Continuation: full-ring and growth statements

The elaborated `exists_full_integer_coordinates` quantifies over every
field K with NumberField K, IsTotallyComplex K and finrank Q K=2. Its
conclusion supplies a positive squarefree integer d and a ring equivalence
from QuadInt 1 ((d+1)/4) when d=3 modulo 4, or QuadInt 0 d otherwise,
to the FULL RingOfIntegers K. It does not assert uniqueness of d or choose
one complex embedding as a hidden extra condition.

`norm_sq_eq_absolute_norm` quantifies over every complex embedding and
every algebraic integer, including zero. Its right side is the cast of
mathlib's determinant-defined integral norm. `irregular_growth` quantifies
over full-ring elements a,b,c and their three integral square roots,
requires precisely irregularity and 3<=|a|<=|b|<=|c|, and concludes
2|a||b|<|c|. Weak inequalities preserve modulus ties. There is no graph,
Bennett, approximation, or unproved norm assumption in these types.

`full_ring_one_three_common_extension_is_integer` proves that any common
extension z of 1 and 3 in the full integer ring is the cast of an integer.
It does not prove the separate signed-cardinality argument, and it imposes
no size restriction or nonzero-square-root condition on z.

This is a same-assistant back-translation of actually elaborated Lean
types. No independent external statement audit is claimed. MainStatement
is still a definition of the bound-five proposition, not its proof.


## Direct recovery statement audit, 2026-10-15

The elaborated `IsD1Tuple.tail_irregular_and_growth` has exactly these
mathematical hypotheses: a quadratic totally complex number field, a
complex embedding, an actual D(1) quadruple in its full integer ring,
weakly ordered complex moduli, and second modulus at least three.
Its conclusion is irregularity of the last triple and D>2BC. No C>=4,
finite-check correctness, enumeration coverage, or extra ring-model
hypothesis remains. Zero roots and modulus ties are not excluded.

`even_root_matrix_det_ne_zero` quantifies over all quadratic number fields
and even finite index types. Its hypotheses are the diagonal entries and
off-diagonal square equations themselves. No domain assertion about the
characteristic-two reduction is assumed. Only its modulus corollary needs
the totally complex hypothesis. This is NOT Bennett's determinant formula.

An inherited auxiliary packaging limitation was also noticed:
`full_ring_negative_integer_square` concludes existence of a positive
squarefree d and m=-d*n^2, but its TYPE does not retain the equivalence that
identifies this d with the field parameter, despite the proof choosing it
that way. Do not use this declaration alone as a fixed-field or uniform-d
classification. The coordinate trace-zero/trace-one lemmas plus the proved
full-ring classification supply the proper data; a future uniform wrapper
should return those data explicitly. Neither of this continuation's two
main results depends on that weaker packaged negative-square statement.
This limitation is not a mathematical contradiction or an unproved axiom.

This was an in-chat self-audit of actual sources and elaborated types,
not an independent agent/referee review or an independent kernel check.
