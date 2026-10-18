import D1Bound5.SmallPairRawSelectedData47
import D1Bound5.PairRawSelectedFloorWitnesses

namespace D1Bound5.PairSelectedPrepared47
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map PairResidueVertex.vertex = (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).1) = true := by
  decide +kernel

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.signature = pairCoordinateSignature smallPairSieve_1_6 x.vertex)) = true := by
  decide +kernel

theorem left_independent_checked :
    pairRawSelectedFloorIndependentBool smallPairSieve_1_6 leftCached leftRows = true := by
  decide +kernel

theorem left_certificate_checked :
    pairRawSelectedFloorIndependentCertificateBool smallPairSieve_1_6
      (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).1 leftCached leftRows = true := by
  unfold pairRawSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

theorem left_checked : pairIndependentBool smallPairSieve_1_6 (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).1 = true :=
  pairIndependentBool_of_raw_selected_floor_certificate (by decide) smallPairSieve_1_6
    (pairSplitByMask smallPairLarge_47 PairGraphPrepared47.colors).1 leftCached leftRows left_certificate_checked

end D1Bound5.PairSelectedPrepared47
