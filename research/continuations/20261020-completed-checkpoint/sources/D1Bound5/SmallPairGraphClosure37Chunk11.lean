import D1Bound5.SmallPairGraphWitnessData37
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared37
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk11_checked :
    pairIndexedWitnessesPrefixBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 42
      (witnesses.drop 704) (destinations.drop 704) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared37
