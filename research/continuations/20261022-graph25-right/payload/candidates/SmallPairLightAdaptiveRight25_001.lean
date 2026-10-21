import D1Bound5.SmallPairLightAdaptiveData25
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight25_001Part00
import D1Bound5.SmallPairLightAdaptiveRight25_001Part01
import D1Bound5.SmallPairLightAdaptiveRight25_001Part02
import D1Bound5.SmallPairLightAdaptiveRight25_001Part03

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 125 through 380; every head retains its entire tail. -/
theorem right_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 256
      rightCached001 rightRows001 = true := by
  have h148 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 108
      (rightCached001.drop 148) (rightRows001.drop 148) = true := right_prefix_001_part03_checked
  have h084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 172
      (rightCached001.drop 84) (rightRows001.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 64 108
      (rightCached001.drop 84) (rightRows001.drop 84)
    · exact right_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h148
  have h038 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 218
      (rightCached001.drop 38) (rightRows001.drop 38) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 46 172
      (rightCached001.drop 38) (rightRows001.drop 38)
    · exact right_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 256
      (rightCached001.drop 0) (rightRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 38 218
      (rightCached001.drop 0) (rightRows001.drop 0)
    · exact right_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h038
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared25
