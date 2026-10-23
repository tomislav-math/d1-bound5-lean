import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation21
import D1Bound5.SmallPairLightAdaptiveRight21_000
import D1Bound5.SmallPairLightAdaptiveRight21_001
import D1Bound5.SmallPairLightAdaptiveRight21_002
import D1Bound5.SmallPairLightAdaptiveRight21_003

namespace D1Bound5.PairLightPrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared21.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared21.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := by
  have h004 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared21.rightCached004 PairLightAdaptivePrepared21.rightRows004 = true := by
    rfl
  have h003 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared21.rightCached003 PairLightAdaptivePrepared21.rightRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 189
      PairLightAdaptivePrepared21.rightCached003 PairLightAdaptivePrepared21.rightRows003
      PairLightAdaptivePrepared21.right_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared21.rightCached002 PairLightAdaptivePrepared21.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 151
      PairLightAdaptivePrepared21.rightCached002 PairLightAdaptivePrepared21.rightRows002
      PairLightAdaptivePrepared21.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared21.rightCached001 PairLightAdaptivePrepared21.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 102
      PairLightAdaptivePrepared21.rightCached001 PairLightAdaptivePrepared21.rightRows001
      PairLightAdaptivePrepared21.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared21.rightCached000 PairLightAdaptivePrepared21.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 82
      PairLightAdaptivePrepared21.rightCached000 PairLightAdaptivePrepared21.rightRows000
      PairLightAdaptivePrepared21.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared21
