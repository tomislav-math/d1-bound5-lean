import D1Bound5.SmallPairLightAdaptiveData12
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft12_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft12_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft12_001Part02

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 138 through 358; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 221
      leftCached001 leftRows001 = true := by
  have h127 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 94
      (leftCached001.drop 127) (leftRows001.drop 127) = true := left_prefix_001_part02_checked
  have h051 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 170
      (leftCached001.drop 51) (leftRows001.drop 51) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared12.sieve 76 94
      (leftCached001.drop 51) (leftRows001.drop 51)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop] using h127
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 221
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared12.sieve 51 170
      (leftCached001.drop 0) (leftRows001.drop 0)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop] using h051
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared12
