# Independent source statement review

Reviewed on 20 October 2026 by the separate sync_audit agent. This is a read-only semantic review of the current source target and assembly. It is not compilation, kernel verification, or a claim that MainStatement has been proved.

## Result

No weakening of the frozen manuscript's main statement was found. MainStatement quantifies over every universe-u field K with Field K, NumberField K, IsTotallyComplex K and Module.finrank over the rationals equal to two. It applies to every finite subset of the full ring of integers and concludes cardinality at most five.

Basic.IsD1 requires every entry to be nonzero and every product of distinct entries plus one to be a square. Zero square roots are permitted. Specification.square_integers_iff_field proves equivalence with roots lying in the field. No certificate premise is present in the target.

Sextuple.exists_ordered_sextuple selects six distinct elements and sorts with non-strict Monotone. Equal moduli remain covered. MainCaseReduction gives an exact equivalence with the zero-small, one-small and at-least-two-small branches. MainTheorem then splits the latter case by the third modulus and by whether the first pair product plus one vanishes. These cases are exhaustive, including cutoff equality and degenerate roots.

All five endpoint theorem headers were inspected. Their premises are precisely field, actual tuple, ordering and relevant case assumptions. They do not supply approximation, finite enumeration, integral-row or nonzero-root certificates as extra hypotheses.

The pinned mathlib RingOfIntegers definition is the integral closure of the integers in K. FullRingBasis constructs a bijection from integer coordinate pairs onto this entire ring and then an actual ring equivalence. Normalization covers both trace zero and trace one. FullRingBridge derives positive discriminant and complex norm compatibility for every embedding. Half-integral bases are therefore included without a suborder assumption. The unit-pair arithmetic model explicitly treats both normalized basis cases.

## Sources inspected

Basic.lean, Specification.lean, Sextuple.lean, MainCaseReduction.lean, MainTheorem.lean, AllLargeImpossible.lean, OneSmallImpossible.lean, ThreeSmallExclusion.lean, TwoSmallNondegenerateImpossible.lean, DegeneratePairImpossible.lean, Coordinates.lean, FullRingBasis.lean, FullRingBridge.lean and UnitPairArithmeticModel.lean. Also inspected the pinned mathlib definitions of RingOfIntegers and IsTotallyComplex and the frozen v4 introduction, main theorem and final proof.

## Exact fingerprints observed

- Frozen manuscript D1_bound5-v4.tex: 776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3
- D1Bound5/MainTheorem.lean: 0d4652828c5f48475a6e80d8d00fa209e39c0638a58ebd99fd719e271c2670f6
- D1Bound5/Specification.lean: 60d7ff20e6ffc449c6452bceb3b22f98c1db628f9ed34831c674a58bbcf40b50
- D1Bound5/Basic.lean: 408272dc6fd995b836f6d3c6be839fa9c5248e49b1ec96b2135117042cb995cf
- D1Bound5/MainCaseReduction.lean: 94580cd4f5977bc9f503aba3da8004380cecfe272766c2d856a70706a14c5d2b
- D1Bound5/Sextuple.lean: 6c1f5ac664f7bb81799f2455c537b967b2cfb9335a5a58979be80cc275c0f766

## Required completion checks

After all dependencies compile, verify an independently written expanded statement, not only the MainStatement alias. Inspect transitive axioms and perform the project's fresh whole-closure kernel verification and clean-checkout gates. The source-level review above does not replace these checks and makes no assertion about pending proof bodies.
