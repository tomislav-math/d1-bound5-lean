import D1Bound5.SmallPairLightAdaptiveData17
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight17_001Part00
import D1Bound5.SmallPairLightAdaptiveRight17_001Part01
import D1Bound5.SmallPairLightAdaptiveRight17_001Part02

namespace D1Bound5.PairLightAdaptivePrepared17
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 138 through 357; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 220
      rightCached001 rightRows001 = true := by
  have h127 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 93
      (rightCached001.drop 127) (rightRows001.drop 127) = true := right_prefix_001_part02_checked
  have h051 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 169
      (rightCached001.drop 51) (rightRows001.drop 51) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared17.sieve 76 93
      (rightCached001.drop 51) (rightRows001.drop 51)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop] using h127
  have h000 : pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 220
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 2 PairLightPrepared17.sieve 51 169
      (rightCached001.drop 0) (rightRows001.drop 0)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop] using h051
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared17
