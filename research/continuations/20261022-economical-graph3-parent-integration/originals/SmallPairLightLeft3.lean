import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation3
import D1Bound5.SmallPairLightAdaptiveLeft3_000
import D1Bound5.SmallPairLightAdaptiveLeft3_001
import D1Bound5.SmallPairLightAdaptiveLeft3_002

namespace D1Bound5.PairLightPrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared3.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared3.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.leftCached003 PairLightAdaptivePrepared3.leftRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.leftCached002 PairLightAdaptivePrepared3.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 102
      PairLightAdaptivePrepared3.leftCached002 PairLightAdaptivePrepared3.leftRows002
      PairLightAdaptivePrepared3.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.leftCached001 PairLightAdaptivePrepared3.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 199
      PairLightAdaptivePrepared3.leftCached001 PairLightAdaptivePrepared3.leftRows001
      PairLightAdaptivePrepared3.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.leftCached000 PairLightAdaptivePrepared3.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 112
      PairLightAdaptivePrepared3.leftCached000 PairLightAdaptivePrepared3.leftRows000
      PairLightAdaptivePrepared3.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared3
