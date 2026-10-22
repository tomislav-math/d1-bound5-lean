import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 137 through 170, each compared with its entire remaining tail. -/
theorem left_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 34
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared46
