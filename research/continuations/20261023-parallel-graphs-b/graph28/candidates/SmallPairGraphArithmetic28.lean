import D1Bound5.SmallPairGraphInputs28
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_28_checked :
    pairSeedsCoveredBool smallPairA_28 smallPairB_28
      seedRootDisk_1_1 smallPairClosure_28 = true := by
  decide +kernel

theorem smallPairFilter_28_checked :
    largePairVertices smallPairA_28 smallPairB_28 smallPairClosure_28 = smallPairLarge_28 := by
  decide +kernel

theorem smallPairLarge_28_count : smallPairLarge_28.length = 1048 := by
  decide +kernel

end D1Bound5
