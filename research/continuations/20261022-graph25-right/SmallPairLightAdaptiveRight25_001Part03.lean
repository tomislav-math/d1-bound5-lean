import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 273 through 380, each compared with its entire remaining tail. -/
theorem right_prefix_001_part03_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 108
      (rightCached001.drop 148) (rightRows001.drop 148) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared25
