import D1Bound5.SmallPairLightAdaptiveData23

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 212 through 481; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 270
      leftCached002 leftRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared23
