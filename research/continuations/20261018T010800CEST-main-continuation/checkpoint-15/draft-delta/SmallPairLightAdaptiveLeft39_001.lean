import D1Bound5.SmallPairLightAdaptiveData39

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 97 through 232; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 136
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared39
