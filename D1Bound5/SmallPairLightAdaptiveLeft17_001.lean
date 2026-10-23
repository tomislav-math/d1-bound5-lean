import D1Bound5.SmallPairLightAdaptiveData17
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft17_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft17_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft17_001Part02

namespace D1Bound5.PairLightAdaptivePrepared17
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 137 through 359; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 223
      leftCached001 leftRows001 = true := by
  have h123 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 100
      (leftCached001.drop 123) (leftRows001.drop 123) = true := left_prefix_001_part02_checked
  have h050 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 173
      (leftCached001.drop 50) (leftRows001.drop 50) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared17.sieve 73 100
      (leftCached001.drop 50) (leftRows001.drop 50)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop] using h123
  have h000 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 223
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared17.sieve 50 173
      (leftCached001.drop 0) (leftRows001.drop 0)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop] using h050
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared17
