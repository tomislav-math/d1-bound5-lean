import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft39_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft39_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft39_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft39_001Part03
import D1Bound5.SmallPairLightAdaptiveLeft39_001Part04
import D1Bound5.SmallPairLightAdaptiveLeft39_001Part05

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_001_direct_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 136
      (PairLightPrepared39.leftCached.drop 97) (PairLightPrepared39.leftRows.drop 97) = true := by
  have h217 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 16
      (PairLightPrepared39.leftCached.drop 217) (PairLightPrepared39.leftRows.drop 217) = true := left_prefix_001_part05_checked
  have h193 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 40
      (PairLightPrepared39.leftCached.drop 193) (PairLightPrepared39.leftRows.drop 193) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 16
      (PairLightPrepared39.leftCached.drop 193) (PairLightPrepared39.leftRows.drop 193)
    · exact left_prefix_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h217
  have h169 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 64
      (PairLightPrepared39.leftCached.drop 169) (PairLightPrepared39.leftRows.drop 169) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 40
      (PairLightPrepared39.leftCached.drop 169) (PairLightPrepared39.leftRows.drop 169)
    · exact left_prefix_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h193
  have h145 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 88
      (PairLightPrepared39.leftCached.drop 145) (PairLightPrepared39.leftRows.drop 145) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 64
      (PairLightPrepared39.leftCached.drop 145) (PairLightPrepared39.leftRows.drop 145)
    · exact left_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h169
  have h121 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 112
      (PairLightPrepared39.leftCached.drop 121) (PairLightPrepared39.leftRows.drop 121) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 88
      (PairLightPrepared39.leftCached.drop 121) (PairLightPrepared39.leftRows.drop 121)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h145
  have h097 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 136
      (PairLightPrepared39.leftCached.drop 97) (PairLightPrepared39.leftRows.drop 97) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 112
      (PairLightPrepared39.leftCached.drop 97) (PairLightPrepared39.leftRows.drop 97)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h121
  exact h097
end D1Bound5.PairLightAdaptivePrepared39
