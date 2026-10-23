import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 132 through 177; each retains its entire original tail. -/
theorem left_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 46
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
