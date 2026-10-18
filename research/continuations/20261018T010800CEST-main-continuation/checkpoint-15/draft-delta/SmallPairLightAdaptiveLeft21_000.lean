import D1Bound5.SmallPairLightAdaptiveData21

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 81; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 82
      leftCached000 leftRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared21
