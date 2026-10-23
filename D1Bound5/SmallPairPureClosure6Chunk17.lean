import D1Bound5.SmallPairPureClosureData6

namespace D1Bound5.PairLightClosurePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both signs retain the full original global destination vertex list. -/
theorem chunk17_checked :
    pairLightIndexedWitnessesPrefixBool 0 1 a b anchorRoot (10^1100) vertices 64
      (witnesses.drop 1088) (destinations.drop 1088) = true := by
  decide +kernel

end D1Bound5.PairLightClosurePrepared6
