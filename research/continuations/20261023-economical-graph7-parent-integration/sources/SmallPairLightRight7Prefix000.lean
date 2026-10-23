import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight7_Pilot12Part00
import D1Bound5.SmallPairLightAdaptiveRight7_000Part01
import D1Bound5.SmallPairLightAdaptiveRight7_000Part02
import D1Bound5.SmallPairLightAdaptiveRight7_000Part03
import D1Bound5.SmallPairLightAdaptiveRight7_000Part04
import D1Bound5.SmallPairLightAdaptiveRight7_000Part05
import D1Bound5.SmallPairLightAdaptiveRight7_000Part06
import D1Bound5.SmallPairLightAdaptiveRight7_000Part07
import D1Bound5.SmallPairLightAdaptiveRight7_000Part08

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_000_direct_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 106
      (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0) = true := by
  have h096 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 10
      (PairLightPrepared7.rightCached.drop 96) (PairLightPrepared7.rightRows.drop 96) = true := right_prefix_000_part08_checked
  have h084 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 22
      (PairLightPrepared7.rightCached.drop 84) (PairLightPrepared7.rightRows.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 10
      (PairLightPrepared7.rightCached.drop 84) (PairLightPrepared7.rightRows.drop 84)
    · exact right_prefix_000_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h096
  have h072 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 34
      (PairLightPrepared7.rightCached.drop 72) (PairLightPrepared7.rightRows.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 22
      (PairLightPrepared7.rightCached.drop 72) (PairLightPrepared7.rightRows.drop 72)
    · exact right_prefix_000_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h060 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 46
      (PairLightPrepared7.rightCached.drop 60) (PairLightPrepared7.rightRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 34
      (PairLightPrepared7.rightCached.drop 60) (PairLightPrepared7.rightRows.drop 60)
    · exact right_prefix_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h072
  have h048 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 58
      (PairLightPrepared7.rightCached.drop 48) (PairLightPrepared7.rightRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 46
      (PairLightPrepared7.rightCached.drop 48) (PairLightPrepared7.rightRows.drop 48)
    · exact right_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h060
  have h036 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 70
      (PairLightPrepared7.rightCached.drop 36) (PairLightPrepared7.rightRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 58
      (PairLightPrepared7.rightCached.drop 36) (PairLightPrepared7.rightRows.drop 36)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h048
  have h024 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 82
      (PairLightPrepared7.rightCached.drop 24) (PairLightPrepared7.rightRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 70
      (PairLightPrepared7.rightCached.drop 24) (PairLightPrepared7.rightRows.drop 24)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h012 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 94
      (PairLightPrepared7.rightCached.drop 12) (PairLightPrepared7.rightRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 82
      (PairLightPrepared7.rightCached.drop 12) (PairLightPrepared7.rightRows.drop 12)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h024
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 106
      (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared7.sieve 12 94
      (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0)
    · exact right_pilot12_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h012
  exact h000
end D1Bound5.PairLightAdaptivePrepared7
