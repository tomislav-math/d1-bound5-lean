import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.PairSelectedFloorWitnesses
import D1Bound5.SmallPairSelectedData34

namespace D1Bound5.PairSelectedPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_certificate_checked :
    pairSelectedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).2
      PairLiteralPilot34.rightCached rightRows = true := by
  decide +kernel

/-- Exact original split-class target, with unchanged literal cache and coverage. -/
theorem right_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).2 = true :=
  pairIndependentBool_of_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).2
    PairLiteralPilot34.rightCached rightRows right_certificate_checked

end D1Bound5.PairSelectedPilot34
