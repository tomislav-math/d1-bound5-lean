import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 36 through 57, each compared with its entire remaining tail. -/
theorem right_prefix_000_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 22
      (rightCached000.drop 36) (rightRows000.drop 36) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared11
