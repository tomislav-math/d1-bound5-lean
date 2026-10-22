import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation43
import D1Bound5.SmallPairLightAdaptiveLeft43_000
import D1Bound5.SmallPairLightAdaptiveLeft43_001
import D1Bound5.SmallPairLightAdaptiveLeft43_002

namespace D1Bound5.PairLightPrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared43.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared43.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 3 sieve leftCached leftRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared43.leftCached003 PairLightAdaptivePrepared43.leftRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared43.leftCached002 PairLightAdaptivePrepared43.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 3 sieve 270
      PairLightAdaptivePrepared43.leftCached002 PairLightAdaptivePrepared43.leftRows002
      PairLightAdaptivePrepared43.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared43.leftCached001 PairLightAdaptivePrepared43.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 3 sieve 121
      PairLightAdaptivePrepared43.leftCached001 PairLightAdaptivePrepared43.leftRows001
      PairLightAdaptivePrepared43.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 1 3 sieve
      PairLightAdaptivePrepared43.leftCached000 PairLightAdaptivePrepared43.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 1 3 sieve 91
      PairLightAdaptivePrepared43.leftCached000 PairLightAdaptivePrepared43.leftRows000
      PairLightAdaptivePrepared43.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 3 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared43
