import D1Bound5.SmallPairLightAdaptiveData15

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 92 through 213; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 122
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared15
