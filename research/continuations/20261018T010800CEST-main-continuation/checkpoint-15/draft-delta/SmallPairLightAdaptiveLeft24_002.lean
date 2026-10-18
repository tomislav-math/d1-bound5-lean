import D1Bound5.SmallPairLightAdaptiveData24

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 248 through 445; every head retains its entire tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 198
      leftCached002 leftRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared24
