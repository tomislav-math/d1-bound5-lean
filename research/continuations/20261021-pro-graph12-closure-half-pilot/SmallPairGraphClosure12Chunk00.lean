import D1Bound5.SmallPairGraphClosure12Chunk00Part00
import D1Bound5.SmallPairGraphClosure12Chunk00Part01
import D1Bound5.SmallPairGraphWitnessData12
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared12
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Full original vertex list and both signs; only aligned row lists are sliced. -/
theorem indexed_chunk00_checked :
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 0) (destinations.drop 0) = true := by
  exact (pairIndexedWitnessesPrefixBool_add smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 64 64 (witnesses.drop 0) (destinations.drop 0)).trans
    (Bool.and_eq_true_iff.mpr ⟨indexed_chunk00_part00_checked, by
      simpa only [List.drop_drop, Nat.reduceAdd] using indexed_chunk00_part01_checked⟩)

end D1Bound5.PairGraphPrepared12
