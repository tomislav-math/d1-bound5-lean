import D1Bound5.SmallPairLightAdaptiveData43
import D1Bound5.SmallPairLightLeft43Prefix002

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 212 through 481; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 270
      leftCached002 leftRows002 = true := by
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    left_prefix_002_direct_checked

end D1Bound5.PairLightAdaptivePrepared43
