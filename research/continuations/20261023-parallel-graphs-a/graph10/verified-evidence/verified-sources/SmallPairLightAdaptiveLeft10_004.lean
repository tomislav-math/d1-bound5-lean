import D1Bound5.SmallPairLightAdaptiveData10
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft10_004Part00
import D1Bound5.SmallPairLightAdaptiveLeft10_004Part01
import D1Bound5.SmallPairLightAdaptiveLeft10_004Part02
import D1Bound5.SmallPairLightAdaptiveLeft10_004Part03

namespace D1Bound5.PairLightAdaptivePrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 191
      leftCached004 leftRows004 = true := by
  have h0550 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 46
      (PairLightPrepared10.leftCached.drop 550) (PairLightPrepared10.leftRows.drop 550) = true := left_prefix_004_part03_checked
  have h0486 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 110
      (PairLightPrepared10.leftCached.drop 486) (PairLightPrepared10.leftRows.drop 486) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 64 46
      (PairLightPrepared10.leftCached.drop 486) (PairLightPrepared10.leftRows.drop 486)
    · exact left_prefix_004_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0550
  have h0441 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 155
      (PairLightPrepared10.leftCached.drop 441) (PairLightPrepared10.leftRows.drop 441) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 45 110
      (PairLightPrepared10.leftCached.drop 441) (PairLightPrepared10.leftRows.drop 441)
    · exact left_prefix_004_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0486
  have h0405 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 191
      (PairLightPrepared10.leftCached.drop 405) (PairLightPrepared10.leftRows.drop 405) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared10.sieve 36 155
      (PairLightPrepared10.leftCached.drop 405) (PairLightPrepared10.leftRows.drop 405)
    · exact left_prefix_004_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0441
  simpa only [leftCached000, leftRows000, leftCached001, leftRows001, leftCached002, leftRows002, leftCached003, leftRows003, leftCached004, leftRows004, List.drop_drop, Nat.reduceAdd, List.drop_zero] using h0405

end D1Bound5.PairLightAdaptivePrepared10
