import D1Bound5.SmallPairLightAdaptiveData38

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 38 through 81; each retains its entire original tail. -/
theorem right_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 44
      (rightCached000.drop 38) (rightRows000.drop 38) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared38
