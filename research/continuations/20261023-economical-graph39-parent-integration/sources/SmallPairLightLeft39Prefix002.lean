import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part00
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part01
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part02
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part03
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part04
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part05
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part06
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part07
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part08
import D1Bound5.SmallPairLightAdaptiveLeft39_002Part09

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_002_direct_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 225
      (PairLightPrepared39.leftCached.drop 233) (PairLightPrepared39.leftRows.drop 233) = true := by
  have h449 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 9
      (PairLightPrepared39.leftCached.drop 449) (PairLightPrepared39.leftRows.drop 449) = true := left_prefix_002_part09_checked
  have h425 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 33
      (PairLightPrepared39.leftCached.drop 425) (PairLightPrepared39.leftRows.drop 425) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 9
      (PairLightPrepared39.leftCached.drop 425) (PairLightPrepared39.leftRows.drop 425)
    · exact left_prefix_002_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h449
  have h401 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 57
      (PairLightPrepared39.leftCached.drop 401) (PairLightPrepared39.leftRows.drop 401) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 33
      (PairLightPrepared39.leftCached.drop 401) (PairLightPrepared39.leftRows.drop 401)
    · exact left_prefix_002_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h425
  have h377 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 81
      (PairLightPrepared39.leftCached.drop 377) (PairLightPrepared39.leftRows.drop 377) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 57
      (PairLightPrepared39.leftCached.drop 377) (PairLightPrepared39.leftRows.drop 377)
    · exact left_prefix_002_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h401
  have h353 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 105
      (PairLightPrepared39.leftCached.drop 353) (PairLightPrepared39.leftRows.drop 353) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 81
      (PairLightPrepared39.leftCached.drop 353) (PairLightPrepared39.leftRows.drop 353)
    · exact left_prefix_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h377
  have h329 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 129
      (PairLightPrepared39.leftCached.drop 329) (PairLightPrepared39.leftRows.drop 329) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 105
      (PairLightPrepared39.leftCached.drop 329) (PairLightPrepared39.leftRows.drop 329)
    · exact left_prefix_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h353
  have h305 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 153
      (PairLightPrepared39.leftCached.drop 305) (PairLightPrepared39.leftRows.drop 305) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 129
      (PairLightPrepared39.leftCached.drop 305) (PairLightPrepared39.leftRows.drop 305)
    · exact left_prefix_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h329
  have h281 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 177
      (PairLightPrepared39.leftCached.drop 281) (PairLightPrepared39.leftRows.drop 281) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 153
      (PairLightPrepared39.leftCached.drop 281) (PairLightPrepared39.leftRows.drop 281)
    · exact left_prefix_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h305
  have h257 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 201
      (PairLightPrepared39.leftCached.drop 257) (PairLightPrepared39.leftRows.drop 257) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 177
      (PairLightPrepared39.leftCached.drop 257) (PairLightPrepared39.leftRows.drop 257)
    · exact left_prefix_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h281
  have h233 : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 225
      (PairLightPrepared39.leftCached.drop 233) (PairLightPrepared39.leftRows.drop 233) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 2 PairLightPrepared39.sieve 24 201
      (PairLightPrepared39.leftCached.drop 233) (PairLightPrepared39.leftRows.drop 233)
    · exact left_prefix_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h257
  exact h233
end D1Bound5.PairLightAdaptivePrepared39
