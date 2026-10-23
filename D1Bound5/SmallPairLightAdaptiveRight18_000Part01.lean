import D1Bound5.SmallPairLightAdaptiveData18

namespace D1Bound5.PairLightAdaptivePrepared18
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 35 through 76; each retains its entire original tail. -/
theorem right_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared18.sieve 42
      (rightCached000.drop 35) (rightRows000.drop 35) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared18
