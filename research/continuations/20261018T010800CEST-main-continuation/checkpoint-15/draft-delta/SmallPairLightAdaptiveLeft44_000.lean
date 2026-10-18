import D1Bound5.SmallPairLightAdaptiveData44

namespace D1Bound5.PairLightAdaptivePrepared44
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 219; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 4 PairLightPrepared44.sieve 220
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared44
