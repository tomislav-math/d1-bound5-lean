import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 57; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 58
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
