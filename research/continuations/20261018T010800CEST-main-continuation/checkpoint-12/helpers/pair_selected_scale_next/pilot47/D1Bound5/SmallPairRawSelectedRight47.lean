import D1Bound5.SmallPairRawSelectedData47
import D1Bound5.PairRawSelectedFloorWitnesses

namespace D1Bound5.PairSelectedPrepared47
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map PairResidueVertex.vertex = (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).2) = true := by
  decide +kernel

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.signature = pairCoordinateSignature smallPairSieve_1_6 x.vertex)) = true := by
  decide +kernel

theorem right_independent_checked :
    pairRawSelectedFloorIndependentBool smallPairSieve_1_6 rightCached rightRows = true := by
  decide +kernel

theorem right_certificate_checked :
    pairRawSelectedFloorIndependentCertificateBool smallPairSieve_1_6
      (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).2 rightCached rightRows = true := by
  unfold pairRawSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

theorem right_checked : pairIndependentBool smallPairSieve_1_6 (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).2 = true :=
  pairIndependentBool_of_raw_selected_floor_certificate (by decide) smallPairSieve_1_6
    (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).2 rightCached rightRows right_certificate_checked

end D1Bound5.PairSelectedPrepared47
