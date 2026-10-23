import D1Bound5.SmallPairLightAdaptiveData39
import D1Bound5.SmallPairLightRight39Prefix002

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 236 through 455; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 220
      rightCached002 rightRows002 = true := by
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_002_direct_checked

end D1Bound5.PairLightAdaptivePrepared39
