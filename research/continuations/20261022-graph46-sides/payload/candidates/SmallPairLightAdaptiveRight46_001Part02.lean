import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 214 through 269, each compared with its entire remaining tail. -/
theorem right_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 56
      (rightCached001.drop 76) (rightRows001.drop 76) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared46
