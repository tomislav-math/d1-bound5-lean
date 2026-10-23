import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation18
import D1Bound5.SmallPairLightAdaptiveRight18_000

namespace D1Bound5.PairLightPrepared18
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared18.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared18.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := by
  have h001 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared18.rightCached001 PairLightAdaptivePrepared18.rightRows001 = true := by
    rfl
  have h000 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared18.rightCached000 PairLightAdaptivePrepared18.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 262
      PairLightAdaptivePrepared18.rightCached000 PairLightAdaptivePrepared18.rightRows000
      PairLightAdaptivePrepared18.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared18
