import D1Bound5.SmallPairGraphInputs48
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_48_checked :
    pairSeedsCoveredBool smallPairA_48 smallPairB_48
      seedRootDisk_1_8 smallPairClosure_48 = true := by
  decide +kernel

theorem smallPairFilter_48_checked :
    largePairVertices smallPairA_48 smallPairB_48 smallPairClosure_48 = smallPairLarge_48 := by
  decide +kernel

theorem smallPairLarge_48_count : smallPairLarge_48.length = 718 := by
  decide +kernel

end D1Bound5
