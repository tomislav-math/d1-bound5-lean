import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 209 through 272, each compared with its entire remaining tail. -/
theorem right_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 64
      (rightCached001.drop 84) (rightRows001.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
