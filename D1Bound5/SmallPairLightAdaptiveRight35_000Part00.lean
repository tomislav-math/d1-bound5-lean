import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 27; each retains its entire original tail. -/
theorem right_prefix_000_part00_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 28
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
