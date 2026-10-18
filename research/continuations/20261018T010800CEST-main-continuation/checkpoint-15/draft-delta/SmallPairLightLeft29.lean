import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation29
import D1Bound5.SmallPairLightAdaptiveLeft29_000
import D1Bound5.SmallPairLightAdaptiveLeft29_001

namespace D1Bound5.PairLightPrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared29.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared29.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true := by
  have h002 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared29.leftCached002 PairLightAdaptivePrepared29.leftRows002 = true := by
    rfl
  have h001 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared29.leftCached001 PairLightAdaptivePrepared29.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 254
      PairLightAdaptivePrepared29.leftCached001 PairLightAdaptivePrepared29.leftRows001
      PairLightAdaptivePrepared29.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared29.leftCached000 PairLightAdaptivePrepared29.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 126
      PairLightAdaptivePrepared29.leftCached000 PairLightAdaptivePrepared29.leftRows000
      PairLightAdaptivePrepared29.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared29
