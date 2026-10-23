import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight24_001Part00
import D1Bound5.SmallPairLightAdaptiveRight24_001Part01
import D1Bound5.SmallPairLightAdaptiveRight24_001Part02
import D1Bound5.SmallPairLightAdaptiveRight24_001Part03
import D1Bound5.SmallPairLightAdaptiveRight24_001Part04
import D1Bound5.SmallPairLightAdaptiveRight24_001Part05
import D1Bound5.SmallPairLightAdaptiveRight24_001Part06

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_001_direct_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 147
      (PairLightPrepared24.rightCached.drop 101) (PairLightPrepared24.rightRows.drop 101) = true := by
  have h245 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 3
      (PairLightPrepared24.rightCached.drop 245) (PairLightPrepared24.rightRows.drop 245) = true := right_prefix_001_part06_checked
  have h221 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 27
      (PairLightPrepared24.rightCached.drop 221) (PairLightPrepared24.rightRows.drop 221) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 24 3
      (PairLightPrepared24.rightCached.drop 221) (PairLightPrepared24.rightRows.drop 221)
    · exact right_prefix_001_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h245
  have h197 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 51
      (PairLightPrepared24.rightCached.drop 197) (PairLightPrepared24.rightRows.drop 197) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 24 27
      (PairLightPrepared24.rightCached.drop 197) (PairLightPrepared24.rightRows.drop 197)
    · exact right_prefix_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h221
  have h173 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 75
      (PairLightPrepared24.rightCached.drop 173) (PairLightPrepared24.rightRows.drop 173) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 24 51
      (PairLightPrepared24.rightCached.drop 173) (PairLightPrepared24.rightRows.drop 173)
    · exact right_prefix_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h197
  have h149 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 99
      (PairLightPrepared24.rightCached.drop 149) (PairLightPrepared24.rightRows.drop 149) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 24 75
      (PairLightPrepared24.rightCached.drop 149) (PairLightPrepared24.rightRows.drop 149)
    · exact right_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h173
  have h125 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 123
      (PairLightPrepared24.rightCached.drop 125) (PairLightPrepared24.rightRows.drop 125) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 24 99
      (PairLightPrepared24.rightCached.drop 125) (PairLightPrepared24.rightRows.drop 125)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h149
  have h101 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 147
      (PairLightPrepared24.rightCached.drop 101) (PairLightPrepared24.rightRows.drop 101) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 24 123
      (PairLightPrepared24.rightCached.drop 101) (PairLightPrepared24.rightRows.drop 101)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h125
  exact h101
end D1Bound5.PairLightAdaptivePrepared24
