# Exact Pell prefix and compatibility certificates

## Scope

This unit verifies three existing, unchanged modules: PellLightMatchingPilot, PellLightPrefixData4 and PellLightPrefixData5. There are 35 public theorems and 35 data definitions. This is a finite-certificate proof unit, not a proof of MainStatement and not an integration into the accepted root.

## Compatibility at d = 4519

The matching pilot contains four explicit positive magnitudes from the previously verified PellLightPrefixPilot list. Its three theorems establish validity of the square masks, success of the complete triangular pair checker, and a lower bound of two for every magnitude. The masks use moduli 9, 11 and 13. Validity checks every residue, so a mask rejection is a necessary-square obstruction, not a heuristic residue sample.

For each index pair i < j the checker supplies a mask rejecting x_i*x_j+1 as an ordinary integer square and another rejecting x_i*x_j-1 as 4519 times an integer square. These are exactly the same-sign and opposite-sign obstructions for distinct positive magnitudes. The witness rows have lengths 3, 2, 1, 0, covering all six index pairs. The checker rejects mismatched row/list lengths; no edges can be skipped by supplying a shorter witness list. It does not test a magnitude against its own negative, which is not needed by the generic matching/no-three argument.

The existing PellLightMatchingBridge translates these checks to the original PellMatchingCertificate. That bridge and the final full-ring assembly are not newly compiled or newly counted in this unit. The new accepted finite equalities should be used through those already defined soundness interfaces. No whole-field sextuple exclusion is claimed from the matching Boolean alone.

## Thirty-two new prefix certificates

Data4 and Data5 certify 32 field parameters from 463 through 759 (the exact parameters and step counts are in PREFIX_SOURCE_REVIEW.json). Each theorem proves pellLightFiniteCheck d a0 (10^275) N magnitudes = true. This checks the exact continued-fraction recurrence inequalities and transition divisibility, the stopping numerator exceeding 10^275, and exact equality of the filtered norm-two solution list with the supplied magnitude list. These include empty lists as well as nonempty lists. The three obligations remain conjoined and their full definitions are preserved in dependencies/PellLightCF.lean.

The already existing completeness bridge is required to conclude completeness for all relevant Pell solutions; this unit does not replace that argument by a finite experiment. It does not enumerate a disk of radius 10^550 directly. The later graph tests and aggregation across all 1016 admissible parameters remain necessary.

## Trust and verification

All mathematical proof bodies are unchanged and use decide +kernel, not native_decide. Three pinned guarded builds and three installed SAME-kernel targeted replays passed with unchanged source/dependency/artifact fingerprints. Exact elaborated types and transitive axioms were inspected for all 70 public declarations. The two mask/matching proofs use propext only. The other 33 theorems and all 35 data definitions use no axioms. No unexpected axioms occur. A preliminary overly strict empty-axiom audit and an audit-script missing import are retained with their actual failures; neither required changing a mathematical source.

There is no independent review, whole-root fresh replay, clean-checkout validation, root integration or final MainStatement proof in this unit. Prepared and unverified aggregate modules remain unverified.
