import D1Bound5.SmallPairLightAdaptiveData33

namespace D1Bound5.PairLightAdaptivePrepared33
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 96 through 136; each retains its entire original tail. -/
theorem right_prefix_000_part03_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared33.sieve 41
      (rightCached000.drop 96) (rightRows000.drop 96) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared33
