import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight43_000Part00
import D1Bound5.SmallPairLightAdaptiveRight43_000Part01
import D1Bound5.SmallPairLightAdaptiveRight43_000Part02
import D1Bound5.SmallPairLightAdaptiveRight43_000Part03
import D1Bound5.SmallPairLightAdaptiveRight43_000Part04
import D1Bound5.SmallPairLightAdaptiveRight43_000Part05
import D1Bound5.SmallPairLightAdaptiveRight43_000Part06
import D1Bound5.SmallPairLightAdaptiveRight43_000Part07

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_prefix_000_direct_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 92
      (PairLightPrepared43.rightCached.drop 0) (PairLightPrepared43.rightRows.drop 0) = true := by
  have h084 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 8
      (PairLightPrepared43.rightCached.drop 84) (PairLightPrepared43.rightRows.drop 84) = true := right_prefix_000_part07_checked
  have h072 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 20
      (PairLightPrepared43.rightCached.drop 72) (PairLightPrepared43.rightRows.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 8
      (PairLightPrepared43.rightCached.drop 72) (PairLightPrepared43.rightRows.drop 72)
    · exact right_prefix_000_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 32
      (PairLightPrepared43.rightCached.drop 60) (PairLightPrepared43.rightRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 20
      (PairLightPrepared43.rightCached.drop 60) (PairLightPrepared43.rightRows.drop 60)
    · exact right_prefix_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 44
      (PairLightPrepared43.rightCached.drop 48) (PairLightPrepared43.rightRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 32
      (PairLightPrepared43.rightCached.drop 48) (PairLightPrepared43.rightRows.drop 48)
    · exact right_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 56
      (PairLightPrepared43.rightCached.drop 36) (PairLightPrepared43.rightRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 44
      (PairLightPrepared43.rightCached.drop 36) (PairLightPrepared43.rightRows.drop 36)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 68
      (PairLightPrepared43.rightCached.drop 24) (PairLightPrepared43.rightRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 56
      (PairLightPrepared43.rightCached.drop 24) (PairLightPrepared43.rightRows.drop 24)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 80
      (PairLightPrepared43.rightCached.drop 12) (PairLightPrepared43.rightRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 68
      (PairLightPrepared43.rightCached.drop 12) (PairLightPrepared43.rightRows.drop 12)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 92
      (PairLightPrepared43.rightCached.drop 0) (PairLightPrepared43.rightRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 80
      (PairLightPrepared43.rightCached.drop 0) (PairLightPrepared43.rightRows.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h012
  exact h000
end D1Bound5.PairLightAdaptivePrepared43
