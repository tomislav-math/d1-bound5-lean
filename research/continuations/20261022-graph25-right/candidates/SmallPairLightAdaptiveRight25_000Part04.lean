import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 109 through 124, each compared with its entire remaining tail. -/
theorem right_prefix_000_part04_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 16
      (rightCached000.drop 109) (rightRows000.drop 109) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared25
