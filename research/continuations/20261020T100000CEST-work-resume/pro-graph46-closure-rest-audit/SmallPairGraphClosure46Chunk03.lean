import D1Bound5.SmallPairGraphWitnessData46
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared46
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk03_checked :
    pairIndexedWitnessesPrefixBool smallPairA_46 smallPairB_46 anchorRoot
      (10^1100) smallPairClosure_46 64
      (witnesses.drop 192) (destinations.drop 192) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared46
