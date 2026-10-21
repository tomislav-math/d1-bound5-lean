import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 78 through 108, each compared with its entire remaining tail. -/
theorem left_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 31
      (leftCached000.drop 78) (leftRows000.drop 78) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
