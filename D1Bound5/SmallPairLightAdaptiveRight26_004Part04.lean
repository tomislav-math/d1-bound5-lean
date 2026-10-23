import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 299 through 310; every full later-vertex tail retained. -/
theorem right_prefix_004_part04_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (rightCached004.drop 48) (rightRows004.drop 48) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
