import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation42
import D1Bound5.SmallPairLightAdaptiveRight42_000

namespace D1Bound5.PairLightPrepared42
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared42.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared42.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 3 sieve rightCached rightRows = true := by
  have h001 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared42.rightCached001 PairLightAdaptivePrepared42.rightRows001 = true := by
    rfl
  have h000 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared42.rightCached000 PairLightAdaptivePrepared42.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 3 sieve 242
      PairLightAdaptivePrepared42.rightCached000 PairLightAdaptivePrepared42.rightRows000
      PairLightAdaptivePrepared42.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 3 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared42
