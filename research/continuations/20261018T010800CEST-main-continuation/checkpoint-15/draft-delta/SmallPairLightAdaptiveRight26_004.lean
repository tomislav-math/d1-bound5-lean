import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 251 through 335; every head retains its entire tail. -/
theorem right_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 85
      rightCached004 rightRows004 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
