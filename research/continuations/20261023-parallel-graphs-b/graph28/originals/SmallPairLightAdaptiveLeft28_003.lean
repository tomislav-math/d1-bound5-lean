import D1Bound5.SmallPairLightAdaptiveData28

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 335 through 523; every head retains its entire tail. -/
theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 189
      leftCached003 leftRows003 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
