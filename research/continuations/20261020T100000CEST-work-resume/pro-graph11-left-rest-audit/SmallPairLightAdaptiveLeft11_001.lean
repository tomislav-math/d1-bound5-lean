import D1Bound5.SmallPairLightAdaptiveData11
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft11_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft11_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft11_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft11_001Part03

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 138 through 358; every head retains its entire tail. -/
theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 221
      leftCached001 leftRows001 = true := by
  have h132 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 89
      (leftCached001.drop 132) (leftRows001.drop 132) = true := left_prefix_001_part03_checked
  have h076 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 145
      (leftCached001.drop 76) (leftRows001.drop 76) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared11.sieve 56 89
      (leftCached001.drop 76) (leftRows001.drop 76)
    · exact left_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h132
  have h034 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 187
      (leftCached001.drop 34) (leftRows001.drop 34) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared11.sieve 42 145
      (leftCached001.drop 34) (leftRows001.drop 34)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h076
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 221
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared11.sieve 34 187
      (leftCached001.drop 0) (leftRows001.drop 0)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h034
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared11
