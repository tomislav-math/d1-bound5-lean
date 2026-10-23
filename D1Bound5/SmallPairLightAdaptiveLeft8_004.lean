import D1Bound5.SmallPairLightAdaptiveData8
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft8_004Part00
import D1Bound5.SmallPairLightAdaptiveLeft8_004Part01
import D1Bound5.SmallPairLightAdaptiveLeft8_004Part02
import D1Bound5.SmallPairLightAdaptiveLeft8_004Part03
import D1Bound5.SmallPairLightAdaptiveLeft8_004Part04
import D1Bound5.SmallPairLightAdaptiveLeft8_004Part05

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 102
      leftCached004 leftRows004 = true := by
  have h0357 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 19
      (PairLightPrepared8.leftCached.drop 357) (PairLightPrepared8.leftRows.drop 357) = true := left_prefix_004_part05_checked
  have h0339 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 37
      (PairLightPrepared8.leftCached.drop 339) (PairLightPrepared8.leftRows.drop 339) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 18 19
      (PairLightPrepared8.leftCached.drop 339) (PairLightPrepared8.leftRows.drop 339)
    · exact left_prefix_004_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0357
  have h0322 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 54
      (PairLightPrepared8.leftCached.drop 322) (PairLightPrepared8.leftRows.drop 322) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 17 37
      (PairLightPrepared8.leftCached.drop 322) (PairLightPrepared8.leftRows.drop 322)
    · exact left_prefix_004_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0339
  have h0305 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 71
      (PairLightPrepared8.leftCached.drop 305) (PairLightPrepared8.leftRows.drop 305) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 17 54
      (PairLightPrepared8.leftCached.drop 305) (PairLightPrepared8.leftRows.drop 305)
    · exact left_prefix_004_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0322
  have h0289 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 87
      (PairLightPrepared8.leftCached.drop 289) (PairLightPrepared8.leftRows.drop 289) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 16 71
      (PairLightPrepared8.leftCached.drop 289) (PairLightPrepared8.leftRows.drop 289)
    · exact left_prefix_004_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0305
  have h0274 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 102
      (PairLightPrepared8.leftCached.drop 274) (PairLightPrepared8.leftRows.drop 274) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 15 87
      (PairLightPrepared8.leftCached.drop 274) (PairLightPrepared8.leftRows.drop 274)
    · exact left_prefix_004_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0289
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, leftCached003, leftRows003, leftCached004, leftRows004, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0274

end D1Bound5.PairLightAdaptivePrepared8
