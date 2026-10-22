import D1Bound5.SmallPairLightAdaptiveData1

namespace D1Bound5.PairLightAdaptivePrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 58 through 81, each compared with its entire remaining tail. -/
theorem right_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 24
      (rightCached000.drop 58) (rightRows000.drop 58) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared1
