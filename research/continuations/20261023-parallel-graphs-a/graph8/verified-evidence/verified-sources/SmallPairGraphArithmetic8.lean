import D1Bound5.SmallPairGraphInputs8
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_8_checked :
    pairSeedsCoveredBool smallPairA_8 smallPairB_8
      seedRootDisk_0_1 smallPairClosure_8 = true := by
  decide +kernel

theorem smallPairFilter_8_checked :
    largePairVertices smallPairA_8 smallPairB_8 smallPairClosure_8 = smallPairLarge_8 := by
  decide +kernel

theorem smallPairLarge_8_count : smallPairLarge_8.length = 1434 := by
  decide +kernel

end D1Bound5
