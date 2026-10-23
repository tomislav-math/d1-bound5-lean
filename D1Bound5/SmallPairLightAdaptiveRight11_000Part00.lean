import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 15, each compared with its entire remaining tail. -/
theorem right_prefix_000_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 16
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared11
