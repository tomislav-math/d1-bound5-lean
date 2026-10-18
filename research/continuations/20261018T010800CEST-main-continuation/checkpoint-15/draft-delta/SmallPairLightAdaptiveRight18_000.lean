import D1Bound5.SmallPairLightAdaptiveData18

namespace D1Bound5.PairLightAdaptivePrepared18
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 261; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared18.sieve 262
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared18
