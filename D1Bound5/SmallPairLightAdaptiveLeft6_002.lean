import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft6_002Part00
import D1Bound5.SmallPairLightAdaptiveLeft6_002Part01
import D1Bound5.SmallPairLightAdaptiveLeft6_002Part02
import D1Bound5.SmallPairLightAdaptiveLeft6_002Part03
import D1Bound5.SmallPairLightAdaptiveLeft6_002Part04
import D1Bound5.SmallPairLightAdaptiveLeft6_002Part05

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 82
      leftCached002 leftRows002 = true := by
  have h0202 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 14
      (PairLightPrepared6.leftCached.drop 202) (PairLightPrepared6.leftRows.drop 202) = true := left_prefix_002_part05_checked
  have h0188 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 28
      (PairLightPrepared6.leftCached.drop 188) (PairLightPrepared6.leftRows.drop 188) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 14 14
      (PairLightPrepared6.leftCached.drop 188) (PairLightPrepared6.leftRows.drop 188)
    · exact left_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0202
  have h0174 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 42
      (PairLightPrepared6.leftCached.drop 174) (PairLightPrepared6.leftRows.drop 174) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 14 28
      (PairLightPrepared6.leftCached.drop 174) (PairLightPrepared6.leftRows.drop 174)
    · exact left_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0188
  have h0160 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 56
      (PairLightPrepared6.leftCached.drop 160) (PairLightPrepared6.leftRows.drop 160) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 14 42
      (PairLightPrepared6.leftCached.drop 160) (PairLightPrepared6.leftRows.drop 160)
    · exact left_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0174
  have h0147 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 69
      (PairLightPrepared6.leftCached.drop 147) (PairLightPrepared6.leftRows.drop 147) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 13 56
      (PairLightPrepared6.leftCached.drop 147) (PairLightPrepared6.leftRows.drop 147)
    · exact left_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0160
  have h0134 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 82
      (PairLightPrepared6.leftCached.drop 134) (PairLightPrepared6.leftRows.drop 134) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 13 69
      (PairLightPrepared6.leftCached.drop 134) (PairLightPrepared6.leftRows.drop 134)
    · exact left_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0147
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0134

end D1Bound5.PairLightAdaptivePrepared6
