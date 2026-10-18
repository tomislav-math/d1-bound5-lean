import D1Bound5.SmallPairLightAdaptiveData6

namespace D1Bound5.PairLightAdaptivePrepared6
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 216 through 317; every head retains its entire tail. -/
theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 102
      leftCached003 leftRows003 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
