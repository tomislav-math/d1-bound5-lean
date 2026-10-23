import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight39_002Part00
import D1Bound5.SmallPairLightAdaptiveRight39_002Part01
import D1Bound5.SmallPairLightAdaptiveRight39_002Part02
import D1Bound5.SmallPairLightAdaptiveRight39_002Part03
import D1Bound5.SmallPairLightAdaptiveRight39_002Part04
import D1Bound5.SmallPairLightAdaptiveRight39_002Part05
import D1Bound5.SmallPairLightAdaptiveRight39_002Part06
import D1Bound5.SmallPairLightAdaptiveRight39_002Part07
import D1Bound5.SmallPairLightAdaptiveRight39_002Part08
import D1Bound5.SmallPairLightAdaptiveRight39_002Part09

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 220
      (PairLightPrepared39.rightCached.drop 236) (PairLightPrepared39.rightRows.drop 236) = true := by
  have h452 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 4
      (PairLightPrepared39.rightCached.drop 452) (PairLightPrepared39.rightRows.drop 452) = true := right_prefix_002_part09_checked
  have h428 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 28
      (PairLightPrepared39.rightCached.drop 428) (PairLightPrepared39.rightRows.drop 428) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 4
      (PairLightPrepared39.rightCached.drop 428) (PairLightPrepared39.rightRows.drop 428)
    · exact right_prefix_002_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h452
  have h404 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 52
      (PairLightPrepared39.rightCached.drop 404) (PairLightPrepared39.rightRows.drop 404) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 28
      (PairLightPrepared39.rightCached.drop 404) (PairLightPrepared39.rightRows.drop 404)
    · exact right_prefix_002_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h428
  have h380 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 76
      (PairLightPrepared39.rightCached.drop 380) (PairLightPrepared39.rightRows.drop 380) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 52
      (PairLightPrepared39.rightCached.drop 380) (PairLightPrepared39.rightRows.drop 380)
    · exact right_prefix_002_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h404
  have h356 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 100
      (PairLightPrepared39.rightCached.drop 356) (PairLightPrepared39.rightRows.drop 356) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 76
      (PairLightPrepared39.rightCached.drop 356) (PairLightPrepared39.rightRows.drop 356)
    · exact right_prefix_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h380
  have h332 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 124
      (PairLightPrepared39.rightCached.drop 332) (PairLightPrepared39.rightRows.drop 332) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 100
      (PairLightPrepared39.rightCached.drop 332) (PairLightPrepared39.rightRows.drop 332)
    · exact right_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h356
  have h308 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 148
      (PairLightPrepared39.rightCached.drop 308) (PairLightPrepared39.rightRows.drop 308) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 124
      (PairLightPrepared39.rightCached.drop 308) (PairLightPrepared39.rightRows.drop 308)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h332
  have h284 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 172
      (PairLightPrepared39.rightCached.drop 284) (PairLightPrepared39.rightRows.drop 284) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 148
      (PairLightPrepared39.rightCached.drop 284) (PairLightPrepared39.rightRows.drop 284)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h308
  have h260 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 196
      (PairLightPrepared39.rightCached.drop 260) (PairLightPrepared39.rightRows.drop 260) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 172
      (PairLightPrepared39.rightCached.drop 260) (PairLightPrepared39.rightRows.drop 260)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h284
  have h236 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 220
      (PairLightPrepared39.rightCached.drop 236) (PairLightPrepared39.rightRows.drop 236) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 196
      (PairLightPrepared39.rightCached.drop 236) (PairLightPrepared39.rightRows.drop 236)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h260
  exact h236
end D1Bound5.PairLightAdaptivePrepared39
