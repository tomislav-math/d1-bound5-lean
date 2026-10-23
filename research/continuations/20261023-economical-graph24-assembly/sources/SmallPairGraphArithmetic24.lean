import D1Bound5.SmallPairGraphInputs24
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_24_checked :
    pairSeedsCoveredBool smallPairA_24 smallPairB_24
      seedRootDisk_1_1 smallPairClosure_24 = true := by
  decide +kernel

theorem smallPairFilter_24_checked :
    largePairVertices smallPairA_24 smallPairB_24 smallPairClosure_24 = smallPairLarge_24 := by
  decide +kernel

theorem smallPairLarge_24_count : smallPairLarge_24.length = 892 := by
  decide +kernel

end D1Bound5
