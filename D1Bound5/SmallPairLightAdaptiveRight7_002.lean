import D1Bound5.SmallPairLightAdaptiveData7
import D1Bound5.SmallPairLightRight7Prefix002

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 272 through 429; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 158
      rightCached002 rightRows002 = true := by
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_002_direct_checked

end D1Bound5.PairLightAdaptivePrepared7
