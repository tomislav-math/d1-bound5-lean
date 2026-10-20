import D1Bound5.SmallPairLightAdaptiveData33

namespace D1Bound5.PairLightAdaptivePrepared33
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 187 through 259; each retains its entire original tail. -/
theorem left_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared33.sieve 73
      (leftCached001.drop 50) (leftRows001.drop 50) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared33
