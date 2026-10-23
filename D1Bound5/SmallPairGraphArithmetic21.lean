import D1Bound5.SmallPairGraphInputs21
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_21_checked :
    pairSeedsCoveredBool smallPairA_21 smallPairB_21
      seedRootDisk_1_1 smallPairClosure_21 = true := by
  decide +kernel

theorem smallPairFilter_21_checked :
    largePairVertices smallPairA_21 smallPairB_21 smallPairClosure_21 = smallPairLarge_21 := by
  decide +kernel

theorem smallPairLarge_21_count : smallPairLarge_21.length = 1048 := by
  decide +kernel

end D1Bound5
