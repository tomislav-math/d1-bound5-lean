import D1Bound5.SmallPairLightAdaptiveData1

namespace D1Bound5.PairLightAdaptivePrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 172 through 213, each compared with its entire remaining tail. -/
theorem right_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 42
      (rightCached001.drop 34) (rightRows001.drop 34) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared1
