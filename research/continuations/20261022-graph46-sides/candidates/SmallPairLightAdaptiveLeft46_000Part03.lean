import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 58 through 81, each compared with its entire remaining tail. -/
theorem left_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 24
      (leftCached000.drop 58) (leftRows000.drop 58) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared46
