import D1Bound5.SmallPairGraphInputs47
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_47_checked :
    pairSeedsCoveredBool smallPairA_47 smallPairB_47
      seedRootDisk_1_6 smallPairClosure_47 = true := by
  decide +kernel

theorem smallPairFilter_47_checked :
    largePairVertices smallPairA_47 smallPairB_47 smallPairClosure_47 = smallPairLarge_47 := by
  decide +kernel

theorem smallPairLarge_47_count : smallPairLarge_47.length = 389 := by
  decide +kernel

end D1Bound5
