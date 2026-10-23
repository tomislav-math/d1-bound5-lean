import D1Bound5.SmallPairGraphInputs15
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_15_checked :
    pairSeedsCoveredBool smallPairA_15 smallPairB_15
      seedRootDisk_0_2 smallPairClosure_15 = true := by
  decide +kernel

theorem smallPairFilter_15_checked :
    largePairVertices smallPairA_15 smallPairB_15 smallPairClosure_15 = smallPairLarge_15 := by
  decide +kernel

theorem smallPairLarge_15_count : smallPairLarge_15.length = 961 := by
  decide +kernel

end D1Bound5
