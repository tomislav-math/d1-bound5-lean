import D1Bound5.SmallPairLightAdaptiveData35
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft35_000Part04

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 131; every head retains its entire tail. -/
theorem left_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 132
      leftCached000 leftRows000 = true := by
  have h130 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 2
      (leftCached000.drop 130) (leftRows000.drop 130) = true := left_prefix_000_part04_checked
  have h092 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 40
      (leftCached000.drop 92) (leftRows000.drop 92) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 38 2
      (leftCached000.drop 92) (leftRows000.drop 92)
    · exact left_prefix_000_part03_checked
    · simpa only [List.drop_drop] using h130
  have h058 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 74
      (leftCached000.drop 58) (leftRows000.drop 58) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 34 40
      (leftCached000.drop 58) (leftRows000.drop 58)
    · exact left_prefix_000_part02_checked
    · simpa only [List.drop_drop] using h092
  have h028 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 104
      (leftCached000.drop 28) (leftRows000.drop 28) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 30 74
      (leftCached000.drop 28) (leftRows000.drop 28)
    · exact left_prefix_000_part01_checked
    · simpa only [List.drop_drop] using h058
  have h000 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared35.sieve 132
      (leftCached000.drop 0) (leftRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared35.sieve 28 104
      (leftCached000.drop 0) (leftRows000.drop 0)
    · exact left_prefix_000_part00_checked
    · simpa only [List.drop_drop] using h028
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared35
