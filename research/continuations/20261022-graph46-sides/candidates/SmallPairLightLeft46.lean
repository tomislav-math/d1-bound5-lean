import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation46
import D1Bound5.SmallPairLightAdaptiveLeft46_000
import D1Bound5.SmallPairLightAdaptiveLeft46_001

namespace D1Bound5.PairLightPrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared46.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared46.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 6 sieve leftCached leftRows = true := by
  have h002 : pairLightSelectedFloorIndependentBool 1 6 sieve
      PairLightAdaptivePrepared46.leftCached002 PairLightAdaptivePrepared46.leftRows002 = true := by
    rfl
  have h001 : pairLightSelectedFloorIndependentBool 1 6 sieve
      PairLightAdaptivePrepared46.leftCached001 PairLightAdaptivePrepared46.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 6 sieve 223
      PairLightAdaptivePrepared46.leftCached001 PairLightAdaptivePrepared46.leftRows001
      PairLightAdaptivePrepared46.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 6 sieve
      PairLightAdaptivePrepared46.leftCached000 PairLightAdaptivePrepared46.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 6 sieve 137
      PairLightAdaptivePrepared46.leftCached000 PairLightAdaptivePrepared46.leftRows000
      PairLightAdaptivePrepared46.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 6 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared46
