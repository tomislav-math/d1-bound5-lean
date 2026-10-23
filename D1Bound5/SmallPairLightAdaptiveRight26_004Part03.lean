import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 287 through 298; every full later-vertex tail retained. -/
theorem right_prefix_004_part03_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (rightCached004.drop 36) (rightRows004.drop 36) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
