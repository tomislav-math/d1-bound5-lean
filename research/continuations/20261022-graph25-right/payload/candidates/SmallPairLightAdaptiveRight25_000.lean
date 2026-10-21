import D1Bound5.SmallPairLightAdaptiveData25
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight25_000Part00
import D1Bound5.SmallPairLightAdaptiveRight25_000Part01
import D1Bound5.SmallPairLightAdaptiveRight25_000Part02
import D1Bound5.SmallPairLightAdaptiveRight25_000Part03
import D1Bound5.SmallPairLightAdaptiveRight25_000Part04

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 124; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 125
      rightCached000 rightRows000 = true := by
  have h109 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 16
      (rightCached000.drop 109) (rightRows000.drop 109) = true := right_prefix_000_part04_checked
  have h078 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 47
      (rightCached000.drop 78) (rightRows000.drop 78) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 31 16
      (rightCached000.drop 78) (rightRows000.drop 78)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h109
  have h050 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 75
      (rightCached000.drop 50) (rightRows000.drop 50) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 28 47
      (rightCached000.drop 50) (rightRows000.drop 50)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h078
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 101
      (rightCached000.drop 24) (rightRows000.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 26 75
      (rightCached000.drop 24) (rightRows000.drop 24)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h050
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 125
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 24 101
      (rightCached000.drop 0) (rightRows000.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h024
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared25
