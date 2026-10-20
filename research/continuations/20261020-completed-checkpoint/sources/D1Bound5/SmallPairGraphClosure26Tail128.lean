import D1Bound5.SmallPairGraphWitnessData26
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared26
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Tail pilot: exactly rows 1397 through 1524, with original global destinations. -/
theorem indexed_tail128_checked :
    pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 1397) (destinations.drop 1397) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared26
