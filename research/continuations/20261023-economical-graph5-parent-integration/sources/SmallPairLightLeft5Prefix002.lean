import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part00
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part01
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part02
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part03
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part04
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part05
import D1Bound5.SmallPairLightAdaptiveLeft5_002Part06

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 162
      (PairLightPrepared5.leftCached.drop 269) (PairLightPrepared5.leftRows.drop 269) = true := by
  have h413 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 18
      (PairLightPrepared5.leftCached.drop 413) (PairLightPrepared5.leftRows.drop 413) = true := left_prefix_002_part06_checked
  have h389 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 42
      (PairLightPrepared5.leftCached.drop 389) (PairLightPrepared5.leftRows.drop 389) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve 24 18
      (PairLightPrepared5.leftCached.drop 389) (PairLightPrepared5.leftRows.drop 389)
    · exact left_prefix_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h413
  have h365 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 66
      (PairLightPrepared5.leftCached.drop 365) (PairLightPrepared5.leftRows.drop 365) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve 24 42
      (PairLightPrepared5.leftCached.drop 365) (PairLightPrepared5.leftRows.drop 365)
    · exact left_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h389
  have h341 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 90
      (PairLightPrepared5.leftCached.drop 341) (PairLightPrepared5.leftRows.drop 341) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve 24 66
      (PairLightPrepared5.leftCached.drop 341) (PairLightPrepared5.leftRows.drop 341)
    · exact left_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h365
  have h317 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 114
      (PairLightPrepared5.leftCached.drop 317) (PairLightPrepared5.leftRows.drop 317) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve 24 90
      (PairLightPrepared5.leftCached.drop 317) (PairLightPrepared5.leftRows.drop 317)
    · exact left_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h341
  have h293 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 138
      (PairLightPrepared5.leftCached.drop 293) (PairLightPrepared5.leftRows.drop 293) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve 24 114
      (PairLightPrepared5.leftCached.drop 293) (PairLightPrepared5.leftRows.drop 293)
    · exact left_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h317
  have h269 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 162
      (PairLightPrepared5.leftCached.drop 269) (PairLightPrepared5.leftRows.drop 269) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve 24 138
      (PairLightPrepared5.leftCached.drop 269) (PairLightPrepared5.leftRows.drop 269)
    · exact left_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h293
  exact h269
end D1Bound5.PairLightAdaptivePrepared5
