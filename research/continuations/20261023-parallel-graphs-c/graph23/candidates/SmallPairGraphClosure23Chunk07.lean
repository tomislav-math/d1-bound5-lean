import D1Bound5.SmallPairGraphWitnessData23
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared23
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination list. -/
theorem indexed_chunk07_checked :
    pairIndexedWitnessesPrefixBool smallPairA_23 smallPairB_23 anchorRoot
      (10^1100) smallPairClosure_23 64
      (witnesses.drop 448) (destinations.drop 448) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared23
