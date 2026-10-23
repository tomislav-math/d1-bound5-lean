import D1Bound5.SmallPairGraphInputs36
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_36_checked :
    pairSeedsCoveredBool smallPairA_36 smallPairB_36
      seedRootDisk_1_2 smallPairClosure_36 = true := by
  decide +kernel

theorem smallPairFilter_36_checked :
    largePairVertices smallPairA_36 smallPairB_36 smallPairClosure_36 = smallPairLarge_36 := by
  decide +kernel

theorem smallPairLarge_36_count : smallPairLarge_36.length = 1121 := by
  decide +kernel

end D1Bound5
