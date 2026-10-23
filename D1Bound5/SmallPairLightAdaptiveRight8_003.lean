import D1Bound5.SmallPairLightAdaptiveData8
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight8_003Part00
import D1Bound5.SmallPairLightAdaptiveRight8_003Part01
import D1Bound5.SmallPairLightAdaptiveRight8_003Part02
import D1Bound5.SmallPairLightAdaptiveRight8_003Part03
import D1Bound5.SmallPairLightAdaptiveRight8_003Part04
import D1Bound5.SmallPairLightAdaptiveRight8_003Part05

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 82
      rightCached003 rightRows003 = true := by
  have h0260 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 14
      (PairLightPrepared8.rightCached.drop 260) (PairLightPrepared8.rightRows.drop 260) = true := right_prefix_003_part05_checked
  have h0246 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 28
      (PairLightPrepared8.rightCached.drop 246) (PairLightPrepared8.rightRows.drop 246) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 14 14
      (PairLightPrepared8.rightCached.drop 246) (PairLightPrepared8.rightRows.drop 246)
    · exact right_prefix_003_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0260
  have h0232 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 42
      (PairLightPrepared8.rightCached.drop 232) (PairLightPrepared8.rightRows.drop 232) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 14 28
      (PairLightPrepared8.rightCached.drop 232) (PairLightPrepared8.rightRows.drop 232)
    · exact right_prefix_003_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0246
  have h0218 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 56
      (PairLightPrepared8.rightCached.drop 218) (PairLightPrepared8.rightRows.drop 218) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 14 42
      (PairLightPrepared8.rightCached.drop 218) (PairLightPrepared8.rightRows.drop 218)
    · exact right_prefix_003_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0232
  have h0205 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 69
      (PairLightPrepared8.rightCached.drop 205) (PairLightPrepared8.rightRows.drop 205) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 13 56
      (PairLightPrepared8.rightCached.drop 205) (PairLightPrepared8.rightRows.drop 205)
    · exact right_prefix_003_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0218
  have h0192 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 82
      (PairLightPrepared8.rightCached.drop 192) (PairLightPrepared8.rightRows.drop 192) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 13 69
      (PairLightPrepared8.rightCached.drop 192) (PairLightPrepared8.rightRows.drop 192)
    · exact right_prefix_003_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0205
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, rightCached003, rightRows003, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0192

end D1Bound5.PairLightAdaptivePrepared8
