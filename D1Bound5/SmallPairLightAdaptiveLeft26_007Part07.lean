import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 700 through 711; every full later-vertex tail retained. -/
theorem left_prefix_007_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (leftCached007.drop 84) (leftRows007.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
