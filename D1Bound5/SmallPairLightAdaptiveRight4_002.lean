import D1Bound5.SmallPairLightAdaptiveData4
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight4_002Part00
import D1Bound5.SmallPairLightAdaptiveRight4_002Part01
import D1Bound5.SmallPairLightAdaptiveRight4_002Part02
import D1Bound5.SmallPairLightAdaptiveRight4_002Part03
import D1Bound5.SmallPairLightAdaptiveRight4_002Part04
import D1Bound5.SmallPairLightAdaptiveRight4_002Part05

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 102
      rightCached002 rightRows002 = true := by
  have h0236 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 19
      (PairLightPrepared4.rightCached.drop 236) (PairLightPrepared4.rightRows.drop 236) = true := right_prefix_002_part05_checked
  have h0218 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 37
      (PairLightPrepared4.rightCached.drop 218) (PairLightPrepared4.rightRows.drop 218) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 18 19
      (PairLightPrepared4.rightCached.drop 218) (PairLightPrepared4.rightRows.drop 218)
    · exact right_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0236
  have h0201 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 54
      (PairLightPrepared4.rightCached.drop 201) (PairLightPrepared4.rightRows.drop 201) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 17 37
      (PairLightPrepared4.rightCached.drop 201) (PairLightPrepared4.rightRows.drop 201)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0218
  have h0184 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 71
      (PairLightPrepared4.rightCached.drop 184) (PairLightPrepared4.rightRows.drop 184) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 17 54
      (PairLightPrepared4.rightCached.drop 184) (PairLightPrepared4.rightRows.drop 184)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0201
  have h0168 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 87
      (PairLightPrepared4.rightCached.drop 168) (PairLightPrepared4.rightRows.drop 168) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 16 71
      (PairLightPrepared4.rightCached.drop 168) (PairLightPrepared4.rightRows.drop 168)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0184
  have h0153 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 102
      (PairLightPrepared4.rightCached.drop 153) (PairLightPrepared4.rightRows.drop 153) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 15 87
      (PairLightPrepared4.rightCached.drop 153) (PairLightPrepared4.rightRows.drop 153)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0168
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0153

end D1Bound5.PairLightAdaptivePrepared4
