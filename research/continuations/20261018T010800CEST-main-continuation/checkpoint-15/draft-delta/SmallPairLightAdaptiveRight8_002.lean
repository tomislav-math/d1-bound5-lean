import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 121 through 191; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 71
      rightCached002 rightRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
