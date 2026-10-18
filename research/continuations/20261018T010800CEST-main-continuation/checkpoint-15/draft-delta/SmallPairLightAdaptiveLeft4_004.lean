import D1Bound5.SmallPairLightAdaptiveData4

namespace D1Bound5.PairLightAdaptivePrepared4
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 405 through 595; every head retains its entire tail. -/
theorem left_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 191
      leftCached004 leftRows004 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
