import D1Bound5.SmallPairLightAdaptiveData48

namespace D1Bound5.PairLightAdaptivePrepared48
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 137; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 138
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared48
