import D1Bound5.SmallPairGraphInputs11
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_11_checked :
    pairSeedsCoveredBool smallPairA_11 smallPairB_11
      seedRootDisk_0_1 smallPairClosure_11 = true := by
  decide +kernel

theorem smallPairFilter_11_checked :
    largePairVertices smallPairA_11 smallPairB_11 smallPairClosure_11 = smallPairLarge_11 := by
  decide +kernel

theorem smallPairLarge_11_count : smallPairLarge_11.length = 718 := by
  decide +kernel

end D1Bound5
