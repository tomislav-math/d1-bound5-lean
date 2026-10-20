import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 250 through 250; every full later-vertex tail retained. -/
theorem left_prefix_003_part06_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 1
      (leftCached003.drop 72) (leftRows003.drop 72) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
