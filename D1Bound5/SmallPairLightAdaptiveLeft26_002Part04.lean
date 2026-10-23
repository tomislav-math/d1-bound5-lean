import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 125 through 127; all later vertices retained. -/
theorem left_prefix_002_part04_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached002.drop 12) (leftRows002.drop 12) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
