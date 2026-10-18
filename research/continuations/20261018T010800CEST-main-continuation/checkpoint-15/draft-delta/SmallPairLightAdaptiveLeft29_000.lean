import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 125; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 126
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
