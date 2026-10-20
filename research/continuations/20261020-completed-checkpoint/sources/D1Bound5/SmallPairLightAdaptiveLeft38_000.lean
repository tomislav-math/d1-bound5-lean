import D1Bound5.SmallPairLightAdaptiveData38
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft38_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft38_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft38_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft38_000Part03

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 279; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 280
      leftCached000 leftRows000 = true := by
  have h140 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 140
      (leftCached000.drop 140) (leftRows000.drop 140) = true := left_prefix_000_part03_checked
  have h082 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 198
      (leftCached000.drop 82) (leftRows000.drop 82) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared38.sieve 58 140
      (leftCached000.drop 82) (leftRows000.drop 82)
    · exact left_prefix_000_part02_checked
    · simpa only [List.drop_drop] using h140
  have h037 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 243
      (leftCached000.drop 37) (leftRows000.drop 37) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared38.sieve 45 198
      (leftCached000.drop 37) (leftRows000.drop 37)
    · exact left_prefix_000_part01_checked
    · simpa only [List.drop_drop] using h082
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared38.sieve 280
      (leftCached000.drop 0) (leftRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared38.sieve 37 243
      (leftCached000.drop 0) (leftRows000.drop 0)
    · exact left_prefix_000_part00_checked
    · simpa only [List.drop_drop] using h037
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared38
