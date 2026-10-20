import D1Bound5.SmallPairLightAdaptiveData40
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight40_000Part00
import D1Bound5.SmallPairLightAdaptiveRight40_000Part01
import D1Bound5.SmallPairLightAdaptiveRight40_000Part02
import D1Bound5.SmallPairLightAdaptiveRight40_000Part03
import D1Bound5.SmallPairLightAdaptiveRight40_000Part04

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 137; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 138
      rightCached000 rightRows000 = true := by
  have h137 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 1
      (rightCached000.drop 137) (rightRows000.drop 137) = true := right_prefix_000_part04_checked
  have h096 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 42
      (rightCached000.drop 96) (rightRows000.drop 96) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared40.sieve 41 1
      (rightCached000.drop 96) (rightRows000.drop 96)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop] using h137
  have h061 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 77
      (rightCached000.drop 61) (rightRows000.drop 61) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared40.sieve 35 42
      (rightCached000.drop 61) (rightRows000.drop 61)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop] using h096
  have h029 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 109
      (rightCached000.drop 29) (rightRows000.drop 29) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared40.sieve 32 77
      (rightCached000.drop 29) (rightRows000.drop 29)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop] using h061
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared40.sieve 138
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared40.sieve 29 109
      (rightCached000.drop 0) (rightRows000.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop] using h029
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared40
