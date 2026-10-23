import D1Bound5.SmallPairLightAdaptiveData43
import D1Bound5.SmallPairLightRight43Prefix002

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 214 through 479; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 266
      rightCached002 rightRows002 = true := by
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_002_direct_checked

end D1Bound5.PairLightAdaptivePrepared43
