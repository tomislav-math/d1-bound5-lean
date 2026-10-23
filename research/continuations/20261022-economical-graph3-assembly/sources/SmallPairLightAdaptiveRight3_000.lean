import D1Bound5.SmallPairLightAdaptiveData3
import D1Bound5.SmallPairLightRight3Prefix000

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 110; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 111
      rightCached000 rightRows000 = true := by
  simpa only [rightCached000, rightRows000, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_000_direct_checked

end D1Bound5.PairLightAdaptivePrepared3
