import D1Bound5.SmallPairLightAdaptiveData38

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 279; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 280
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared38
