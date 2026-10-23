import D1Bound5.PairLightArithmeticChunkProofs
import D1Bound5.SmallPairLightAdaptiveValidation3
import D1Bound5.SmallPairLightAdaptiveRight3_000
import D1Bound5.SmallPairLightAdaptiveRight3_001
import D1Bound5.SmallPairLightAdaptiveRight3_002

namespace D1Bound5.PairLightPrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true :=
  PairLightAdaptivePrepared3.right_coverage_checked

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true :=
  PairLightAdaptivePrepared3.right_signatures_checked

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 0 1 sieve rightCached rightRows = true := by
  have h003 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.rightCached003 PairLightAdaptivePrepared3.rightRows003 = true := by
    rfl
  have h002 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.rightCached002 PairLightAdaptivePrepared3.rightRows002 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 108
      PairLightAdaptivePrepared3.rightCached002 PairLightAdaptivePrepared3.rightRows002
      PairLightAdaptivePrepared3.right_prefix_002_checked h003
  have h001 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.rightCached001 PairLightAdaptivePrepared3.rightRows001 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 195
      PairLightAdaptivePrepared3.rightCached001 PairLightAdaptivePrepared3.rightRows001
      PairLightAdaptivePrepared3.right_prefix_001_checked h002
  have h000 : pairLightSelectedFloorIndependentBool 0 1 sieve
      PairLightAdaptivePrepared3.rightCached000 PairLightAdaptivePrepared3.rightRows000 = true :=
    pairLightSelectedFloorIndependentBool_of_prefix_drop 0 1 sieve 111
      PairLightAdaptivePrepared3.rightCached000 PairLightAdaptivePrepared3.rightRows000
      PairLightAdaptivePrepared3.right_prefix_000_checked h001
  exact h000

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 0 1 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared3
