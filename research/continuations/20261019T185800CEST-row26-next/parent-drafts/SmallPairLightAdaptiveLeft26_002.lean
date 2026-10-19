import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part00
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part01
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part02
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part03
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part04
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part05
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part06
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part07
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part08
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part09
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part10
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part11
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part12
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part13
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part14
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part15
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part16
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part17
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part18
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part19
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part20
import D1Bound5.SmallPairLightAdaptiveLeft26_002Part21

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000

/-- Exact original head block; every head retains its entire remaining tail. -/
theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 65
      leftCached002 leftRows002 = true := by
  have h063 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 2
      (leftCached002.drop 63) (leftRows002.drop 63) = true := left_prefix_002_part21_checked
  have h060 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 5
      (leftCached002.drop 60) (leftRows002.drop 60) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 2
      (leftCached002.drop 60) (leftRows002.drop 60)
    · exact left_prefix_002_part20_checked
    · simpa only [List.drop_drop] using h063
  have h057 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 8
      (leftCached002.drop 57) (leftRows002.drop 57) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 5
      (leftCached002.drop 57) (leftRows002.drop 57)
    · exact left_prefix_002_part19_checked
    · simpa only [List.drop_drop] using h060
  have h054 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 11
      (leftCached002.drop 54) (leftRows002.drop 54) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 8
      (leftCached002.drop 54) (leftRows002.drop 54)
    · exact left_prefix_002_part18_checked
    · simpa only [List.drop_drop] using h057
  have h051 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 14
      (leftCached002.drop 51) (leftRows002.drop 51) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 11
      (leftCached002.drop 51) (leftRows002.drop 51)
    · exact left_prefix_002_part17_checked
    · simpa only [List.drop_drop] using h054
  have h048 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 17
      (leftCached002.drop 48) (leftRows002.drop 48) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 14
      (leftCached002.drop 48) (leftRows002.drop 48)
    · exact left_prefix_002_part16_checked
    · simpa only [List.drop_drop] using h051
  have h045 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 20
      (leftCached002.drop 45) (leftRows002.drop 45) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 17
      (leftCached002.drop 45) (leftRows002.drop 45)
    · exact left_prefix_002_part15_checked
    · simpa only [List.drop_drop] using h048
  have h042 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 23
      (leftCached002.drop 42) (leftRows002.drop 42) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 20
      (leftCached002.drop 42) (leftRows002.drop 42)
    · exact left_prefix_002_part14_checked
    · simpa only [List.drop_drop] using h045
  have h039 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 26
      (leftCached002.drop 39) (leftRows002.drop 39) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 23
      (leftCached002.drop 39) (leftRows002.drop 39)
    · exact left_prefix_002_part13_checked
    · simpa only [List.drop_drop] using h042
  have h036 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 29
      (leftCached002.drop 36) (leftRows002.drop 36) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 26
      (leftCached002.drop 36) (leftRows002.drop 36)
    · exact left_prefix_002_part12_checked
    · simpa only [List.drop_drop] using h039
  have h033 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 32
      (leftCached002.drop 33) (leftRows002.drop 33) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 29
      (leftCached002.drop 33) (leftRows002.drop 33)
    · exact left_prefix_002_part11_checked
    · simpa only [List.drop_drop] using h036
  have h030 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 35
      (leftCached002.drop 30) (leftRows002.drop 30) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 32
      (leftCached002.drop 30) (leftRows002.drop 30)
    · exact left_prefix_002_part10_checked
    · simpa only [List.drop_drop] using h033
  have h027 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 38
      (leftCached002.drop 27) (leftRows002.drop 27) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 35
      (leftCached002.drop 27) (leftRows002.drop 27)
    · exact left_prefix_002_part09_checked
    · simpa only [List.drop_drop] using h030
  have h024 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 41
      (leftCached002.drop 24) (leftRows002.drop 24) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 38
      (leftCached002.drop 24) (leftRows002.drop 24)
    · exact left_prefix_002_part08_checked
    · simpa only [List.drop_drop] using h027
  have h021 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 44
      (leftCached002.drop 21) (leftRows002.drop 21) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 41
      (leftCached002.drop 21) (leftRows002.drop 21)
    · exact left_prefix_002_part07_checked
    · simpa only [List.drop_drop] using h024
  have h018 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 47
      (leftCached002.drop 18) (leftRows002.drop 18) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 44
      (leftCached002.drop 18) (leftRows002.drop 18)
    · exact left_prefix_002_part06_checked
    · simpa only [List.drop_drop] using h021
  have h015 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 50
      (leftCached002.drop 15) (leftRows002.drop 15) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 47
      (leftCached002.drop 15) (leftRows002.drop 15)
    · exact left_prefix_002_part05_checked
    · simpa only [List.drop_drop] using h018
  have h012 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 53
      (leftCached002.drop 12) (leftRows002.drop 12) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 50
      (leftCached002.drop 12) (leftRows002.drop 12)
    · exact left_prefix_002_part04_checked
    · simpa only [List.drop_drop] using h015
  have h009 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 56
      (leftCached002.drop 9) (leftRows002.drop 9) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 53
      (leftCached002.drop 9) (leftRows002.drop 9)
    · exact left_prefix_002_part03_checked
    · simpa only [List.drop_drop] using h012
  have h006 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 59
      (leftCached002.drop 6) (leftRows002.drop 6) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 56
      (leftCached002.drop 6) (leftRows002.drop 6)
    · exact left_prefix_002_part02_checked
    · simpa only [List.drop_drop] using h009
  have h003 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 62
      (leftCached002.drop 3) (leftRows002.drop 3) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 59
      (leftCached002.drop 3) (leftRows002.drop 3)
    · exact left_prefix_002_part01_checked
    · simpa only [List.drop_drop] using h006
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 65
      (leftCached002.drop 0) (leftRows002.drop 0) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared26.sieve 3 62
      (leftCached002.drop 0) (leftRows002.drop 0)
    · exact left_prefix_002_part00_checked
    · simpa only [List.drop_drop] using h003
  simpa only [List.drop_zero] using h000

end D1Bound5.PairLightAdaptivePrepared26
