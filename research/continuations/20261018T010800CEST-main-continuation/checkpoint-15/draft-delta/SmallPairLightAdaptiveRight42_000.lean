import D1Bound5.SmallPairLightAdaptiveData42

namespace D1Bound5.PairLightAdaptivePrepared42
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 241; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared42.sieve 242
      rightCached000 rightRows000 = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared42
