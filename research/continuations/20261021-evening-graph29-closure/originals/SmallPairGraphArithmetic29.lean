import D1Bound5.SmallPairGraphInputs29
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_29_checked :
    pairSeedsCoveredBool smallPairA_29 smallPairB_29
      seedRootDisk_1_1 smallPairClosure_29 = true := by
  decide +kernel

theorem smallPairFilter_29_checked :
    largePairVertices smallPairA_29 smallPairB_29 smallPairClosure_29 = smallPairLarge_29 := by
  decide +kernel

theorem smallPairLarge_29_count : smallPairLarge_29.length = 761 := by
  decide +kernel

end D1Bound5
