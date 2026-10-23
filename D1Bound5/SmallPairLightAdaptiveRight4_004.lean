import D1Bound5.SmallPairLightAdaptiveData4
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight4_004Part00
import D1Bound5.SmallPairLightAdaptiveRight4_004Part01
import D1Bound5.SmallPairLightAdaptiveRight4_004Part02
import D1Bound5.SmallPairLightAdaptiveRight4_004Part03

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 191
      rightCached004 rightRows004 = true := by
  have h0550 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 46
      (PairLightPrepared4.rightCached.drop 550) (PairLightPrepared4.rightRows.drop 550) = true := right_prefix_004_part03_checked
  have h0486 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 110
      (PairLightPrepared4.rightCached.drop 486) (PairLightPrepared4.rightRows.drop 486) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 64 46
      (PairLightPrepared4.rightCached.drop 486) (PairLightPrepared4.rightRows.drop 486)
    · exact right_prefix_004_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0550
  have h0441 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 155
      (PairLightPrepared4.rightCached.drop 441) (PairLightPrepared4.rightRows.drop 441) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 45 110
      (PairLightPrepared4.rightCached.drop 441) (PairLightPrepared4.rightRows.drop 441)
    · exact right_prefix_004_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0486
  have h0405 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 191
      (PairLightPrepared4.rightCached.drop 405) (PairLightPrepared4.rightRows.drop 405) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared4.sieve 36 155
      (PairLightPrepared4.rightCached.drop 405) (PairLightPrepared4.rightRows.drop 405)
    · exact right_prefix_004_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0441
  simpa only [rightCached000, rightRows000, rightCached001, rightRows001, rightCached002, rightRows002, rightCached003, rightRows003, rightCached004, rightRows004, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0405

end D1Bound5.PairLightAdaptivePrepared4
