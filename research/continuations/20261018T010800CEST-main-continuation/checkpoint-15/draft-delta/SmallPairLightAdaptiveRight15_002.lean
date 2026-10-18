import D1Bound5.SmallPairLightAdaptiveData15

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 214 through 479; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 266
      rightCached002 rightRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared15
