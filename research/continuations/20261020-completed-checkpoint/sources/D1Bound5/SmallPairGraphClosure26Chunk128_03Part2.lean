import D1Bound5.SmallPairGraphWitnessData26
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared26
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original global vertex list; exactly 32 aligned witness/destination rows. -/
theorem indexed_chunk128_03_part2_checked :
    pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 448) (destinations.drop 448) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared26
