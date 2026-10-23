import D1Bound5.SmallPairGraphInputs34
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_34_checked :
    pairSeedsCoveredBool smallPairA_34 smallPairB_34
      seedRootDisk_1_2 smallPairClosure_34 = true := by
  decide +kernel

theorem smallPairFilter_34_checked :
    largePairVertices smallPairA_34 smallPairB_34 smallPairClosure_34 = smallPairLarge_34 := by
  decide +kernel

theorem smallPairLarge_34_count : smallPairLarge_34.length = 457 := by
  decide +kernel

end D1Bound5
