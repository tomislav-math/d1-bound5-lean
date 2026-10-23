import D1Bound5.SmallPairGraphClosure10Coverage
import D1Bound5.SmallPairGraphClosure10Chunk00
import D1Bound5.SmallPairGraphClosure10Chunk01
import D1Bound5.SmallPairGraphClosure10Chunk02
import D1Bound5.SmallPairGraphClosure10Chunk03
import D1Bound5.SmallPairGraphClosure10Chunk04
import D1Bound5.SmallPairGraphClosure10Chunk05
import D1Bound5.SmallPairGraphClosure10Chunk06
import D1Bound5.SmallPairGraphClosure10Chunk07
import D1Bound5.SmallPairGraphClosure10Chunk08
import D1Bound5.SmallPairGraphClosure10Chunk09
import D1Bound5.SmallPairGraphClosure10Chunk10
import D1Bound5.SmallPairGraphClosure10Chunk11
import D1Bound5.SmallPairGraphClosure10Chunk12
import D1Bound5.SmallPairGraphClosure10Chunk13
import D1Bound5.SmallPairGraphClosure10Chunk14
import D1Bound5.SmallPairGraphClosure10Chunk15
import D1Bound5.SmallPairGraphClosure10Chunk16
import D1Bound5.SmallPairGraphClosure10Chunk17
import D1Bound5.SmallPairGraphClosure10Chunk18

namespace D1Bound5
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared10

theorem PairGraphPrepared10.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 witnesses destinations = true := by
  apply pairClosureIndexedWitnessBool_of_checked_parts
    smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10
    witnesses destinations indexed_coverage_checked
  have h1194 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 1194) (destinations.drop 1194) = true := by
    rfl
  have h1152 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 1152) (destinations.drop 1152) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 42
      (witnesses.drop 1152) (destinations.drop 1152) indexed_chunk18_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h1194
  have h1088 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 1088) (destinations.drop 1088) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 1088) (destinations.drop 1088) indexed_chunk17_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h1152
  have h1024 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 1024) (destinations.drop 1024) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 1024) (destinations.drop 1024) indexed_chunk16_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h1088
  have h0960 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 960) (destinations.drop 960) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 960) (destinations.drop 960) indexed_chunk15_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h1024
  have h0896 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 896) (destinations.drop 896) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 896) (destinations.drop 896) indexed_chunk14_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0960
  have h0832 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 832) (destinations.drop 832) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 832) (destinations.drop 832) indexed_chunk13_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0896
  have h0768 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 768) (destinations.drop 768) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 768) (destinations.drop 768) indexed_chunk12_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0832
  have h0704 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 704) (destinations.drop 704) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 704) (destinations.drop 704) indexed_chunk11_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0768
  have h0640 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 640) (destinations.drop 640) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 640) (destinations.drop 640) indexed_chunk10_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0704
  have h0576 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 576) (destinations.drop 576) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 576) (destinations.drop 576) indexed_chunk09_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0640
  have h0512 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 512) (destinations.drop 512) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 512) (destinations.drop 512) indexed_chunk08_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0576
  have h0448 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 448) (destinations.drop 448) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 448) (destinations.drop 448) indexed_chunk07_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0512
  have h0384 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 384) (destinations.drop 384) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 384) (destinations.drop 384) indexed_chunk06_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0448
  have h0320 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 320) (destinations.drop 320) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 320) (destinations.drop 320) indexed_chunk05_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0384
  have h0256 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 256) (destinations.drop 256) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 256) (destinations.drop 256) indexed_chunk04_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0320
  have h0192 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 192) (destinations.drop 192) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 192) (destinations.drop 192) indexed_chunk03_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0256
  have h0128 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 128) (destinations.drop 128) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 128) (destinations.drop 128) indexed_chunk02_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0192
  have h0064 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 64) (destinations.drop 64) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 64) (destinations.drop 64) indexed_chunk01_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0128
  have h0000 : pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 (witnesses.drop 0) (destinations.drop 0) = true := by
    apply pairIndexedWitnessesCheckedBool_of_prefix_drop
      smallPairA_10 smallPairB_10 anchorRoot (10^1100) smallPairClosure_10 64
      (witnesses.drop 0) (destinations.drop 0) indexed_chunk00_checked
    simpa only [List.drop_drop, Nat.reduceAdd] using h0064
  simpa only [List.drop_zero] using h0000

theorem smallPairClosure_10_checked :
    pairClosureBool smallPairA_10 smallPairB_10
      (10^1100) smallPairClosure_10 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_10 smallPairB_10 anchorRoot
    (10^1100) smallPairClosure_10 witnesses destinations PairGraphPrepared10.indexed_checked

end D1Bound5
