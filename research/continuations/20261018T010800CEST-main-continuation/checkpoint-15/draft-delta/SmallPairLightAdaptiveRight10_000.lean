import D1Bound5.SmallPairLightAdaptiveData10

namespace D1Bound5.PairLightAdaptivePrepared10
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 70; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 71
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared10
