import D1Bound5.SmallPairGraphInputs31
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_31_checked :
    pairSeedsCoveredBool smallPairA_31 smallPairB_31
      seedRootDisk_0_5 smallPairClosure_31 = true := by
  decide +kernel

theorem smallPairFilter_31_checked :
    largePairVertices smallPairA_31 smallPairB_31 smallPairClosure_31 = smallPairLarge_31 := by
  decide +kernel

theorem smallPairLarge_31_count : smallPairLarge_31.length = 410 := by
  decide +kernel

end D1Bound5
