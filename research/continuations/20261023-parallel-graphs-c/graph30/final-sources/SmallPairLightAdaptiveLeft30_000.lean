import D1Bound5.SmallPairLightAdaptiveData30
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelLeft30_000Part00
import D1Bound5.SmallPairParallelLeft30_000Part01
import D1Bound5.SmallPairParallelLeft30_000Part02
import D1Bound5.SmallPairParallelLeft30_000Part03
import D1Bound5.SmallPairParallelLeft30_000Part04
import D1Bound5.SmallPairParallelLeft30_000Part05
import D1Bound5.SmallPairParallelLeft30_000Part06
import D1Bound5.SmallPairParallelLeft30_000Part07

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 91
      leftCached000 leftRows000 = true := by
  have h0084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 7
      (PairLightPrepared30.leftCached.drop 84) (PairLightPrepared30.leftRows.drop 84) = true := left_parallel_000_part07_checked
  have h0072 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 19
      (PairLightPrepared30.leftCached.drop 72) (PairLightPrepared30.leftRows.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 7
      (PairLightPrepared30.leftCached.drop 72) (PairLightPrepared30.leftRows.drop 72)
    · exact left_parallel_000_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0084
  have h0060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 31
      (PairLightPrepared30.leftCached.drop 60) (PairLightPrepared30.leftRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 19
      (PairLightPrepared30.leftCached.drop 60) (PairLightPrepared30.leftRows.drop 60)
    · exact left_parallel_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0072
  have h0048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 43
      (PairLightPrepared30.leftCached.drop 48) (PairLightPrepared30.leftRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 31
      (PairLightPrepared30.leftCached.drop 48) (PairLightPrepared30.leftRows.drop 48)
    · exact left_parallel_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0060
  have h0036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 55
      (PairLightPrepared30.leftCached.drop 36) (PairLightPrepared30.leftRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 43
      (PairLightPrepared30.leftCached.drop 36) (PairLightPrepared30.leftRows.drop 36)
    · exact left_parallel_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0048
  have h0024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 67
      (PairLightPrepared30.leftCached.drop 24) (PairLightPrepared30.leftRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 55
      (PairLightPrepared30.leftCached.drop 24) (PairLightPrepared30.leftRows.drop 24)
    · exact left_parallel_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0036
  have h0012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 79
      (PairLightPrepared30.leftCached.drop 12) (PairLightPrepared30.leftRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 67
      (PairLightPrepared30.leftCached.drop 12) (PairLightPrepared30.leftRows.drop 12)
    · exact left_parallel_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0024
  have h0000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 91
      (PairLightPrepared30.leftCached.drop 0) (PairLightPrepared30.leftRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared30.sieve 12 79
      (PairLightPrepared30.leftCached.drop 0) (PairLightPrepared30.leftRows.drop 0)
    · exact left_parallel_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0012
  exact h0000

end D1Bound5.PairLightAdaptivePrepared30
