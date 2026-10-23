import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 82 through 107, each compared with its entire remaining tail. -/
theorem left_prefix_000_part04_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 26
      (leftCached000.drop 82) (leftRows000.drop 82) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared46
