import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 376 through 526; every head retains its entire tail. -/
theorem left_prefix_005_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 151
      leftCached005 leftRows005 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
