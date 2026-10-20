import D1Bound5.SmallPairGraphWitnessData33
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared33
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk00_checked :
    pairIndexedWitnessesPrefixBool smallPairA_33 smallPairB_33 anchorRoot
      (10^1100) smallPairClosure_33 128
      (witnesses.drop 0) (destinations.drop 0) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared33
