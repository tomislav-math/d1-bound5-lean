# Back-translation of the compiled bounded Pell endpoint

Scope: an authoring-assistant statement check against the actual elaborated type from the successful pinned audit. This is not an independent final review.

`D1Bound5.IsD1Tuple.unit_pair_fifth_large` is universe-polymorphic. Its inputs are a field K with NumberField and IsTotallyComplex instances, the dimension equality finrank Q K = 2, and a field embedding phi into C. Entries have type RingOfIntegers K, i.e. the full integer ring, with no chosen coordinate basis as an extra premise.

`t : Fin 6 -> O_K` satisfies IsD1Tuple. The definition read from Basic.lean requires injectivity, nonzero entries, and an integral square witness for every distinct pair. It does not require the witnesses to be nonzero. The additional inputs are t 0 = -1, t 1 = 1, and monotonicity of the six complex moduli. Monotonicity is non-strict and therefore permits tied moduli.

The conclusion is 10^550 < norm(phi(t 4)), the fifth of six ordered entries. There is no finite-field list, arbitrary enumeration-completeness assumption, supplied certificate, analytic inequality, chosen root sign, or nonzero-root hypothesis in this final endpoint type. Those prerequisites are constructed by its actual dependency closure.

This result is a necessary lower bound for a hypothetical sextuple, not a contradiction by itself. The upper-bound branches are still required for the unit-pair impossibility result. It does not assert the main cardinality-five theorem or a bound-four theorem.

The separate `full_ring_unit_pair_pell_no_three_bounded` theorem explicitly assumes a common arithmetic model, its numerical field range, real Pell descriptions of three extensions, and their squared-norm bounds. The sextuple endpoint derives the model and descriptions internally, then applies this bounded theorem to positions 2, 3 and 4. Those intermediate hypotheses have not been silently transferred into the sextuple conclusion.
