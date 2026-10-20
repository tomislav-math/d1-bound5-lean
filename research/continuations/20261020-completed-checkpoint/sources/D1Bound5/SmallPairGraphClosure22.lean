import D1Bound5.SmallPairGraphClosure22Chunk00
import D1Bound5.SmallPairGraphClosure22Chunk01
import D1Bound5.SmallPairGraphClosure22Chunk02
import D1Bound5.SmallPairGraphClosure22Chunk03
import D1Bound5.SmallPairGraphClosure22Chunk04
import D1Bound5.SmallPairGraphClosure22Chunk05
import D1Bound5.SmallPairGraphClosure22Chunk06
import D1Bound5.SmallPairGraphClosure22Chunk07
import D1Bound5.SmallPairGraphClosure22Chunk08

set_option autoImplicit false

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared22

theorem PairGraphPrepared22.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 witnesses destinations = true := by
  have hcoverage : decide (anchorRoot * anchorRoot = smallPairA_22 * smallPairB_22 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_22) = true := by
    decide +kernel
  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22
    witnesses destinations hcoverage
  have h009 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 963) (destinations.drop 963) = true := by
    rfl
  have h008 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 896)
      (destinations.drop 896) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 67
      (witnesses.drop 896) (destinations.drop 896)
      indexed_chunk08_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h009
  have h007 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 768)
      (destinations.drop 768) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 128
      (witnesses.drop 768) (destinations.drop 768)
      indexed_chunk07_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h008
  have h006 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 640)
      (destinations.drop 640) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 128
      (witnesses.drop 640) (destinations.drop 640)
      indexed_chunk06_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h007
  have h005 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 512)
      (destinations.drop 512) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 128
      (witnesses.drop 512) (destinations.drop 512)
      indexed_chunk05_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h006
  have h004 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 384)
      (destinations.drop 384) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 128
      (witnesses.drop 384) (destinations.drop 384)
      indexed_chunk04_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h005
  have h003 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 256)
      (destinations.drop 256) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 128
      (witnesses.drop 256) (destinations.drop 256)
      indexed_chunk03_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h004
  have h002 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 128)
      (destinations.drop 128) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 128
      (witnesses.drop 128) (destinations.drop 128)
      indexed_chunk02_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h003
  have h001 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 64)
      (destinations.drop 64) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 64
      (witnesses.drop 64) (destinations.drop 64)
      indexed_chunk01_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h002
  have h000 : pairIndexedWitnessesCheckedBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 (witnesses.drop 0)
      (destinations.drop 0) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_22 smallPairB_22 anchorRoot (10^1100) smallPairClosure_22 64
      (witnesses.drop 0) (destinations.drop 0)
      indexed_chunk00_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h001
  simpa only [List.drop_zero] using h000

theorem smallPairClosure_22_checked :
    pairClosureBool smallPairA_22 smallPairB_22
      (10^1100) smallPairClosure_22 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_22 smallPairB_22 anchorRoot
    (10^1100) smallPairClosure_22 witnesses destinations PairGraphPrepared22.indexed_checked

end D1Bound5
