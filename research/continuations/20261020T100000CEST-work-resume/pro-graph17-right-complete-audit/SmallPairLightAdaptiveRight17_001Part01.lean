import D1Bound5.SmallPairLightAdaptiveData17

namespace D1Bound5.PairLightAdaptivePrepared17
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 189 through 264; each retains its entire original tail. -/
theorem right_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 76
      (rightCached001.drop 51) (rightRows001.drop 51) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared17
