import D1Bound5.SmallPairGraphInputs22
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_22_checked :
    pairSeedsCoveredBool smallPairA_22 smallPairB_22
      seedRootDisk_1_1 smallPairClosure_22 = true := by
  decide +kernel

theorem smallPairFilter_22_checked :
    largePairVertices smallPairA_22 smallPairB_22 smallPairClosure_22 = smallPairLarge_22 := by
  decide +kernel

theorem smallPairLarge_22_count : smallPairLarge_22.length = 962 := by
  decide +kernel

end D1Bound5
