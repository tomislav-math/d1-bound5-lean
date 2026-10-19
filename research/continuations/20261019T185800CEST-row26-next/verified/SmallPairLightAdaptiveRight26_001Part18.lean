import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 108 through 110; all later vertices retained. -/
theorem right_prefix_001_part18_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached001.drop 54) (rightRows001.drop 54) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
