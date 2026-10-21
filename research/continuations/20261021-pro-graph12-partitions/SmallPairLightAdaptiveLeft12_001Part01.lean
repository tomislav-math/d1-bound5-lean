import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 189 through 264; every head retains its complete original tail. -/
theorem left_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 76
      (leftCached001.drop 51) (leftRows001.drop 51) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
