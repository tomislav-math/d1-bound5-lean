import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 125 through 162, each compared with its entire remaining tail. -/
theorem right_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 38
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
