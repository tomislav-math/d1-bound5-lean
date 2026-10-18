import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 524 through 717; every head retains its entire tail. -/
theorem right_prefix_006_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 194
      rightCached006 rightRows006 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
