import D1Bound5.SmallPairPureClosureData4

namespace D1Bound5.PairLightClosurePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both signs retain the full original global destination vertex list. -/
theorem chunk13_checked :
    pairLightIndexedWitnessesPrefixBool 0 1 a b anchorRoot (10^1100) vertices 64
      (witnesses.drop 832) (destinations.drop 832) = true := by
  decide +kernel

end D1Bound5.PairLightClosurePrepared4
