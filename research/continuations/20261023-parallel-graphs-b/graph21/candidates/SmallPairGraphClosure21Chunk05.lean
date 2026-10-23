import D1Bound5.SmallPairGraphWitnessData21
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared21
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination list. -/
theorem indexed_chunk05_checked :
    pairIndexedWitnessesPrefixBool smallPairA_21 smallPairB_21 anchorRoot
      (10^1100) smallPairClosure_21 64
      (witnesses.drop 320) (destinations.drop 320) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared21
