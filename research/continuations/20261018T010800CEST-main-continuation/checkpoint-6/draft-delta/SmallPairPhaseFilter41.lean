import D1Bound5.SmallPairPhaseData41

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem filter_checked :
    largePairVertices anchorA anchorB closure = large := by
  decide +kernel

end D1Bound5.PairPhasePilot41
