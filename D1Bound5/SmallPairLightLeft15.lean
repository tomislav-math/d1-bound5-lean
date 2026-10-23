import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation15
import D1Bound5.SmallPairLightAdaptiveLeft15_000
import D1Bound5.SmallPairLightAdaptiveLeft15_001
import D1Bound5.SmallPairLightAdaptiveLeft15_002

namespace D1Bound5.PairLightPrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared15.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared15.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 2 sieve leftCached leftRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared15.leftCached003 PairLightAdaptivePrepared15.leftRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared15.leftCached002 PairLightAdaptivePrepared15.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 267
      PairLightAdaptivePrepared15.leftCached002 PairLightAdaptivePrepared15.leftRows002
      PairLightAdaptivePrepared15.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared15.leftCached001 PairLightAdaptivePrepared15.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 122
      PairLightAdaptivePrepared15.leftCached001 PairLightAdaptivePrepared15.leftRows001
      PairLightAdaptivePrepared15.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 2 sieve
      PairLightAdaptivePrepared15.leftCached000 PairLightAdaptivePrepared15.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 2 sieve 92
      PairLightAdaptivePrepared15.leftCached000 PairLightAdaptivePrepared15.leftRows000
      PairLightAdaptivePrepared15.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared15
