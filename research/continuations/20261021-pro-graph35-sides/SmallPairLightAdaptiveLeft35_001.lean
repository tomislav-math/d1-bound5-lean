import D1Bound5.SmallPairLightAdaptiveData35
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft35_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft35_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft35_001Part02

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 132 through 368; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 237
      leftCached001 leftRows001 = true := by
  have h108 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 129
      (leftCached001.drop 108) (leftRows001.drop 108) = true := left_prefix_001_part02_checked
  have h046 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 191
      (leftCached001.drop 46) (leftRows001.drop 46) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 62 129
      (leftCached001.drop 46) (leftRows001.drop 46)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop] using h108
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 237
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 46 191
      (leftCached001.drop 0) (leftRows001.drop 0)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop] using h046
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared35
