import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation6
import D1Bound5.SmallPairLightAdaptiveRight6_000
import D1Bound5.SmallPairLightAdaptiveRight6_001
import D1Bound5.SmallPairLightAdaptiveRight6_002
import D1Bound5.SmallPairLightAdaptiveRight6_003
import D1Bound5.SmallPairLightAdaptiveRight6_004
import D1Bound5.SmallPairLightAdaptiveRight6_005

namespace D1Bound5.PairLightPrepared6
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared6.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared6.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve rightCached rightRows = true := by
  have h006 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached006 PairLightAdaptivePrepared6.rightRows006 = true := by
    rfl
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached005 PairLightAdaptivePrepared6.rightRows005 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 181
      PairLightAdaptivePrepared6.rightCached005 PairLightAdaptivePrepared6.rightRows005
      PairLightAdaptivePrepared6.right_prefix_005_checked h006
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached004 PairLightAdaptivePrepared6.rightRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 155
      PairLightAdaptivePrepared6.rightCached004 PairLightAdaptivePrepared6.rightRows004
      PairLightAdaptivePrepared6.right_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached003 PairLightAdaptivePrepared6.rightRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 103
      PairLightAdaptivePrepared6.rightCached003 PairLightAdaptivePrepared6.rightRows003
      PairLightAdaptivePrepared6.right_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached002 PairLightAdaptivePrepared6.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 83
      PairLightAdaptivePrepared6.rightCached002 PairLightAdaptivePrepared6.rightRows002
      PairLightAdaptivePrepared6.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached001 PairLightAdaptivePrepared6.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared6.rightCached001 PairLightAdaptivePrepared6.rightRows001
      PairLightAdaptivePrepared6.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.rightCached000 PairLightAdaptivePrepared6.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 64
      PairLightAdaptivePrepared6.rightCached000 PairLightAdaptivePrepared6.rightRows000
      PairLightAdaptivePrepared6.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared6
