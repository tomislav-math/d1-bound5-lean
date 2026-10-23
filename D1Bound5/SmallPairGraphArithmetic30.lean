import D1Bound5.SmallPairGraphInputs30
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_30_checked :
    pairSeedsCoveredBool smallPairA_30 smallPairB_30
      seedRootDisk_1_1 smallPairClosure_30 = true := by
  decide +kernel

theorem smallPairFilter_30_checked :
    largePairVertices smallPairA_30 smallPairB_30 smallPairClosure_30 = smallPairLarge_30 := by
  decide +kernel

theorem smallPairLarge_30_count : smallPairLarge_30.length = 962 := by
  decide +kernel

end D1Bound5
