import D1Bound5.SmallPairLightAdaptiveData43
import D1Bound5.SmallPairLightLeft43Prefix000

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 90; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 91
      leftCached000 leftRows000 = true := by
  simpa only [leftCached000, leftRows000, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    left_prefix_000_direct_checked

end D1Bound5.PairLightAdaptivePrepared43
