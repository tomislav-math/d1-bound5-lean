import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation8
import D1Bound5.SmallPairLightAdaptiveLeft8_000
import D1Bound5.SmallPairLightAdaptiveLeft8_001
import D1Bound5.SmallPairLightAdaptiveLeft8_002
import D1Bound5.SmallPairLightAdaptiveLeft8_003
import D1Bound5.SmallPairLightAdaptiveLeft8_004
import D1Bound5.SmallPairLightAdaptiveLeft8_005
import D1Bound5.SmallPairLightAdaptiveLeft8_006

namespace D1Bound5.PairLightPrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared8.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared8.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h007 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached007 PairLightAdaptivePrepared8.leftRows007 = true := by
    rfl
  have h006 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached006 PairLightAdaptivePrepared8.leftRows006 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 189
      PairLightAdaptivePrepared8.leftCached006 PairLightAdaptivePrepared8.leftRows006
      PairLightAdaptivePrepared8.left_prefix_006_checked h007
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached005 PairLightAdaptivePrepared8.leftRows005 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 151
      PairLightAdaptivePrepared8.leftCached005 PairLightAdaptivePrepared8.leftRows005
      PairLightAdaptivePrepared8.left_prefix_005_checked h006
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached004 PairLightAdaptivePrepared8.leftRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 102
      PairLightAdaptivePrepared8.leftCached004 PairLightAdaptivePrepared8.leftRows004
      PairLightAdaptivePrepared8.left_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached003 PairLightAdaptivePrepared8.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 82
      PairLightAdaptivePrepared8.leftCached003 PairLightAdaptivePrepared8.leftRows003
      PairLightAdaptivePrepared8.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached002 PairLightAdaptivePrepared8.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared8.leftCached002 PairLightAdaptivePrepared8.leftRows002
      PairLightAdaptivePrepared8.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached001 PairLightAdaptivePrepared8.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 63
      PairLightAdaptivePrepared8.leftCached001 PairLightAdaptivePrepared8.leftRows001
      PairLightAdaptivePrepared8.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.leftCached000 PairLightAdaptivePrepared8.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 58
      PairLightAdaptivePrepared8.leftCached000 PairLightAdaptivePrepared8.leftRows000
      PairLightAdaptivePrepared8.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared8
