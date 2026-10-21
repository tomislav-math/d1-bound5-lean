import D1Bound5.SmallPairGraphWitnessData12
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared12
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original rows 64 through 127, both mutation signs and the full destination vertex list. -/
theorem indexed_chunk00_part01_checked :
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 64
      (witnesses.drop 64) (destinations.drop 64) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared12
