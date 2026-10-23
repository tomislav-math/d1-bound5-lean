import D1Bound5.SmallPairGraphInputs27
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_27_checked :
    pairSeedsCoveredBool smallPairA_27 smallPairB_27
      seedRootDisk_1_1 smallPairClosure_27 = true := by
  decide +kernel

theorem smallPairFilter_27_checked :
    largePairVertices smallPairA_27 smallPairB_27 smallPairClosure_27 = smallPairLarge_27 := by
  decide +kernel

theorem smallPairLarge_27_count : smallPairLarge_27.length = 481 := by
  decide +kernel

end D1Bound5
