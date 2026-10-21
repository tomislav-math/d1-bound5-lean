import D1Bound5.SmallPairLightAdaptiveData12
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight12_000Part00
import D1Bound5.SmallPairLightAdaptiveRight12_000Part01
import D1Bound5.SmallPairLightAdaptiveRight12_000Part02
import D1Bound5.SmallPairLightAdaptiveRight12_000Part03
import D1Bound5.SmallPairLightAdaptiveRight12_000Part04

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Heads 0 through 137; every head retains its entire tail. -/
theorem right_prefix_000_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 138
      rightCached000 rightRows000 = true := by
  have h136 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 2
      (rightCached000.drop 136) (rightRows000.drop 136) = true := right_prefix_000_part04_checked
  have h095 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 43
      (rightCached000.drop 95) (rightRows000.drop 95) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared12.sieve 41 2
      (rightCached000.drop 95) (rightRows000.drop 95)
    · exact right_prefix_000_part03_checked
    · simpa only [List.drop_drop] using h136
  have h060 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 78
      (rightCached000.drop 60) (rightRows000.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared12.sieve 35 43
      (rightCached000.drop 60) (rightRows000.drop 60)
    · exact right_prefix_000_part02_checked
    · simpa only [List.drop_drop] using h095
  have h029 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 109
      (rightCached000.drop 29) (rightRows000.drop 29) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared12.sieve 31 78
      (rightCached000.drop 29) (rightRows000.drop 29)
    · exact right_prefix_000_part01_checked
    · simpa only [List.drop_drop] using h060
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared12.sieve 138
      (rightCached000.drop 0) (rightRows000.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared12.sieve 29 109
      (rightCached000.drop 0) (rightRows000.drop 0)
    · exact right_prefix_000_part00_checked
    · simpa only [List.drop_drop] using h029
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared12
