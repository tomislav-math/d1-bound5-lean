import D1Bound5.SmallPairLightAdaptiveData48

namespace D1Bound5.PairLightAdaptivePrepared48
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 134 through 136; each retains its entire original tail. -/
theorem left_prefix_000_part04_checked :
    pairLightSelectedFloorPrefixBool 1 8 PairLightPrepared48.sieve 3
      (leftCached000.drop 134) (leftRows000.drop 134) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared48
