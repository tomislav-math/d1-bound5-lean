import D1Bound5.SmallPairGraphWitnessData7
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared7
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk01_checked :
    pairIndexedWitnessesPrefixBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 64
      (witnesses.drop 64) (destinations.drop 64) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared7
