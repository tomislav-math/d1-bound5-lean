import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight26_003Part00
import D1Bound5.SmallPairLightAdaptiveRight26_003Part01
import D1Bound5.SmallPairLightAdaptiveRight26_003Part02
import D1Bound5.SmallPairLightAdaptiveRight26_003Part03
import D1Bound5.SmallPairLightAdaptiveRight26_003Part04
import D1Bound5.SmallPairLightAdaptiveRight26_003Part05
import D1Bound5.SmallPairLightAdaptiveRight26_003Part06

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000

/-- Exact original head block with every complete later-vertex tail retained. -/
theorem right_prefix_003_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 73
      rightCached003 rightRows003 = true := by
  have h072 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 1
      (rightCached003.drop 72) (rightRows003.drop 72) = true := right_prefix_003_part06_checked
  have h060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 13
      (rightCached003.drop 60) (rightRows003.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 1
      (rightCached003.drop 60) (rightRows003.drop 60)
    · exact right_prefix_003_part05_checked
    · simpa only [List.drop_drop] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 25
      (rightCached003.drop 48) (rightRows003.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 13
      (rightCached003.drop 48) (rightRows003.drop 48)
    · exact right_prefix_003_part04_checked
    · simpa only [List.drop_drop] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 37
      (rightCached003.drop 36) (rightRows003.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 25
      (rightCached003.drop 36) (rightRows003.drop 36)
    · exact right_prefix_003_part03_checked
    · simpa only [List.drop_drop] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 49
      (rightCached003.drop 24) (rightRows003.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 37
      (rightCached003.drop 24) (rightRows003.drop 24)
    · exact right_prefix_003_part02_checked
    · simpa only [List.drop_drop] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 61
      (rightCached003.drop 12) (rightRows003.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 49
      (rightCached003.drop 12) (rightRows003.drop 12)
    · exact right_prefix_003_part01_checked
    · simpa only [List.drop_drop] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 73
      (rightCached003.drop 0) (rightRows003.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 61
      (rightCached003.drop 0) (rightRows003.drop 0)
    · exact right_prefix_003_part00_checked
    · simpa only [List.drop_drop] using h012
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared26
