import D1Bound5.SmallPairGraphClosure37Chunk00
import D1Bound5.SmallPairGraphClosure37Chunk01
import D1Bound5.SmallPairGraphClosure37Chunk02
import D1Bound5.SmallPairGraphClosure37Chunk03
import D1Bound5.SmallPairGraphClosure37Chunk04
import D1Bound5.SmallPairGraphClosure37Chunk05
import D1Bound5.SmallPairGraphClosure37Chunk06
import D1Bound5.SmallPairGraphClosure37Chunk07
import D1Bound5.SmallPairGraphClosure37Chunk08
import D1Bound5.SmallPairGraphClosure37Chunk09
import D1Bound5.SmallPairGraphClosure37Chunk10
import D1Bound5.SmallPairGraphClosure37Chunk11

set_option autoImplicit false

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared37

theorem PairGraphPrepared37.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 witnesses destinations = true := by
  have hcoverage : decide (anchorRoot * anchorRoot = smallPairA_37 * smallPairB_37 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_37) = true := by
    decide +kernel
  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37
    witnesses destinations hcoverage
  have h012 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 746) (destinations.drop 746) = true := by
    rfl
  have h011 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 704)
      (destinations.drop 704) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 42
      (witnesses.drop 704) (destinations.drop 704)
      indexed_chunk11_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h012
  have h010 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 640)
      (destinations.drop 640) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 640) (destinations.drop 640)
      indexed_chunk10_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h011
  have h009 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 576)
      (destinations.drop 576) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 576) (destinations.drop 576)
      indexed_chunk09_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h010
  have h008 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 512)
      (destinations.drop 512) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 512) (destinations.drop 512)
      indexed_chunk08_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h009
  have h007 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 448)
      (destinations.drop 448) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 448) (destinations.drop 448)
      indexed_chunk07_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h008
  have h006 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 384)
      (destinations.drop 384) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 384) (destinations.drop 384)
      indexed_chunk06_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h007
  have h005 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 320)
      (destinations.drop 320) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 320) (destinations.drop 320)
      indexed_chunk05_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h006
  have h004 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 256)
      (destinations.drop 256) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 256) (destinations.drop 256)
      indexed_chunk04_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h005
  have h003 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 192)
      (destinations.drop 192) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 192) (destinations.drop 192)
      indexed_chunk03_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h004
  have h002 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 128)
      (destinations.drop 128) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 128) (destinations.drop 128)
      indexed_chunk02_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h003
  have h001 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 64)
      (destinations.drop 64) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 64) (destinations.drop 64)
      indexed_chunk01_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h002
  have h000 : pairIndexedWitnessesCheckedBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 (witnesses.drop 0)
      (destinations.drop 0) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_37 smallPairB_37 anchorRoot (10^1100) smallPairClosure_37 64
      (witnesses.drop 0) (destinations.drop 0)
      indexed_chunk00_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h001
  simpa only [List.drop_zero] using h000

theorem smallPairClosure_37_checked :
    pairClosureBool smallPairA_37 smallPairB_37
      (10^1100) smallPairClosure_37 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_37 smallPairB_37 anchorRoot
    (10^1100) smallPairClosure_37 witnesses destinations PairGraphPrepared37.indexed_checked

end D1Bound5
