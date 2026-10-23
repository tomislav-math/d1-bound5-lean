import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft6_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft6_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft6_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft6_001Part03
import D1Bound5.SmallPairLightAdaptiveLeft6_001Part04
import D1Bound5.SmallPairLightAdaptiveLeft6_001Part05

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 71
      leftCached001 leftRows001 = true := by
  have h0122 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 12
      (PairLightPrepared6.leftCached.drop 122) (PairLightPrepared6.leftRows.drop 122) = true := left_prefix_001_part05_checked
  have h0110 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 24
      (PairLightPrepared6.leftCached.drop 110) (PairLightPrepared6.leftRows.drop 110) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 12 12
      (PairLightPrepared6.leftCached.drop 110) (PairLightPrepared6.leftRows.drop 110)
    · exact left_prefix_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0122
  have h0098 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 36
      (PairLightPrepared6.leftCached.drop 98) (PairLightPrepared6.leftRows.drop 98) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 12 24
      (PairLightPrepared6.leftCached.drop 98) (PairLightPrepared6.leftRows.drop 98)
    · exact left_prefix_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0110
  have h0086 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 48
      (PairLightPrepared6.leftCached.drop 86) (PairLightPrepared6.leftRows.drop 86) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 12 36
      (PairLightPrepared6.leftCached.drop 86) (PairLightPrepared6.leftRows.drop 86)
    · exact left_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0098
  have h0074 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 60
      (PairLightPrepared6.leftCached.drop 74) (PairLightPrepared6.leftRows.drop 74) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 12 48
      (PairLightPrepared6.leftCached.drop 74) (PairLightPrepared6.leftRows.drop 74)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0086
  have h0063 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 71
      (PairLightPrepared6.leftCached.drop 63) (PairLightPrepared6.leftRows.drop 63) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 11 60
      (PairLightPrepared6.leftCached.drop 63) (PairLightPrepared6.leftRows.drop 63)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0074
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0063

end D1Bound5.PairLightAdaptivePrepared6
