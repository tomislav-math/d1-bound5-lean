import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation1
import D1Bound5.SmallPairLightAdaptiveLeft1_000
import D1Bound5.SmallPairLightAdaptiveLeft1_001

namespace D1Bound5.PairLightPrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared1.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared1.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared1.leftCached002 PairLightAdaptivePrepared1.leftRows002 = true := by
    rfl
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared1.leftCached001 PairLightAdaptivePrepared1.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 223
      PairLightAdaptivePrepared1.leftCached001 PairLightAdaptivePrepared1.leftRows001
      PairLightAdaptivePrepared1.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared1.leftCached000 PairLightAdaptivePrepared1.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 137
      PairLightAdaptivePrepared1.leftCached000 PairLightAdaptivePrepared1.leftRows000
      PairLightAdaptivePrepared1.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared1
