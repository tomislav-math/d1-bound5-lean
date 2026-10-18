import D1Bound5.SmallPairLightAdaptiveData14

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 417 through 495; every head retains its entire tail. -/
theorem right_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 79
      rightCached003 rightRows003 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared14
