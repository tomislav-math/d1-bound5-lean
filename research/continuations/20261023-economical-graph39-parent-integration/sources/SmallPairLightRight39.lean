import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation39
import D1Bound5.SmallPairLightAdaptiveRight39_000
import D1Bound5.SmallPairLightAdaptiveRight39_001
import D1Bound5.SmallPairLightAdaptiveRight39_002

namespace D1Bound5.PairLightPrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared39.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared39.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 2 sieve rightCached rightRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.rightCached003 PairLightAdaptivePrepared39.rightRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.rightCached002 PairLightAdaptivePrepared39.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 220
      PairLightAdaptivePrepared39.rightCached002 PairLightAdaptivePrepared39.rightRows002
      PairLightAdaptivePrepared39.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.rightCached001 PairLightAdaptivePrepared39.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 138
      PairLightAdaptivePrepared39.rightCached001 PairLightAdaptivePrepared39.rightRows001
      PairLightAdaptivePrepared39.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.rightCached000 PairLightAdaptivePrepared39.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 98
      PairLightAdaptivePrepared39.rightCached000 PairLightAdaptivePrepared39.rightRows000
      PairLightAdaptivePrepared39.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared39
