import D1Bound5.SmallPairLightAdaptiveData21

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 184 through 334; every head retains its entire tail. -/
theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 151
      rightCached002 rightRows002 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared21
