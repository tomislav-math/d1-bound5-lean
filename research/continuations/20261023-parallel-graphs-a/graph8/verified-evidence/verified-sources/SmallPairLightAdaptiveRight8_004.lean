import D1Bound5.SmallPairLightAdaptiveData8
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight8_004Part00
import D1Bound5.SmallPairLightAdaptiveRight8_004Part01
import D1Bound5.SmallPairLightAdaptiveRight8_004Part02
import D1Bound5.SmallPairLightAdaptiveRight8_004Part03
import D1Bound5.SmallPairLightAdaptiveRight8_004Part04
import D1Bound5.SmallPairLightAdaptiveRight8_004Part05

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 101
      rightCached004 rightRows004 = true := by
  have h0356 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 19
      (PairLightPrepared8.rightCached.drop 356) (PairLightPrepared8.rightRows.drop 356) = true := right_prefix_004_part05_checked
  have h0338 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 37
      (PairLightPrepared8.rightCached.drop 338) (PairLightPrepared8.rightRows.drop 338) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 18 19
      (PairLightPrepared8.rightCached.drop 338) (PairLightPrepared8.rightRows.drop 338)
    · exact right_prefix_004_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0356
  have h0321 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 54
      (PairLightPrepared8.rightCached.drop 321) (PairLightPrepared8.rightRows.drop 321) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 17 37
      (PairLightPrepared8.rightCached.drop 321) (PairLightPrepared8.rightRows.drop 321)
    · exact right_prefix_004_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0338
  have h0305 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 70
      (PairLightPrepared8.rightCached.drop 305) (PairLightPrepared8.rightRows.drop 305) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 16 54
      (PairLightPrepared8.rightCached.drop 305) (PairLightPrepared8.rightRows.drop 305)
    · exact right_prefix_004_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0321
  have h0289 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 86
      (PairLightPrepared8.rightCached.drop 289) (PairLightPrepared8.rightRows.drop 289) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 16 70
      (PairLightPrepared8.rightCached.drop 289) (PairLightPrepared8.rightRows.drop 289)
    · exact right_prefix_004_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0305
  have h0274 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 101
      (PairLightPrepared8.rightCached.drop 274) (PairLightPrepared8.rightRows.drop 274) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 15 86
      (PairLightPrepared8.rightCached.drop 274) (PairLightPrepared8.rightRows.drop 274)
    · exact right_prefix_004_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0289
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, rightCached003, rightRows003, rightCached004, rightRows004, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0274

end D1Bound5.PairLightAdaptivePrepared8
