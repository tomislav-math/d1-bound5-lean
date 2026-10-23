import D1Bound5.SmallPairLightAdaptiveData40

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 28; each retains its entire original tail. -/
theorem right_prefix_000_part00_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 29
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared40
