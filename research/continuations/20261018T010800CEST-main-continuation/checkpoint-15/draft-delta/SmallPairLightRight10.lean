import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation10
import D1Bound5.SmallPairLightAdaptiveRight10_000
import D1Bound5.SmallPairLightAdaptiveRight10_001
import D1Bound5.SmallPairLightAdaptiveRight10_002
import D1Bound5.SmallPairLightAdaptiveRight10_003
import D1Bound5.SmallPairLightAdaptiveRight10_004

namespace D1Bound5.PairLightPrepared10
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared10.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared10.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve rightCached rightRows = true := by
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.rightCached005 PairLightAdaptivePrepared10.rightRows005 = true := by
    rfl
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.rightCached004 PairLightAdaptivePrepared10.rightRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 191
      PairLightAdaptivePrepared10.rightCached004 PairLightAdaptivePrepared10.rightRows004
      PairLightAdaptivePrepared10.right_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.rightCached003 PairLightAdaptivePrepared10.rightRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 150
      PairLightAdaptivePrepared10.rightCached003 PairLightAdaptivePrepared10.rightRows003
      PairLightAdaptivePrepared10.right_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.rightCached002 PairLightAdaptivePrepared10.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 102
      PairLightAdaptivePrepared10.rightCached002 PairLightAdaptivePrepared10.rightRows002
      PairLightAdaptivePrepared10.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.rightCached001 PairLightAdaptivePrepared10.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 82
      PairLightAdaptivePrepared10.rightCached001 PairLightAdaptivePrepared10.rightRows001
      PairLightAdaptivePrepared10.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.rightCached000 PairLightAdaptivePrepared10.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared10.rightCached000 PairLightAdaptivePrepared10.rightRows000
      PairLightAdaptivePrepared10.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared10
