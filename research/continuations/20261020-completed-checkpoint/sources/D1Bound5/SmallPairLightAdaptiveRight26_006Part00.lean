import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 443 through 454; every full later-vertex tail retained. -/
theorem right_prefix_006_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (rightCached006.drop 0) (rightRows006.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
