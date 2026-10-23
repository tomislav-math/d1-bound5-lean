import D1Bound5.SmallPairGraphInputs39
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_39_checked :
    pairSeedsCoveredBool smallPairA_39 smallPairB_39
      seedRootDisk_1_2 smallPairClosure_39 = true := by
  decide +kernel

theorem smallPairFilter_39_checked :
    largePairVertices smallPairA_39 smallPairB_39 smallPairClosure_39 = smallPairLarge_39 := by
  decide +kernel

theorem smallPairLarge_39_count : smallPairLarge_39.length = 914 := by
  decide +kernel

end D1Bound5
