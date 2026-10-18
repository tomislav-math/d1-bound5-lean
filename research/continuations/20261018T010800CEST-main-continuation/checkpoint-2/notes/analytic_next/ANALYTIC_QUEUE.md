# Analytic continuation queue

All files in this directory are local drafts for the parent to transfer and
compile serially. No remote writes, compiler runs, or Git operations were made
by this subagent. No draft contains `sorry`, `admit`, or added axioms.

## Reported kernel acceptance

The parent has reported acceptance of `CoherentIntegralForms`,
`CoherentPolynomialWeights`, `CoherentTwoVanishing`, and `CoherentNearOne`.
`CoherentQuotientForms` received the requested six explicit source-ring
Vandermonde coercion fixes; its corrected compilation is pending a report.
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

## Independent verification and limits

The mathematical statements/proofs through the three-anchor parameter unit
have independent source-audit approval. The four-anchor unit is awaiting
that audit. Its exact rational comparisons were independently checked using
Python fractions; this is not Lean kernel acceptance. The 24 Vandermonde
signs were generated from the six actual factors and checked symbolically;
the Lean proof still expands them with `ring`.

These units do not yet prove the retained-gap theorem as a full tuple
statement, the finite forbidden-interval coverage, the approximation
theorem, or the final cardinality bound. The parent coordinates those
dependencies and all remote compilation/integration.
