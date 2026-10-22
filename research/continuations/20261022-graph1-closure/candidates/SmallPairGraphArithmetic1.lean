import D1Bound5.SmallPairGraphInputs1
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_1_checked :
    pairSeedsCoveredBool smallPairA_1 smallPairB_1
      seedRootDisk_0_1 smallPairClosure_1 = true := by
  decide +kernel

theorem smallPairFilter_1_checked :
    largePairVertices smallPairA_1 smallPairB_1 smallPairClosure_1 = smallPairLarge_1 := by
  decide +kernel

theorem smallPairLarge_1_count : smallPairLarge_1.length = 718 := by
  decide +kernel

end D1Bound5
