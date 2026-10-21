import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 23, each compared with its entire remaining tail. -/
theorem left_prefix_000_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 24
      (leftCached000.drop 0) (leftRows000.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared25
