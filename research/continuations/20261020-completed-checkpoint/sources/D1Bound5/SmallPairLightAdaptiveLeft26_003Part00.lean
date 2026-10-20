import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads178 through189; every head keeps its entire later-vertex tail. -/
theorem left_prefix_003_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 12
      (leftCached003.drop 0) (leftRows003.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared26
