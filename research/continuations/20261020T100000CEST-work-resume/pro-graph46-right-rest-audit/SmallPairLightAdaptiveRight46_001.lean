import D1Bound5.SmallPairLightAdaptiveData46
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight46_001Part00
import D1Bound5.SmallPairLightAdaptiveRight46_001Part01
import D1Bound5.SmallPairLightAdaptiveRight46_001Part02
import D1Bound5.SmallPairLightAdaptiveRight46_001Part03

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 138 through 357; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 220
      rightCached001 rightRows001 = true := by
  have h132 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 88
      (rightCached001.drop 132) (rightRows001.drop 132) = true := right_prefix_001_part03_checked
  have h076 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 144
      (rightCached001.drop 76) (rightRows001.drop 76) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 56 88
      (rightCached001.drop 76) (rightRows001.drop 76)
    · exact right_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h132
  have h034 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 186
      (rightCached001.drop 34) (rightRows001.drop 34) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 42 144
      (rightCached001.drop 34) (rightRows001.drop 34)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h076
  have h000 : pairLightSelectedFloorPrefixBool 1 6 PairLightPrepared46.sieve 220
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 6 PairLightPrepared46.sieve 34 186
      (rightCached001.drop 0) (rightRows001.drop 0)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h034
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared46
