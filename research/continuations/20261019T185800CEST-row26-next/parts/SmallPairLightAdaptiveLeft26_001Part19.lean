import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 111 through 112; all later vertices retained. -/
theorem left_prefix_001_part19_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 2
      (leftCached001.drop 57) (leftRows001.drop 57) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
