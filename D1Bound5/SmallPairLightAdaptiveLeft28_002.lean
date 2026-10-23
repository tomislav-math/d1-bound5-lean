import D1Bound5.SmallPairLightAdaptiveData28
import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairParallelLeft28_002Part00
import D1Bound5.SmallPairParallelLeft28_002Part01
import D1Bound5.SmallPairParallelLeft28_002Part02
import D1Bound5.SmallPairParallelLeft28_002Part03
import D1Bound5.SmallPairParallelLeft28_002Part04
import D1Bound5.SmallPairParallelLeft28_002Part05
import D1Bound5.SmallPairParallelLeft28_002Part06
import D1Bound5.SmallPairParallelLeft28_002Part07
import D1Bound5.SmallPairParallelLeft28_002Part08
import D1Bound5.SmallPairParallelLeft28_002Part09
import D1Bound5.SmallPairParallelLeft28_002Part10
import D1Bound5.SmallPairParallelLeft28_002Part11
import D1Bound5.SmallPairParallelLeft28_002Part12

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_prefix_002_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 151
      leftCached002 leftRows002 = true := by
  have h0328 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 7
      (PairLightPrepared28.leftCached.drop 328) (PairLightPrepared28.leftRows.drop 328) = true := left_parallel_002_part12_checked
  have h0316 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 19
      (PairLightPrepared28.leftCached.drop 316) (PairLightPrepared28.leftRows.drop 316) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 7
      (PairLightPrepared28.leftCached.drop 316) (PairLightPrepared28.leftRows.drop 316)
    · exact left_parallel_002_part11_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0328
  have h0304 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 31
      (PairLightPrepared28.leftCached.drop 304) (PairLightPrepared28.leftRows.drop 304) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 19
      (PairLightPrepared28.leftCached.drop 304) (PairLightPrepared28.leftRows.drop 304)
    · exact left_parallel_002_part10_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0316
  have h0292 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 43
      (PairLightPrepared28.leftCached.drop 292) (PairLightPrepared28.leftRows.drop 292) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 31
      (PairLightPrepared28.leftCached.drop 292) (PairLightPrepared28.leftRows.drop 292)
    · exact left_parallel_002_part09_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0304
  have h0280 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 55
      (PairLightPrepared28.leftCached.drop 280) (PairLightPrepared28.leftRows.drop 280) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 43
      (PairLightPrepared28.leftCached.drop 280) (PairLightPrepared28.leftRows.drop 280)
    · exact left_parallel_002_part08_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0292
  have h0268 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 67
      (PairLightPrepared28.leftCached.drop 268) (PairLightPrepared28.leftRows.drop 268) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 55
      (PairLightPrepared28.leftCached.drop 268) (PairLightPrepared28.leftRows.drop 268)
    · exact left_parallel_002_part07_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0280
  have h0256 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 79
      (PairLightPrepared28.leftCached.drop 256) (PairLightPrepared28.leftRows.drop 256) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 67
      (PairLightPrepared28.leftCached.drop 256) (PairLightPrepared28.leftRows.drop 256)
    · exact left_parallel_002_part06_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0268
  have h0244 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 91
      (PairLightPrepared28.leftCached.drop 244) (PairLightPrepared28.leftRows.drop 244) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 79
      (PairLightPrepared28.leftCached.drop 244) (PairLightPrepared28.leftRows.drop 244)
    · exact left_parallel_002_part05_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0256
  have h0232 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 103
      (PairLightPrepared28.leftCached.drop 232) (PairLightPrepared28.leftRows.drop 232) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 91
      (PairLightPrepared28.leftCached.drop 232) (PairLightPrepared28.leftRows.drop 232)
    · exact left_parallel_002_part04_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0244
  have h0220 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 115
      (PairLightPrepared28.leftCached.drop 220) (PairLightPrepared28.leftRows.drop 220) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 103
      (PairLightPrepared28.leftCached.drop 220) (PairLightPrepared28.leftRows.drop 220)
    · exact left_parallel_002_part03_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0232
  have h0208 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 127
      (PairLightPrepared28.leftCached.drop 208) (PairLightPrepared28.leftRows.drop 208) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 115
      (PairLightPrepared28.leftCached.drop 208) (PairLightPrepared28.leftRows.drop 208)
    · exact left_parallel_002_part02_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0220
  have h0196 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 139
      (PairLightPrepared28.leftCached.drop 196) (PairLightPrepared28.leftRows.drop 196) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 127
      (PairLightPrepared28.leftCached.drop 196) (PairLightPrepared28.leftRows.drop 196)
    · exact left_parallel_002_part01_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0208
  have h0184 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 151
      (PairLightPrepared28.leftCached.drop 184) (PairLightPrepared28.leftRows.drop 184) = true := by
    apply pairLightSelectedFloorPrefixBool_of_add 1 1 PairLightPrepared28.sieve 12 139
      (PairLightPrepared28.leftCached.drop 184) (PairLightPrepared28.leftRows.drop 184)
    · exact left_parallel_002_part00_checked
    · simpa only [List.drop_drop, Nat.reduceAdd] using h0196
  exact h0184

end D1Bound5.PairLightAdaptivePrepared28
