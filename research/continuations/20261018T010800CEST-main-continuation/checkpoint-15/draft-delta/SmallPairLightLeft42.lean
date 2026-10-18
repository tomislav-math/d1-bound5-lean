import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation42
import D1Bound5.SmallPairLightAdaptiveLeft42_000

namespace D1Bound5.PairLightPrepared42
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared42.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared42.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 3 sieve leftCached leftRows = true := by
  have h001 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared42.leftCached001 PairLightAdaptivePrepared42.leftRows001 = true := by
    rfl
  have h000 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared42.leftCached000 PairLightAdaptivePrepared42.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 3 sieve 242
      PairLightAdaptivePrepared42.leftCached000 PairLightAdaptivePrepared42.leftRows000
      PairLightAdaptivePrepared42.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 3 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared42
