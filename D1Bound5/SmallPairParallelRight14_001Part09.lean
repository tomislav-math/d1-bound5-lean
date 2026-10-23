import D1Bound5.SmallPairLightData14Sieve
import D1Bound5.SmallPairLightData14RightCached
import D1Bound5.SmallPairLightData14RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 196 through 201, with every original tail comparison. -/
theorem right_parallel_001_part09_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 6
      (PairLightPrepared14.rightCached.drop 196) (PairLightPrepared14.rightRows.drop 196) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared14
