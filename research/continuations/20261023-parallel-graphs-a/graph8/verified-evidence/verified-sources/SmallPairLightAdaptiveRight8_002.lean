import D1Bound5.SmallPairLightAdaptiveData8
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight8_002Part00
import D1Bound5.SmallPairLightAdaptiveRight8_002Part01
import D1Bound5.SmallPairLightAdaptiveRight8_002Part02
import D1Bound5.SmallPairLightAdaptiveRight8_002Part03
import D1Bound5.SmallPairLightAdaptiveRight8_002Part04
import D1Bound5.SmallPairLightAdaptiveRight8_002Part05

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 71
      rightCached002 rightRows002 = true := by
  have h0179 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 13
      (PairLightPrepared8.rightCached.drop 179) (PairLightPrepared8.rightRows.drop 179) = true := right_prefix_002_part05_checked
  have h0167 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 25
      (PairLightPrepared8.rightCached.drop 167) (PairLightPrepared8.rightRows.drop 167) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 12 13
      (PairLightPrepared8.rightCached.drop 167) (PairLightPrepared8.rightRows.drop 167)
    · exact right_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0179
  have h0155 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 37
      (PairLightPrepared8.rightCached.drop 155) (PairLightPrepared8.rightRows.drop 155) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 12 25
      (PairLightPrepared8.rightCached.drop 155) (PairLightPrepared8.rightRows.drop 155)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0167
  have h0143 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 49
      (PairLightPrepared8.rightCached.drop 143) (PairLightPrepared8.rightRows.drop 143) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 12 37
      (PairLightPrepared8.rightCached.drop 143) (PairLightPrepared8.rightRows.drop 143)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0155
  have h0132 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 60
      (PairLightPrepared8.rightCached.drop 132) (PairLightPrepared8.rightRows.drop 132) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 11 49
      (PairLightPrepared8.rightCached.drop 132) (PairLightPrepared8.rightRows.drop 132)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0143
  have h0121 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 71
      (PairLightPrepared8.rightCached.drop 121) (PairLightPrepared8.rightRows.drop 121) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared8.sieve 11 60
      (PairLightPrepared8.rightCached.drop 121) (PairLightPrepared8.rightRows.drop 121)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0132
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0121

end D1Bound5.PairLightAdaptivePrepared8
