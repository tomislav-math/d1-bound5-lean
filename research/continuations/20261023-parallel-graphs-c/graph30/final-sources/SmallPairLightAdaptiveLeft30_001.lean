import D1Bound5.SmallPairLightAdaptiveData30
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelLeft30_001Part00
import D1Bound5.SmallPairParallelLeft30_001Part01
import D1Bound5.SmallPairParallelLeft30_001Part02
import D1Bound5.SmallPairParallelLeft30_001Part03
import D1Bound5.SmallPairParallelLeft30_001Part04
import D1Bound5.SmallPairParallelLeft30_001Part05
import D1Bound5.SmallPairParallelLeft30_001Part06
import D1Bound5.SmallPairParallelLeft30_001Part07
import D1Bound5.SmallPairParallelLeft30_001Part08
import D1Bound5.SmallPairParallelLeft30_001Part09
import D1Bound5.SmallPairParallelLeft30_001Part10

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 121
      leftCached001 leftRows001 = true := by
  have h0211 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 1
      (PairLightPrepared30.leftCached.drop 211) (PairLightPrepared30.leftRows.drop 211) = true := left_parallel_001_part10_checked
  have h0199 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 13
      (PairLightPrepared30.leftCached.drop 199) (PairLightPrepared30.leftRows.drop 199) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 1
      (PairLightPrepared30.leftCached.drop 199) (PairLightPrepared30.leftRows.drop 199)
    · exact left_parallel_001_part09_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0211
  have h0187 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 25
      (PairLightPrepared30.leftCached.drop 187) (PairLightPrepared30.leftRows.drop 187) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 13
      (PairLightPrepared30.leftCached.drop 187) (PairLightPrepared30.leftRows.drop 187)
    · exact left_parallel_001_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0199
  have h0175 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 37
      (PairLightPrepared30.leftCached.drop 175) (PairLightPrepared30.leftRows.drop 175) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 25
      (PairLightPrepared30.leftCached.drop 175) (PairLightPrepared30.leftRows.drop 175)
    · exact left_parallel_001_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0187
  have h0163 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 49
      (PairLightPrepared30.leftCached.drop 163) (PairLightPrepared30.leftRows.drop 163) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 37
      (PairLightPrepared30.leftCached.drop 163) (PairLightPrepared30.leftRows.drop 163)
    · exact left_parallel_001_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0175
  have h0151 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 61
      (PairLightPrepared30.leftCached.drop 151) (PairLightPrepared30.leftRows.drop 151) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 49
      (PairLightPrepared30.leftCached.drop 151) (PairLightPrepared30.leftRows.drop 151)
    · exact left_parallel_001_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0163
  have h0139 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 73
      (PairLightPrepared30.leftCached.drop 139) (PairLightPrepared30.leftRows.drop 139) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 61
      (PairLightPrepared30.leftCached.drop 139) (PairLightPrepared30.leftRows.drop 139)
    · exact left_parallel_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0151
  have h0127 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 85
      (PairLightPrepared30.leftCached.drop 127) (PairLightPrepared30.leftRows.drop 127) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 73
      (PairLightPrepared30.leftCached.drop 127) (PairLightPrepared30.leftRows.drop 127)
    · exact left_parallel_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0139
  have h0115 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 97
      (PairLightPrepared30.leftCached.drop 115) (PairLightPrepared30.leftRows.drop 115) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 85
      (PairLightPrepared30.leftCached.drop 115) (PairLightPrepared30.leftRows.drop 115)
    · exact left_parallel_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0127
  have h0103 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 109
      (PairLightPrepared30.leftCached.drop 103) (PairLightPrepared30.leftRows.drop 103) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 97
      (PairLightPrepared30.leftCached.drop 103) (PairLightPrepared30.leftRows.drop 103)
    · exact left_parallel_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0115
  have h0091 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 121
      (PairLightPrepared30.leftCached.drop 91) (PairLightPrepared30.leftRows.drop 91) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 109
      (PairLightPrepared30.leftCached.drop 91) (PairLightPrepared30.leftRows.drop 91)
    · exact left_parallel_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0103
  exact h0091

end D1Bound5.PairLightAdaptivePrepared30
