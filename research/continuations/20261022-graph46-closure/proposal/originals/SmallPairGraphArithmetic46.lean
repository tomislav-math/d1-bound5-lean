import D1Bound5.SmallPairGraphInputs46
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_46_checked :
    pairSeedsCoveredBool smallPairA_46 smallPairB_46
      seedRootDisk_1_6 smallPairClosure_46 = true := by
  decide +kernel

theorem smallPairFilter_46_checked :
    largePairVertices smallPairA_46 smallPairB_46 smallPairClosure_46 = smallPairLarge_46 := by
  decide +kernel

theorem smallPairLarge_46_count : smallPairLarge_46.length = 718 := by
  decide +kernel

end D1Bound5
