import D1Bound5.SmallPairCachedData41
import D1Bound5.PairCachedIndependentChunks

namespace D1Bound5.PairCachedPilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- The first sixteen left-color rows, each against its full remaining tail.
This is a component of the exact full-class independence certificate. -/
theorem left_cached_prefix16_checked :
    pairCachedIndependentPrefixBool smallPairSieve_1_2 16
      (pairSplitByMask cachedVertices smallPairPilotColors_41).1 = true := by
  decide +kernel

end D1Bound5.PairCachedPilot41
