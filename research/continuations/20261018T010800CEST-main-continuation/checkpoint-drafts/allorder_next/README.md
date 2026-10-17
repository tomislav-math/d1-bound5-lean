# All-order algebraic residue cancellation

Status: new Lean drafts supplied for root-controlled compilation. No remote
sources, Git state, or compilers were changed by this worker.

## Modules

`BennettPartialFractions.lean` imports the accepted residue-coefficient module
and mathlib's actual arbitrary-multiplicity partial-fraction theorem. It proves
existence of an exact constant-coefficient cleared decomposition for a polynomial
of degree smaller than the monic denominator degree. It proves the quotient is
zero by monic polynomial division uniqueness, rather than assuming properness
of a supplied decomposition. Under the stronger degree gap, it obtains a
zero sum of simple-pole coefficients.

`BennettLocalResidues.lean` defines a concrete algebraic residue as

    coeff_(e_i) [ f(a_i+X) * product_(l != i)
      bennettPoleSeries(a_i-a_l, e_l+1) ].

The previously accepted pole series supplies exact negative-integer binomial
coefficients and really is the reciprocal local denominator factor. The new
module proves that this explicit coefficient is the simple-pole coefficient
of any exact decomposition. On the selected node the reciprocal cancels the
other factors. On every other node, divisibility by X^(e_i+1) forces the selected
coefficient to vanish.

Together these modules prove the explicit algebraic residue theorem

    sum_i residue_i(f) = 0

for injective field-valued nodes, positive multiplicities e_i+1, and
`f.degree < sum_i(e_i+1)-1`. No decomposition identity or residue cancellation
is a hypothesis of this final theorem.

The field is arbitrary in the first module and of characteristic zero in the
second because the accepted binomial-series construction requires CharZero.

## Connection to Bennett

For the coefficient of order r in the residual row indexed by q, take
f(W)=W^r and multiplicities k+delta(q,i). Their total is card(iota)*k+1, so the
degree condition is precisely r<card(iota)*k. This is the algebraic
residue-cancellation core of the planned proof.

Still required: identify coefficients of the actual Bennett polynomial-times-
binomial residual with these residue functionals, including the global factor
choose(k+nu,r), and match the matrix definition developed by the Bennett worker.
The all-order determinant constant and node-removal recurrence are separate.
These drafts do not assert the final Bennett theorem or sextuple exclusion.

## Compilation prerequisite

`Mathlib.Algebra.Polynomial.PartialFractions` is present in the pinned mathlib
sources but had no built olean at the earlier checkpoint. Root must build this
dependency before compiling the new modules. The exact theorem source was read,
including its reversed indexing: simple poles correspond to `Fin.last (e i)`.

## Further interface modules supplied

`BennettBinomialTransfer.lean` proves the exact one-term coefficient identity

    choose(k+nu,h) [x^r] x^h(1+a*x)^(k-h)(1+a*x)^nu
      = choose(k+nu,r) [z^h](a+z)^r

for h<=k and arbitrary field nu. The binomial factors are formal power series.
This is the coefficient identity needed by the actual residue-polynomial
assembly in the Bennett worker's residual-cancellation module.

`BennettDeterminantConstant.lean` uses that worker's actual P matrix monomial
identity and entrywise homogenization to prove the cleared matrix G has
constant determinant. Evaluation first uses N!=0, retaining the factor
N^(card(iota)*k), and then polynomial equality on an infinite field removes the
restriction. Consequently evaluations at arbitrary node-removal values are
legitimate. The value/nonvanishing of the constant remains the responsibility
of the node-removal induction.

All new source in this directory remains draft until the root's serial
compilation and acceptance logs establish otherwise. Independent mathematical
source audit approved the first three modules. No additional axioms or sorry
terms were introduced.
