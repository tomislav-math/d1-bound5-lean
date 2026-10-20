import D1Bound5.SmallPairGraphWitnessData22
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared22
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk01_checked :
    pairIndexedWitnessesPrefixBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 64
      (witnesses.drop 64) (destinations.drop 64) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared22
