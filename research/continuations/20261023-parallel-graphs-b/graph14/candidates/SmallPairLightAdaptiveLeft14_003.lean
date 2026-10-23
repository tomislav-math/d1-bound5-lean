import D1Bound5.SmallPairLightAdaptiveData14
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelLeft14_003Part00
import D1Bound5.SmallPairParallelLeft14_003Part01
import D1Bound5.SmallPairParallelLeft14_003Part02
import D1Bound5.SmallPairParallelLeft14_003Part03
import D1Bound5.SmallPairParallelLeft14_003Part04
import D1Bound5.SmallPairParallelLeft14_003Part05
import D1Bound5.SmallPairParallelLeft14_003Part06

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 76
      leftCached003 leftRows003 = true := by
  have h0491 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 4
      (PairLightPrepared14.leftCached.drop 491) (PairLightPrepared14.leftRows.drop 491) = true := left_parallel_003_part06_checked
  have h0479 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 16
      (PairLightPrepared14.leftCached.drop 479) (PairLightPrepared14.leftRows.drop 479) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 4
      (PairLightPrepared14.leftCached.drop 479) (PairLightPrepared14.leftRows.drop 479)
    · exact left_parallel_003_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0491
  have h0467 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 28
      (PairLightPrepared14.leftCached.drop 467) (PairLightPrepared14.leftRows.drop 467) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 16
      (PairLightPrepared14.leftCached.drop 467) (PairLightPrepared14.leftRows.drop 467)
    · exact left_parallel_003_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0479
  have h0455 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 40
      (PairLightPrepared14.leftCached.drop 455) (PairLightPrepared14.leftRows.drop 455) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 28
      (PairLightPrepared14.leftCached.drop 455) (PairLightPrepared14.leftRows.drop 455)
    · exact left_parallel_003_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0467
  have h0443 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 52
      (PairLightPrepared14.leftCached.drop 443) (PairLightPrepared14.leftRows.drop 443) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 40
      (PairLightPrepared14.leftCached.drop 443) (PairLightPrepared14.leftRows.drop 443)
    · exact left_parallel_003_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0455
  have h0431 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 64
      (PairLightPrepared14.leftCached.drop 431) (PairLightPrepared14.leftRows.drop 431) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 52
      (PairLightPrepared14.leftCached.drop 431) (PairLightPrepared14.leftRows.drop 431)
    · exact left_parallel_003_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0443
  have h0419 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 76
      (PairLightPrepared14.leftCached.drop 419) (PairLightPrepared14.leftRows.drop 419) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared14.sieve 12 64
      (PairLightPrepared14.leftCached.drop 419) (PairLightPrepared14.leftRows.drop 419)
    · exact left_parallel_003_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0431
  exact h0419

end D1Bound5.PairLightAdaptivePrepared14
