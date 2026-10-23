import D1Bound5.SmallPairGraphWitnessData19
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared19
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk13_checked :
    pairIndexedWitnessesPrefixBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 61
      (witnesses.drop 832) (destinations.drop 832) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared19
