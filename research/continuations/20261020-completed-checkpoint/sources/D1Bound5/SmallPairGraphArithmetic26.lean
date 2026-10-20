import D1Bound5.SmallPairGraphInputs26
import D1Bound5.TwoSmallSeedDisks
import D1Bound5.SmallPairGraphCheck


namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairSeeds_26_checked :
    pairSeedsCoveredBool smallPairA_26 smallPairB_26
      seedRootDisk_1_1 smallPairClosure_26 = true := by
  decide +kernel

theorem smallPairFilter_26_checked :
    largePairVertices smallPairA_26 smallPairB_26 smallPairClosure_26 = smallPairLarge_26 := by
  decide +kernel

theorem smallPairLarge_26_count : smallPairLarge_26.length = 1522 := by
  decide +kernel

end D1Bound5

