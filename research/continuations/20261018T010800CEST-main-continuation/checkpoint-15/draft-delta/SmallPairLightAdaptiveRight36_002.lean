import D1Bound5.SmallPairLightAdaptiveData36

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 167 through 286; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 120
      rightCached002 rightRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
