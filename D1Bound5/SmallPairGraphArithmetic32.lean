import D1Bound5.SmallPairGraphInputs32
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_32_checked :
    pairSeedsCoveredBool smallPairA_32 smallPairB_32
      seedRootDisk_0_6 smallPairClosure_32 = true := by
  decide +kernel

theorem smallPairFilter_32_checked :
    largePairVertices smallPairA_32 smallPairB_32 smallPairClosure_32 = smallPairLarge_32 := by
  decide +kernel

theorem smallPairLarge_32_count : smallPairLarge_32.length = 389 := by
  decide +kernel

end D1Bound5
