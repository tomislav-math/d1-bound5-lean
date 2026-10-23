import D1Bound5.SmallPairGraphInputs14
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_14_checked :
    pairSeedsCoveredBool smallPairA_14 smallPairB_14
      seedRootDisk_0_2 smallPairClosure_14 = true := by
  decide +kernel

theorem smallPairFilter_14_checked :
    largePairVertices smallPairA_14 smallPairB_14 smallPairClosure_14 = smallPairLarge_14 := by
  decide +kernel

theorem smallPairLarge_14_count : smallPairLarge_14.length = 991 := by
  decide +kernel

end D1Bound5
