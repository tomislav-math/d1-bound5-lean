import D1Bound5.SmallPairGraphClosure12Coverage
import D1Bound5.SmallPairGraphClosure12Chunk00
import D1Bound5.SmallPairGraphClosure12Chunk01
import D1Bound5.SmallPairGraphClosure12Chunk02
import D1Bound5.SmallPairGraphClosure12Chunk03
import D1Bound5.SmallPairGraphClosure12Chunk04
import D1Bound5.SmallPairGraphClosure12Chunk05

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared12

theorem PairGraphPrepared12.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 witnesses destinations = true := by
  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12
    witnesses destinations indexed_coverage_checked
  have h006 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 720) (destinations.drop 720) = true := by
    rfl
  have h005 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 640)
      (destinations.drop 640) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12 80
      (witnesses.drop 640) (destinations.drop 640)
      indexed_chunk05_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h006
  have h004 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 512)
      (destinations.drop 512) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12 128
      (witnesses.drop 512) (destinations.drop 512)
      indexed_chunk04_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h005
  have h003 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 384)
      (destinations.drop 384) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12 128
      (witnesses.drop 384) (destinations.drop 384)
      indexed_chunk03_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h004
  have h002 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 256)
      (destinations.drop 256) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12 128
      (witnesses.drop 256) (destinations.drop 256)
      indexed_chunk02_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h003
  have h001 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 128)
      (destinations.drop 128) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12 128
      (witnesses.drop 128) (destinations.drop 128)
      indexed_chunk01_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h002
  have h000 : pairIndexedWitnessesCheckedBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 (witnesses.drop 0)
      (destinations.drop 0) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_12 smallPairB_12 anchorRoot (10^1100) smallPairClosure_12 128
      (witnesses.drop 0) (destinations.drop 0)
      indexed_chunk00_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h001
  simpa only [List.drop_zero] using h000

theorem smallPairClosure_12_checked :
    pairClosureBool smallPairA_12 smallPairB_12
      (10^1100) smallPairClosure_12 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_12 smallPairB_12 anchorRoot
    (10^1100) smallPairClosure_12 witnesses destinations PairGraphPrepared12.indexed_checked

end D1Bound5
