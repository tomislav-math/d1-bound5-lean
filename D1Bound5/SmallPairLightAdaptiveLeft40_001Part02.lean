import D1Bound5.SmallPairLightAdaptiveData40

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 260 through 359; each retains its entire original tail. -/
theorem left_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 100
      (leftCached001.drop 123) (leftRows001.drop 123) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared40
