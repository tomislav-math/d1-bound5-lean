import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 132 through 368; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 237
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
