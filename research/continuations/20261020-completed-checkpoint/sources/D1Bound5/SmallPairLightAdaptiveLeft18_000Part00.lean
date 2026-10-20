import D1Bound5.SmallPairLightAdaptiveData18

namespace D1Bound5.PairLightAdaptivePrepared18
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 34; each retains its entire original tail. -/
theorem left_prefix_000_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared18.sieve 35
      (leftCached000.drop 0) (leftRows000.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared18
