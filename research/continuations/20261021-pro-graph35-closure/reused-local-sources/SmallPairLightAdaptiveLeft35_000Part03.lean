import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 92 through 129; each retains its entire original tail. -/
theorem left_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 38
      (leftCached000.drop 92) (leftRows000.drop 92) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared35
