import D1Bound5.SmallPairLightAdaptiveData35
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight35_001Part00
import D1Bound5.SmallPairLightAdaptiveRight35_001Part01
import D1Bound5.SmallPairLightAdaptiveRight35_001Part02

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 132 through 367; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 236
      rightCached001 rightRows001 = true := by
  have h110 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 126
      (rightCached001.drop 110) (rightRows001.drop 110) = true := right_prefix_001_part02_checked
  have h047 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 189
      (rightCached001.drop 47) (rightRows001.drop 47) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 63 126
      (rightCached001.drop 47) (rightRows001.drop 47)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop] using h110
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 236
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 47 189
      (rightCached001.drop 0) (rightRows001.drop 0)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop] using h047
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared35
