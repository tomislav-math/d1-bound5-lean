import D1Bound5.SmallPairLightAdaptiveData45

namespace D1Bound5.PairLightAdaptivePrepared45
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 42; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 5 PairLightPrepared45.sieve 43
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared45
