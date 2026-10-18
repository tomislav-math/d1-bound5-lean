import D1Bound5.SmallPairLightAdaptiveData13

namespace D1Bound5.PairLightAdaptivePrepared13
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 247; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared13.sieve 248
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared13
