import D1Bound5.SmallPairGraphWitnessData3
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared3
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk06_checked :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 64
      (witnesses.drop 384) (destinations.drop 384) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared3
