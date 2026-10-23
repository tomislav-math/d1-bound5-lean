import D1Bound5.SmallPairLightAdaptiveData7
import D1Bound5.SmallPairLightLeft7Prefix000

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 104; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 105
      leftCached000 leftRows000 = true := by
  simpa only [leftCached000, leftRows000, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    left_prefix_000_direct_checked

end D1Bound5.PairLightAdaptivePrepared7
