import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part03
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part04
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part05
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part06
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part07
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part08
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part09
import D1Bound5.SmallPairLightAdaptiveLeft43_001Part10

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_001_direct_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 121
      (PairLightPrepared43.leftCached.drop 91) (PairLightPrepared43.leftRows.drop 91) = true := by
  have h211 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 1
      (PairLightPrepared43.leftCached.drop 211) (PairLightPrepared43.leftRows.drop 211) = true := left_prefix_001_part10_checked
  have h199 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 13
      (PairLightPrepared43.leftCached.drop 199) (PairLightPrepared43.leftRows.drop 199) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 1
      (PairLightPrepared43.leftCached.drop 199) (PairLightPrepared43.leftRows.drop 199)
    · exact left_prefix_001_part09_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h211
  have h187 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 25
      (PairLightPrepared43.leftCached.drop 187) (PairLightPrepared43.leftRows.drop 187) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 13
      (PairLightPrepared43.leftCached.drop 187) (PairLightPrepared43.leftRows.drop 187)
    · exact left_prefix_001_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h199
  have h175 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 37
      (PairLightPrepared43.leftCached.drop 175) (PairLightPrepared43.leftRows.drop 175) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 25
      (PairLightPrepared43.leftCached.drop 175) (PairLightPrepared43.leftRows.drop 175)
    · exact left_prefix_001_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h187
  have h163 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 49
      (PairLightPrepared43.leftCached.drop 163) (PairLightPrepared43.leftRows.drop 163) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 37
      (PairLightPrepared43.leftCached.drop 163) (PairLightPrepared43.leftRows.drop 163)
    · exact left_prefix_001_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h175
  have h151 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 61
      (PairLightPrepared43.leftCached.drop 151) (PairLightPrepared43.leftRows.drop 151) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 49
      (PairLightPrepared43.leftCached.drop 151) (PairLightPrepared43.leftRows.drop 151)
    · exact left_prefix_001_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h163
  have h139 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 73
      (PairLightPrepared43.leftCached.drop 139) (PairLightPrepared43.leftRows.drop 139) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 61
      (PairLightPrepared43.leftCached.drop 139) (PairLightPrepared43.leftRows.drop 139)
    · exact left_prefix_001_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h151
  have h127 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 85
      (PairLightPrepared43.leftCached.drop 127) (PairLightPrepared43.leftRows.drop 127) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 73
      (PairLightPrepared43.leftCached.drop 127) (PairLightPrepared43.leftRows.drop 127)
    · exact left_prefix_001_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h139
  have h115 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 97
      (PairLightPrepared43.leftCached.drop 115) (PairLightPrepared43.leftRows.drop 115) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 85
      (PairLightPrepared43.leftCached.drop 115) (PairLightPrepared43.leftRows.drop 115)
    · exact left_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h127
  have h103 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 109
      (PairLightPrepared43.leftCached.drop 103) (PairLightPrepared43.leftRows.drop 103) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 97
      (PairLightPrepared43.leftCached.drop 103) (PairLightPrepared43.leftRows.drop 103)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h115
  have h091 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 121
      (PairLightPrepared43.leftCached.drop 91) (PairLightPrepared43.leftRows.drop 91) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 109
      (PairLightPrepared43.leftCached.drop 91) (PairLightPrepared43.leftRows.drop 91)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h103
  exact h091
end D1Bound5.PairLightAdaptivePrepared43
