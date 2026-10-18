import D1Bound5.SmallPairLightAdaptiveData6

namespace D1Bound5.PairLightAdaptivePrepared6
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 62; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 63
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
