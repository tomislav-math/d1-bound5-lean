import D1Bound5.SmallPairLightAdaptiveData5

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 105; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 106
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared5
