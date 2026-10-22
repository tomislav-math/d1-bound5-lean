import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 108 through 137, each compared with its entire remaining tail. -/
theorem left_prefix_000_part05_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 30
      (leftCached000.drop 108) (leftRows000.drop 108) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared11
