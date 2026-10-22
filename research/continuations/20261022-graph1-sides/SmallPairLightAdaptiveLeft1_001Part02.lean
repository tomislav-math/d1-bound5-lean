import D1Bound5.SmallPairLightAdaptiveData1

namespace D1Bound5.PairLightAdaptivePrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 213 through 268, each compared with its entire remaining tail. -/
theorem left_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 56
      (leftCached001.drop 76) (leftRows001.drop 76) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared1
