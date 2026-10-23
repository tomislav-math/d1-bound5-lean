import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation39
import D1Bound5.SmallPairLightAdaptiveLeft39_000
import D1Bound5.SmallPairLightAdaptiveLeft39_001
import D1Bound5.SmallPairLightAdaptiveLeft39_002

namespace D1Bound5.PairLightPrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared39.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared39.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 2 sieve leftCached leftRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.leftCached003 PairLightAdaptivePrepared39.leftRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.leftCached002 PairLightAdaptivePrepared39.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 225
      PairLightAdaptivePrepared39.leftCached002 PairLightAdaptivePrepared39.leftRows002
      PairLightAdaptivePrepared39.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.leftCached001 PairLightAdaptivePrepared39.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 136
      PairLightAdaptivePrepared39.leftCached001 PairLightAdaptivePrepared39.leftRows001
      PairLightAdaptivePrepared39.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared39.leftCached000 PairLightAdaptivePrepared39.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 97
      PairLightAdaptivePrepared39.leftCached000 PairLightAdaptivePrepared39.leftRows000
      PairLightAdaptivePrepared39.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared39
