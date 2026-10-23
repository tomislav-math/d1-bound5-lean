import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation36
import D1Bound5.SmallPairLightAdaptiveLeft36_000
import D1Bound5.SmallPairLightAdaptiveLeft36_001
import D1Bound5.SmallPairLightAdaptiveLeft36_002
import D1Bound5.SmallPairLightAdaptiveLeft36_003

namespace D1Bound5.PairLightPrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared36.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared36.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 2 sieve leftCached leftRows = true := by
  have h004 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared36.leftCached004 PairLightAdaptivePrepared36.leftRows004 = true := by
    rfl
  have h003 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared36.leftCached003 PairLightAdaptivePrepared36.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 275
      PairLightAdaptivePrepared36.leftCached003 PairLightAdaptivePrepared36.leftRows003
      PairLightAdaptivePrepared36.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared36.leftCached002 PairLightAdaptivePrepared36.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 119
      PairLightAdaptivePrepared36.leftCached002 PairLightAdaptivePrepared36.leftRows002
      PairLightAdaptivePrepared36.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared36.leftCached001 PairLightAdaptivePrepared36.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 91
      PairLightAdaptivePrepared36.leftCached001 PairLightAdaptivePrepared36.leftRows001
      PairLightAdaptivePrepared36.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 2 sieve
      PairLightAdaptivePrepared36.leftCached000 PairLightAdaptivePrepared36.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 2 sieve 76
      PairLightAdaptivePrepared36.leftCached000 PairLightAdaptivePrepared36.leftRows000
      PairLightAdaptivePrepared36.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared36
