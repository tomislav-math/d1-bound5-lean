import D1Bound5.SmallPairGraphWitnessData12
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared12
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk01_checked :
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 128) (destinations.drop 128) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared12
