import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 50 through 77, each compared with its entire remaining tail. -/
theorem right_prefix_000_part02_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared29.sieve 28
      (rightCached000.drop 50) (rightRows000.drop 50) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared29
