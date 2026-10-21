import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation35
import D1Bound5.SmallPairLightAdaptiveRight35_000
import D1Bound5.SmallPairLightAdaptiveRight35_001

namespace D1Bound5.PairLightPrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared35.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared35.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 2 sieve rightCached rightRows = true := by
  have h002 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared35.rightCached002 PairLightAdaptivePrepared35.rightRows002 = true := by
    rfl
  have h001 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared35.rightCached001 PairLightAdaptivePrepared35.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 236
      PairLightAdaptivePrepared35.rightCached001 PairLightAdaptivePrepared35.rightRows001
      PairLightAdaptivePrepared35.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared35.rightCached000 PairLightAdaptivePrepared35.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 132
      PairLightAdaptivePrepared35.rightCached000 PairLightAdaptivePrepared35.rightRows000
      PairLightAdaptivePrepared35.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared35
