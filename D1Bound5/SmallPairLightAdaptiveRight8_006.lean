import D1Bound5.SmallPairLightAdaptiveData8
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight8_006Part00
import D1Bound5.SmallPairLightAdaptiveRight8_006Part01
import D1Bound5.SmallPairLightAdaptiveRight8_006Part02
import D1Bound5.SmallPairLightAdaptiveRight8_006Part03

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_006_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 194
      rightCached006 rightRows006 = true := by
  have h0665 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 53
      (PairLightPrepared8.rightCached.drop 665) (PairLightPrepared8.rightRows.drop 665) = true := right_prefix_006_part03_checked
  have h0604 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 114
      (PairLightPrepared8.rightCached.drop 604) (PairLightPrepared8.rightRows.drop 604) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 61 53
      (PairLightPrepared8.rightCached.drop 604) (PairLightPrepared8.rightRows.drop 604)
    · exact right_prefix_006_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0665
  have h0560 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 158
      (PairLightPrepared8.rightCached.drop 560) (PairLightPrepared8.rightRows.drop 560) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 44 114
      (PairLightPrepared8.rightCached.drop 560) (PairLightPrepared8.rightRows.drop 560)
    · exact right_prefix_006_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0604
  have h0524 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 194
      (PairLightPrepared8.rightCached.drop 524) (PairLightPrepared8.rightRows.drop 524) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 36 158
      (PairLightPrepared8.rightCached.drop 524) (PairLightPrepared8.rightRows.drop 524)
    · exact right_prefix_006_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0560
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, rightCached003, rightRows003, rightCached004, rightRows004, rightCached005, rightRows005, rightCached006, rightRows006, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0524

end D1Bound5.PairLightAdaptivePrepared8
