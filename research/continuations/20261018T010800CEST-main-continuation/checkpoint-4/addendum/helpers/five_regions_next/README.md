# Five unbounded first-pair regions

Status: complete source draft, frozen for the coordinator's serial Lean compiler. No new module in this folder is claimed compiler-accepted. The original accepted root/manifests remain under the coordinator's control.

The source endpoint `IsD1Tuple.five_region_impossible` assumes only an actual ordered six-tuple in the full imaginary quadratic integer ring, the first squared modulus at most eight, and one of the five explicit first-pair regions. It constructs all coefficient heights, max-distance residual bounds, actual full-ring forbidden intervals, retained and coupled-phase gaps, overlap comparisons, and the ordinary infinite tail internally.

`IsD1Tuple.one_small_first_pair_reduction` uses the proved algebraic-norm identity to reduce the one-small case to norm one with second modulus below eight, or norm two with second modulus below four. `IsD1Tuple.one_small_first_pair_size` exposes the squared-modulus form used by the finite classification. `IsD1Tuple.not_one_small` joins this reduction with `OneSmallReducedImpossible`, assuming only first modulus below three and second modulus at least three.

## Internal dependency order

1. `FiniteHomogeneousRatio`: retain the first-anchor modulus ratio in each actual homogeneous integer coefficient polynomial.
2. `FiniteN2RatioHeight`, `FiniteN3RatioHeight`, `FiniteA3RatioHeight`, `FiniteA4RatioHeight`, `FiniteA5RatioHeight`: all 25 printed height bounds, proved from existing exact coefficient vectors.
3. `FiveRegionParameters`: exact region constants, retained coefficients, phase rows, gap comparisons, and adaptive P rate comparisons.
4. `FiveRegionResidualRates`: actual max-distance bounds, including close anchors; no lower separation assumption.
5. `FiveRegionOverlapBounds`: all sixteen exact comparisons used by `CommonIntervalOverlaps`, lifted from the rational corner A²=n, B=S=m.
6. `FiveRegionRetainedScalar`, `FiveRegionTupleGap`: actual H48 retained gap and coupled complex phase bound.
7. `FiveRegionN2Interval`, `FiveRegionN3Interval`, `FiveRegionA3Interval`, `FiveRegionA4Interval`, `FiveRegionA5Interval`, `FiveRegionPInterval`: actual full-ring region windows.
8. `FiveRegionImpossible`, `OneSmallFirstPairReduction`, `OneSmallImpossible`: complete branch joins.

External substantive dependencies include the actual N2/N3 and A-family matrices, Bennett's adaptive P family, the ordinary M and Q families, `FiniteN2ExactInterval`, the A3/A4/A5 max-distance refinements, the actual small-norm retained start, the coupled-phase theorem, and the complete finite first-pair remainder. All are explicit imports; none is replaced by an assumed target theorem.

## Verification and provenance

`verify_tables.py` uses exact Python fractions to check both printed gap comparisons, each adaptive P rate, and all sixteen overlap corner inequalities in all five rows. The minimum exact quotients are approximately 1.2606619065, 2.3296816110, 1.1660489527, 5.4591888479, and 1.3218181741; all strictly exceed one. These auxiliary computations do not replace the Lean proofs, which use exact `norm_num` certificates.

The source-audit agent independently read the retained scalar, tuple gap, all overlap comparisons, and final branch joins, and reported mathematical PASS. The article-audit agent independently parsed the actual Lean coefficient vectors and actual matrix polynomials: all 30 polynomial identities and all 75 row-wise exact rational bounds passed. Its record is `audit_next/five_region_ratio_review.json`. Compiler and full transitive axiom acceptance are pending.

The scripts regenerate coefficient-height and interval source from actual existing coefficient tables and the explicit region constants. `SOURCE_SHA256.txt` records the frozen Lean source hashes. All modifications to frozen source will be reported to the coordinator before recompilation.
