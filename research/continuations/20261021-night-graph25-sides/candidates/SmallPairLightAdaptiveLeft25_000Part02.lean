import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 50 through 77, each compared with its entire remaining tail. -/
theorem left_prefix_000_part02_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 28
      (leftCached000.drop 50) (leftRows000.drop 50) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared25
