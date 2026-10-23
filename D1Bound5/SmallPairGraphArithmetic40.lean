import D1Bound5.SmallPairGraphInputs40
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_40_checked :
    pairSeedsCoveredBool smallPairA_40 smallPairB_40
      seedRootDisk_1_2 smallPairClosure_40 = true := by
  decide +kernel

theorem smallPairFilter_40_checked :
    largePairVertices smallPairA_40 smallPairB_40 smallPairClosure_40 = smallPairLarge_40 := by
  decide +kernel

theorem smallPairLarge_40_count : smallPairLarge_40.length = 718 := by
  decide +kernel

end D1Bound5
