import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 95 through 135; every head retains its complete original tail. -/
theorem right_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 41
      (rightCached000.drop 95) (rightRows000.drop 95) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
