import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 29 through 59; every head retains its complete original tail. -/
theorem left_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 31
      (leftCached000.drop 29) (leftRows000.drop 29) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
