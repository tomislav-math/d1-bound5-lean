import D1Bound5.SmallPairLightAdaptiveData14
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelRight14_003Part00
import D1Bound5.SmallPairParallelRight14_003Part01
import D1Bound5.SmallPairParallelRight14_003Part02
import D1Bound5.SmallPairParallelRight14_003Part03
import D1Bound5.SmallPairParallelRight14_003Part04
import D1Bound5.SmallPairParallelRight14_003Part05
import D1Bound5.SmallPairParallelRight14_003Part06

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 79
      rightCached003 rightRows003 = true := by
  have h0489 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 7
      (PairLightPrepared14.rightCached.drop 489) (PairLightPrepared14.rightRows.drop 489) = true := right_parallel_003_part06_checked
  have h0477 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 19
      (PairLightPrepared14.rightCached.drop 477) (PairLightPrepared14.rightRows.drop 477) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 7
      (PairLightPrepared14.rightCached.drop 477) (PairLightPrepared14.rightRows.drop 477)
    · exact right_parallel_003_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0489
  have h0465 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 31
      (PairLightPrepared14.rightCached.drop 465) (PairLightPrepared14.rightRows.drop 465) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 19
      (PairLightPrepared14.rightCached.drop 465) (PairLightPrepared14.rightRows.drop 465)
    · exact right_parallel_003_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0477
  have h0453 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 43
      (PairLightPrepared14.rightCached.drop 453) (PairLightPrepared14.rightRows.drop 453) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 31
      (PairLightPrepared14.rightCached.drop 453) (PairLightPrepared14.rightRows.drop 453)
    · exact right_parallel_003_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0465
  have h0441 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 55
      (PairLightPrepared14.rightCached.drop 441) (PairLightPrepared14.rightRows.drop 441) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 43
      (PairLightPrepared14.rightCached.drop 441) (PairLightPrepared14.rightRows.drop 441)
    · exact right_parallel_003_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0453
  have h0429 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 67
      (PairLightPrepared14.rightCached.drop 429) (PairLightPrepared14.rightRows.drop 429) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 55
      (PairLightPrepared14.rightCached.drop 429) (PairLightPrepared14.rightRows.drop 429)
    · exact right_parallel_003_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0441
  have h0417 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 79
      (PairLightPrepared14.rightCached.drop 417) (PairLightPrepared14.rightRows.drop 417) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 67
      (PairLightPrepared14.rightCached.drop 417) (PairLightPrepared14.rightRows.drop 417)
    · exact right_parallel_003_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0429
  exact h0417

end D1Bound5.PairLightAdaptivePrepared14
