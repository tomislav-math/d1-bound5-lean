import D1Bound5.SmallPairGraphInputs16
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_16_checked :
    pairSeedsCoveredBool smallPairA_16 smallPairB_16
      seedRootDisk_0_2 smallPairClosure_16 = true := by
  decide +kernel

theorem smallPairFilter_16_checked :
    largePairVertices smallPairA_16 smallPairB_16 smallPairClosure_16 = smallPairLarge_16 := by
  decide +kernel

theorem smallPairLarge_16_count : smallPairLarge_16.length = 552 := by
  decide +kernel

end D1Bound5
