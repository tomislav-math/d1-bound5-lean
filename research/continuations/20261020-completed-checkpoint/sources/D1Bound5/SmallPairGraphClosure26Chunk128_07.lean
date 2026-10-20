import D1Bound5.SmallPairGraphWitnessData26
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared26
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs and original global destination indices are preserved. -/
theorem indexed_chunk128_07_checked :
    pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 896) (destinations.drop 896) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared26
