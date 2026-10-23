import D1Bound5.SmallPairLightAdaptiveData4
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part00
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part01
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part02
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part03
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part04
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part05
import D1Bound5.SmallPairLightAdaptiveLeft4_003Part06

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 150
      leftCached003 leftRows003 = true := by
  have h0402 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 3
      (PairLightPrepared4.leftCached.drop 402) (PairLightPrepared4.leftRows.drop 402) = true := left_prefix_003_part06_checked
  have h0371 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 34
      (PairLightPrepared4.leftCached.drop 371) (PairLightPrepared4.leftRows.drop 371) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 31 3
      (PairLightPrepared4.leftCached.drop 371) (PairLightPrepared4.leftRows.drop 371)
    · exact left_prefix_003_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0402
  have h0344 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 61
      (PairLightPrepared4.leftCached.drop 344) (PairLightPrepared4.leftRows.drop 344) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 27 34
      (PairLightPrepared4.leftCached.drop 344) (PairLightPrepared4.leftRows.drop 344)
    · exact left_prefix_003_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0371
  have h0319 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 86
      (PairLightPrepared4.leftCached.drop 319) (PairLightPrepared4.leftRows.drop 319) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 25 61
      (PairLightPrepared4.leftCached.drop 319) (PairLightPrepared4.leftRows.drop 319)
    · exact left_prefix_003_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0344
  have h0296 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 109
      (PairLightPrepared4.leftCached.drop 296) (PairLightPrepared4.leftRows.drop 296) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 23 86
      (PairLightPrepared4.leftCached.drop 296) (PairLightPrepared4.leftRows.drop 296)
    · exact left_prefix_003_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0319
  have h0275 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 130
      (PairLightPrepared4.leftCached.drop 275) (PairLightPrepared4.leftRows.drop 275) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 21 109
      (PairLightPrepared4.leftCached.drop 275) (PairLightPrepared4.leftRows.drop 275)
    · exact left_prefix_003_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0296
  have h0255 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 150
      (PairLightPrepared4.leftCached.drop 255) (PairLightPrepared4.leftRows.drop 255) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 20 130
      (PairLightPrepared4.leftCached.drop 255) (PairLightPrepared4.leftRows.drop 255)
    · exact left_prefix_003_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0275
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, leftCached003, leftRows003, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0255

end D1Bound5.PairLightAdaptivePrepared4
