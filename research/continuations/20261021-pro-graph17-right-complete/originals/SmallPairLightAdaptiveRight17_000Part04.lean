import D1Bound5.SmallPairLightAdaptiveData17

namespace D1Bound5.PairLightAdaptivePrepared17
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 137 through 137; each retains its entire original tail. -/
theorem right_prefix_000_part04_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 1
      (rightCached000.drop 137) (rightRows000.drop 137) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared17
