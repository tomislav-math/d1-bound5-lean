import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation10
import D1Bound5.SmallPairLightAdaptiveLeft10_000
import D1Bound5.SmallPairLightAdaptiveLeft10_001
import D1Bound5.SmallPairLightAdaptiveLeft10_002
import D1Bound5.SmallPairLightAdaptiveLeft10_003
import D1Bound5.SmallPairLightAdaptiveLeft10_004

namespace D1Bound5.PairLightPrepared10
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true :=
  PairLightAdaptivePrepared10.left_coverage_checked

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared10.left_signatures_checked

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve leftCached leftRows = true := by
  have h005 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.leftCached005 PairLightAdaptivePrepared10.leftRows005 = true := by
    rfl
  have h004 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.leftCached004 PairLightAdaptivePrepared10.leftRows004 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 191
      PairLightAdaptivePrepared10.leftCached004 PairLightAdaptivePrepared10.leftRows004
      PairLightAdaptivePrepared10.left_prefix_004_checked h005
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.leftCached003 PairLightAdaptivePrepared10.leftRows003 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 150
      PairLightAdaptivePrepared10.leftCached003 PairLightAdaptivePrepared10.leftRows003
      PairLightAdaptivePrepared10.left_prefix_003_checked h004
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.leftCached002 PairLightAdaptivePrepared10.leftRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 102
      PairLightAdaptivePrepared10.leftCached002 PairLightAdaptivePrepared10.leftRows002
      PairLightAdaptivePrepared10.left_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.leftCached001 PairLightAdaptivePrepared10.leftRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 82
      PairLightAdaptivePrepared10.leftCached001 PairLightAdaptivePrepared10.leftRows001
      PairLightAdaptivePrepared10.left_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared10.leftCached000 PairLightAdaptivePrepared10.leftRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 71
      PairLightAdaptivePrepared10.leftCached000 PairLightAdaptivePrepared10.leftRows000
      PairLightAdaptivePrepared10.left_prefix_000_checked h001
  exact h000

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared10
