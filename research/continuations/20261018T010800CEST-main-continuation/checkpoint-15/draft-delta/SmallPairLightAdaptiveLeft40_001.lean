import D1Bound5.SmallPairLightAdaptiveData40

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 137 through 359; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 223
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared40
