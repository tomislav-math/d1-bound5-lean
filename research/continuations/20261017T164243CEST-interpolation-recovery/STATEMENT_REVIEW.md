# Authoring statement and proof review

This is a review by the proof-development invocation, NOT an independent reviewer.

For a nonempty finite set S of indices, m=card(S), distinct field values a_i, and every natural k, the new root theorem lagrange_power_moment_eq_hsymm asserts

  sum_i a_i^(m-1+k) / product_{j != i}(a_i-a_j) = h_k(a_i : i in S).

The right side is the evaluation of mathlib MvPolynomial.hsymm on the finite subtype S. The auxiliary homogeneousMultisetSum is proved equal to that existing definition for arbitrary commutative semirings and every degree. There is no independent or assumed recurrence hidden in the theorem type.

Proof: prove the exact new-node denominator factorization and cancellation for arbitrary nodal data. Specialize to power moments. Transport the already checked Option-variable hsymm recurrence to insertion into an arbitrary finite set. The singleton case is a genuine one-monomial sum. Induct on the finite set, then on k. The base k=0 follows from Lagrange.coeff_eq_sum; positive degrees use the matching two recurrences. Distinctness is only used to cancel new-node differences. Zero node values are permitted in the ordinary-moment theorem.

For distinct NONZERO anchors, reciprocal_anchor_sum_eq_hsymm asserts at every k

  sum_i (a_i^-1)^(k+1) / product_{j != i}(a_i-a_j)
    = (-1)^(m-1) / product_i a_i * h_k(a_i^-1 : i in S).

This combines the checked reciprocal Vandermonde transfer with the new all-degree theorem. Natural subtraction is justified using m>0; no exponent truncation is hidden. With n=m+k this is exactly the n>=m branch of the three-case interpolation-weight identity immediately before eq:coherent-exact in frozen v4 lines 561-571. It is an algebraic identity, NOT a proof of analytic convergence, the infinite-series interchange, the remainder estimate eq:coherent-tail, Bennett's determinant, finite descent/coverage or MainStatement.

Original frozen v4 rechecked read-only at /Users/tp/Lean/D1Bound5Handoff/verification/revision_v4/D1_bound5-v4.tex, SHA256 776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3. The separate repository paper/Diophantine_tuples_bound_five_2026-10-15.tex is a different source and was not relabeled as frozen v4. Neither source was edited.

New mathematical theorem declarations: 9 (three node-adjunction/cancellation, five multiset/moment bridge, one all-degree reciprocal conclusion). Recovered from previously checked CURRENT continuations: 12 (six homogeneous Option statements and six reciprocal statements); these are not counted as new discoveries. The common multiset definition is also included in the 22-declaration transitive axiom audit. No historical snapshot or exploration module is an accepted import.
