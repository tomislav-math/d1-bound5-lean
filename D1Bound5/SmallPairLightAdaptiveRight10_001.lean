import D1Bound5.SmallPairLightAdaptiveData10
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight10_001Part00
import D1Bound5.SmallPairLightAdaptiveRight10_001Part01
import D1Bound5.SmallPairLightAdaptiveRight10_001Part02
import D1Bound5.SmallPairLightAdaptiveRight10_001Part03
import D1Bound5.SmallPairLightAdaptiveRight10_001Part04
import D1Bound5.SmallPairLightAdaptiveRight10_001Part05

namespace D1Bound5.PairLightAdaptivePrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 82
      rightCached001 rightRows001 = true := by
  have h0139 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 14
      (PairLightPrepared10.rightCached.drop 139) (PairLightPrepared10.rightRows.drop 139) = true := right_prefix_001_part05_checked
  have h0125 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 28
      (PairLightPrepared10.rightCached.drop 125) (PairLightPrepared10.rightRows.drop 125) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 14 14
      (PairLightPrepared10.rightCached.drop 125) (PairLightPrepared10.rightRows.drop 125)
    · exact right_prefix_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0139
  have h0111 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 42
      (PairLightPrepared10.rightCached.drop 111) (PairLightPrepared10.rightRows.drop 111) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 14 28
      (PairLightPrepared10.rightCached.drop 111) (PairLightPrepared10.rightRows.drop 111)
    · exact right_prefix_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0125
  have h0097 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 56
      (PairLightPrepared10.rightCached.drop 97) (PairLightPrepared10.rightRows.drop 97) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 14 42
      (PairLightPrepared10.rightCached.drop 97) (PairLightPrepared10.rightRows.drop 97)
    · exact right_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0111
  have h0084 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 69
      (PairLightPrepared10.rightCached.drop 84) (PairLightPrepared10.rightRows.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 13 56
      (PairLightPrepared10.rightCached.drop 84) (PairLightPrepared10.rightRows.drop 84)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0097
  have h0071 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 82
      (PairLightPrepared10.rightCached.drop 71) (PairLightPrepared10.rightRows.drop 71) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 13 69
      (PairLightPrepared10.rightCached.drop 71) (PairLightPrepared10.rightRows.drop 71)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0084
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0071

end D1Bound5.PairLightAdaptivePrepared10
