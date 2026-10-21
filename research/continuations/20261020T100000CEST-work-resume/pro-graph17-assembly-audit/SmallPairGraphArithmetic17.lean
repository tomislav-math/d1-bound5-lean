import D1Bound5.SmallPairGraphInputs17
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_17_checked :
    pairSeedsCoveredBool smallPairA_17 smallPairB_17
      seedRootDisk_0_2 smallPairClosure_17 = true := by
  decide +kernel

theorem smallPairFilter_17_checked :
    largePairVertices smallPairA_17 smallPairB_17 smallPairClosure_17 = smallPairLarge_17 := by
  decide +kernel

theorem smallPairLarge_17_count : smallPairLarge_17.length = 718 := by
  decide +kernel

end D1Bound5
