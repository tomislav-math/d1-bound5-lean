import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 126 through 163, each compared with its entire remaining tail. -/
theorem left_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 38
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
