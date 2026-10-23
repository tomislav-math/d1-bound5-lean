import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation24
import D1Bound5.SmallPairLightAdaptiveRight24_000
import D1Bound5.SmallPairLightAdaptiveRight24_001
import D1Bound5.SmallPairLightAdaptiveRight24_002

namespace D1Bound5.PairLightPrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared24.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared24.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared24.rightCached003 PairLightAdaptivePrepared24.rightRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared24.rightCached002 PairLightAdaptivePrepared24.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 198
      PairLightAdaptivePrepared24.rightCached002 PairLightAdaptivePrepared24.rightRows002
      PairLightAdaptivePrepared24.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared24.rightCached001 PairLightAdaptivePrepared24.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 147
      PairLightAdaptivePrepared24.rightCached001 PairLightAdaptivePrepared24.rightRows001
      PairLightAdaptivePrepared24.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 1 sieve
      PairLightAdaptivePrepared24.rightCached000 PairLightAdaptivePrepared24.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 1 sieve 101
      PairLightAdaptivePrepared24.rightCached000 PairLightAdaptivePrepared24.rightRows000
      PairLightAdaptivePrepared24.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared24
