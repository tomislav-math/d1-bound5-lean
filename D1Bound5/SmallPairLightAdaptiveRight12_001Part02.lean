import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 265 through 358; every head retains its complete original tail. -/
theorem right_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 94
      (rightCached001.drop 127) (rightRows001.drop 127) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
