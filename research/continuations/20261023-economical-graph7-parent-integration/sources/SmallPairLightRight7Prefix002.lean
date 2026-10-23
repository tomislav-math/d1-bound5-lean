import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight7_002Part00
import D1Bound5.SmallPairLightAdaptiveRight7_002Part01
import D1Bound5.SmallPairLightAdaptiveRight7_002Part02
import D1Bound5.SmallPairLightAdaptiveRight7_002Part03
import D1Bound5.SmallPairLightAdaptiveRight7_002Part04
import D1Bound5.SmallPairLightAdaptiveRight7_002Part05
import D1Bound5.SmallPairLightAdaptiveRight7_002Part06

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 158
      (PairLightPrepared7.rightCached.drop 272) (PairLightPrepared7.rightRows.drop 272) = true := by
  have h416 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 14
      (PairLightPrepared7.rightCached.drop 416) (PairLightPrepared7.rightRows.drop 416) = true := right_prefix_002_part06_checked
  have h392 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 38
      (PairLightPrepared7.rightCached.drop 392) (PairLightPrepared7.rightRows.drop 392) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 24 14
      (PairLightPrepared7.rightCached.drop 392) (PairLightPrepared7.rightRows.drop 392)
    · exact right_prefix_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h416
  have h368 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 62
      (PairLightPrepared7.rightCached.drop 368) (PairLightPrepared7.rightRows.drop 368) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 24 38
      (PairLightPrepared7.rightCached.drop 368) (PairLightPrepared7.rightRows.drop 368)
    · exact right_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h392
  have h344 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 86
      (PairLightPrepared7.rightCached.drop 344) (PairLightPrepared7.rightRows.drop 344) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 24 62
      (PairLightPrepared7.rightCached.drop 344) (PairLightPrepared7.rightRows.drop 344)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h368
  have h320 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 110
      (PairLightPrepared7.rightCached.drop 320) (PairLightPrepared7.rightRows.drop 320) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 24 86
      (PairLightPrepared7.rightCached.drop 320) (PairLightPrepared7.rightRows.drop 320)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h344
  have h296 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 134
      (PairLightPrepared7.rightCached.drop 296) (PairLightPrepared7.rightRows.drop 296) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 24 110
      (PairLightPrepared7.rightCached.drop 296) (PairLightPrepared7.rightRows.drop 296)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h320
  have h272 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 158
      (PairLightPrepared7.rightCached.drop 272) (PairLightPrepared7.rightRows.drop 272) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 24 134
      (PairLightPrepared7.rightCached.drop 272) (PairLightPrepared7.rightRows.drop 272)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h296
  exact h272
end D1Bound5.PairLightAdaptivePrepared7
