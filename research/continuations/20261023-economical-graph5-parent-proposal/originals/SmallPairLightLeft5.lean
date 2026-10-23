import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation5
import D1Bound5.SmallPairLightAdaptiveLeft5_000
import D1Bound5.SmallPairLightAdaptiveLeft5_001
import D1Bound5.SmallPairLightAdaptiveLeft5_002

namespace D1Bound5.PairLightPrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared5.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared5.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared5.leftCached003 PairLightAdaptivePrepared5.leftRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared5.leftCached002 PairLightAdaptivePrepared5.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 162
      PairLightAdaptivePrepared5.leftCached002 PairLightAdaptivePrepared5.leftRows002
      PairLightAdaptivePrepared5.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared5.leftCached001 PairLightAdaptivePrepared5.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 164
      PairLightAdaptivePrepared5.leftCached001 PairLightAdaptivePrepared5.leftRows001
      PairLightAdaptivePrepared5.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared5.leftCached000 PairLightAdaptivePrepared5.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 105
      PairLightAdaptivePrepared5.leftCached000 PairLightAdaptivePrepared5.leftRows000
      PairLightAdaptivePrepared5.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared5
