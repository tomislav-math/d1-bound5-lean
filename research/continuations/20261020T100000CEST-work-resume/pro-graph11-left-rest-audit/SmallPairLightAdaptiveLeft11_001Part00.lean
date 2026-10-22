import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 138 through 171, each compared with its entire remaining tail. -/
theorem left_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 34
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared11
