import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part00
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part01
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part02
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part03
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part04
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part05
import D1Bound5.SmallPairLightAdaptiveLeft6_004Part06

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 151
      leftCached004 leftRows004 = true := by
  have h0466 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 3
      (PairLightPrepared6.leftCached.drop 466) (PairLightPrepared6.leftRows.drop 466) = true := left_prefix_004_part06_checked
  have h0435 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 34
      (PairLightPrepared6.leftCached.drop 435) (PairLightPrepared6.leftRows.drop 435) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 31 3
      (PairLightPrepared6.leftCached.drop 435) (PairLightPrepared6.leftRows.drop 435)
    · exact left_prefix_004_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0466
  have h0407 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 62
      (PairLightPrepared6.leftCached.drop 407) (PairLightPrepared6.leftRows.drop 407) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 28 34
      (PairLightPrepared6.leftCached.drop 407) (PairLightPrepared6.leftRows.drop 407)
    · exact left_prefix_004_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0435
  have h0382 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 87
      (PairLightPrepared6.leftCached.drop 382) (PairLightPrepared6.leftRows.drop 382) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 25 62
      (PairLightPrepared6.leftCached.drop 382) (PairLightPrepared6.leftRows.drop 382)
    · exact left_prefix_004_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0407
  have h0359 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 110
      (PairLightPrepared6.leftCached.drop 359) (PairLightPrepared6.leftRows.drop 359) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 23 87
      (PairLightPrepared6.leftCached.drop 359) (PairLightPrepared6.leftRows.drop 359)
    · exact left_prefix_004_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0382
  have h0338 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 131
      (PairLightPrepared6.leftCached.drop 338) (PairLightPrepared6.leftRows.drop 338) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 21 110
      (PairLightPrepared6.leftCached.drop 338) (PairLightPrepared6.leftRows.drop 338)
    · exact left_prefix_004_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0359
  have h0318 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 151
      (PairLightPrepared6.leftCached.drop 318) (PairLightPrepared6.leftRows.drop 318) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 20 131
      (PairLightPrepared6.leftCached.drop 318) (PairLightPrepared6.leftRows.drop 318)
    · exact left_prefix_004_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0338
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, leftCached003, leftRows003, leftCached004, leftRows004, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0318

end D1Bound5.PairLightAdaptivePrepared6
