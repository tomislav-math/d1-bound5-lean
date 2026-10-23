import D1Bound5.SmallPairLightAdaptiveData36
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelLeft36_002Part00
import D1Bound5.SmallPairParallelLeft36_002Part01
import D1Bound5.SmallPairParallelLeft36_002Part02
import D1Bound5.SmallPairParallelLeft36_002Part03
import D1Bound5.SmallPairParallelLeft36_002Part04
import D1Bound5.SmallPairParallelLeft36_002Part05
import D1Bound5.SmallPairParallelLeft36_002Part06
import D1Bound5.SmallPairParallelLeft36_002Part07
import D1Bound5.SmallPairParallelLeft36_002Part08
import D1Bound5.SmallPairParallelLeft36_002Part09

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 119
      leftCached002 leftRows002 = true := by
  have h0275 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 11
      (PairLightPrepared36.leftCached.drop 275) (PairLightPrepared36.leftRows.drop 275) = true := left_parallel_002_part09_checked
  have h0263 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 23
      (PairLightPrepared36.leftCached.drop 263) (PairLightPrepared36.leftRows.drop 263) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 11
      (PairLightPrepared36.leftCached.drop 263) (PairLightPrepared36.leftRows.drop 263)
    · exact left_parallel_002_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0275
  have h0251 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 35
      (PairLightPrepared36.leftCached.drop 251) (PairLightPrepared36.leftRows.drop 251) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 23
      (PairLightPrepared36.leftCached.drop 251) (PairLightPrepared36.leftRows.drop 251)
    · exact left_parallel_002_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0263
  have h0239 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 47
      (PairLightPrepared36.leftCached.drop 239) (PairLightPrepared36.leftRows.drop 239) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 35
      (PairLightPrepared36.leftCached.drop 239) (PairLightPrepared36.leftRows.drop 239)
    · exact left_parallel_002_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0251
  have h0227 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 59
      (PairLightPrepared36.leftCached.drop 227) (PairLightPrepared36.leftRows.drop 227) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 47
      (PairLightPrepared36.leftCached.drop 227) (PairLightPrepared36.leftRows.drop 227)
    · exact left_parallel_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0239
  have h0215 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 71
      (PairLightPrepared36.leftCached.drop 215) (PairLightPrepared36.leftRows.drop 215) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 59
      (PairLightPrepared36.leftCached.drop 215) (PairLightPrepared36.leftRows.drop 215)
    · exact left_parallel_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0227
  have h0203 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 83
      (PairLightPrepared36.leftCached.drop 203) (PairLightPrepared36.leftRows.drop 203) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 71
      (PairLightPrepared36.leftCached.drop 203) (PairLightPrepared36.leftRows.drop 203)
    · exact left_parallel_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0215
  have h0191 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 95
      (PairLightPrepared36.leftCached.drop 191) (PairLightPrepared36.leftRows.drop 191) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 83
      (PairLightPrepared36.leftCached.drop 191) (PairLightPrepared36.leftRows.drop 191)
    · exact left_parallel_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0203
  have h0179 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 107
      (PairLightPrepared36.leftCached.drop 179) (PairLightPrepared36.leftRows.drop 179) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 95
      (PairLightPrepared36.leftCached.drop 179) (PairLightPrepared36.leftRows.drop 179)
    · exact left_parallel_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0191
  have h0167 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 119
      (PairLightPrepared36.leftCached.drop 167) (PairLightPrepared36.leftRows.drop 167) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 107
      (PairLightPrepared36.leftCached.drop 167) (PairLightPrepared36.leftRows.drop 167)
    · exact left_parallel_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0179
  exact h0167

end D1Bound5.PairLightAdaptivePrepared36
