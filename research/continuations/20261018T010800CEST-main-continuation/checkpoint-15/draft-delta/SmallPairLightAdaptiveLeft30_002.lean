import D1Bound5.SmallPairLightAdaptiveData30

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 212 through 481; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 270
      leftCached002 leftRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared30
