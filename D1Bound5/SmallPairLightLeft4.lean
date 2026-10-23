import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation4
import D1Bound5.SmallPairLightAdaptiveLeft4_000
import D1Bound5.SmallPairLightAdaptiveLeft4_001
import D1Bound5.SmallPairLightAdaptiveLeft4_002
import D1Bound5.SmallPairLightAdaptiveLeft4_003
import D1Bound5.SmallPairLightAdaptiveLeft4_004

namespace D1Bound5.PairLightPrepared4
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared4.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared4.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared4.leftCached005 PairLightAdaptivePrepared4.leftRows005 = true := by
    rfl
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared4.leftCached004 PairLightAdaptivePrepared4.leftRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 191
      PairLightAdaptivePrepared4.leftCached004 PairLightAdaptivePrepared4.leftRows004
      PairLightAdaptivePrepared4.left_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared4.leftCached003 PairLightAdaptivePrepared4.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 150
      PairLightAdaptivePrepared4.leftCached003 PairLightAdaptivePrepared4.leftRows003
      PairLightAdaptivePrepared4.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared4.leftCached002 PairLightAdaptivePrepared4.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 102
      PairLightAdaptivePrepared4.leftCached002 PairLightAdaptivePrepared4.leftRows002
      PairLightAdaptivePrepared4.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared4.leftCached001 PairLightAdaptivePrepared4.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 82
      PairLightAdaptivePrepared4.leftCached001 PairLightAdaptivePrepared4.leftRows001
      PairLightAdaptivePrepared4.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared4.leftCached000 PairLightAdaptivePrepared4.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared4.leftCached000 PairLightAdaptivePrepared4.leftRows000
      PairLightAdaptivePrepared4.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared4
