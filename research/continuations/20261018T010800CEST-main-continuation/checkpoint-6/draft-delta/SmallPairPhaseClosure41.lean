import D1Bound5.SmallPairPhaseData41

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem closure_checked :
    pairClosureBool anchorA anchorB (10^1100) closure = true := by
  decide +kernel

end D1Bound5.PairPhasePilot41
