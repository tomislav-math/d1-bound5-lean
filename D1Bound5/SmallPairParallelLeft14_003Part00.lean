import D1Bound5.SmallPairLightData14Sieve
import D1Bound5.SmallPairLightData14LeftCached
import D1Bound5.SmallPairLightData14LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 419 through 430, with every original tail comparison. -/
theorem left_parallel_003_part00_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 12
      (PairLightPrepared14.leftCached.drop 419) (PairLightPrepared14.leftRows.drop 419) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared14
