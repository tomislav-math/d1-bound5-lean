# Analytic continuation queue

All files in this directory are local drafts for the parent to transfer and
compile serially. No remote writes, compiler runs, or Git operations were made
by this subagent. No draft contains `sorry`, `admit`, or added axioms.

## Reported kernel acceptance

The parent has reported acceptance of `CoherentIntegralForms`,
`CoherentPolynomialWeights`, `CoherentQuotientForms`, `CoherentTwoVanishing`,
and `CoherentNearOne`. `CoherentTwoSize`, `CoherentFormBounds`, and
`CoherentThreeSimultaneous` have received the requested first-pass compiler
corrections and await their retry results.
All other files listed below remain drafts until the parent reports results.

## Dependency order and substantive endpoints

1. `CoherentIntegralForms`, `CoherentPolynomialWeights`,
   `CoherentQuotientForms`: actual coherent root integrality, polynomial
   quotient weights, and full-ring modulus lower bounds.
2. `CoherentTwoVanishing`, `CoherentTwoSize`: actual L2 nonvanishing from
   B≥3, P≥5B, Q≥5ABP, then actual full-ring modulus at least one.
3. `CoherentNearOne`, `CoherentFormBounds`: actual branch estimates and exact
   quotient-form normalization with an explicit remainder upper bound.
4. `CoherentTwoUpper`, `CoherentTwoGap`, `CoherentTwoMainGap`: actual L2
   upper bound and strong gap A²P³<(10001/10000)Q. The final main wrapper
   supplies the auxiliary square root and analytic parameter premises under
   A≥3 or P≥48.
5. `CoherentThreeGeneral`: actual general L3 bound
   5BS²/Z+3SZ/(AP³), with all analytic estimates discharged.
6. `CoherentThreeSimultaneous`, `CoherentThreeNonvanishing`: the common
   quadratic, exact coefficient identities, and actual non-simultaneous
   vanishing of L3 on 012 and 013 under P²≥32BST/A³. The draft's omitted
   -(p+q) cubic coefficient was found in independent audit and corrected
   before compilation; the lower coefficient equations were unaffected.
7. `CoherentThreeParameters`, `CoherentParameterForms`: exact two-sided
   f3/remainder bounds and actual parameter-form direct bound and zero-form
   window. The H32 and H48 numerical rows are separate exact rational
   comparisons, written as `norm_num` proofs.
8. `CoherentVandermondeFourNorm`, `CoherentFourParameters`,
   `CoherentDirectFour`: the 24-term Vandermonde bound, exact two-sided f4
   and remainder bounds, and the actual direct-four upper bound and
   zero-form window from the manuscript. This reuses the existing scalar
   parameter lemmas via V↦VP and F↦PF.
9. `CoherentRetainedIntegral`, `CoherentRetainedAnalyticData`,
   `CoherentRetainedGap`, `CoherentRetainedTuple`: actual H48 form
   nonvanishing/integrality, normalized Vandermonde and root bounds,
   precise retained gap, and the actual ordered-five endpoint
   `IsD1Tuple.all_large_retained_growth`. It assumes only the actual tuple,
   modulus order, and A≥3, and concludes C>400 A⁷B⁵S³. The precise scalar
   conversion and coefficient comparison are in the other agent's
   `RetainedGapScalar` and `AllLargeOverlapConstants`.
10. `CoherentRetainedBasicGap`, `CoherentRetainedFourSizes`,
    `CoherentRetainedStart`: coefficient>1 gives the fifth-power retained
    bound; repeating it on (a,b,s,c,d) and excluding the actual L4 zero
    window yields its integral lower bound. The endpoint
    `IsD1Tuple.all_large_retained_start` assumes only the actual ordered
    sextuple and A≥3 and concludes D>A²C⁷/(S²T⁴), together with the preceding
    power gaps and the required large terminal estimates. It uses the
    other agent's `RetainedFourScalar` for the final scalar conversion.

## Independent verification and limits

The mathematical statements/proofs through the actual retained coefficient
400 tuple endpoint have independent source-audit approval. The subsequent
retained-start unit is awaiting that audit. Exact rational comparisons were independently checked using
Python fractions; this is not Lean kernel acceptance. The 24 Vandermonde
signs were generated from the six actual factors and checked symbolically;
the Lean proof still expands them with `ring`.

The retained units are restricted to the no-small-entry branch A≥3; their
source-level proofs do not constitute kernel acceptance while the queue is
pending. These units do not yet prove the finite forbidden-interval coverage,
the approximation theorem, or the final cardinality bound. The parent coordinates those
dependencies and all remote compilation/integration.
