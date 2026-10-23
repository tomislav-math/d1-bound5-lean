import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft24_Pilot12Part00
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part05
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part06
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part07
import D1Bound5.SmallPairLightAdaptiveLeft24_000Part08

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_000_direct_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 101
      (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0) = true := by
  have h096 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 5
      (PairLightPrepared24.leftCached.drop 96) (PairLightPrepared24.leftRows.drop 96) = true := left_prefix_000_part08_checked
  have h084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 17
      (PairLightPrepared24.leftCached.drop 84) (PairLightPrepared24.leftRows.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 5
      (PairLightPrepared24.leftCached.drop 84) (PairLightPrepared24.leftRows.drop 84)
    · exact left_prefix_000_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h096
  have h072 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 29
      (PairLightPrepared24.leftCached.drop 72) (PairLightPrepared24.leftRows.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 17
      (PairLightPrepared24.leftCached.drop 72) (PairLightPrepared24.leftRows.drop 72)
    · exact left_prefix_000_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 41
      (PairLightPrepared24.leftCached.drop 60) (PairLightPrepared24.leftRows.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 29
      (PairLightPrepared24.leftCached.drop 60) (PairLightPrepared24.leftRows.drop 60)
    · exact left_prefix_000_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 53
      (PairLightPrepared24.leftCached.drop 48) (PairLightPrepared24.leftRows.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 41
      (PairLightPrepared24.leftCached.drop 48) (PairLightPrepared24.leftRows.drop 48)
    · exact left_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 65
      (PairLightPrepared24.leftCached.drop 36) (PairLightPrepared24.leftRows.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 53
      (PairLightPrepared24.leftCached.drop 36) (PairLightPrepared24.leftRows.drop 36)
    · exact left_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 77
      (PairLightPrepared24.leftCached.drop 24) (PairLightPrepared24.leftRows.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 65
      (PairLightPrepared24.leftCached.drop 24) (PairLightPrepared24.leftRows.drop 24)
    · exact left_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 89
      (PairLightPrepared24.leftCached.drop 12) (PairLightPrepared24.leftRows.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 77
      (PairLightPrepared24.leftCached.drop 12) (PairLightPrepared24.leftRows.drop 12)
    · exact left_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 101
      (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared24.sieve 12 89
      (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0)
    · exact left_pilot12_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h012
  exact h000
end D1Bound5.PairLightAdaptivePrepared24
