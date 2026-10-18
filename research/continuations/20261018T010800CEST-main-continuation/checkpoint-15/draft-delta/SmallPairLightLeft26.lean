import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation26
import D1Bound5.SmallPairLightAdaptiveLeft26_000
import D1Bound5.SmallPairLightAdaptiveLeft26_001
import D1Bound5.SmallPairLightAdaptiveLeft26_002
import D1Bound5.SmallPairLightAdaptiveLeft26_003
import D1Bound5.SmallPairLightAdaptiveLeft26_004
import D1Bound5.SmallPairLightAdaptiveLeft26_005
import D1Bound5.SmallPairLightAdaptiveLeft26_006
import D1Bound5.SmallPairLightAdaptiveLeft26_007

namespace D1Bound5.PairLightPrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared26.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared26.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true := by
  have h008 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached008 PairLightAdaptivePrepared26.leftRows008 = true := by
    rfl
  have h007 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached007 PairLightAdaptivePrepared26.leftRows007 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 145
      PairLightAdaptivePrepared26.leftCached007 PairLightAdaptivePrepared26.leftRows007
      PairLightAdaptivePrepared26.left_prefix_007_checked h008
  have h006 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached006 PairLightAdaptivePrepared26.leftRows006 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 173
      PairLightAdaptivePrepared26.leftCached006 PairLightAdaptivePrepared26.leftRows006
      PairLightAdaptivePrepared26.left_prefix_006_checked h007
  have h005 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached005 PairLightAdaptivePrepared26.leftRows005 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 107
      PairLightAdaptivePrepared26.leftCached005 PairLightAdaptivePrepared26.leftRows005
      PairLightAdaptivePrepared26.left_prefix_005_checked h006
  have h004 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached004 PairLightAdaptivePrepared26.leftRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 85
      PairLightAdaptivePrepared26.leftCached004 PairLightAdaptivePrepared26.leftRows004
      PairLightAdaptivePrepared26.left_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached003 PairLightAdaptivePrepared26.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 73
      PairLightAdaptivePrepared26.leftCached003 PairLightAdaptivePrepared26.leftRows003
      PairLightAdaptivePrepared26.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached002 PairLightAdaptivePrepared26.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 65
      PairLightAdaptivePrepared26.leftCached002 PairLightAdaptivePrepared26.leftRows002
      PairLightAdaptivePrepared26.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached001 PairLightAdaptivePrepared26.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 59
      PairLightAdaptivePrepared26.leftCached001 PairLightAdaptivePrepared26.leftRows001
      PairLightAdaptivePrepared26.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared26.leftCached000 PairLightAdaptivePrepared26.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 54
      PairLightAdaptivePrepared26.leftCached000 PairLightAdaptivePrepared26.leftRows000
      PairLightAdaptivePrepared26.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared26
