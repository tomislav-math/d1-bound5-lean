import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part00
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part01
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part02
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part03
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part04
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part05
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part06
import D1Bound5.SmallPairLightAdaptiveLeft26_004Part07

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000

/-- Exact original head block with every complete later-vertex tail retained. -/
theorem left_prefix_004_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 85
      leftCached004 leftRows004 = true := by
  have h084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 1
      (leftCached004.drop 84) (leftRows004.drop 84) = true := left_prefix_004_part07_checked
  have h072 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 13
      (leftCached004.drop 72) (leftRows004.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 1
      (leftCached004.drop 72) (leftRows004.drop 72)
    · exact left_prefix_004_part06_checked
    · simpa only [List.drop_drop] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 25
      (leftCached004.drop 60) (leftRows004.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 13
      (leftCached004.drop 60) (leftRows004.drop 60)
    · exact left_prefix_004_part05_checked
    · simpa only [List.drop_drop] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 37
      (leftCached004.drop 48) (leftRows004.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 25
      (leftCached004.drop 48) (leftRows004.drop 48)
    · exact left_prefix_004_part04_checked
    · simpa only [List.drop_drop] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 49
      (leftCached004.drop 36) (leftRows004.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 37
      (leftCached004.drop 36) (leftRows004.drop 36)
    · exact left_prefix_004_part03_checked
    · simpa only [List.drop_drop] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 61
      (leftCached004.drop 24) (leftRows004.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 49
      (leftCached004.drop 24) (leftRows004.drop 24)
    · exact left_prefix_004_part02_checked
    · simpa only [List.drop_drop] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 73
      (leftCached004.drop 12) (leftRows004.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 61
      (leftCached004.drop 12) (leftRows004.drop 12)
    · exact left_prefix_004_part01_checked
    · simpa only [List.drop_drop] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 85
      (leftCached004.drop 0) (leftRows004.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 73
      (leftCached004.drop 0) (leftRows004.drop 0)
    · exact left_prefix_004_part00_checked
    · simpa only [List.drop_drop] using h012
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared26
