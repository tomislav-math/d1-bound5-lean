import D1Bound5.SmallPairLightAdaptiveData40

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 137 through 186; each retains its entire original tail. -/
theorem left_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 50
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared40
