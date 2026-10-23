import D1Bound5.SmallPairGraphWitnessData17
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared17
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk03_checked :
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 128
      (witnesses.drop 384) (destinations.drop 384) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared17
