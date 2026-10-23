import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation6
import D1Bound5.SmallPairLightAdaptiveLeft6_000
import D1Bound5.SmallPairLightAdaptiveLeft6_001
import D1Bound5.SmallPairLightAdaptiveLeft6_002
import D1Bound5.SmallPairLightAdaptiveLeft6_003
import D1Bound5.SmallPairLightAdaptiveLeft6_004
import D1Bound5.SmallPairLightAdaptiveLeft6_005

namespace D1Bound5.PairLightPrepared6
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared6.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared6.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h006 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached006 PairLightAdaptivePrepared6.leftRows006 = true := by
    rfl
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached005 PairLightAdaptivePrepared6.leftRows005 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 189
      PairLightAdaptivePrepared6.leftCached005 PairLightAdaptivePrepared6.leftRows005
      PairLightAdaptivePrepared6.left_prefix_005_checked h006
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached004 PairLightAdaptivePrepared6.leftRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 151
      PairLightAdaptivePrepared6.leftCached004 PairLightAdaptivePrepared6.leftRows004
      PairLightAdaptivePrepared6.left_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached003 PairLightAdaptivePrepared6.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 102
      PairLightAdaptivePrepared6.leftCached003 PairLightAdaptivePrepared6.leftRows003
      PairLightAdaptivePrepared6.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached002 PairLightAdaptivePrepared6.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 82
      PairLightAdaptivePrepared6.leftCached002 PairLightAdaptivePrepared6.leftRows002
      PairLightAdaptivePrepared6.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached001 PairLightAdaptivePrepared6.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared6.leftCached001 PairLightAdaptivePrepared6.leftRows001
      PairLightAdaptivePrepared6.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared6.leftCached000 PairLightAdaptivePrepared6.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 63
      PairLightAdaptivePrepared6.leftCached000 PairLightAdaptivePrepared6.leftRows000
      PairLightAdaptivePrepared6.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared6
