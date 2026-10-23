import D1Bound5.SmallPairGraphInputs4
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_4_checked :
    pairSeedsCoveredBool smallPairA_4 smallPairB_4
      seedRootDisk_0_1 smallPairClosure_4 = true := by
  decide +kernel

theorem smallPairFilter_4_checked :
    largePairVertices smallPairA_4 smallPairB_4 smallPairClosure_4 = smallPairLarge_4 := by
  decide +kernel

theorem smallPairLarge_4_count : smallPairLarge_4.length = 1192 := by
  decide +kernel

end D1Bound5
