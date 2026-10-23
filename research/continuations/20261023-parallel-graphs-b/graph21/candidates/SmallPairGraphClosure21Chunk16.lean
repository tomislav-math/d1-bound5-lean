import D1Bound5.SmallPairGraphWitnessData21
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared21
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination list. -/
theorem indexed_chunk16_checked :
    pairIndexedWitnessesPrefixBool smallPairA_21 smallPairB_21 anchorRoot
      (10^1100) smallPairClosure_21 25
      (witnesses.drop 1024) (destinations.drop 1024) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared21
