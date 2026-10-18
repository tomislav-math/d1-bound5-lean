import D1Bound5.SmallPairLightAdaptiveData9

namespace D1Bound5.PairLightAdaptivePrepared9
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 218; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared9.sieve 219
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared9
