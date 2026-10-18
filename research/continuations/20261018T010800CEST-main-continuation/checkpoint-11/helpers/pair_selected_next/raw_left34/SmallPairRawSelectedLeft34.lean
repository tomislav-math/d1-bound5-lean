import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.PairRawSelectedFloorWitnesses
import D1Bound5.SmallPairSelectedData34

namespace D1Bound5.PairRawSelectedPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- The exact existing literal class, packed words, and floor witnesses;
only the proved-equal natural-arithmetic mask evaluation is selected. -/
theorem left_certificate_checked :
    pairRawSelectedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
      PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows = true := by
  decide +kernel

/-- Exactly the original left independent-class assertion. -/
theorem left_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 = true :=
  pairIndependentBool_of_raw_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
    PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows left_certificate_checked

end D1Bound5.PairRawSelectedPilot34
