import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 126 through 379; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 254
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
