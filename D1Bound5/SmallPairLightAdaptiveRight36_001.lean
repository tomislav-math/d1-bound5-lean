import D1Bound5.SmallPairLightAdaptiveData36
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelRight36_001Part00
import D1Bound5.SmallPairParallelRight36_001Part01
import D1Bound5.SmallPairParallelRight36_001Part02
import D1Bound5.SmallPairParallelRight36_001Part03
import D1Bound5.SmallPairParallelRight36_001Part04
import D1Bound5.SmallPairParallelRight36_001Part05
import D1Bound5.SmallPairParallelRight36_001Part06
import D1Bound5.SmallPairParallelRight36_001Part07

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 91
      rightCached001 rightRows001 = true := by
  have h0160 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 7
      (PairLightPrepared36.rightCached.drop 160) (PairLightPrepared36.rightRows.drop 160) = true := right_parallel_001_part07_checked
  have h0148 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 19
      (PairLightPrepared36.rightCached.drop 148) (PairLightPrepared36.rightRows.drop 148) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 7
      (PairLightPrepared36.rightCached.drop 148) (PairLightPrepared36.rightRows.drop 148)
    · exact right_parallel_001_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0160
  have h0136 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 31
      (PairLightPrepared36.rightCached.drop 136) (PairLightPrepared36.rightRows.drop 136) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 19
      (PairLightPrepared36.rightCached.drop 136) (PairLightPrepared36.rightRows.drop 136)
    · exact right_parallel_001_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0148
  have h0124 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 43
      (PairLightPrepared36.rightCached.drop 124) (PairLightPrepared36.rightRows.drop 124) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 31
      (PairLightPrepared36.rightCached.drop 124) (PairLightPrepared36.rightRows.drop 124)
    · exact right_parallel_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0136
  have h0112 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 55
      (PairLightPrepared36.rightCached.drop 112) (PairLightPrepared36.rightRows.drop 112) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 43
      (PairLightPrepared36.rightCached.drop 112) (PairLightPrepared36.rightRows.drop 112)
    · exact right_parallel_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0124
  have h0100 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 67
      (PairLightPrepared36.rightCached.drop 100) (PairLightPrepared36.rightRows.drop 100) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 55
      (PairLightPrepared36.rightCached.drop 100) (PairLightPrepared36.rightRows.drop 100)
    · exact right_parallel_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0112
  have h0088 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 79
      (PairLightPrepared36.rightCached.drop 88) (PairLightPrepared36.rightRows.drop 88) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 67
      (PairLightPrepared36.rightCached.drop 88) (PairLightPrepared36.rightRows.drop 88)
    · exact right_parallel_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0100
  have h0076 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 91
      (PairLightPrepared36.rightCached.drop 76) (PairLightPrepared36.rightRows.drop 76) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 79
      (PairLightPrepared36.rightCached.drop 76) (PairLightPrepared36.rightRows.drop 76)
    · exact right_parallel_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0088
  exact h0076

end D1Bound5.PairLightAdaptivePrepared36
