import D1Bound5.SmallPairLightAdaptiveData28

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 184 through 334; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 151
      leftCached002 leftRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
