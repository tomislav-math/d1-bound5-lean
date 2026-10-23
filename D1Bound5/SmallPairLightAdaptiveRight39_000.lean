import D1Bound5.SmallPairLightAdaptiveData39
import D1Bound5.SmallPairLightRight39Prefix000

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 97; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 98
      rightCached000 rightRows000 = true := by
  simpa only [rightCached000, rightRows000, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_000_direct_checked

end D1Bound5.PairLightAdaptivePrepared39
