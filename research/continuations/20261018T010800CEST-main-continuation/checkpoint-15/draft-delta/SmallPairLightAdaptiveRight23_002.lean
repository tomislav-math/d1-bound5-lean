import D1Bound5.SmallPairLightAdaptiveData23

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 214 through 479; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 266
      rightCached002 rightRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared23
