import D1Bound5.SmallPairGraphWitnessData5
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared5
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk13_checked :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 31
      (witnesses.drop 832) (destinations.drop 832) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared5
