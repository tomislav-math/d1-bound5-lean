import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part00
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part01
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part02
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part03
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part04
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part05
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part06
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part07
import D1Bound5.SmallPairLightAdaptiveLeft26_005Part08

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000

/-- Exact original head block with every complete later-vertex tail retained. -/
theorem left_prefix_005_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 107
      leftCached005 leftRows005 = true := by
  have h096 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 11
      (leftCached005.drop 96) (leftRows005.drop 96) = true := left_prefix_005_part08_checked
  have h084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 23
      (leftCached005.drop 84) (leftRows005.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 11
      (leftCached005.drop 84) (leftRows005.drop 84)
    · exact left_prefix_005_part07_checked
    · simpa only [List.drop_drop] using h096
  have h072 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 35
      (leftCached005.drop 72) (leftRows005.drop 72) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 23
      (leftCached005.drop 72) (leftRows005.drop 72)
    · exact left_prefix_005_part06_checked
    · simpa only [List.drop_drop] using h084
  have h060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 47
      (leftCached005.drop 60) (leftRows005.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 35
      (leftCached005.drop 60) (leftRows005.drop 60)
    · exact left_prefix_005_part05_checked
    · simpa only [List.drop_drop] using h072
  have h048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 59
      (leftCached005.drop 48) (leftRows005.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 47
      (leftCached005.drop 48) (leftRows005.drop 48)
    · exact left_prefix_005_part04_checked
    · simpa only [List.drop_drop] using h060
  have h036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 71
      (leftCached005.drop 36) (leftRows005.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 59
      (leftCached005.drop 36) (leftRows005.drop 36)
    · exact left_prefix_005_part03_checked
    · simpa only [List.drop_drop] using h048
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 83
      (leftCached005.drop 24) (leftRows005.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 71
      (leftCached005.drop 24) (leftRows005.drop 24)
    · exact left_prefix_005_part02_checked
    · simpa only [List.drop_drop] using h036
  have h012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 95
      (leftCached005.drop 12) (leftRows005.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 83
      (leftCached005.drop 12) (leftRows005.drop 12)
    · exact left_prefix_005_part01_checked
    · simpa only [List.drop_drop] using h024
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 107
      (leftCached005.drop 0) (leftRows005.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 12 95
      (leftCached005.drop 0) (leftRows005.drop 0)
    · exact left_prefix_005_part00_checked
    · simpa only [List.drop_drop] using h012
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared26
