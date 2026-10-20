import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 18 through 20 of the original first block; every full tail is retained. -/
theorem left_prefix_000_part06_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 18) (leftRows000.drop 18) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
