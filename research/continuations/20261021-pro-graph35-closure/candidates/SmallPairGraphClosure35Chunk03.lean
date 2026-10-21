import D1Bound5.SmallPairGraphWitnessData35
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared35
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk03_checked :
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 128
      (witnesses.drop 384) (destinations.drop 384) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared35
