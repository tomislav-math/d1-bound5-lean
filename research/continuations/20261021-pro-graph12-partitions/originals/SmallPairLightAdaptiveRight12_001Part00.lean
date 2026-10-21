import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 138 through 188; every head retains its complete original tail. -/
theorem right_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 51
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
