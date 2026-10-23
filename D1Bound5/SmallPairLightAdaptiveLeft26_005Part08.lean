import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 432 through 442; every full later-vertex tail retained. -/
theorem left_prefix_005_part08_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 11
      (leftCached005.drop 96) (leftRows005.drop 96) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
