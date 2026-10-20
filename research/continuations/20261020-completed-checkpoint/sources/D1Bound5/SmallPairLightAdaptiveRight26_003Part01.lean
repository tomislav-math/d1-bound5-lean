import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 190 through 201; every full later-vertex tail retained. -/
theorem right_prefix_003_part01_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (rightCached003.drop 12) (rightRows003.drop 12) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
