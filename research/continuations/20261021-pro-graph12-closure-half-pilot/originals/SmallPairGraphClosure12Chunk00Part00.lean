import D1Bound5.SmallPairGraphWitnessData12
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared12
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original rows 0 through 63, both mutation signs and the full destination vertex list. -/
theorem indexed_chunk00_part00_checked :
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 64
      (witnesses.drop 0) (destinations.drop 0) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared12
