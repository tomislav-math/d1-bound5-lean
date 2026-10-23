import D1Bound5.SmallPairGraphInputs33
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_33_checked :
    pairSeedsCoveredBool smallPairA_33 smallPairB_33
      seedRootDisk_1_2 smallPairClosure_33 = true := by
  decide +kernel

theorem smallPairFilter_33_checked :
    largePairVertices smallPairA_33 smallPairB_33 smallPairClosure_33 = smallPairLarge_33 := by
  decide +kernel

theorem smallPairLarge_33_count : smallPairLarge_33.length = 718 := by
  decide +kernel

end D1Bound5
