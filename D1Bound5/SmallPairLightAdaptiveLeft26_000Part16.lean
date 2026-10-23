import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 48 through 50 of the original first block; every full tail is retained. -/
theorem left_prefix_000_part16_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 48) (leftRows000.drop 48) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
