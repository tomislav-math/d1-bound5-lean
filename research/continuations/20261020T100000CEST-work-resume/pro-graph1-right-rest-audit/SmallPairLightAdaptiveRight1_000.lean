import D1Bound5.SmallPairLightAdaptiveData1
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight1_000Part00
import D1Bound5.SmallPairLightAdaptiveRight1_000Part01
import D1Bound5.SmallPairLightAdaptiveRight1_000Part02
import D1Bound5.SmallPairLightAdaptiveRight1_000Part03
import D1Bound5.SmallPairLightAdaptiveRight1_000Part04
import D1Bound5.SmallPairLightAdaptiveRight1_000Part05

namespace D1Bound5.PairLightAdaptivePrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 137; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 138
      rightCached000 rightRows000 = true := by
  have h108 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 30
      (rightCached000.drop 108) (rightRows000.drop 108) = true := right_prefix_000_part05_checked
  have h082 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 56
      (rightCached000.drop 82) (rightRows000.drop 82) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared1.sieve 26 30
      (rightCached000.drop 82) (rightRows000.drop 82)
    · exact right_prefix_000_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h108
  have h058 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 80
      (rightCached000.drop 58) (rightRows000.drop 58) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared1.sieve 24 56
      (rightCached000.drop 58) (rightRows000.drop 58)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h082
  have h036 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 102
      (rightCached000.drop 36) (rightRows000.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared1.sieve 22 80
      (rightCached000.drop 36) (rightRows000.drop 36)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h058
  have h016 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 122
      (rightCached000.drop 16) (rightRows000.drop 16) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared1.sieve 20 102
      (rightCached000.drop 16) (rightRows000.drop 16)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h036
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared1.sieve 138
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared1.sieve 16 122
      (rightCached000.drop 0) (rightRows000.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h016
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared1
