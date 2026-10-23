import D1Bound5.SmallPairLightAdaptiveData48

namespace D1Bound5.PairLightAdaptivePrepared48
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 138 through 188; each retains its entire original tail. -/
theorem right_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 51
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared48
