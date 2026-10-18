import D1Bound5.SmallPairLightAdaptiveData1

namespace D1Bound5.PairLightAdaptivePrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 138 through 357; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 220
      rightCached001 rightRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared1
