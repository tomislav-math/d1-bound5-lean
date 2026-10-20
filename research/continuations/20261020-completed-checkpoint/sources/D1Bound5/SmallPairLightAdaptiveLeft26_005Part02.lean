import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 360 through 371; every full later-vertex tail retained. -/
theorem left_prefix_005_part02_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (leftCached005.drop 24) (leftRows005.drop 24) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
