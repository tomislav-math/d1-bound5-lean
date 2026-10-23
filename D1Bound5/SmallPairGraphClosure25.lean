import D1Bound5.SmallPairGraphClosure25Coverage
import D1Bound5.SmallPairGraphClosure25Chunk00
import D1Bound5.SmallPairGraphClosure25Chunk01
import D1Bound5.SmallPairGraphClosure25Chunk02
import D1Bound5.SmallPairGraphClosure25Chunk03
import D1Bound5.SmallPairGraphClosure25Chunk04
import D1Bound5.SmallPairGraphClosure25Chunk05
import D1Bound5.SmallPairGraphClosure25Chunk06
import D1Bound5.SmallPairGraphClosure25Chunk07
import D1Bound5.SmallPairGraphClosure25Chunk08
import D1Bound5.SmallPairGraphClosure25Chunk09
import D1Bound5.SmallPairGraphClosure25Chunk10
import D1Bound5.SmallPairGraphClosure25Chunk11

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared25

theorem PairGraphPrepared25.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 witnesses destinations = true := by
  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25
    witnesses destinations indexed_coverage_checked
  have h762 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 762) (destinations.drop 762) = true := by
    rfl
  have h704 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 704) (destinations.drop 704) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 58
      (witnesses.drop 704) (destinations.drop 704) indexed_chunk11_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h762
  have h640 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 640) (destinations.drop 640) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 640) (destinations.drop 640) indexed_chunk10_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h704
  have h576 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 576) (destinations.drop 576) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 576) (destinations.drop 576) indexed_chunk09_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h640
  have h512 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 512) (destinations.drop 512) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 512) (destinations.drop 512) indexed_chunk08_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h576
  have h448 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 448) (destinations.drop 448) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 448) (destinations.drop 448) indexed_chunk07_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h512
  have h384 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 384) (destinations.drop 384) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 384) (destinations.drop 384) indexed_chunk06_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h448
  have h320 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 320) (destinations.drop 320) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 320) (destinations.drop 320) indexed_chunk05_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h384
  have h256 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 256) (destinations.drop 256) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 256) (destinations.drop 256) indexed_chunk04_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h320
  have h192 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 192) (destinations.drop 192) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 192) (destinations.drop 192) indexed_chunk03_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h256
  have h128 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 128) (destinations.drop 128) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 128) (destinations.drop 128) indexed_chunk02_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h192
  have h064 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 64) (destinations.drop 64) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 64) (destinations.drop 64) indexed_chunk01_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h128
  have h000 : pairIndexedWitnessesCheckedBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 (witnesses.drop 0) (destinations.drop 0) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_25 smallPairB_25 anchorRoot (10^1100) smallPairClosure_25 64
      (witnesses.drop 0) (destinations.drop 0) indexed_chunk00_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h064
  simpa only [List.drop_zero] using h000

theorem smallPairClosure_25_checked :
    pairClosureBool smallPairA_25 smallPairB_25
      (10^1100) smallPairClosure_25 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_25 smallPairB_25 anchorRoot
    (10^1100) smallPairClosure_25 witnesses destinations PairGraphPrepared25.indexed_checked

end D1Bound5
