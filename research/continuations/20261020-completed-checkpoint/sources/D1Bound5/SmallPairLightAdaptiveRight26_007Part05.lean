import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 676 through 687; every full later-vertex tail retained. -/
theorem right_prefix_007_part05_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (rightCached007.drop 60) (rightRows007.drop 60) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
