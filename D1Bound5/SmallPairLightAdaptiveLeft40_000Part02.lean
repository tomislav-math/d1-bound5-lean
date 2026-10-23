import D1Bound5.SmallPairLightAdaptiveData40

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 59 through 93; each retains its entire original tail. -/
theorem left_prefix_000_part02_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 35
      (leftCached000.drop 59) (leftRows000.drop 59) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared40
