import D1Bound5.SmallPairLightAdaptiveData28

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 81; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 82
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
