import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 240 through 368; each retains its entire original tail. -/
theorem left_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 129
      (leftCached001.drop 108) (leftRows001.drop 108) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
