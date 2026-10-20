import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight26_005Part00
import D1Bound5.SmallPairLightAdaptiveRight26_005Part01
import D1Bound5.SmallPairLightAdaptiveRight26_005Part02
import D1Bound5.SmallPairLightAdaptiveRight26_005Part03
import D1Bound5.SmallPairLightAdaptiveRight26_005Part04
import D1Bound5.SmallPairLightAdaptiveRight26_005Part05
import D1Bound5.SmallPairLightAdaptiveRight26_005Part06
import D1Bound5.SmallPairLightAdaptiveRight26_005Part07
import D1Bound5.SmallPairLightAdaptiveRight26_005Part08

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000

/-- Exact original head block with every complete later-vertex tail retained. -/
theorem right_prefix_005_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 107
      rightCached005 rightRows005 = true := by
  have h096 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 11
      (rightCached005.drop 96) (rightRows005.drop 96) = true := right_prefix_005_part08_checked
  have h084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 23
      (rightCached005.drop 84) (rightRows005.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 11
      (rightCached005.drop 84) (rightRows005.drop 84)
    · exact right_prefix_005_part07_checked
    · simpa only [List.drop_drop] using h096
  have h072 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 35
      (rightCached005.drop 72) (rightRows005.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 23
      (rightCached005.drop 72) (rightRows005.drop 72)
    · exact right_prefix_005_part06_checked
    · simpa only [List.drop_drop] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 47
      (rightCached005.drop 60) (rightRows005.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 35
      (rightCached005.drop 60) (rightRows005.drop 60)
    · exact right_prefix_005_part05_checked
    · simpa only [List.drop_drop] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 59
      (rightCached005.drop 48) (rightRows005.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 47
      (rightCached005.drop 48) (rightRows005.drop 48)
    · exact right_prefix_005_part04_checked
    · simpa only [List.drop_drop] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 71
      (rightCached005.drop 36) (rightRows005.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 59
      (rightCached005.drop 36) (rightRows005.drop 36)
    · exact right_prefix_005_part03_checked
    · simpa only [List.drop_drop] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 83
      (rightCached005.drop 24) (rightRows005.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 71
      (rightCached005.drop 24) (rightRows005.drop 24)
    · exact right_prefix_005_part02_checked
    · simpa only [List.drop_drop] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 95
      (rightCached005.drop 12) (rightRows005.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 83
      (rightCached005.drop 12) (rightRows005.drop 12)
    · exact right_prefix_005_part01_checked
    · simpa only [List.drop_drop] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 107
      (rightCached005.drop 0) (rightRows005.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 95
      (rightCached005.drop 0) (rightRows005.drop 0)
    · exact right_prefix_005_part00_checked
    · simpa only [List.drop_drop] using h012
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared26
