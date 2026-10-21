import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 179 through 241; each retains its entire original tail. -/
theorem right_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 63
      (rightCached001.drop 47) (rightRows001.drop 47) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
