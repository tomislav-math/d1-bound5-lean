import D1Bound5.SmallPairLightData28Sieve
import D1Bound5.SmallPairLightData28LeftCached
import D1Bound5.SmallPairLightData28LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 335 through 346, with every original tail comparison. -/
theorem left_parallel_003_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 12
      (PairLightPrepared28.leftCached.drop 335) (PairLightPrepared28.leftRows.drop 335) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
