import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 84 through 86; all later vertices retained. -/
theorem right_prefix_001_part10_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached001.drop 30) (rightRows001.drop 30) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
