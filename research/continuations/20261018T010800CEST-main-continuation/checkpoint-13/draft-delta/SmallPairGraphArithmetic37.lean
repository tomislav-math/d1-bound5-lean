import D1Bound5.SmallPairGraphInputs37
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_37_checked :
    pairSeedsCoveredBool smallPairA_37 smallPairB_37
      seedRootDisk_1_2 smallPairClosure_37 = true := by
  decide +kernel

theorem smallPairFilter_37_checked :
    largePairVertices smallPairA_37 smallPairB_37 smallPairClosure_37 = smallPairLarge_37 := by
  decide +kernel

theorem smallPairLarge_37_count : smallPairLarge_37.length = 744 := by
  decide +kernel

end D1Bound5
