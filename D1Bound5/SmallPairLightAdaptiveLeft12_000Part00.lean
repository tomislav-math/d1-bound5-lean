import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 28; every head retains its complete original tail. -/
theorem left_prefix_000_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 29
      (leftCached000.drop 0) (leftRows000.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared12
