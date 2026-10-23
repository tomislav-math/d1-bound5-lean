import D1Bound5.SmallPairLightAdaptiveData38

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 37 through 81; each retains its entire original tail. -/
theorem left_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 45
      (leftCached000.drop 37) (leftRows000.drop 37) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared38
