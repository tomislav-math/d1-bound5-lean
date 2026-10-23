import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight39_001Part00
import D1Bound5.SmallPairLightAdaptiveRight39_001Part01
import D1Bound5.SmallPairLightAdaptiveRight39_001Part02
import D1Bound5.SmallPairLightAdaptiveRight39_001Part03
import D1Bound5.SmallPairLightAdaptiveRight39_001Part04
import D1Bound5.SmallPairLightAdaptiveRight39_001Part05

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_001_direct_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 138
      (PairLightPrepared39.rightCached.drop 98) (PairLightPrepared39.rightRows.drop 98) = true := by
  have h218 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 18
      (PairLightPrepared39.rightCached.drop 218) (PairLightPrepared39.rightRows.drop 218) = true := right_prefix_001_part05_checked
  have h194 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 42
      (PairLightPrepared39.rightCached.drop 194) (PairLightPrepared39.rightRows.drop 194) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 18
      (PairLightPrepared39.rightCached.drop 194) (PairLightPrepared39.rightRows.drop 194)
    · exact right_prefix_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h218
  have h170 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 66
      (PairLightPrepared39.rightCached.drop 170) (PairLightPrepared39.rightRows.drop 170) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 42
      (PairLightPrepared39.rightCached.drop 170) (PairLightPrepared39.rightRows.drop 170)
    · exact right_prefix_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h194
  have h146 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 90
      (PairLightPrepared39.rightCached.drop 146) (PairLightPrepared39.rightRows.drop 146) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 66
      (PairLightPrepared39.rightCached.drop 146) (PairLightPrepared39.rightRows.drop 146)
    · exact right_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h170
  have h122 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 114
      (PairLightPrepared39.rightCached.drop 122) (PairLightPrepared39.rightRows.drop 122) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 90
      (PairLightPrepared39.rightCached.drop 122) (PairLightPrepared39.rightRows.drop 122)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h146
  have h098 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 138
      (PairLightPrepared39.rightCached.drop 98) (PairLightPrepared39.rightRows.drop 98) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 114
      (PairLightPrepared39.rightCached.drop 98) (PairLightPrepared39.rightRows.drop 98)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h122
  exact h098
end D1Bound5.PairLightAdaptivePrepared39
