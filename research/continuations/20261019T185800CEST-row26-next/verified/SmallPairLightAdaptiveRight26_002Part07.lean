import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 134 through 136; all later vertices retained. -/
theorem right_prefix_002_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached002.drop 21) (rightRows002.drop 21) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
