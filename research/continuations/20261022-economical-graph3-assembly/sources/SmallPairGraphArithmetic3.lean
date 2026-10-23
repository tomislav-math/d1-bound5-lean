import D1Bound5.SmallPairGraphInputs3
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_3_checked :
    pairSeedsCoveredBool smallPairA_3 smallPairB_3
      seedRootDisk_0_1 smallPairClosure_3 = true := by
  decide +kernel

theorem smallPairFilter_3_checked :
    largePairVertices smallPairA_3 smallPairB_3 smallPairClosure_3 = smallPairLarge_3 := by
  decide +kernel

theorem smallPairLarge_3_count : smallPairLarge_3.length = 827 := by
  decide +kernel

end D1Bound5
