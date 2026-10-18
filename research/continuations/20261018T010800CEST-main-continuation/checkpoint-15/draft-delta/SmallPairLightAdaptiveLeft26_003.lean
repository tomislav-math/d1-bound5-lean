import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 178 through 250; every head retains its entire tail. -/
theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 73
      leftCached003 leftRows003 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
