import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 16 through 35, each compared with its entire remaining tail. -/
theorem left_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 20
      (leftCached000.drop 16) (leftRows000.drop 16) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared11
