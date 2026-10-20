import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 611 through 615; every full later-vertex tail retained. -/
theorem right_prefix_006_part14_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 5
      (rightCached006.drop 168) (rightRows006.drop 168) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
