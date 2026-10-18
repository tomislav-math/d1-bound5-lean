import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 274 through 375; every head retains its entire tail. -/
theorem left_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 102
      leftCached004 leftRows004 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
