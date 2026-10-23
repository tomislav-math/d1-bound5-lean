import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft39_Pilot12Part00
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part05
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part06
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part07
import D1Bound5.SmallPairLightAdaptiveLeft39_000Part08

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_000_direct_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 97
      (PairLightPrepared39.leftCached.drop 0) (PairLightPrepared39.leftRows.drop 0) = true := by
  have h096 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 1
      (PairLightPrepared39.leftCached.drop 96) (PairLightPrepared39.leftRows.drop 96) = true := left_prefix_000_part08_checked
  have h084 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 13
      (PairLightPrepared39.leftCached.drop 84) (PairLightPrepared39.leftRows.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 1
      (PairLightPrepared39.leftCached.drop 84) (PairLightPrepared39.leftRows.drop 84)
    · exact left_prefix_000_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h096
  have h072 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 25
      (PairLightPrepared39.leftCached.drop 72) (PairLightPrepared39.leftRows.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 13
      (PairLightPrepared39.leftCached.drop 72) (PairLightPrepared39.leftRows.drop 72)
    · exact left_prefix_000_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 37
      (PairLightPrepared39.leftCached.drop 60) (PairLightPrepared39.leftRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 25
      (PairLightPrepared39.leftCached.drop 60) (PairLightPrepared39.leftRows.drop 60)
    · exact left_prefix_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 49
      (PairLightPrepared39.leftCached.drop 48) (PairLightPrepared39.leftRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 37
      (PairLightPrepared39.leftCached.drop 48) (PairLightPrepared39.leftRows.drop 48)
    · exact left_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 61
      (PairLightPrepared39.leftCached.drop 36) (PairLightPrepared39.leftRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 49
      (PairLightPrepared39.leftCached.drop 36) (PairLightPrepared39.leftRows.drop 36)
    · exact left_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 73
      (PairLightPrepared39.leftCached.drop 24) (PairLightPrepared39.leftRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 61
      (PairLightPrepared39.leftCached.drop 24) (PairLightPrepared39.leftRows.drop 24)
    · exact left_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 85
      (PairLightPrepared39.leftCached.drop 12) (PairLightPrepared39.leftRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 73
      (PairLightPrepared39.leftCached.drop 12) (PairLightPrepared39.leftRows.drop 12)
    · exact left_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 97
      (PairLightPrepared39.leftCached.drop 0) (PairLightPrepared39.leftRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 12 85
      (PairLightPrepared39.leftCached.drop 0) (PairLightPrepared39.leftRows.drop 0)
    · exact left_pilot12_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h012
  exact h000
end D1Bound5.PairLightAdaptivePrepared39
