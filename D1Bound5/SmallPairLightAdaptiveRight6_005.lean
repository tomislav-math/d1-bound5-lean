import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight6_005Part00
import D1Bound5.SmallPairLightAdaptiveRight6_005Part01
import D1Bound5.SmallPairLightAdaptiveRight6_005Part02
import D1Bound5.SmallPairLightAdaptiveRight6_005Part03

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_005_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 181
      rightCached005 rightRows005 = true := by
  have h0638 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 19
      (PairLightPrepared6.rightCached.drop 638) (PairLightPrepared6.rightRows.drop 638) = true := right_prefix_005_part03_checked
  have h0563 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 94
      (PairLightPrepared6.rightCached.drop 563) (PairLightPrepared6.rightRows.drop 563) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 75 19
      (PairLightPrepared6.rightCached.drop 563) (PairLightPrepared6.rightRows.drop 563)
    · exact right_prefix_005_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0638
  have h0514 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 143
      (PairLightPrepared6.rightCached.drop 514) (PairLightPrepared6.rightRows.drop 514) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 49 94
      (PairLightPrepared6.rightCached.drop 514) (PairLightPrepared6.rightRows.drop 514)
    · exact right_prefix_005_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0563
  have h0476 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 181
      (PairLightPrepared6.rightCached.drop 476) (PairLightPrepared6.rightRows.drop 476) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 38 143
      (PairLightPrepared6.rightCached.drop 476) (PairLightPrepared6.rightRows.drop 476)
    · exact right_prefix_005_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0514
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, rightCached003, rightRows003, rightCached004, rightRows004, rightCached005, rightRows005, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0476

end D1Bound5.PairLightAdaptivePrepared6
