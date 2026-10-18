import D1Bound5.SmallPairBipartitePilotData41
import D1Bound5.SmallPairSieve_1_2

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairPilotLeft_41_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).1 = true := by
  decide +kernel

end D1Bound5
