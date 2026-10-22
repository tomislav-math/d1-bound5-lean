import D1Bound5.SmallPairLightAdaptiveData3

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 111; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 112
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared3
