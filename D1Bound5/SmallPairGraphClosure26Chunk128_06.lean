import D1Bound5.SmallPairGraphClosure26Chunk128_06Part0
import D1Bound5.SmallPairGraphClosure26Chunk128_06Part1
import D1Bound5.SmallPairGraphClosure26Chunk128_06Part2
import D1Bound5.SmallPairGraphClosure26Chunk128_06Part3

namespace D1Bound5.PairGraphPrepared26
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs and original global destination indices are preserved. -/
theorem indexed_chunk128_06_checked :
    pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 768) (destinations.drop 768) = true := by
  have h064 : pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 64
      (witnesses.drop 832) (destinations.drop 832) = true := by
    apply (pairIndexedWitnessesPrefixBool_add smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32 32
      (witnesses.drop 832) (destinations.drop 832)).trans
    refine Bool.and_eq_true_iff.mpr ⟨indexed_chunk128_06_part2_checked, ?_⟩
    simpa only [List.drop_drop, Nat.reduceAdd] using indexed_chunk128_06_part3_checked
  have h096 : pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 96
      (witnesses.drop 800) (destinations.drop 800) = true := by
    apply (pairIndexedWitnessesPrefixBool_add smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32 64
      (witnesses.drop 800) (destinations.drop 800)).trans
    refine Bool.and_eq_true_iff.mpr ⟨indexed_chunk128_06_part1_checked, ?_⟩
    simpa only [List.drop_drop, Nat.reduceAdd] using h064
  apply (pairIndexedWitnessesPrefixBool_add smallPairA_26 smallPairB_26 anchorRoot
    (10^1100) smallPairClosure_26 32 96
    (witnesses.drop 768) (destinations.drop 768)).trans
  refine Bool.and_eq_true_iff.mpr ⟨indexed_chunk128_06_part0_checked, ?_⟩
  simpa only [List.drop_drop, Nat.reduceAdd] using h096

end D1Bound5.PairGraphPrepared26
