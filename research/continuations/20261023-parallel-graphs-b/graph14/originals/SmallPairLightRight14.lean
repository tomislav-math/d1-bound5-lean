import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation14
import D1Bound5.SmallPairLightAdaptiveRight14_000
import D1Bound5.SmallPairLightAdaptiveRight14_001
import D1Bound5.SmallPairLightAdaptiveRight14_002
import D1Bound5.SmallPairLightAdaptiveRight14_003

namespace D1Bound5.PairLightPrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared14.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared14.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 0 2 sieve rightCached rightRows = true := by
  have h004 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.rightCached004 PairLightAdaptivePrepared14.rightRows004 = true := by
    rfl
  have h003 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.rightCached003 PairLightAdaptivePrepared14.rightRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 79
      PairLightAdaptivePrepared14.rightCached003 PairLightAdaptivePrepared14.rightRows003
      PairLightAdaptivePrepared14.right_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.rightCached002 PairLightAdaptivePrepared14.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 215
      PairLightAdaptivePrepared14.rightCached002 PairLightAdaptivePrepared14.rightRows002
      PairLightAdaptivePrepared14.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.rightCached001 PairLightAdaptivePrepared14.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 114
      PairLightAdaptivePrepared14.rightCached001 PairLightAdaptivePrepared14.rightRows001
      PairLightAdaptivePrepared14.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.rightCached000 PairLightAdaptivePrepared14.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 88
      PairLightAdaptivePrepared14.rightCached000 PairLightAdaptivePrepared14.rightRows000
      PairLightAdaptivePrepared14.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared14
