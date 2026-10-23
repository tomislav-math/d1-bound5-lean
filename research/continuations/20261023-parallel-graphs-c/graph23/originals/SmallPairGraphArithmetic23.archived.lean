import D1Bound5.SmallPairGraphInputs23
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_23_checked :
    pairSeedsCoveredBool smallPairA_23 smallPairB_23
      seedRootDisk_1_1 smallPairClosure_23 = true := by
  decide +kernel

theorem smallPairFilter_23_checked :
    largePairVertices smallPairA_23 smallPairB_23 smallPairClosure_23 = smallPairLarge_23 := by
  decide +kernel

theorem smallPairLarge_23_count : smallPairLarge_23.length = 962 := by
  decide +kernel

end D1Bound5
