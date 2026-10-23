import D1Bound5.SmallPairLightAdaptiveData45

namespace D1Bound5.PairLightAdaptivePrepared45
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 43 through 102; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 5 PairLightPrepared45.sieve 60
      rightCached001 rightRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared45
