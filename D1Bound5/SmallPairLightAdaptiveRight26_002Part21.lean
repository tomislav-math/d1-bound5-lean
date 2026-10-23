import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 176 through 177; all later vertices retained. -/
theorem right_prefix_002_part21_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 2
      (rightCached002.drop 63) (rightRows002.drop 63) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
