import D1Bound5.SmallPairLightAdaptiveData6

namespace D1Bound5.PairLightAdaptivePrepared6
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 63 through 133; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 71
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
