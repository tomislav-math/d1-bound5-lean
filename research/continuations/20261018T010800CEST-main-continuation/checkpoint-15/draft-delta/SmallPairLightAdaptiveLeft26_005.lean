import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 336 through 442; every head retains its entire tail. -/
theorem left_prefix_005_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 107
      leftCached005 leftRows005 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
