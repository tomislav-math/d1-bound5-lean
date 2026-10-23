import D1Bound5.SmallPairLightAdaptiveData38
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight38_000Part00
import D1Bound5.SmallPairLightAdaptiveRight38_000Part01
import D1Bound5.SmallPairLightAdaptiveRight38_000Part02
import D1Bound5.SmallPairLightAdaptiveRight38_000Part03

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 280; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 281
      rightCached000 rightRows000 = true := by
  have h140 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 141
      (rightCached000.drop 140) (rightRows000.drop 140) = true := right_prefix_000_part03_checked
  have h082 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 199
      (rightCached000.drop 82) (rightRows000.drop 82) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared38.sieve 58 141
      (rightCached000.drop 82) (rightRows000.drop 82)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop] using h140
  have h038 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 243
      (rightCached000.drop 38) (rightRows000.drop 38) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared38.sieve 44 199
      (rightCached000.drop 38) (rightRows000.drop 38)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop] using h082
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 281
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared38.sieve 38 243
      (rightCached000.drop 0) (rightRows000.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop] using h038
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared38
