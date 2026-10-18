import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 192 through 273; every head retains its entire tail. -/
theorem right_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 82
      rightCached003 rightRows003 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
