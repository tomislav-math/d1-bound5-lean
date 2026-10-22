import D1Bound5.SmallPairGraphWitnessData11
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared11
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk04_checked :
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 256) (destinations.drop 256) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared11
