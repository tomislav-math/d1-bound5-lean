import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation17
import D1Bound5.SmallPairLightAdaptiveRight17_000
import D1Bound5.SmallPairLightAdaptiveRight17_001

namespace D1Bound5.PairLightPrepared17
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared17.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared17.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 0 2 sieve rightCached rightRows = true := by
  have h002 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared17.rightCached002 PairLightAdaptivePrepared17.rightRows002 = true := by
    rfl
  have h001 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared17.rightCached001 PairLightAdaptivePrepared17.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 220
      PairLightAdaptivePrepared17.rightCached001 PairLightAdaptivePrepared17.rightRows001
      PairLightAdaptivePrepared17.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared17.rightCached000 PairLightAdaptivePrepared17.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 138
      PairLightAdaptivePrepared17.rightCached000 PairLightAdaptivePrepared17.rightRows000
      PairLightAdaptivePrepared17.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared17
