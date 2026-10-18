import D1Bound5.SmallPairLightAdaptiveData10

namespace D1Bound5.PairLightAdaptivePrepared10
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 405 through 595; every head retains its entire tail. -/
theorem right_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 191
      rightCached004 rightRows004 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared10
