import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 136 through 137; every head retains its complete original tail. -/
theorem right_prefix_000_part04_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 2
      (rightCached000.drop 136) (rightRows000.drop 136) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
