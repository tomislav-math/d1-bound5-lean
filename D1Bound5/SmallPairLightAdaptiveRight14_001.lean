import D1Bound5.SmallPairLightAdaptiveData14
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelRight14_001Part00
import D1Bound5.SmallPairParallelRight14_001Part01
import D1Bound5.SmallPairParallelRight14_001Part02
import D1Bound5.SmallPairParallelRight14_001Part03
import D1Bound5.SmallPairParallelRight14_001Part04
import D1Bound5.SmallPairParallelRight14_001Part05
import D1Bound5.SmallPairParallelRight14_001Part06
import D1Bound5.SmallPairParallelRight14_001Part07
import D1Bound5.SmallPairParallelRight14_001Part08
import D1Bound5.SmallPairParallelRight14_001Part09

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 114
      rightCached001 rightRows001 = true := by
  have h0196 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 6
      (PairLightPrepared14.rightCached.drop 196) (PairLightPrepared14.rightRows.drop 196) = true := right_parallel_001_part09_checked
  have h0184 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 18
      (PairLightPrepared14.rightCached.drop 184) (PairLightPrepared14.rightRows.drop 184) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 6
      (PairLightPrepared14.rightCached.drop 184) (PairLightPrepared14.rightRows.drop 184)
    · exact right_parallel_001_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0196
  have h0172 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 30
      (PairLightPrepared14.rightCached.drop 172) (PairLightPrepared14.rightRows.drop 172) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 18
      (PairLightPrepared14.rightCached.drop 172) (PairLightPrepared14.rightRows.drop 172)
    · exact right_parallel_001_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0184
  have h0160 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 42
      (PairLightPrepared14.rightCached.drop 160) (PairLightPrepared14.rightRows.drop 160) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 30
      (PairLightPrepared14.rightCached.drop 160) (PairLightPrepared14.rightRows.drop 160)
    · exact right_parallel_001_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0172
  have h0148 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 54
      (PairLightPrepared14.rightCached.drop 148) (PairLightPrepared14.rightRows.drop 148) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 42
      (PairLightPrepared14.rightCached.drop 148) (PairLightPrepared14.rightRows.drop 148)
    · exact right_parallel_001_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0160
  have h0136 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 66
      (PairLightPrepared14.rightCached.drop 136) (PairLightPrepared14.rightRows.drop 136) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 54
      (PairLightPrepared14.rightCached.drop 136) (PairLightPrepared14.rightRows.drop 136)
    · exact right_parallel_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0148
  have h0124 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 78
      (PairLightPrepared14.rightCached.drop 124) (PairLightPrepared14.rightRows.drop 124) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 66
      (PairLightPrepared14.rightCached.drop 124) (PairLightPrepared14.rightRows.drop 124)
    · exact right_parallel_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0136
  have h0112 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 90
      (PairLightPrepared14.rightCached.drop 112) (PairLightPrepared14.rightRows.drop 112) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 78
      (PairLightPrepared14.rightCached.drop 112) (PairLightPrepared14.rightRows.drop 112)
    · exact right_parallel_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0124
  have h0100 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 102
      (PairLightPrepared14.rightCached.drop 100) (PairLightPrepared14.rightRows.drop 100) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 90
      (PairLightPrepared14.rightCached.drop 100) (PairLightPrepared14.rightRows.drop 100)
    · exact right_parallel_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0112
  have h0088 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 114
      (PairLightPrepared14.rightCached.drop 88) (PairLightPrepared14.rightRows.drop 88) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 102
      (PairLightPrepared14.rightCached.drop 88) (PairLightPrepared14.rightRows.drop 88)
    · exact right_parallel_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0100
  exact h0088

end D1Bound5.PairLightAdaptivePrepared14
