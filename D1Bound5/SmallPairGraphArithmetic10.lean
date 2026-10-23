import D1Bound5.SmallPairGraphInputs10
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_10_checked :
    pairSeedsCoveredBool smallPairA_10 smallPairB_10
      seedRootDisk_0_1 smallPairClosure_10 = true := by
  decide +kernel

theorem smallPairFilter_10_checked :
    largePairVertices smallPairA_10 smallPairB_10 smallPairClosure_10 = smallPairLarge_10 := by
  decide +kernel

theorem smallPairLarge_10_count : smallPairLarge_10.length = 1192 := by
  decide +kernel

end D1Bound5
