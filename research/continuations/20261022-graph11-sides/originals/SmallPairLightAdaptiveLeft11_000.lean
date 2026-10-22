import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 137; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 138
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared11
