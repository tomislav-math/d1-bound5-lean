import D1Bound5.SmallPairGraphInputs6
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_6_checked :
    pairSeedsCoveredBool smallPairA_6 smallPairB_6
      seedRootDisk_0_1 smallPairClosure_6 = true := by
  decide +kernel

theorem smallPairFilter_6_checked :
    largePairVertices smallPairA_6 smallPairB_6 smallPairClosure_6 = smallPairLarge_6 := by
  decide +kernel

theorem smallPairLarge_6_count : smallPairLarge_6.length = 1315 := by
  decide +kernel

end D1Bound5
