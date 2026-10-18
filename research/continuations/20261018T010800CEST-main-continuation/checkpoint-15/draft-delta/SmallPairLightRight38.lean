import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation38
import D1Bound5.SmallPairLightAdaptiveRight38_000

namespace D1Bound5.PairLightPrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared38.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared38.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 2 sieve rightCached rightRows = true := by
  have h001 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared38.rightCached001 PairLightAdaptivePrepared38.rightRows001 = true := by
    rfl
  have h000 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared38.rightCached000 PairLightAdaptivePrepared38.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 281
      PairLightAdaptivePrepared38.rightCached000 PairLightAdaptivePrepared38.rightRows000
      PairLightAdaptivePrepared38.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared38
