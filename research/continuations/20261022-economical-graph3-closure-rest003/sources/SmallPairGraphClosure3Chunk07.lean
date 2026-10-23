import D1Bound5.SmallPairGraphClosure3Chunk07Part00
import D1Bound5.SmallPairGraphClosure3Chunk07Part01
import D1Bound5.SmallPairGraphClosure3Chunk07Part02
import D1Bound5.SmallPairGraphClosure3Chunk07Part03
import D1Bound5.SmallPairGraphWitnessData3
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared3
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs use the complete original destination vertex list. -/
theorem indexed_chunk07_checked :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 64
      (witnesses.drop 448) (destinations.drop 448) = true := by
  have h32 : pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot (10^1100) smallPairClosure_3 32 (witnesses.drop 480) (destinations.drop 480) = true := by
    change pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot (10^1100) smallPairClosure_3 (16 + 16) (witnesses.drop 480) (destinations.drop 480) = true
    rw [pairIndexedWitnessesPrefixBool_add]
    apply Bool.and_eq_true_iff.mpr
    constructor
    · exact indexed_chunk07_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using indexed_chunk07_part03_checked
  have h48 : pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot (10^1100) smallPairClosure_3 48 (witnesses.drop 464) (destinations.drop 464) = true := by
    change pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot (10^1100) smallPairClosure_3 (16 + 32) (witnesses.drop 464) (destinations.drop 464) = true
    rw [pairIndexedWitnessesPrefixBool_add]
    apply Bool.and_eq_true_iff.mpr
    constructor
    · exact indexed_chunk07_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h32
  have h64 : pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot (10^1100) smallPairClosure_3 64 (witnesses.drop 448) (destinations.drop 448) = true := by
    change pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot (10^1100) smallPairClosure_3 (16 + 48) (witnesses.drop 448) (destinations.drop 448) = true
    rw [pairIndexedWitnessesPrefixBool_add]
    apply Bool.and_eq_true_iff.mpr
    constructor
    · exact indexed_chunk07_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h48
  exact h64

end D1Bound5.PairGraphPrepared3
