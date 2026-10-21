import D1Bound5.SmallPairGraphInputs12
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_12_checked :
    pairSeedsCoveredBool smallPairA_12 smallPairB_12
      seedRootDisk_0_1 smallPairClosure_12 = true := by
  decide +kernel

theorem smallPairFilter_12_checked :
    largePairVertices smallPairA_12 smallPairB_12 smallPairClosure_12 = smallPairLarge_12 := by
  decide +kernel

theorem smallPairLarge_12_count : smallPairLarge_12.length = 718 := by
  decide +kernel

end D1Bound5
