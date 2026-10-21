import D1Bound5.SmallPairLightAdaptiveData25
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part00
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part01
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part02
import D1Bound5.SmallPairLightAdaptiveLeft25_001Part03

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_001_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 254
      leftCached001 leftRows001 = true := by
  have h149 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 105
      (leftCached001.drop 149) (leftRows001.drop 149) = true := left_prefix_001_part03_checked
  have h084 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 170
      (leftCached001.drop 84) (leftRows001.drop 84) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 65 105
      (leftCached001.drop 84) (leftRows001.drop 84)
    · exact left_prefix_001_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h149
  have h038 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 216
      (leftCached001.drop 38) (leftRows001.drop 38) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 46 170
      (leftCached001.drop 38) (leftRows001.drop 38)
    · exact left_prefix_001_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h084
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared25.sieve 254
      (leftCached001.drop 0) (leftRows001.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared25.sieve 38 216
      (leftCached001.drop 0) (leftRows001.drop 0)
    · exact left_prefix_001_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h038
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared25
