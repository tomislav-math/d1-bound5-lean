import D1Bound5.SmallPairGraphClosure26Chunk128_03Part0
import D1Bound5.SmallPairGraphClosure26Chunk128_03Part1
import D1Bound5.SmallPairGraphClosure26Chunk128_03Part2
import D1Bound5.SmallPairGraphClosure26Chunk128_03Part3

namespace D1Bound5.PairGraphPrepared26
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Both mutation signs and original global destination indices are preserved. -/
theorem indexed_chunk128_03_checked :
    pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 384) (destinations.drop 384) = true := by
  have h064 : pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 64
      (witnesses.drop 448) (destinations.drop 448) = true := by
    apply (pairIndexedWitnessesPrefixBool_add smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32 32
      (witnesses.drop 448) (destinations.drop 448)).trans
    refine Bool.and_eq_true_iff.mpr ⟨indexed_chunk128_03_part2_checked, ?_⟩
    simpa only [List.drop_drop, Nat.reduceAdd] using indexed_chunk128_03_part3_checked
  have h096 : pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 96
      (witnesses.drop 416) (destinations.drop 416) = true := by
    apply (pairIndexedWitnessesPrefixBool_add smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32 64
      (witnesses.drop 416) (destinations.drop 416)).trans
    refine Bool.and_eq_true_iff.mpr ⟨indexed_chunk128_03_part1_checked, ?_⟩
    simpa only [List.drop_drop, Nat.reduceAdd] using h064
  apply (pairIndexedWitnessesPrefixBool_add smallPairA_26 smallPairB_26 anchorRoot
    (10^1100) smallPairClosure_26 32 96
    (witnesses.drop 384) (destinations.drop 384)).trans
  refine Bool.and_eq_true_iff.mpr ⟨indexed_chunk128_03_part0_checked, ?_⟩
  simpa only [List.drop_drop, Nat.reduceAdd] using h096

end D1Bound5.PairGraphPrepared26
