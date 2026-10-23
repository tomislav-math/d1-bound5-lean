import D1Bound5.SmallPairLightAdaptiveData33
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight33_001Part00
import D1Bound5.SmallPairLightAdaptiveRight33_001Part01
import D1Bound5.SmallPairLightAdaptiveRight33_001Part02

namespace D1Bound5.PairLightAdaptivePrepared33
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 138 through 357; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared33.sieve 220
      rightCached001 rightRows001 = true := by
  have h127 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared33.sieve 93
      (rightCached001.drop 127) (rightRows001.drop 127) = true := right_prefix_001_part02_checked
  have h051 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared33.sieve 169
      (rightCached001.drop 51) (rightRows001.drop 51) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared33.sieve 76 93
      (rightCached001.drop 51) (rightRows001.drop 51)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop] using h127
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared33.sieve 220
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared33.sieve 51 169
      (rightCached001.drop 0) (rightRows001.drop 0)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop] using h051
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared33
