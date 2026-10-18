import D1Bound5.SmallPairLightAdaptiveData36

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 286 through 560; every head retains its entire tail. -/
theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 275
      leftCached003 leftRows003 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
