import D1Bound5.SmallPairLightAdaptiveData14

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 88 through 201; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 114
      leftCached001 leftRows001 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared14
