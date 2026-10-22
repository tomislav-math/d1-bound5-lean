import D1Bound5.SmallPairGraphInputs43
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_43_checked :
    pairSeedsCoveredBool smallPairA_43 smallPairB_43
      seedRootDisk_1_3 smallPairClosure_43 = true := by
  decide +kernel

theorem smallPairFilter_43_checked :
    largePairVertices smallPairA_43 smallPairB_43 smallPairClosure_43 = smallPairLarge_43 := by
  decide +kernel

theorem smallPairLarge_43_count : smallPairLarge_43.length = 962 := by
  decide +kernel

end D1Bound5
