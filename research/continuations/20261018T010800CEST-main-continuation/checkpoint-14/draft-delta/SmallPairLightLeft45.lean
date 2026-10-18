import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation45
import D1Bound5.SmallPairLightAdaptiveLeft45_000
import D1Bound5.SmallPairLightAdaptiveLeft45_001
import D1Bound5.SmallPairLightAdaptiveLeft45_002

namespace D1Bound5.PairLightPrepared45
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared45.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared45.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 5 sieve leftCached leftRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 1 5 sieve
      PairLightAdaptivePrepared45.leftCached003 PairLightAdaptivePrepared45.leftRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 1 5 sieve
      PairLightAdaptivePrepared45.leftCached002 PairLightAdaptivePrepared45.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 5 sieve 101
      PairLightAdaptivePrepared45.leftCached002 PairLightAdaptivePrepared45.leftRows002
      PairLightAdaptivePrepared45.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 5 sieve
      PairLightAdaptivePrepared45.leftCached001 PairLightAdaptivePrepared45.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 5 sieve 61
      PairLightAdaptivePrepared45.leftCached001 PairLightAdaptivePrepared45.leftRows001
      PairLightAdaptivePrepared45.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 5 sieve
      PairLightAdaptivePrepared45.leftCached000 PairLightAdaptivePrepared45.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 5 sieve 43
      PairLightAdaptivePrepared45.leftCached000 PairLightAdaptivePrepared45.leftRows000
      PairLightAdaptivePrepared45.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 5 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared45
