import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 78 through 108, each compared with its entire remaining tail. -/
theorem right_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 31
      (rightCached000.drop 78) (rightRows000.drop 78) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared25
