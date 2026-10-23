import D1Bound5.SmallPairLightAdaptiveData43
import D1Bound5.SmallPairLightLeft43Prefix001

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 91 through 211; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 121
      leftCached001 leftRows001 = true := by
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    left_prefix_001_direct_checked

end D1Bound5.PairLightAdaptivePrepared43
