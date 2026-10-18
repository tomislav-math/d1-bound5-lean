import D1Bound5.SmallPairLightAdaptiveData4

namespace D1Bound5.PairLightAdaptivePrepared4
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 70; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 71
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
