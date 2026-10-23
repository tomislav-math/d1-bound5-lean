import D1Bound5.SmallPairGraphWitnessData1
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared1
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk06_checked :
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 384) (destinations.drop 384) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared1
