import D1Bound5.SmallPairPureClosureData36

namespace D1Bound5.PairLightClosurePrepared36
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both signs retain the full original global destination vertex list. -/
theorem chunk17_checked :
    pairLightIndexedWitnessesPrefixBool 1 2 a b anchorRoot (10^1100) vertices 35
      (witnesses.drop 1088) (destinations.drop 1088) = true := by
  decide +kernel

end D1Bound5.PairLightClosurePrepared36
