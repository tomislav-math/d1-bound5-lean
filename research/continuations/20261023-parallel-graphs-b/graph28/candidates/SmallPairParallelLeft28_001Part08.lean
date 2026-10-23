import D1Bound5.SmallPairLightData28Sieve
import D1Bound5.SmallPairLightData28LeftCached
import D1Bound5.SmallPairLightData28LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 178 through 183, with every original tail comparison. -/
theorem left_parallel_001_part08_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 6
      (PairLightPrepared28.leftCached.drop 178) (PairLightPrepared28.leftRows.drop 178) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
