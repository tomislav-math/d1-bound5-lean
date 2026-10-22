import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part05
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part06
import D1Bound5.SmallPairLightAdaptiveLeft43_000Part07

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_000_direct_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 91
      PairLightPrepared43.leftCached PairLightPrepared43.leftRows = true := by
  have h084 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 7
      (PairLightPrepared43.leftCached.drop 84) (PairLightPrepared43.leftRows.drop 84) = true := left_prefix_000_part07_checked
  have h072 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 19
      (PairLightPrepared43.leftCached.drop 72) (PairLightPrepared43.leftRows.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 7
      (PairLightPrepared43.leftCached.drop 72) (PairLightPrepared43.leftRows.drop 72)
    · exact left_prefix_000_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 31
      (PairLightPrepared43.leftCached.drop 60) (PairLightPrepared43.leftRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 19
      (PairLightPrepared43.leftCached.drop 60) (PairLightPrepared43.leftRows.drop 60)
    · exact left_prefix_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 43
      (PairLightPrepared43.leftCached.drop 48) (PairLightPrepared43.leftRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 31
      (PairLightPrepared43.leftCached.drop 48) (PairLightPrepared43.leftRows.drop 48)
    · exact left_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 55
      (PairLightPrepared43.leftCached.drop 36) (PairLightPrepared43.leftRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 43
      (PairLightPrepared43.leftCached.drop 36) (PairLightPrepared43.leftRows.drop 36)
    · exact left_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 67
      (PairLightPrepared43.leftCached.drop 24) (PairLightPrepared43.leftRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 55
      (PairLightPrepared43.leftCached.drop 24) (PairLightPrepared43.leftRows.drop 24)
    · exact left_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 79
      (PairLightPrepared43.leftCached.drop 12) (PairLightPrepared43.leftRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 67
      (PairLightPrepared43.leftCached.drop 12) (PairLightPrepared43.leftRows.drop 12)
    · exact left_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 91
      (PairLightPrepared43.leftCached.drop 0) (PairLightPrepared43.leftRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 3 PairLightPrepared43.sieve 12 79
      (PairLightPrepared43.leftCached.drop 0) (PairLightPrepared43.leftRows.drop 0)
    · exact left_prefix_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h012
  simpa only [List.drop_zero] using h000
end D1Bound5.PairLightAdaptivePrepared43
