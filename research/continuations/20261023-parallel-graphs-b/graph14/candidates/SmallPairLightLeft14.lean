import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation14
import D1Bound5.SmallPairLightAdaptiveLeft14_000
import D1Bound5.SmallPairLightAdaptiveLeft14_001
import D1Bound5.SmallPairLightAdaptiveLeft14_002
import D1Bound5.SmallPairLightAdaptiveLeft14_003

namespace D1Bound5.PairLightPrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared14.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared14.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 2 sieve leftCached leftRows = true := by
  have h004 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.leftCached004 PairLightAdaptivePrepared14.leftRows004 = true := by
    rfl
  have h003 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.leftCached003 PairLightAdaptivePrepared14.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 76
      PairLightAdaptivePrepared14.leftCached003 PairLightAdaptivePrepared14.leftRows003
      PairLightAdaptivePrepared14.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.leftCached002 PairLightAdaptivePrepared14.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 217
      PairLightAdaptivePrepared14.leftCached002 PairLightAdaptivePrepared14.leftRows002
      PairLightAdaptivePrepared14.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.leftCached001 PairLightAdaptivePrepared14.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 114
      PairLightAdaptivePrepared14.leftCached001 PairLightAdaptivePrepared14.leftRows001
      PairLightAdaptivePrepared14.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared14.leftCached000 PairLightAdaptivePrepared14.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 88
      PairLightAdaptivePrepared14.leftCached000 PairLightAdaptivePrepared14.leftRows000
      PairLightAdaptivePrepared14.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared14
