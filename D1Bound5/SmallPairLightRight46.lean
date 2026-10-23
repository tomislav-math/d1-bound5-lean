import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation46
import D1Bound5.SmallPairLightAdaptiveRight46_000
import D1Bound5.SmallPairLightAdaptiveRight46_001

namespace D1Bound5.PairLightPrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared46.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared46.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 6 sieve rightCached rightRows = true := by
  have h002 : pairLightSelectedFloorIndependentBool 1 6 sieve
      PairLightAdaptivePrepared46.rightCached002 PairLightAdaptivePrepared46.rightRows002 = true := by
    rfl
  have h001 : pairLightSelectedFloorIndependentBool 1 6 sieve
      PairLightAdaptivePrepared46.rightCached001 PairLightAdaptivePrepared46.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 6 sieve 220
      PairLightAdaptivePrepared46.rightCached001 PairLightAdaptivePrepared46.rightRows001
      PairLightAdaptivePrepared46.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 6 sieve
      PairLightAdaptivePrepared46.rightCached000 PairLightAdaptivePrepared46.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 6 sieve 138
      PairLightAdaptivePrepared46.rightCached000 PairLightAdaptivePrepared46.rightRows000
      PairLightAdaptivePrepared46.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 6 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared46
