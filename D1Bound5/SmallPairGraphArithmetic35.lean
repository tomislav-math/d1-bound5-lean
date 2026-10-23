import D1Bound5.SmallPairGraphInputs35
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_35_checked :
    pairSeedsCoveredBool smallPairA_35 smallPairB_35
      seedRootDisk_1_2 smallPairClosure_35 = true := by
  decide +kernel

theorem smallPairFilter_35_checked :
    largePairVertices smallPairA_35 smallPairB_35 smallPairClosure_35 = smallPairLarge_35 := by
  decide +kernel

theorem smallPairLarge_35_count : smallPairLarge_35.length = 737 := by
  decide +kernel

end D1Bound5
