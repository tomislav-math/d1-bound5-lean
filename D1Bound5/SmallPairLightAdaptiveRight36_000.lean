import D1Bound5.SmallPairLightAdaptiveData36
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelRight36_000Part00
import D1Bound5.SmallPairParallelRight36_000Part01
import D1Bound5.SmallPairParallelRight36_000Part02
import D1Bound5.SmallPairParallelRight36_000Part03
import D1Bound5.SmallPairParallelRight36_000Part04
import D1Bound5.SmallPairParallelRight36_000Part05
import D1Bound5.SmallPairParallelRight36_000Part06

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 76
      rightCached000 rightRows000 = true := by
  have h0072 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 4
      (PairLightPrepared36.rightCached.drop 72) (PairLightPrepared36.rightRows.drop 72) = true := right_parallel_000_part06_checked
  have h0060 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 16
      (PairLightPrepared36.rightCached.drop 60) (PairLightPrepared36.rightRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 4
      (PairLightPrepared36.rightCached.drop 60) (PairLightPrepared36.rightRows.drop 60)
    · exact right_parallel_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0072
  have h0048 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 28
      (PairLightPrepared36.rightCached.drop 48) (PairLightPrepared36.rightRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 16
      (PairLightPrepared36.rightCached.drop 48) (PairLightPrepared36.rightRows.drop 48)
    · exact right_parallel_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0060
  have h0036 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 40
      (PairLightPrepared36.rightCached.drop 36) (PairLightPrepared36.rightRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 28
      (PairLightPrepared36.rightCached.drop 36) (PairLightPrepared36.rightRows.drop 36)
    · exact right_parallel_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0048
  have h0024 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 52
      (PairLightPrepared36.rightCached.drop 24) (PairLightPrepared36.rightRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 40
      (PairLightPrepared36.rightCached.drop 24) (PairLightPrepared36.rightRows.drop 24)
    · exact right_parallel_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0036
  have h0012 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 64
      (PairLightPrepared36.rightCached.drop 12) (PairLightPrepared36.rightRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 52
      (PairLightPrepared36.rightCached.drop 12) (PairLightPrepared36.rightRows.drop 12)
    · exact right_parallel_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0024
  have h0000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 76
      (PairLightPrepared36.rightCached.drop 0) (PairLightPrepared36.rightRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared36.sieve 12 64
      (PairLightPrepared36.rightCached.drop 0) (PairLightPrepared36.rightRows.drop 0)
    · exact right_parallel_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0012
  exact h0000

end D1Bound5.PairLightAdaptivePrepared36
