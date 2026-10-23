import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft6_005Part00
import D1Bound5.SmallPairLightAdaptiveLeft6_005Part01
import D1Bound5.SmallPairLightAdaptiveLeft6_005Part02
import D1Bound5.SmallPairLightAdaptiveLeft6_005Part03

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_005_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 189
      leftCached005 leftRows005 = true := by
  have h0618 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 40
      (PairLightPrepared6.leftCached.drop 618) (PairLightPrepared6.leftRows.drop 618) = true := left_prefix_005_part03_checked
  have h0552 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 106
      (PairLightPrepared6.leftCached.drop 552) (PairLightPrepared6.leftRows.drop 552) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 66 40
      (PairLightPrepared6.leftCached.drop 552) (PairLightPrepared6.leftRows.drop 552)
    · exact left_prefix_005_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0618
  have h0506 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 152
      (PairLightPrepared6.leftCached.drop 506) (PairLightPrepared6.leftRows.drop 506) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 46 106
      (PairLightPrepared6.leftCached.drop 506) (PairLightPrepared6.leftRows.drop 506)
    · exact left_prefix_005_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0552
  have h0469 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 189
      (PairLightPrepared6.leftCached.drop 469) (PairLightPrepared6.leftRows.drop 469) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 37 152
      (PairLightPrepared6.leftCached.drop 469) (PairLightPrepared6.leftRows.drop 469)
    · exact left_prefix_005_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0506
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, leftCached003, leftRows003, leftCached004, leftRows004, leftCached005, leftRows005, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0469

end D1Bound5.PairLightAdaptivePrepared6
