import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft6_003Part00
import D1Bound5.SmallPairLightAdaptiveLeft6_003Part01
import D1Bound5.SmallPairLightAdaptiveLeft6_003Part02
import D1Bound5.SmallPairLightAdaptiveLeft6_003Part03
import D1Bound5.SmallPairLightAdaptiveLeft6_003Part04
import D1Bound5.SmallPairLightAdaptiveLeft6_003Part05

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 102
      leftCached003 leftRows003 = true := by
  have h0299 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 19
      (PairLightPrepared6.leftCached.drop 299) (PairLightPrepared6.leftRows.drop 299) = true := left_prefix_003_part05_checked
  have h0281 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 37
      (PairLightPrepared6.leftCached.drop 281) (PairLightPrepared6.leftRows.drop 281) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 18 19
      (PairLightPrepared6.leftCached.drop 281) (PairLightPrepared6.leftRows.drop 281)
    · exact left_prefix_003_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0299
  have h0264 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 54
      (PairLightPrepared6.leftCached.drop 264) (PairLightPrepared6.leftRows.drop 264) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 17 37
      (PairLightPrepared6.leftCached.drop 264) (PairLightPrepared6.leftRows.drop 264)
    · exact left_prefix_003_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0281
  have h0247 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 71
      (PairLightPrepared6.leftCached.drop 247) (PairLightPrepared6.leftRows.drop 247) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 17 54
      (PairLightPrepared6.leftCached.drop 247) (PairLightPrepared6.leftRows.drop 247)
    · exact left_prefix_003_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0264
  have h0231 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 87
      (PairLightPrepared6.leftCached.drop 231) (PairLightPrepared6.leftRows.drop 231) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 16 71
      (PairLightPrepared6.leftCached.drop 231) (PairLightPrepared6.leftRows.drop 231)
    · exact left_prefix_003_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0247
  have h0216 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 102
      (PairLightPrepared6.leftCached.drop 216) (PairLightPrepared6.leftRows.drop 216) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 15 87
      (PairLightPrepared6.leftCached.drop 216) (PairLightPrepared6.leftRows.drop 216)
    · exact left_prefix_003_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0231
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, leftCached003, leftRows003, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0216

end D1Bound5.PairLightAdaptivePrepared6
