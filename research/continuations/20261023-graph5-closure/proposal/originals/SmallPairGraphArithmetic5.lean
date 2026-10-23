import D1Bound5.SmallPairGraphInputs5
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_5_checked :
    pairSeedsCoveredBool smallPairA_5 smallPairB_5
      seedRootDisk_0_1 smallPairClosure_5 = true := by
  decide +kernel

theorem smallPairFilter_5_checked :
    largePairVertices smallPairA_5 smallPairB_5 smallPairClosure_5 = smallPairLarge_5 := by
  decide +kernel

theorem smallPairLarge_5_count : smallPairLarge_5.length = 861 := by
  decide +kernel

end D1Bound5
