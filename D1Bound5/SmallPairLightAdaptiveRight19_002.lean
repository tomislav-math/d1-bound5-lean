import D1Bound5.SmallPairLightAdaptiveData19
import D1Bound5.SmallPairLightRight19Prefix002

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 248 through 445; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 198
      rightCached002 rightRows002 = true := by
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_002_direct_checked

end D1Bound5.PairLightAdaptivePrepared19
