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
