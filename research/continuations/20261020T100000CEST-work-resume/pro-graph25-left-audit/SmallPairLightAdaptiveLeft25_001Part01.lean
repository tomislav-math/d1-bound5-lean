import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 164 through 209, each compared with its entire remaining tail. -/
theorem left_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 46
      (leftCached001.drop 38) (leftRows001.drop 38) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared25
