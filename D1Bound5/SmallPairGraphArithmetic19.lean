import D1Bound5.SmallPairGraphInputs19
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_19_checked :
    pairSeedsCoveredBool smallPairA_19 smallPairB_19
      seedRootDisk_1_1 smallPairClosure_19 = true := by
  decide +kernel

theorem smallPairFilter_19_checked :
    largePairVertices smallPairA_19 smallPairB_19 smallPairClosure_19 = smallPairLarge_19 := by
  decide +kernel

theorem smallPairLarge_19_count : smallPairLarge_19.length = 892 := by
  decide +kernel

end D1Bound5
