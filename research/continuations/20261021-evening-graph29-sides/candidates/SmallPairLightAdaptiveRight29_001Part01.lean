import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 163 through 208, each compared with its entire remaining tail. -/
theorem right_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 46
      (rightCached001.drop 38) (rightRows001.drop 38) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
