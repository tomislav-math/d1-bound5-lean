import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 270 through 357, each compared with its entire remaining tail. -/
theorem right_prefix_001_part03_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 88
      (rightCached001.drop 132) (rightRows001.drop 132) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared46
