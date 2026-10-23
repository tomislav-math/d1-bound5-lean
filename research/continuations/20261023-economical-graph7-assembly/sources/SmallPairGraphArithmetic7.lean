import D1Bound5.SmallPairGraphInputs7
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_7_checked :
    pairSeedsCoveredBool smallPairA_7 smallPairB_7
      seedRootDisk_0_1 smallPairClosure_7 = true := by
  decide +kernel

theorem smallPairFilter_7_checked :
    largePairVertices smallPairA_7 smallPairB_7 smallPairClosure_7 = smallPairLarge_7 := by
  decide +kernel

theorem smallPairLarge_7_count : smallPairLarge_7.length = 862 := by
  decide +kernel

end D1Bound5
