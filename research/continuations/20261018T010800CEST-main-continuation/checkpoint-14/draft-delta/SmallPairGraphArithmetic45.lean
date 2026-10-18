import D1Bound5.SmallPairGraphInputs45
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_45_checked :
    pairSeedsCoveredBool smallPairA_45 smallPairB_45
      seedRootDisk_1_5 smallPairClosure_45 = true := by
  decide +kernel

theorem smallPairFilter_45_checked :
    largePairVertices smallPairA_45 smallPairB_45 smallPairClosure_45 = smallPairLarge_45 := by
  decide +kernel

theorem smallPairLarge_45_count : smallPairLarge_45.length = 411 := by
  decide +kernel

end D1Bound5
