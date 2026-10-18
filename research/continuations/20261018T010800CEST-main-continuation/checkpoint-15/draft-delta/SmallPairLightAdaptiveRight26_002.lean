import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 113 through 177; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 65
      rightCached002 rightRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
