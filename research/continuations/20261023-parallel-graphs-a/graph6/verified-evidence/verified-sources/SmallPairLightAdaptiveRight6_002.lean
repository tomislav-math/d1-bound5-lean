import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight6_002Part00
import D1Bound5.SmallPairLightAdaptiveRight6_002Part01
import D1Bound5.SmallPairLightAdaptiveRight6_002Part02
import D1Bound5.SmallPairLightAdaptiveRight6_002Part03
import D1Bound5.SmallPairLightAdaptiveRight6_002Part04
import D1Bound5.SmallPairLightAdaptiveRight6_002Part05

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 83
      rightCached002 rightRows002 = true := by
  have h0203 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 15
      (PairLightPrepared6.rightCached.drop 203) (PairLightPrepared6.rightRows.drop 203) = true := right_prefix_002_part05_checked
  have h0189 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 29
      (PairLightPrepared6.rightCached.drop 189) (PairLightPrepared6.rightRows.drop 189) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 14 15
      (PairLightPrepared6.rightCached.drop 189) (PairLightPrepared6.rightRows.drop 189)
    · exact right_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0203
  have h0175 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 43
      (PairLightPrepared6.rightCached.drop 175) (PairLightPrepared6.rightRows.drop 175) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 14 29
      (PairLightPrepared6.rightCached.drop 175) (PairLightPrepared6.rightRows.drop 175)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0189
  have h0161 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 57
      (PairLightPrepared6.rightCached.drop 161) (PairLightPrepared6.rightRows.drop 161) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 14 43
      (PairLightPrepared6.rightCached.drop 161) (PairLightPrepared6.rightRows.drop 161)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0175
  have h0148 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 70
      (PairLightPrepared6.rightCached.drop 148) (PairLightPrepared6.rightRows.drop 148) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 13 57
      (PairLightPrepared6.rightCached.drop 148) (PairLightPrepared6.rightRows.drop 148)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0161
  have h0135 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 83
      (PairLightPrepared6.rightCached.drop 135) (PairLightPrepared6.rightRows.drop 135) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 13 70
      (PairLightPrepared6.rightCached.drop 135) (PairLightPrepared6.rightRows.drop 135)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0148
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0135

end D1Bound5.PairLightAdaptivePrepared6
