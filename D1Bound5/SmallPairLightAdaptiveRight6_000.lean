import D1Bound5.SmallPairLightAdaptiveData6
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight6_000Part00
import D1Bound5.SmallPairLightAdaptiveRight6_000Part01
import D1Bound5.SmallPairLightAdaptiveRight6_000Part02
import D1Bound5.SmallPairLightAdaptiveRight6_000Part03
import D1Bound5.SmallPairLightAdaptiveRight6_000Part04
import D1Bound5.SmallPairLightAdaptiveRight6_000Part05

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 64
      rightCached000 rightRows000 = true := by
  have h0053 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 11
      (PairLightPrepared6.rightCached.drop 53) (PairLightPrepared6.rightRows.drop 53) = true := right_prefix_000_part05_checked
  have h0042 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 22
      (PairLightPrepared6.rightCached.drop 42) (PairLightPrepared6.rightRows.drop 42) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 11 11
      (PairLightPrepared6.rightCached.drop 42) (PairLightPrepared6.rightRows.drop 42)
    · exact right_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0053
  have h0031 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 33
      (PairLightPrepared6.rightCached.drop 31) (PairLightPrepared6.rightRows.drop 31) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 11 22
      (PairLightPrepared6.rightCached.drop 31) (PairLightPrepared6.rightRows.drop 31)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0042
  have h0020 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 44
      (PairLightPrepared6.rightCached.drop 20) (PairLightPrepared6.rightRows.drop 20) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 11 33
      (PairLightPrepared6.rightCached.drop 20) (PairLightPrepared6.rightRows.drop 20)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0031
  have h0010 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 54
      (PairLightPrepared6.rightCached.drop 10) (PairLightPrepared6.rightRows.drop 10) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 10 44
      (PairLightPrepared6.rightCached.drop 10) (PairLightPrepared6.rightRows.drop 10)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0020
  have h0000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 64
      (PairLightPrepared6.rightCached.drop 0) (PairLightPrepared6.rightRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared6.sieve 10 54
      (PairLightPrepared6.rightCached.drop 0) (PairLightPrepared6.rightRows.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0010
  simpa only [rightCached000, rightRows000, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0000

end D1Bound5.PairLightAdaptivePrepared6
