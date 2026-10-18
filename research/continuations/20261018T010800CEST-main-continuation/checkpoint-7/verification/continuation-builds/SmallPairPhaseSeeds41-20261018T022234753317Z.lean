import D1Bound5.SmallPairPhaseData41
import D1Bound5.TwoSmallSeedDisks

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem seeds_checked :
    pairSeedsCoveredBool anchorA anchorB seedRootDisk_1_2 closure = true := by
  decide +kernel

end D1Bound5.PairPhasePilot41
