import D1Bound5.SmallPairLightAdaptiveData19
import D1Bound5.SmallPairLightRight19Prefix001

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 101 through 247; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 147
      rightCached001 rightRows001 = true := by
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, List.drop_drop, Nat.reduceAdd, List.drop_zero] using
    right_prefix_001_direct_checked

end D1Bound5.PairLightAdaptivePrepared19
