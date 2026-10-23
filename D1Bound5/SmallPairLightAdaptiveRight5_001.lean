import D1Bound5.SmallPairLightAdaptiveData5
import D1Bound5.SmallPairLightRight5Prefix001

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 106 through 271; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 166
      rightCached001 rightRows001 = true := by
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_001_direct_checked

end D1Bound5.PairLightAdaptivePrepared5
