import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation8
import D1Bound5.SmallPairLightAdaptiveRight8_000
import D1Bound5.SmallPairLightAdaptiveRight8_001
import D1Bound5.SmallPairLightAdaptiveRight8_002
import D1Bound5.SmallPairLightAdaptiveRight8_003
import D1Bound5.SmallPairLightAdaptiveRight8_004
import D1Bound5.SmallPairLightAdaptiveRight8_005
import D1Bound5.SmallPairLightAdaptiveRight8_006

namespace D1Bound5.PairLightPrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared8.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared8.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve rightCached rightRows = true := by
  have h007 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached007 PairLightAdaptivePrepared8.rightRows007 = true := by
    rfl
  have h006 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached006 PairLightAdaptivePrepared8.rightRows006 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 194
      PairLightAdaptivePrepared8.rightCached006 PairLightAdaptivePrepared8.rightRows006
      PairLightAdaptivePrepared8.right_prefix_006_checked h007
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached005 PairLightAdaptivePrepared8.rightRows005 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 149
      PairLightAdaptivePrepared8.rightCached005 PairLightAdaptivePrepared8.rightRows005
      PairLightAdaptivePrepared8.right_prefix_005_checked h006
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached004 PairLightAdaptivePrepared8.rightRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 101
      PairLightAdaptivePrepared8.rightCached004 PairLightAdaptivePrepared8.rightRows004
      PairLightAdaptivePrepared8.right_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached003 PairLightAdaptivePrepared8.rightRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 82
      PairLightAdaptivePrepared8.rightCached003 PairLightAdaptivePrepared8.rightRows003
      PairLightAdaptivePrepared8.right_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached002 PairLightAdaptivePrepared8.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared8.rightCached002 PairLightAdaptivePrepared8.rightRows002
      PairLightAdaptivePrepared8.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached001 PairLightAdaptivePrepared8.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 63
      PairLightAdaptivePrepared8.rightCached001 PairLightAdaptivePrepared8.rightRows001
      PairLightAdaptivePrepared8.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared8.rightCached000 PairLightAdaptivePrepared8.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 58
      PairLightAdaptivePrepared8.rightCached000 PairLightAdaptivePrepared8.rightRows000
      PairLightAdaptivePrepared8.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared8
