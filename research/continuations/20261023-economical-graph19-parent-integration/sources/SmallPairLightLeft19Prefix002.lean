import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part00
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part01
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part02
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part03
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part04
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part05
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part06
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part07
import D1Bound5.SmallPairLightAdaptiveLeft19_002Part08

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 198
      (PairLightPrepared19.leftCached.drop 248) (PairLightPrepared19.leftRows.drop 248) = true := by
  have h440 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 6
      (PairLightPrepared19.leftCached.drop 440) (PairLightPrepared19.leftRows.drop 440) = true := left_prefix_002_part08_checked
  have h416 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 30
      (PairLightPrepared19.leftCached.drop 416) (PairLightPrepared19.leftRows.drop 416) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 6
      (PairLightPrepared19.leftCached.drop 416) (PairLightPrepared19.leftRows.drop 416)
    · exact left_prefix_002_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h440
  have h392 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 54
      (PairLightPrepared19.leftCached.drop 392) (PairLightPrepared19.leftRows.drop 392) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 30
      (PairLightPrepared19.leftCached.drop 392) (PairLightPrepared19.leftRows.drop 392)
    · exact left_prefix_002_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h416
  have h368 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 78
      (PairLightPrepared19.leftCached.drop 368) (PairLightPrepared19.leftRows.drop 368) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 54
      (PairLightPrepared19.leftCached.drop 368) (PairLightPrepared19.leftRows.drop 368)
    · exact left_prefix_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h392
  have h344 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 102
      (PairLightPrepared19.leftCached.drop 344) (PairLightPrepared19.leftRows.drop 344) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 78
      (PairLightPrepared19.leftCached.drop 344) (PairLightPrepared19.leftRows.drop 344)
    · exact left_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h368
  have h320 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 126
      (PairLightPrepared19.leftCached.drop 320) (PairLightPrepared19.leftRows.drop 320) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 102
      (PairLightPrepared19.leftCached.drop 320) (PairLightPrepared19.leftRows.drop 320)
    · exact left_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h344
  have h296 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 150
      (PairLightPrepared19.leftCached.drop 296) (PairLightPrepared19.leftRows.drop 296) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 126
      (PairLightPrepared19.leftCached.drop 296) (PairLightPrepared19.leftRows.drop 296)
    · exact left_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h320
  have h272 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 174
      (PairLightPrepared19.leftCached.drop 272) (PairLightPrepared19.leftRows.drop 272) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 150
      (PairLightPrepared19.leftCached.drop 272) (PairLightPrepared19.leftRows.drop 272)
    · exact left_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h296
  have h248 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 198
      (PairLightPrepared19.leftCached.drop 248) (PairLightPrepared19.leftRows.drop 248) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared19.sieve 24 174
      (PairLightPrepared19.leftCached.drop 248) (PairLightPrepared19.leftRows.drop 248)
    · exact left_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h272
  exact h248
end D1Bound5.PairLightAdaptivePrepared19
