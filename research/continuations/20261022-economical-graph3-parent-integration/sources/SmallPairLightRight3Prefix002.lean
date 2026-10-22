import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight3_002Part00
import D1Bound5.SmallPairLightAdaptiveRight3_002Part01
import D1Bound5.SmallPairLightAdaptiveRight3_002Part02
import D1Bound5.SmallPairLightAdaptiveRight3_002Part03
import D1Bound5.SmallPairLightAdaptiveRight3_002Part04

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 108
      (PairLightPrepared3.rightCached.drop 306) (PairLightPrepared3.rightRows.drop 306) = true := by
  have h402 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 12
      (PairLightPrepared3.rightCached.drop 402) (PairLightPrepared3.rightRows.drop 402) = true := right_prefix_002_part04_checked
  have h378 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 36
      (PairLightPrepared3.rightCached.drop 378) (PairLightPrepared3.rightRows.drop 378) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared3.sieve 24 12
      (PairLightPrepared3.rightCached.drop 378) (PairLightPrepared3.rightRows.drop 378)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h402
  have h354 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 60
      (PairLightPrepared3.rightCached.drop 354) (PairLightPrepared3.rightRows.drop 354) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared3.sieve 24 36
      (PairLightPrepared3.rightCached.drop 354) (PairLightPrepared3.rightRows.drop 354)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h378
  have h330 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 84
      (PairLightPrepared3.rightCached.drop 330) (PairLightPrepared3.rightRows.drop 330) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared3.sieve 24 60
      (PairLightPrepared3.rightCached.drop 330) (PairLightPrepared3.rightRows.drop 330)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h354
  have h306 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 108
      (PairLightPrepared3.rightCached.drop 306) (PairLightPrepared3.rightRows.drop 306) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared3.sieve 24 84
      (PairLightPrepared3.rightCached.drop 306) (PairLightPrepared3.rightRows.drop 306)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h330
  exact h306
end D1Bound5.PairLightAdaptivePrepared3
