import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight43_002Part00
import D1Bound5.SmallPairLightAdaptiveRight43_002Part01
import D1Bound5.SmallPairLightAdaptiveRight43_002Part02
import D1Bound5.SmallPairLightAdaptiveRight43_002Part03
import D1Bound5.SmallPairLightAdaptiveRight43_002Part04
import D1Bound5.SmallPairLightAdaptiveRight43_002Part05
import D1Bound5.SmallPairLightAdaptiveRight43_002Part06
import D1Bound5.SmallPairLightAdaptiveRight43_002Part07
import D1Bound5.SmallPairLightAdaptiveRight43_002Part08
import D1Bound5.SmallPairLightAdaptiveRight43_002Part09
import D1Bound5.SmallPairLightAdaptiveRight43_002Part10
import D1Bound5.SmallPairLightAdaptiveRight43_002Part11

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 266
      (PairLightPrepared43.rightCached.drop 214) (PairLightPrepared43.rightRows.drop 214) = true := by
  have h478 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 2
      (PairLightPrepared43.rightCached.drop 478) (PairLightPrepared43.rightRows.drop 478) = true := right_prefix_002_part11_checked
  have h454 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 26
      (PairLightPrepared43.rightCached.drop 454) (PairLightPrepared43.rightRows.drop 454) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 2
      (PairLightPrepared43.rightCached.drop 454) (PairLightPrepared43.rightRows.drop 454)
    · exact right_prefix_002_part10_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h478
  have h430 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 50
      (PairLightPrepared43.rightCached.drop 430) (PairLightPrepared43.rightRows.drop 430) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 26
      (PairLightPrepared43.rightCached.drop 430) (PairLightPrepared43.rightRows.drop 430)
    · exact right_prefix_002_part09_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h454
  have h406 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 74
      (PairLightPrepared43.rightCached.drop 406) (PairLightPrepared43.rightRows.drop 406) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 50
      (PairLightPrepared43.rightCached.drop 406) (PairLightPrepared43.rightRows.drop 406)
    · exact right_prefix_002_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h430
  have h382 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 98
      (PairLightPrepared43.rightCached.drop 382) (PairLightPrepared43.rightRows.drop 382) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 74
      (PairLightPrepared43.rightCached.drop 382) (PairLightPrepared43.rightRows.drop 382)
    · exact right_prefix_002_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h406
  have h358 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 122
      (PairLightPrepared43.rightCached.drop 358) (PairLightPrepared43.rightRows.drop 358) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 98
      (PairLightPrepared43.rightCached.drop 358) (PairLightPrepared43.rightRows.drop 358)
    · exact right_prefix_002_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h382
  have h334 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 146
      (PairLightPrepared43.rightCached.drop 334) (PairLightPrepared43.rightRows.drop 334) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 122
      (PairLightPrepared43.rightCached.drop 334) (PairLightPrepared43.rightRows.drop 334)
    · exact right_prefix_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h358
  have h310 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 170
      (PairLightPrepared43.rightCached.drop 310) (PairLightPrepared43.rightRows.drop 310) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 146
      (PairLightPrepared43.rightCached.drop 310) (PairLightPrepared43.rightRows.drop 310)
    · exact right_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h334
  have h286 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 194
      (PairLightPrepared43.rightCached.drop 286) (PairLightPrepared43.rightRows.drop 286) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 170
      (PairLightPrepared43.rightCached.drop 286) (PairLightPrepared43.rightRows.drop 286)
    · exact right_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h310
  have h262 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 218
      (PairLightPrepared43.rightCached.drop 262) (PairLightPrepared43.rightRows.drop 262) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 194
      (PairLightPrepared43.rightCached.drop 262) (PairLightPrepared43.rightRows.drop 262)
    · exact right_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h286
  have h238 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 242
      (PairLightPrepared43.rightCached.drop 238) (PairLightPrepared43.rightRows.drop 238) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 218
      (PairLightPrepared43.rightCached.drop 238) (PairLightPrepared43.rightRows.drop 238)
    · exact right_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h262
  have h214 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 266
      (PairLightPrepared43.rightCached.drop 214) (PairLightPrepared43.rightRows.drop 214) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 24 242
      (PairLightPrepared43.rightCached.drop 214) (PairLightPrepared43.rightRows.drop 214)
    · exact right_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h238
  exact h214
end D1Bound5.PairLightAdaptivePrepared43
