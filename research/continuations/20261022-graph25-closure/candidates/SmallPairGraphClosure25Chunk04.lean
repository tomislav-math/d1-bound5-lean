import D1Bound5.SmallPairGraphWitnessData25
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared25
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk04_checked :
    pairIndexedWitnessesPrefixBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 64
      (witnesses.drop 256) (destinations.drop 256) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared25
