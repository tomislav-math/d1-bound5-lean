import D1Bound5.SmallPairGraphWitnessData36
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared36
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination list. -/
theorem indexed_chunk12_checked :
    pairIndexedWitnessesPrefixBool smallPairA_36 smallPairB_36 anchorRoot
      (10^1100) smallPairClosure_36 64
      (witnesses.drop 768) (destinations.drop 768) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared36
