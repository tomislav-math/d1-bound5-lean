import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 36 through 38 of the original first block; every full tail is retained. -/
theorem right_prefix_000_part12_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 36) (rightRows000.drop 36) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
