import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 335 through 335; every full later-vertex tail retained. -/
theorem left_prefix_004_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 1
      (leftCached004.drop 84) (leftRows004.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
