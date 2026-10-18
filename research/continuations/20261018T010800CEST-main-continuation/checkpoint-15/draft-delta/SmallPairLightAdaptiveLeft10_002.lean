import D1Bound5.SmallPairLightAdaptiveData10

namespace D1Bound5.PairLightAdaptivePrepared10
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 153 through 254; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 102
      leftCached002 leftRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared10
