import D1Bound5.SmallPairLightAdaptiveData46
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft46_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft46_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft46_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft46_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft46_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft46_000Part05

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 136; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 137
      leftCached000 leftRows000 = true := by
  have h108 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 29
      (leftCached000.drop 108) (leftRows000.drop 108) = true := left_prefix_000_part05_checked
  have h082 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 55
      (leftCached000.drop 82) (leftRows000.drop 82) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 26 29
      (leftCached000.drop 82) (leftRows000.drop 82)
    · exact left_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h108
  have h058 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 79
      (leftCached000.drop 58) (leftRows000.drop 58) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 24 55
      (leftCached000.drop 58) (leftRows000.drop 58)
    · exact left_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h082
  have h036 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 101
      (leftCached000.drop 36) (leftRows000.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 22 79
      (leftCached000.drop 36) (leftRows000.drop 36)
    · exact left_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h058
  have h016 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 121
      (leftCached000.drop 16) (leftRows000.drop 16) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 20 101
      (leftCached000.drop 16) (leftRows000.drop 16)
    · exact left_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h000 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 137
      (leftCached000.drop 0) (leftRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 16 121
      (leftCached000.drop 0) (leftRows000.drop 0)
    · exact left_prefix_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h016
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared46
