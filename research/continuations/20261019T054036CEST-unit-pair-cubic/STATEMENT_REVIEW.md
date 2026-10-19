# Statement review against frozen v4

This is the executing assistant's statement review, not an independent review.

The full-ring cubic lemma quantifies over a number field K with finrank(Q,K)=2 and NumberField.IsTotallyComplex K, an arbitrary embedding phi:K -> C, and actual c,d in NumberField.RingOfIntegers K. The five square witnesses are in the full integer ring. It assumes |c|>=9, |c|<=|d| and d!=-c and concludes |c|^3/2<|d|. The proof supplies signed roots in the same ring and proves its second-order form nonzero. No integrality, nonzero-root or approximation estimate is smuggled into the specialized conclusion.

The cubic-iteration theorem uses an actual IsD1Tuple a indexed by Fin 6, the identities a 0=-1 and a 1=1, monotonicity of the six moduli and |a 2|>=9. The opposite-pair hypotheses needed for the individual cubic steps are discharged by the already proved symmetric-five obstruction. Its endpoint is |a 2|^27/8192<|a 5|.

The final theorem `D1Bound5.IsD1Tuple.unit_pair_first_extension_lt` retains exactly the field/embedding data, IsD1Tuple, the two initial identities and non-strict monotonicity. It proves |phi(a 2)|<10000. The large/small split is internal; there is no large-entry premise in its type. Its pair {-1,1} itself has zero square root and is not excluded. Other zero square witnesses, half-integral coordinates in O_K and modulus ties are not removed by the statement. Its proof uses the proved all-order Bennett inequality with A=B=1 and delta=2, the actual terminal root, and the proved logarithmic cutoff.

This proves the first-extension cutoff used in the manuscript proof of `sm:bs7-unit-pair`, not the full nonexistence lemma. The range below 10000 still needs the canonical field/axis reduction and exhaustive finite Pell checks. None is assumed in a claimed global theorem. Accepted-root import closure, clean-checkout build and final independent statement review remain separate gates.
