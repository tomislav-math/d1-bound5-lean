import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 551 through 562; every full later-vertex tail retained. -/
theorem left_prefix_006_part09_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (leftCached006.drop 108) (leftRows006.drop 108) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
