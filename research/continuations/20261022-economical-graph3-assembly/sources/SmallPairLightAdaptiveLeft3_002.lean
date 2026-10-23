import D1Bound5.SmallPairLightAdaptiveData3
import D1Bound5.SmallPairLightLeft3Prefix002

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 311 through 412; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 102
      leftCached002 leftRows002 = true := by
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    left_prefix_002_direct_checked

end D1Bound5.PairLightAdaptivePrepared3
