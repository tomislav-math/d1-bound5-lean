import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 16 through 35, each compared with its entire remaining tail. -/
theorem right_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 20
      (rightCached000.drop 16) (rightRows000.drop 16) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared46
