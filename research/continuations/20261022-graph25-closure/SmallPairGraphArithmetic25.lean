import D1Bound5.SmallPairGraphInputs25
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_25_checked :
    pairSeedsCoveredBool smallPairA_25 smallPairB_25
      seedRootDisk_1_1 smallPairClosure_25 = true := by
  decide +kernel

theorem smallPairFilter_25_checked :
    largePairVertices smallPairA_25 smallPairB_25 smallPairClosure_25 = smallPairLarge_25 := by
  decide +kernel

theorem smallPairLarge_25_count : smallPairLarge_25.length = 761 := by
  decide +kernel

end D1Bound5
