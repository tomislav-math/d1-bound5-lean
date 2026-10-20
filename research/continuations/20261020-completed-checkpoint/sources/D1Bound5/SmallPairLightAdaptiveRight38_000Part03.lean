import D1Bound5.SmallPairLightAdaptiveData38

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 140 through 280; each retains its entire original tail. -/
theorem right_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 141
      (rightCached000.drop 140) (rightRows000.drop 140) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared38
