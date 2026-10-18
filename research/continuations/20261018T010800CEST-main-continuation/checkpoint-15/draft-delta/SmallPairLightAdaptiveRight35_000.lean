import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 131; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 132
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
