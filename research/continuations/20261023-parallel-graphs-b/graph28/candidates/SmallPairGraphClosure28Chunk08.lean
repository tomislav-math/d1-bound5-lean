import D1Bound5.SmallPairGraphWitnessData28
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared28
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination list. -/
theorem indexed_chunk08_checked :
    pairIndexedWitnessesPrefixBool smallPairA_28 smallPairB_28 anchorRoot
      (10^1100) smallPairClosure_28 64
      (witnesses.drop 512) (destinations.drop 512) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared28
